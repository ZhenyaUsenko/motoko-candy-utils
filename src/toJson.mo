import Array "mo:base/Array";
import Candy "mo:candy/types";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Float "mo:base/Float";
import Bool "mo:base/Bool";
import Prim "mo:prim";
import Principal "mo:base/Principal";

module {
  let { nat32ToChar; charToNat32; charToText } = Prim;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func escapeJson(text: Text): Text {
    var result = "";

    for (char in text.chars()) {
      if (char == '\"') {
        result #= "\\\"";
      } else if (char == '\\') {
        result #= "\\\\";
      } else if (char == '\t') {
        result #= "\\t";
      } else if (char == '\n') {
        result #= "\\n";
      } else if (char < ' ') {
        let char32 = charToNat32(char);
        let charOffset: Nat32 = if (char32 < 10) 48 else if (char32 < 16) 87 else if (char32 < 26) 32 else 71;

        result #= (if (char32 < 16) "\\u000" else "\\u001") # charToText(nat32ToChar(char32 +% charOffset));
      } else {
        result #= charToText(char);
      };
    };

    return result;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func candyToJson(candy: Candy.CandyValue): Text {
    return switch(candy) {
      case (#Empty) "null";
      case (#Text(value)) "\"" # escapeJson(value) # "\"";
      case (#Principal(value)) "\"" # Principal.toText(value) # "\"";
      case (#Bool(value)) Bool.toText(value);
      case (#Int(value)) Int.toText(value);
      case (#Int8(value)) Int.toText(Prim.int8ToInt(value));
      case (#Int16(value)) Int.toText(Prim.int16ToInt(value));
      case (#Int32(value)) Int.toText(Prim.int32ToInt(value));
      case (#Int64(value)) Int.toText(Prim.int64ToInt(value));
      case (#Nat(value)) Int.toText(value);
      case (#Nat8(value)) Int.toText(Prim.nat8ToNat(value));
      case (#Nat16(value)) Int.toText(Prim.nat16ToNat(value));
      case (#Nat32(value)) Int.toText(Prim.nat32ToNat(value));
      case (#Nat64(value)) Int.toText(Prim.nat64ToNat(value));
      case (#Float(value)) Float.toText(value);
      case (#Option(value)) switch (value) { case (?value) candyToJson(value); case (_) "null" };

      case (#Class(value)) {
        var json = "{";
        var firstProp = true;

        for (prop in value.vals()) {
          if (firstProp) firstProp := false else json #= ",";

          json #= "\"" # escapeJson(prop.name) # "\":" # candyToJson(prop.value);
        };

        json # "}";
      };

      case (#Array(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        var json = "[";
        var firstItem = true;

        for (item in array.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= candyToJson(item);
        };

        json # "]";
      };

      case (#Bytes(value)) {
         let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        var json = "[";
        var firstItem = true;

        for (item in array.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(Prim.nat8ToNat(item));
        };

        json # "]";
      };

      case (#Floats(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        var json = "[";
        var firstItem = true;

        for (item in array.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Float.toText(item);
        };

        json # "]";
      };

      case (#Nats(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        var json = "[";
        var firstItem = true;

        for (item in array.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(item);
        };

        json # "]";
      };

      case (#Blob(value)) {
        var json = "[";
        var firstItem = true;

        for (item in value.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(Prim.nat8ToNat(item));
        };

        json # "]";
      };
    };
  };
};
