import Candy "mo:candy/types";
import Iter "mo:base/Iter";
import Prim "mo:prim";
import Utils "./utils";

module {
  let { nat32ToNat; blobToArray; charToNat32; charToText; encodeUtf8; trap } = Prim;

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

  public let EXISTING_VALUE = 0:Nat8;
  public let NULL_VALUE = 1:Nat8;
  public let EMPTY_VALUE = 2:Nat8;

  public let CONDITION_STAGE = 0:Nat8;
  public let VALUE_STAGE = 1:Nat8;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func isReservedChar(char: Char): Bool {
    return (
      char == '*' or char == '@' or char == '$' or char == '?' or char == ':' or char == ' '
    ) or (
      char == '(' or char == ')' or char == '.' or char == '[' or char == ']'
    );
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func escapePath(text: Text): Text {
    var result = "";

    for (char in text.chars()) if (isReservedChar(char)) result #= "\\" # charToText(char) else result #= charToText(char);

    return result;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func processPath(iter: Iter.Iter<Char>, firstProp: Bool): Path {
    var propName = "";
    var propNameSize = 0:Nat32;
    var propInt = 0:Int;
    var intSign = 1:Int;
    var intValid = true;
    var escaped = false;
    var everEscaped = false;

    for (char in iter) {
      if (escaped) {
        escaped := false;
        propName #= charToText(char);
        propNameSize +%= 1;
      } else if (char == '\\') {
        escaped := true;
        everEscaped := true;
        intValid := false;
      } else if (char == ' ' or char == '.' or char == '[' or char == ']') {
        let hasNextProp = char == '.' or char == '[';
        let singleChar = not everEscaped and propNameSize == 1;

        if (singleChar and firstProp and hasNextProp and (propName == "$" or propName == "@")) {
          let nextProp = processPath(iter, false);

          return if (propName == "$") (#ROOT, ?nextProp, nextProp.2) else (#CURRENT, ?nextProp, nextProp.2);
        };

        let prop = if (singleChar and propName == "*") #ALL else #PROP(propName, propInt * intSign, intValid and propName != "" and propName != "-");

        if (hasNextProp) {
          let nextProp = if (char == '[') processCondition(iter, false) else processPath(iter, false);

          return (prop, ?nextProp, nextProp.2);
        };

        return (prop, null, char);
      } else {
        propName #= charToText(char);
        propNameSize +%= 1;

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

  public func processCondition(iter: Iter.Iter<Char>, rootCondition: Bool): Path {
    let path = processPath(iter, true);

    if (path.2 == ']') if (rootCondition) return path else trap("No operator found");

    var value = "";
    var valueBool = false;
    var boolValid = true;
    var valueInt = 0:Int;
    var intSign = 1:Int;
    var intValid = true;
    var valueFloat = 0:Float;
    var floatSign = 1:Float;
    var floatValid = true;
    var valueIntValid = true;
    var valueFloatValid = true;
    var valueType = EXISTING_VALUE;

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
            case (_) trap("Invalid operator: \"" # operatorName # "\"");
          };

          stage := VALUE_STAGE;
        };
      } else if (stage == VALUE_STAGE) {
        if (char == ']') {
          let parsedValueValid = value != "" and value != "-";

          let valueData = (
            value,
            encodeUtf8(value),
            valueBool,
            boolValid and parsedValueValid,
            intSign * valueInt,
            intValid and parsedValueValid,
            floatSign * valueFloat,
            floatValid and parsedValueValid,
            switch (operator) { case (#LIKE or #UNLIKE) searchUtils(value); case (_) Utils.DEFAULT_UTILS },
            switch (operator) { case (#ILIKE or #IUNLIKE) lowerSearchUtils(value); case (_) Utils.DEFAULT_UTILS },
            null,
            valueType,
          ):Value;

          if (rootCondition) return (#CONDITION(path, operator, valueData, null, null, null), null, char);
        };
      };
    };

    trap("Unexpected end of condition");
  };

  public func path(text: Text): Path {
    return processCondition((text # "]").chars(), true);
  };
};
