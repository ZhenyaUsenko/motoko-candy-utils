import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Buffer "mo:stablebuffer/StableBuffer";
import Candy "mo:candy2/types";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Map "mo:map7/Map";
import Prim "mo:prim";
import Principal "mo:base/Principal";
import Set "mo:map7/Set";
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

  public func toJson(candy: Candy.Candy): Text {
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
      case (#Option(value)) switch (value) { case (?value) toJson(value); case (_) "null" };

      case (#Class(props)) {
        var json = "{";
        var firstProp = true;

        for (prop in Map.vals(props)) {
          if (firstProp) firstProp := false else json #= ",";

          json #= "\"" # escapeJson(prop.name) # "\":" # toJson(prop.value);
        };

        return json # "}";
      };

      case (#Map(map)) {
        var json = "[";
        var firstProp = true;

        for ((key, value) in Map.entries(map)) {
          if (firstProp) firstProp := false else json #= ",";

          json #= "[" # toJson(key) # "," # toJson(value) # "]";
        };

        return json # "]";
      };

      case (#Set(set)) {
        var json = "[";
        var firstProp = true;

        for (key in Set.keys(set)) {
          if (firstProp) firstProp := false else json #= ",";

          json #= toJson(key);
        };

        return json # "]";
      };

      case (#Array(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
          if (firstItem) firstItem := false else json #= ",";

          json #= toJson(item);
        };

        return json # "]";
      };

      case (#Bytes(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(Prim.nat8ToNat(item));
        };

        return json # "]";
      };

      case (#Floats(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Float.toText(item);
        };

        return json # "]";
      };

      case (#Ints(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(item);
        };

        return json # "]";
      };

      case (#Nats(array)) {
        var json = "[";
        var firstItem = true;

        for (item in Buffer.vals(array)) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(item);
        };

        return json # "]";
      };

      case (#Blob(value)) {
        var json = "[";
        var firstItem = true;

        for (item in value.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(Prim.nat8ToNat(item));
        };

        return json # "]";
      };
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func toJsonShared(candy: Candy.CandyShared): Text {
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
      case (#Option(value)) switch (value) { case (?value) toJsonShared(value); case (_) "null" };

      case (#Class(props)) {
        var json = "{";
        var firstProp = true;

        for (prop in props.vals()) {
          if (firstProp) firstProp := false else json #= ",";

          json #= "\"" # escapeJson(prop.name) # "\":" # toJsonShared(prop.value);
        };

        return json # "}";
      };

      case (#Map(map)) {
        var json = "[";
        var firstProp = true;

        for ((key, value) in map.vals()) {
          if (firstProp) firstProp := false else json #= ",";

          json #= "[" # toJsonShared(key) # "," # toJsonShared(value) # "]";
        };

        return json # "]";
      };

      case (#Set(set)) {
        var json = "[";
        var firstProp = true;

        for (key in set.vals()) {
          if (firstProp) firstProp := false else json #= ",";

          json #= toJsonShared(key);
        };

        return json # "]";
      };

      case (#Array(array)) {
        var json = "[";
        var firstItem = true;

        for (item in array.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= toJsonShared(item);
        };

        return json # "]";
      };

      case (#Bytes(array)) {
        var json = "[";
        var firstItem = true;

        for (item in array.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(Prim.nat8ToNat(item));
        };

        return json # "]";
      };

      case (#Floats(array)) {
        var json = "[";
        var firstItem = true;

        for (item in array.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Float.toText(item);
        };

        return json # "]";
      };

      case (#Ints(array)) {
        var json = "[";
        var firstItem = true;

        for (item in array.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(item);
        };

        return json # "]";
      };

      case (#Nats(array)) {
        var json = "[";
        var firstItem = true;

        for (item in array.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(item);
        };

        return json # "]";
      };

      case (#Blob(value)) {
        var json = "[";
        var firstItem = true;

        for (item in value.vals()) {
          if (firstItem) firstItem := false else json #= ",";

          json #= Int.toText(Prim.nat8ToNat(item));
        };

        return json # "]";
      };
    };
  };
};
