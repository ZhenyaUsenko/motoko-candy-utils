import Array "mo:base/Array";
import Candy "mo:candy/types";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Float "mo:base/Float";
import Bool "mo:base/Bool";
import Prim "mo:prim";
import Principal "mo:base/Principal";

module {
  let { blobToArray; charToText } = Prim;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func textReplace(text: Text, search: Char, replacer: Text): Text {
    var result = "";

    for (char in text.chars()) if (char == search) result #= replacer else result #= charToText(char);

    return result;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func candyToJson(candy: Candy.CandyValue): Text {
    return switch(candy) {
      case (#Empty) "null";
      case (#Text(value)) "\"" # textReplace(value, '\"', "\\\"") # "\"";
      case (#Principal(value)) candyToJson(#Text(Principal.toText(value)));
      case (#Blob(value)) candyToJson(#Bytes(#thawed(blobToArray(value))));
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
        let props = Array.map<Candy.Property, Text>(value, func(item) { candyToJson(#Text(item.name)) # ":" # candyToJson(item.value) });

        "{" # Text.join(",", props.vals()) # "}";
      };

      case (#Array(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        let items = Array.map<Candy.CandyValue, Text>(array, func(item) { candyToJson(item) });

        "[" # Text.join(",", items.vals()) # "]";
      };

      case (#Bytes(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        let items = Array.map<Nat8, Text>(array, func(item) { candyToJson(#Nat8(item)) });

        "[" # Text.join(",", items.vals()) # "]";
      };

      case (#Floats(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        let items = Array.map<Float, Text>(array, func(item) { candyToJson(#Float(item)) });

        "[" # Text.join(",", items.vals()) # "]";
      };

      case (#Nats(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        let items = Array.map<Nat, Text>(array, func(item) { candyToJson(#Nat(item)) });

        "[" # Text.join(",", items.vals()) # "]";
      };
    };
  };
};
