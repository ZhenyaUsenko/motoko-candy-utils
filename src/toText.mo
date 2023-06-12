import Candy "mo:candy2/types";
import Int "mo:base/Int";
import Float "mo:base/Float";
import Bool "mo:base/Bool";
import Prim "mo:prim";
import Principal "mo:base/Principal";

module {
  public func candyToText(candy: Candy.Candy): ?Text {
    return switch(candy) {
      case (#Text(value)) ?value;
      case (#Principal(value)) ?Principal.toText(value);
      case (#Blob(value)) Prim.decodeUtf8(value);
      case (#Bool(value)) ?Bool.toText(value);
      case (#Int(value)) ?Int.toText(value);
      case (#Int8(value)) ?Int.toText(Prim.int8ToInt(value));
      case (#Int16(value)) ?Int.toText(Prim.int16ToInt(value));
      case (#Int32(value)) ?Int.toText(Prim.int32ToInt(value));
      case (#Int64(value)) ?Int.toText(Prim.int64ToInt(value));
      case (#Nat(value)) ?Int.toText(value);
      case (#Nat8(value)) ?Int.toText(Prim.nat8ToNat(value));
      case (#Nat16(value)) ?Int.toText(Prim.nat16ToNat(value));
      case (#Nat32(value)) ?Int.toText(Prim.nat32ToNat(value));
      case (#Nat64(value)) ?Int.toText(Prim.nat64ToNat(value));
      case (#Float(value)) ?Float.toText(value);
      case (#Option(value)) switch (value) { case (?value) candyToText(value); case (_) null };
      case (_) null;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func candySharedToText(candy: Candy.CandyShared): ?Text {
    return switch(candy) {
      case (#Text(value)) ?value;
      case (#Principal(value)) ?Principal.toText(value);
      case (#Blob(value)) Prim.decodeUtf8(value);
      case (#Bool(value)) ?Bool.toText(value);
      case (#Int(value)) ?Int.toText(value);
      case (#Int8(value)) ?Int.toText(Prim.int8ToInt(value));
      case (#Int16(value)) ?Int.toText(Prim.int16ToInt(value));
      case (#Int32(value)) ?Int.toText(Prim.int32ToInt(value));
      case (#Int64(value)) ?Int.toText(Prim.int64ToInt(value));
      case (#Nat(value)) ?Int.toText(value);
      case (#Nat8(value)) ?Int.toText(Prim.nat8ToNat(value));
      case (#Nat16(value)) ?Int.toText(Prim.nat16ToNat(value));
      case (#Nat32(value)) ?Int.toText(Prim.nat32ToNat(value));
      case (#Nat64(value)) ?Int.toText(Prim.nat64ToNat(value));
      case (#Float(value)) ?Float.toText(value);
      case (#Option(value)) switch (value) { case (?value) candySharedToText(value); case (_) null };
      case (_) null;
    };
  };
};
