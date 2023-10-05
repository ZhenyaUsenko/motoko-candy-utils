import Array "mo:base/Array";
import Candy "mo:candy2/types";
import GetShared "./getShared";
import Path "./path";
import { abs; clzNat32; nat32ToNat } "mo:prim";

module {
  type CandiesShared = (
    id: Nat32,
    data: [var Candy.CandyShared],
    capacity: Nat32,
    size: Nat32,
  );

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func growCandies(candies: CandiesShared, size: Nat32): CandiesShared {
    let newCapacity = 2 **% (33 -% clzNat32(size));
    let newCandies = Array.init<Candy.CandyShared>(nat32ToNat(newCapacity), #Option(null));

    for (index in candies.1.keys()) newCandies[index] := candies.1[index];

    return (candies.0 +% 1, newCandies, newCapacity, size);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func getAllProps(root: Candy.CandyShared, candies: CandiesShared, prop: Path.Prop): CandiesShared {
    var newCandies = candies;
    var size = 0:Nat32;
    var index = 0:Nat32;

    for (candy in candies.1.vals()) {
      switch (candy) {
        case (#Class(data)) {
          label propertySearch for (item in data.vals()) if (item.name == prop.0) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := item.value;
            size +%= 1;

            break propertySearch;
          };
        };

        case (#Array(array)) if (prop.2) {
          let arraySize = array.size();
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := array[abs(prop.1)];
            size +%= 1;
          };
        };

        case (#Bytes(array)) if (prop.2) {
          let arraySize = array.size();
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat8(array[abs(prop.1)]);
            size +%= 1;
          };
        };

        case (#Floats(array)) if (prop.2) {
          let arraySize = array.size();
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Float(array[abs(prop.1)]);
            size +%= 1;
          };
        };

        case (#Ints(array)) if (prop.2) {
          let arraySize = array.size();
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Int(array[abs(prop.1)]);
            size +%= 1;
          };
        };

        case (#Nats(array)) if (prop.2) {
          let arraySize = array.size();
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat(array[abs(prop.1)]);
            size +%= 1;
          };
        };

        case (_) {};
      };

      index +%= 1;
    };

    return if (size == newCandies.3) newCandies else (newCandies.0, newCandies.1, newCandies.2, size);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func arrayGetAll(root: Candy.CandyShared, candies: CandiesShared): CandiesShared {
    var newCandies = candies;
    var size = 0:Nat32;
    var index = 0:Nat32;

    for (candy in candies.1.vals()) {
      switch (candy) {
        case (#Array(array)) {
          for (item in array.vals()) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := item;
            size +%= 1;
          };
        };

        case (#Bytes(array)) {
          for (item in array.vals()) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat8(item);
            size +%= 1;
          };
        };

        case (#Floats(array)) {
          for (item in array.vals()) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Float(item);
            size +%= 1;
          };
        };

        case (#Ints(array)) {
          for (item in array.vals()) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Int(item);
            size +%= 1;
          };
        };

        case (#Nats(array)) {
          for (item in array.vals()) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat(item);
            size +%= 1;
          };
        };

        case (_) {};
      };

      index +%= 1;
    };

    return if (size == newCandies.3) newCandies else (newCandies.0, newCandies.1, newCandies.2, size);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func find(root: Candy.CandyShared, candies: CandiesShared, condition: Path.Condition): CandiesShared {
    var newCandies = candies;
    var size = 0:Nat32;
    var index = 0:Nat32;

    for (candy in candies.1.vals()) {
      switch (candy) {
        case (#Array(array)) {
          for (item in array.vals()) if (GetShared.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := item;
            size +%= 1;
          };
        };

        case (#Bytes(array)) {
          for (item in array.vals()) if (GetShared.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat8(item);
            size +%= 1;
          };
        };

        case (#Floats(array)) {
          for (item in array.vals()) if (GetShared.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Float(item);
            size +%= 1;
          };
        };

        case (#Ints(array)) {
          for (item in array.vals()) if (GetShared.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Int(item);
            size +%= 1;
          };
        };

        case (#Nats(array)) {
          for (item in array.vals()) if (GetShared.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat(item);
            size +%= 1;
          };
        };

       case (_) {};
      };

      index +%= 1;
    };

    return if (size == newCandies.3) newCandies else (newCandies.0, newCandies.1, newCandies.2, size);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func pathGet(root: Candy.CandyShared, candy: Candy.CandyShared, path: Path.Path): [Candy.CandyShared] {
    var result = (1, [var candy, #Option(null), #Option(null), #Option(null)], 4, 1):CandiesShared;
    var currentProp = path;

    label pathLoop loop {
      switch (currentProp.0) {
        case (#ROOT) result := (1, [var root, #Option(null), #Option(null), #Option(null)], 4, 1):CandiesShared;
        case (#ALL) result := arrayGetAll(root, result);
        case (#PROP(prop)) result := getAllProps(root, result, prop);
        case (#CONDITION(condition)) result := find(root, result, condition);
        case (_) {};
      };

      switch (currentProp.1) { case (?prop) currentProp := prop; case (_) break pathLoop };
    };

    return Array.tabulate<Candy.CandyShared>(nat32ToNat(result.3), func(i) = result.1[i]);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func getAllShared(candy: Candy.CandyShared, path: ?Path.Path): [Candy.CandyShared] {
    return switch (path) {
      case (?path) switch (path.0) {
        case (#CONDITION(condition)) [#Bool(GetShared.checkCondition(candy, candy, condition))];
        case (_) pathGet(candy, candy, path);
      };

      case (_) [];
    };
  };
};
