import Candy "mo:candy/types";
import Iter "mo:base/Iter";
import Prim "mo:prim";
import Utils "./utils";

module {
  let { nat32ToNat; charToNat32; charToText; intToFloat; encodeUtf8; trap } = Prim;

  let { searchUtils; lowerSearchUtils } = Utils;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public type Prop = (
    propName: Text,
    propInt: Int,
    intValid: Bool,
  );

  public type Operator = { #EQ; #NE; #GTLT; #GT; #GTE; #LT; #LTE; #LIKE; #ILIKE; #UNLIKE; #IUNLIKE };

  public type Value = (
    text: Text,
    blob: Blob,
    bool: Bool,
    boolValid: Bool,
    int: Int,
    intValid: Bool,
    float: Float,
    floatValid: Bool,
    searchUtils: Utils.SearchUtils,
    lowerSearchUtils: Utils.SearchUtils,
    path: ?Path,
    valueType: Nat8,
  );

  public type Condition = (
    path: Path,
    operator: Operator,
    value: Value,
    and1: ?Condition,
    or1: ?Condition,
    and2: ?Condition,
  );

  public type PathType = { #CURRENT; #ROOT; #ALL; #PROP: Prop; #CONDITION: Condition };

  public type Path = (
    path: PathType,
    next: ?Path,
    lastChar: Char,
  );

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public let PATH_NAME = 0:Nat8;
  public let PATH_ALL = 1:Nat8;
  public let PATH_ROOT = 2:Nat8;
  public let PATH_CURRENT = 3:Nat8;

  public let EXISTING_VALUE = 0:Nat8;
  public let NULL_VALUE = 1:Nat8;
  public let EMPTY_VALUE = 2:Nat8;

  public let NO_CHAIN = 0:Nat8;
  public let AND_CHAIN = 1:Nat8;
  public let OR_CHAIN = 2:Nat8;

  public let CONDITION_STAGE = 0:Nat8;
  public let VALUE_STAGE = 1:Nat8;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func escapePath(text: Text): Text {
    var result = "";

    for (char in text.chars()) if ((
      char == '*' or char == '@' or char == '$' or char == '?' or char == ':' or char == ' '
    ) or (
      char == '(' or char == ')' or char == '.' or char == '[' or char == ']'
    )) {
      result #= "\\" # charToText(char);
    } else {
      result #= charToText(char);
    };

    return result;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func processPath(iter: Iter.Iter<Char>, firstProp: Bool, initialPathType: Nat8): Path {
    var propName = if (initialPathType == PATH_ROOT) "$" else if (initialPathType == PATH_CURRENT) "@" else "";
    var propNameSize = if (initialPathType != PATH_NAME) 1:Nat32 else 0:Nat32;
    var propInt = 0:Int;
    var intSign = 1:Int;
    var intValid = initialPathType == PATH_NAME;
    var pathType = initialPathType;
    var escaped = false;

    for (char in iter) {
      if (escaped) {
        escaped := false;
        propName #= charToText(char);
        propNameSize +%= 1;
      } else if (char == '\\') {
        escaped := true;
        intValid := false;
      } else if (char == ' ' or char == '.' or char == '[' or char == ']') {
        let prop = if (pathType == PATH_ALL) {
          if (propNameSize == 1) #ALL else trap("Wrong (*) usage");
        } else if (pathType == PATH_ROOT) {
          if (firstProp and propNameSize == 1) #ROOT else trap("Wrong ($) usage");
        } else if (pathType == PATH_CURRENT) {
          if (firstProp and propNameSize == 1) #CURRENT else trap("Wrong (@) usage");
        } else {
          #PROP(propName, propInt * intSign, intValid and propNameSize > 0 and (intSign == 1 or propNameSize > 1));
        };

        if (char == '.' or char == '[') {
          let nextProp = if (char == '[') processCondition(iter, false, NO_CHAIN) else processPath(iter, false, PATH_NAME);

          return (prop, ?nextProp, nextProp.2);
        };

        return (prop, null, char);
      } else {
        propName #= charToText(char);
        propNameSize +%= 1;

        if (char == '*') pathType := PATH_ALL else if (char == '$') pathType := PATH_ROOT else if (char == '@') pathType := PATH_CURRENT;

        if (intValid) {
          if (propNameSize == 1 and char == '-') {
            intSign := -1;
          } else if (char >= '0' and char <= '9') {
            propInt := propInt * 10 + nat32ToNat(charToNat32(char) -% 48);
          } else {
            intValid := false;
          };
        };
      };
    };

    trap("Unexpected end of path");
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func processCondition(iter: Iter.Iter<Char>, rootCondition: Bool, conditionChain: Nat8): Path {
    let path = processPath(iter, true, PATH_NAME);

    if (path.2 == ']') if (rootCondition) return path else trap("No operator found");

    var value = "";
    var valueSize = 0:Nat32;
    var boolValid = true;
    var valueInt = 0:Int;
    var intSign = 1:Int;
    var intValid = true;
    var valueFloat = 0:Float;
    var floatSign = 1:Float;
    var floatFractionDivisor = 0:Float;
    var floatValid = true;
    var valueType = EXISTING_VALUE;
    var escaped = false;

    var operator = #EQ:Operator;
    var operatorName = " ";
    var operatorSize = 0:Nat32;

    var stage = CONDITION_STAGE;

    for (char in iter) {
      if (stage == CONDITION_STAGE) {
        if (char == ']') trap("Unexpected end of operator");

        operatorName #= charToText(char);
        operatorSize +%= 1;

        if (char == ' ' or operatorSize == 6) {
          operator := switch (operatorName) {
            case (" == ") #EQ;
            case (" != ") #NE;
            case (" <> ") #GTLT;
            case (" > ") #GT;
            case (" >= ") #GTE;
            case (" < ") #LT;
            case (" <= ") #LTE;
            case (" ~= ") #LIKE;
            case (" ~~= ") #ILIKE;
            case (" !~= ") #UNLIKE;
            case (" !~~= ") #IUNLIKE;
            case (_) trap("Invalid compare operator: \"" # operatorName # "\"");
          };

          stage := VALUE_STAGE;
        };
      } else if (stage == VALUE_STAGE) {
        if (escaped) {
          escaped := false;
          value #= charToText(char);
          valueSize +%= 1;
        } else if (char == '\\') {
          escaped := true;
          intValid := false;
          floatValid := false;
          boolValid := false;
        } else if (char == ']' or char == ' ' or (valueSize == 0 and (char == '$' or char == '@'))) {
          let iterNext = iter.next;
          let numericValueValid = valueSize > 0 and (intSign == 1 or valueSize > 1);
          let isTrue = boolValid and value == "true";
          let isFalse = boolValid and value == "false";
          var valuePath = null:?Path;
          var lastChar = char;
          var and1 = null:?Condition;
          var or1 = null:?Condition;

          if (valueType == NULL_VALUE and valueSize > 1 or valueType == EMPTY_VALUE and valueSize > 2) trap("Wrong (?) usage");

          if (char == '$' or char == '@') {
            let nextProp = if (char == '$') processPath(iter, false, PATH_ROOT) else processPath(iter, false, PATH_CURRENT);

            valuePath := ?nextProp;
            lastChar := nextProp.2;
          };

          let valueData = (
            value,
            encodeUtf8(value),
            isTrue,
            isTrue or isFalse,
            intSign * valueInt,
            intValid and numericValueValid,
            floatSign * valueFloat,
            floatValid and numericValueValid,
            switch (operator) { case (#LIKE or #UNLIKE) searchUtils(value); case (_) Utils.DEFAULT_UTILS },
            switch (operator) { case (#ILIKE or #IUNLIKE) lowerSearchUtils(value); case (_) Utils.DEFAULT_UTILS },
            valuePath,
            valueType,
          ):Value;

          if (lastChar == ' ') {
            lastChar := switch (iterNext()) { case (?char) char; case (_) trap("Unexpected end of string") };

            if (lastChar == '&' or lastChar == '|') {
              if (lastChar == '&' or conditionChain != AND_CHAIN) {
                switch (iterNext()) { case (?char) if (char != ' ') trap("Invalid and/or operator"); case (_) trap("Unexpected end of string") };

                if (lastChar == '&') {
                  let nextCondition = processCondition(iter, false, AND_CHAIN);

                  and1 := ?(switch (nextCondition.0) { case (#CONDITION(condition)) condition; case (_) trap("unreachable") });
                  lastChar := nextCondition.2;

                  if (lastChar == '|') {
                    switch (iterNext()) { case (?char) if (char != ' ') trap("Invalid and/or operator"); case (_) trap("Unexpected end of string") };
                  };
                };

                if (lastChar == '|') {
                  let nextCondition = processCondition(iter, false, OR_CHAIN);

                  or1 := ?(switch (nextCondition.0) { case (#CONDITION(condition)) condition; case (_) trap("unreachable") });
                  lastChar := nextCondition.2;
                };

                return (#CONDITION(path, operator, valueData, and1, or1, null), null, lastChar);
              };
            } else {
              trap("Invalid and/or operator");
            };
          };

          let condition = #CONDITION(path, operator, valueData, and1, or1, null);

          if (rootCondition or conditionChain != NO_CHAIN) return (condition, null, lastChar);

          let nextChar = switch (iterNext()) { case (?char) char; case (_) trap("Unexpected end of string") };

          if (nextChar == '.' or nextChar == '[') {
            let nextProp = if (nextChar == '[') processCondition(iter, false, NO_CHAIN) else processPath(iter, false, PATH_NAME);

            return (condition, ?nextProp, nextProp.2);
          };

          if (nextChar == ']') return (condition, null, nextChar) else trap("Unexpected char after condition close");
        } else {
          value #= charToText(char);
          valueSize +%= 1;

          if (char == '?') if (valueType == NULL_VALUE) valueType := EMPTY_VALUE else valueType := NULL_VALUE;

          if (intValid) {
            if (valueSize == 1 and char == '-') {
              intSign := -1;
            } else if (char >= '0' and char <= '9') {
              valueInt := valueInt * 10 + nat32ToNat(charToNat32(char) -% 48);
            } else {
              intValid := false;
            };
          };

          if (floatValid) {
            if (valueSize == 1 and char == '-') {
              floatSign := -1;
            } else if (char >= '0' and char <= '9') {
              if (floatFractionDivisor > 0) {
                valueFloat += intToFloat(nat32ToNat(charToNat32(char) -% 48)) / floatFractionDivisor;
                floatFractionDivisor *= 10;
              } else {
                valueFloat := valueFloat * 10 + intToFloat(nat32ToNat(charToNat32(char) -% 48));
              };
            } else if (char == '.' and floatFractionDivisor == 0 and valueSize > 0 and (floatSign == 1 or valueSize > 1)) {
              floatFractionDivisor := 10;
            } else {
              floatValid := false;
            };
          };
        };
      };
    };

    trap("Unexpected end of condition");
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func path(text: Text): ?Path {
    return ?processCondition((text # "]").chars(), true, NO_CHAIN);
  };
};
