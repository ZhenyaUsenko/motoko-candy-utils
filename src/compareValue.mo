import Candy "mo:candy/types";
import Prim "mo:prim";
import Principal "mo:base/Principal";
import Path "./path";
import Utils "./utils";

module {
  let { contains; containsLower; searchUtils; lowerSearchUtils } = Utils;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func equal(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) target.11 == Path.EXISTING_VALUE and value == target.0;
      case (#Principal(value)) target.11 == Path.EXISTING_VALUE and Principal.toText(value) == target.0;
      case (#Blob(value)) target.11 == Path.EXISTING_VALUE and value == target.1;
      case (#Bool(value)) target.3 and value == target.2;
      case (#Int(value)) target.5 and value == target.4;
      case (#Int8(value)) target.5 and Prim.int8ToInt(value) == target.4;
      case (#Int16(value)) target.5 and Prim.int16ToInt(value) == target.4;
      case (#Int32(value)) target.5 and Prim.int32ToInt(value) == target.4;
      case (#Int64(value)) target.5 and Prim.int64ToInt(value) == target.4;
      case (#Nat(value)) target.5 and value == target.4;
      case (#Nat8(value)) target.5 and Prim.nat8ToNat(value) == target.4;
      case (#Nat16(value)) target.5 and Prim.nat16ToNat(value) == target.4;
      case (#Nat32(value)) target.5 and Prim.nat32ToNat(value) == target.4;
      case (#Nat64(value)) target.5 and Prim.nat64ToNat(value) == target.4;
      case (#Float(value)) target.7 and value == target.6;
      case (#Option(?value)) equal(value, target);
      case (#Option(null)) target.11 == Path.NULL_VALUE;
      case (#Empty) target.11 == Path.EMPTY_VALUE;
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func greaterOrLess(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) target.11 == Path.EXISTING_VALUE and value != target.0;
      case (#Principal(value)) target.11 == Path.EXISTING_VALUE and Principal.toText(value) != target.0;
      case (#Blob(value)) target.11 == Path.EXISTING_VALUE and value != target.1;
      case (#Bool(value)) target.3 and value != target.2;
      case (#Int(value)) target.5 and value != target.4;
      case (#Int8(value)) target.5 and Prim.int8ToInt(value) != target.4;
      case (#Int16(value)) target.5 and Prim.int16ToInt(value) != target.4;
      case (#Int32(value)) target.5 and Prim.int32ToInt(value) != target.4;
      case (#Int64(value)) target.5 and Prim.int64ToInt(value) != target.4;
      case (#Nat(value)) target.5 and value != target.4;
      case (#Nat8(value)) target.5 and Prim.nat8ToNat(value) != target.4;
      case (#Nat16(value)) target.5 and Prim.nat16ToNat(value) != target.4;
      case (#Nat32(value)) target.5 and Prim.nat32ToNat(value) != target.4;
      case (#Nat64(value)) target.5 and Prim.nat64ToNat(value) != target.4;
      case (#Float(value)) target.7 and value != target.6;
      case (#Option(?value)) greaterOrLess(value, target);
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func greater(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) target.11 == Path.EXISTING_VALUE and value > target.0;
      case (#Principal(value)) target.11 == Path.EXISTING_VALUE and Principal.toText(value) > target.0;
      case (#Blob(value)) target.11 == Path.EXISTING_VALUE and value > target.1;
      case (#Bool(value)) target.3 and value;
      case (#Int(value)) target.5 and value > target.4;
      case (#Int8(value)) target.5 and Prim.int8ToInt(value) > target.4;
      case (#Int16(value)) target.5 and Prim.int16ToInt(value) > target.4;
      case (#Int32(value)) target.5 and Prim.int32ToInt(value) > target.4;
      case (#Int64(value)) target.5 and Prim.int64ToInt(value) > target.4;
      case (#Nat(value)) target.5 and value > target.4;
      case (#Nat8(value)) target.5 and Prim.nat8ToNat(value) > target.4;
      case (#Nat16(value)) target.5 and Prim.nat16ToNat(value) > target.4;
      case (#Nat32(value)) target.5 and Prim.nat32ToNat(value) > target.4;
      case (#Nat64(value)) target.5 and Prim.nat64ToNat(value) > target.4;
      case (#Float(value)) target.7 and value > target.6;
      case (#Option(?value)) greater(value, target);
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func greaterOrEqual(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) target.11 == Path.EXISTING_VALUE and value >= target.0;
      case (#Principal(value)) target.11 == Path.EXISTING_VALUE and Principal.toText(value) >= target.0;
      case (#Blob(value)) target.11 == Path.EXISTING_VALUE and value >= target.1;
      case (#Bool(value)) target.3;
      case (#Int(value)) target.5 and value >= target.4;
      case (#Int8(value)) target.5 and Prim.int8ToInt(value) >= target.4;
      case (#Int16(value)) target.5 and Prim.int16ToInt(value) >= target.4;
      case (#Int32(value)) target.5 and Prim.int32ToInt(value) >= target.4;
      case (#Int64(value)) target.5 and Prim.int64ToInt(value) >= target.4;
      case (#Nat(value)) target.5 and value >= target.4;
      case (#Nat8(value)) target.5 and Prim.nat8ToNat(value) >= target.4;
      case (#Nat16(value)) target.5 and Prim.nat16ToNat(value) >= target.4;
      case (#Nat32(value)) target.5 and Prim.nat32ToNat(value) >= target.4;
      case (#Nat64(value)) target.5 and Prim.nat64ToNat(value) >= target.4;
      case (#Float(value)) target.7 and value >= target.6;
      case (#Option(?value)) greaterOrEqual(value, target);
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func less(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) target.11 == Path.EXISTING_VALUE and value < target.0;
      case (#Principal(value)) target.11 == Path.EXISTING_VALUE and Principal.toText(value) < target.0;
      case (#Blob(value)) target.11 == Path.EXISTING_VALUE and value < target.1;
      case (#Bool(value)) target.3 and target.2;
      case (#Int(value)) target.5 and value < target.4;
      case (#Int8(value)) target.5 and Prim.int8ToInt(value) < target.4;
      case (#Int16(value)) target.5 and Prim.int16ToInt(value) < target.4;
      case (#Int32(value)) target.5 and Prim.int32ToInt(value) < target.4;
      case (#Int64(value)) target.5 and Prim.int64ToInt(value) < target.4;
      case (#Nat(value)) target.5 and value < target.4;
      case (#Nat8(value)) target.5 and Prim.nat8ToNat(value) < target.4;
      case (#Nat16(value)) target.5 and Prim.nat16ToNat(value) < target.4;
      case (#Nat32(value)) target.5 and Prim.nat32ToNat(value) < target.4;
      case (#Nat64(value)) target.5 and Prim.nat64ToNat(value) < target.4;
      case (#Float(value)) target.7 and value < target.6;
      case (#Option(?value)) less(value, target);
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func lessOrEqual(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) target.11 == Path.EXISTING_VALUE and value <= target.0;
      case (#Principal(value)) target.11 == Path.EXISTING_VALUE and Principal.toText(value) <= target.0;
      case (#Blob(value)) target.11 == Path.EXISTING_VALUE and value <= target.1;
      case (#Bool(value)) target.3;
      case (#Int(value)) target.5 and value <= target.4;
      case (#Int8(value)) target.5 and Prim.int8ToInt(value) <= target.4;
      case (#Int16(value)) target.5 and Prim.int16ToInt(value) <= target.4;
      case (#Int32(value)) target.5 and Prim.int32ToInt(value) <= target.4;
      case (#Int64(value)) target.5 and Prim.int64ToInt(value) <= target.4;
      case (#Nat(value)) target.5 and value <= target.4;
      case (#Nat8(value)) target.5 and Prim.nat8ToNat(value) <= target.4;
      case (#Nat16(value)) target.5 and Prim.nat16ToNat(value) <= target.4;
      case (#Nat32(value)) target.5 and Prim.nat32ToNat(value) <= target.4;
      case (#Nat64(value)) target.5 and Prim.nat64ToNat(value) <= target.4;
      case (#Float(value)) target.7 and value <= target.6;
      case (#Option(?value)) lessOrEqual(value, target);
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func like(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) contains(value, target.8);
      case (#Option(?value)) like(value, target);
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func ilike(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) containsLower(value, target.9);
      case (#Option(?value)) ilike(value, target);
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func unlike(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) not contains(value, target.9);
      case (#Option(?value)) unlike(value, target);
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func iunlike(value: Candy.CandyValue, target: Path.Value): Bool {
    return switch (value) {
      case (#Text(value)) not containsLower(value, target.9);
      case (#Option(?value)) iunlike(value, target);
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func compare(value: Candy.CandyValue, operator: Path.Operator, target: Path.Value): Bool {
    switch (operator) {
      case (#EQ) return equal(value, target);
      case (#NE) return not equal(value, target);
      case (#GTLT) return greaterOrLess(value, target);
      case (#GT) return greater(value, target);
      case (#GTE) return greaterOrEqual(value, target);
      case (#LT) return less(value, target);
      case (#LTE) return lessOrEqual(value, target);
      case (#LIKE) return like(value, target);
      case (#ILIKE) return ilike(value, target);
      case (#UNLIKE) return unlike(value, target);
      case (#IUNLIKE) return iunlike(value, target);
    };
  };
};
