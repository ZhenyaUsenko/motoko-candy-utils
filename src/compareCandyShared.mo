import Candy "mo:candy3/types";
import Path "./path";
import Prim "mo:prim";
import Principal "mo:base/Principal";
import { contains; containsLower; searchUtils; lowerSearchUtils } "./utils";

module {
  public func equal(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) value == target; case (_) false };
      case (#Principal(value)) switch (target) { case (#Principal(target)) value == target; case (_) false };
      case (#Blob(value)) switch (target) { case (#Blob(target)) value == target; case (_) false };
      case (#Bool(value)) switch (target) { case (#Bool(target)) value == target; case (_) false };
      case (#Int(value)) switch (target) { case (#Int(target)) value == target; case (_) false };
      case (#Int8(value)) switch (target) { case (#Int8(target)) value == target; case (_) false };
      case (#Int16(value)) switch (target) { case (#Int16(target)) value == target; case (_) false };
      case (#Int32(value)) switch (target) { case (#Int32(target)) value == target; case (_) false };
      case (#Int64(value)) switch (target) { case (#Int64(target)) value == target; case (_) false };
      case (#Nat(value)) switch (target) { case (#Nat(target)) value == target; case (_) false };
      case (#Nat8(value)) switch (target) { case (#Nat8(target)) value == target; case (_) false };
      case (#Nat16(value)) switch (target) { case (#Nat16(target)) value == target; case (_) false };
      case (#Nat32(value)) switch (target) { case (#Nat32(target)) value == target; case (_) false };
      case (#Nat64(value)) switch (target) { case (#Nat64(target)) value == target; case (_) false };
      case (#Float(value)) switch (target) { case (#Float(target)) value == target; case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) equal(value, target); case (_) false };
      case (#Option(null)) switch (target) { case (#Option(null)) true; case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func greaterOrLess(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) value != target; case (_) false };
      case (#Principal(value)) switch (target) { case (#Principal(target)) value != target; case (_) false };
      case (#Blob(value)) switch (target) { case (#Blob(target)) value != target; case (_) false };
      case (#Bool(value)) switch (target) { case (#Bool(target)) value != target; case (_) false };
      case (#Int(value)) switch (target) { case (#Int(target)) value != target; case (_) false };
      case (#Int8(value)) switch (target) { case (#Int8(target)) value != target; case (_) false };
      case (#Int16(value)) switch (target) { case (#Int16(target)) value != target; case (_) false };
      case (#Int32(value)) switch (target) { case (#Int32(target)) value != target; case (_) false };
      case (#Int64(value)) switch (target) { case (#Int64(target)) value != target; case (_) false };
      case (#Nat(value)) switch (target) { case (#Nat(target)) value != target; case (_) false };
      case (#Nat8(value)) switch (target) { case (#Nat8(target)) value != target; case (_) false };
      case (#Nat16(value)) switch (target) { case (#Nat16(target)) value != target; case (_) false };
      case (#Nat32(value)) switch (target) { case (#Nat32(target)) value != target; case (_) false };
      case (#Nat64(value)) switch (target) { case (#Nat64(target)) value != target; case (_) false };
      case (#Float(value)) switch (target) { case (#Float(target)) value != target; case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) greaterOrLess(value, target); case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func greater(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) value > target; case (_) false };
      case (#Principal(value)) switch (target) { case (#Principal(target)) value > target; case (_) false };
      case (#Blob(value)) switch (target) { case (#Blob(target)) value > target; case (_) false };
      case (#Bool(value)) switch (target) { case (#Bool(_)) value; case (_) false };
      case (#Int(value)) switch (target) { case (#Int(target)) value > target; case (_) false };
      case (#Int8(value)) switch (target) { case (#Int8(target)) value > target; case (_) false };
      case (#Int16(value)) switch (target) { case (#Int16(target)) value > target; case (_) false };
      case (#Int32(value)) switch (target) { case (#Int32(target)) value > target; case (_) false };
      case (#Int64(value)) switch (target) { case (#Int64(target)) value > target; case (_) false };
      case (#Nat(value)) switch (target) { case (#Nat(target)) value > target; case (_) false };
      case (#Nat8(value)) switch (target) { case (#Nat8(target)) value > target; case (_) false };
      case (#Nat16(value)) switch (target) { case (#Nat16(target)) value > target; case (_) false };
      case (#Nat32(value)) switch (target) { case (#Nat32(target)) value > target; case (_) false };
      case (#Nat64(value)) switch (target) { case (#Nat64(target)) value > target; case (_) false };
      case (#Float(value)) switch (target) { case (#Float(target)) value > target; case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) greaterOrLess(value, target); case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func greaterOrEqual(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) value >= target; case (_) false };
      case (#Principal(value)) switch (target) { case (#Principal(target)) value >= target; case (_) false };
      case (#Blob(value)) switch (target) { case (#Blob(target)) value >= target; case (_) false };
      case (#Bool(value)) switch (target) { case (#Bool(_)) true; case (_) false };
      case (#Int(value)) switch (target) { case (#Int(target)) value >= target; case (_) false };
      case (#Int8(value)) switch (target) { case (#Int8(target)) value >= target; case (_) false };
      case (#Int16(value)) switch (target) { case (#Int16(target)) value >= target; case (_) false };
      case (#Int32(value)) switch (target) { case (#Int32(target)) value >= target; case (_) false };
      case (#Int64(value)) switch (target) { case (#Int64(target)) value >= target; case (_) false };
      case (#Nat(value)) switch (target) { case (#Nat(target)) value >= target; case (_) false };
      case (#Nat8(value)) switch (target) { case (#Nat8(target)) value >= target; case (_) false };
      case (#Nat16(value)) switch (target) { case (#Nat16(target)) value >= target; case (_) false };
      case (#Nat32(value)) switch (target) { case (#Nat32(target)) value >= target; case (_) false };
      case (#Nat64(value)) switch (target) { case (#Nat64(target)) value >= target; case (_) false };
      case (#Float(value)) switch (target) { case (#Float(target)) value >= target; case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) greaterOrLess(value, target); case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func less(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) value < target; case (_) false };
      case (#Principal(value)) switch (target) { case (#Principal(target)) value < target; case (_) false };
      case (#Blob(value)) switch (target) { case (#Blob(target)) value < target; case (_) false };
      case (#Bool(value)) switch (target) { case (#Bool(_)) not value; case (_) false };
      case (#Int(value)) switch (target) { case (#Int(target)) value < target; case (_) false };
      case (#Int8(value)) switch (target) { case (#Int8(target)) value < target; case (_) false };
      case (#Int16(value)) switch (target) { case (#Int16(target)) value < target; case (_) false };
      case (#Int32(value)) switch (target) { case (#Int32(target)) value < target; case (_) false };
      case (#Int64(value)) switch (target) { case (#Int64(target)) value < target; case (_) false };
      case (#Nat(value)) switch (target) { case (#Nat(target)) value < target; case (_) false };
      case (#Nat8(value)) switch (target) { case (#Nat8(target)) value < target; case (_) false };
      case (#Nat16(value)) switch (target) { case (#Nat16(target)) value < target; case (_) false };
      case (#Nat32(value)) switch (target) { case (#Nat32(target)) value < target; case (_) false };
      case (#Nat64(value)) switch (target) { case (#Nat64(target)) value < target; case (_) false };
      case (#Float(value)) switch (target) { case (#Float(target)) value < target; case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) greaterOrLess(value, target); case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func lessOrEqual(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) value <= target; case (_) false };
      case (#Principal(value)) switch (target) { case (#Principal(target)) value <= target; case (_) false };
      case (#Blob(value)) switch (target) { case (#Blob(target)) value <= target; case (_) false };
      case (#Bool(value)) switch (target) { case (#Bool(_)) true; case (_) false };
      case (#Int(value)) switch (target) { case (#Int(target)) value <= target; case (_) false };
      case (#Int8(value)) switch (target) { case (#Int8(target)) value <= target; case (_) false };
      case (#Int16(value)) switch (target) { case (#Int16(target)) value <= target; case (_) false };
      case (#Int32(value)) switch (target) { case (#Int32(target)) value <= target; case (_) false };
      case (#Int64(value)) switch (target) { case (#Int64(target)) value <= target; case (_) false };
      case (#Nat(value)) switch (target) { case (#Nat(target)) value <= target; case (_) false };
      case (#Nat8(value)) switch (target) { case (#Nat8(target)) value <= target; case (_) false };
      case (#Nat16(value)) switch (target) { case (#Nat16(target)) value <= target; case (_) false };
      case (#Nat32(value)) switch (target) { case (#Nat32(target)) value <= target; case (_) false };
      case (#Nat64(value)) switch (target) { case (#Nat64(target)) value <= target; case (_) false };
      case (#Float(value)) switch (target) { case (#Float(target)) value <= target; case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) greaterOrLess(value, target); case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func like(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) contains(value, searchUtils(target)); case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) like(value, target); case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func ilike(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) containsLower(value, lowerSearchUtils(target)); case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) ilike(value, target); case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func unlike(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) not contains(value, searchUtils(target)); case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) unlike(value, target); case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func iunlike(value: Candy.CandyShared, target: Candy.CandyShared): Bool {
    return switch (value) {
      case (#Text(value)) switch (target) { case (#Text(target)) not containsLower(value, lowerSearchUtils(target)); case (_) false };
      case (#Option(?value)) switch (target) { case (#Option(?target)) iunlike(value, target); case (_) false };
      case (_) false;
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func compare(value: Candy.CandyShared, operator: Path.Operator, target: Candy.CandyShared): Bool {
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
