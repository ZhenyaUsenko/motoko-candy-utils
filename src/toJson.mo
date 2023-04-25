import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:stablebuffer/StableBuffer";
import Candy "mo:candy/types";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Map "mo:map/Map";
import Prim "mo:prim";
import Principal "mo:base/Principal";
import Set "mo:map/Set";
import Text "mo:base/Text";

module {
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
        let char32 = Prim.charToNat32(char);
        let charOffset: Nat32 = if (char32 < 10) 48 else if (char32 < 16) 87 else if (char32 < 26) 32 else 71;

        result #= (if (char32 < 16) "\\u000" else "\\u001") # Prim.charToText(Prim.nat32ToChar(char32 +% charOffset));
      } else {
        result #= Prim.charToText(char);
      };
    };

    return result;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func candyToJson(candy: Candy.Candy): Text {
    return switch(candy) {
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

      case (#Class(data)) {
        var json = "{";
        var firstProp = true;

        for (prop in Map.vals(data)) {
          if (firstProp) firstProp := false else json #= ",";

          json #= "\"" # escapeJson(prop.name) # "\":" # candyToJson(prop.value);
        };

        json # "}";
      };

      case (#Map(data)) {
        var json = "[";
        var firstProp = true;

        for (item in Map.entries(data)) {
          if (firstProp) firstProp := false else json #= ",";

          json #= "[" # candyToJson(item.0) # "," # candyToJson(item.1) # "]";
        };

        json # "]";
      };

      case (#Set(data)) {
        var json = "[";
        var firstProp = true;

        for (item in Set.keys(data)) {
          if (firstProp) firstProp := false else json #= ",";

          json #= candyToJson(item);
        };

        json # "]";
      };

      case (#Array(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
          if (firstItem) firstItem := false else json #= ",";

          json #= candyToJson(item);
        };

        json # "]";
      };

      case (#Bytes(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(Prim.nat8ToNat(item));
        };

        json # "]";
      };

      case (#Floats(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Float.toText(item);
        };

        json # "]";
      };

      case (#Ints(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(item);
        };

        json # "]";
      };

      case (#Nats(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
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
