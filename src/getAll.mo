import Array "mo:base/Array";
import Buffer "mo:stablebuffer/StableBuffer";
import Candy "mo:candy2/types";
import Get "./get";
import Map "mo:map/Map";
import Path "./path";
import Prim "mo:prim";
import { abs; clzNat32; nat32ToNat } "mo:prim";
import { thash } "mo:map/Map";

module {
  type Candies = (
    id: Nat32,
    data: [var Candy.Candy],
    capacity: Nat32,
    size: Nat32,
  );

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func growCandies(candies: Candies, size: Nat32): Candies {
    let newCapacity = 2 **% (33 -% clzNat32(size));
    let newCandies = Array.init<Candy.Candy>(nat32ToNat(newCapacity), #Option(null));

    for (index in candies.1.keys()) newCandies[index] := candies.1[index];

    return (candies.0 +% 1, newCandies, newCapacity, size);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func getAllProps(root: Candy.Candy, candies: Candies, prop: Path.Prop): Candies {
    var newCandies = candies;
    var size = 0:Nat32;
    var index = 0:Nat32;

    for (candy in candies.1.vals()) {
      switch (candy) {
        case (#Class(data)) switch (Map.get(data, thash, prop.0)) {
          case (?item) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := item.value;
            size +%= 1;
          };

          case (_) {};
        };

        case (#Array(array)) if (prop.2) {
          let arraySize = Buffer.size(array);
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := Buffer.get(array, abs(prop.1));
            size +%= 1;
          };
        };

        case (#Bytes(array)) if (prop.2) {
          let arraySize = Buffer.size(array);
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat8(Buffer.get(array, abs(prop.1)));
            size +%= 1;
          };
        };

        case (#Floats(array)) if (prop.2) {
          let arraySize = Buffer.size(array);
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Float(Buffer.get(array, abs(prop.1)));
            size +%= 1;
          };
        };

        case (#Ints(array)) if (prop.2) {
          let arraySize = Buffer.size(array);
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Int(Buffer.get(array, abs(prop.1)));
            size +%= 1;
          };
        };

        case (#Nats(array)) if (prop.2) {
          let arraySize = Buffer.size(array);
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat(Buffer.get(array, abs(prop.1)));
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

  public func arrayGetAll(root: Candy.Candy, candies: Candies): Candies {
    var newCandies = candies;
    var size = 0:Nat32;
    var index = 0:Nat32;

    for (candy in candies.1.vals()) {
      switch (candy) {
        case (#Array(array)) {
          for (item in Buffer.vals(array)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := item;
            size +%= 1;
          };
        };

        case (#Bytes(array)) {
          for (item in Buffer.vals(array)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat8(item);
            size +%= 1;
          };
        };

        case (#Floats(array)) {
          for (item in Buffer.vals(array)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Float(item);
            size +%= 1;
          };
        };

        case (#Ints(array)) {
          for (item in Buffer.vals(array)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Int(item);
            size +%= 1;
          };
        };

        case (#Nats(array)) {
          for (item in Buffer.vals(array)) {
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

  public func find(root: Candy.Candy, candies: Candies, condition: Path.Condition): Candies {
    var newCandies = candies;
    var size = 0:Nat32;
    var index = 0:Nat32;

    for (candy in candies.1.vals()) {
      switch (candy) {
        case (#Array(array)) {
          for (item in Buffer.vals(array)) if (Get.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := item;
            size +%= 1;
          };
        };

        case (#Bytes(array)) {
          for (item in Buffer.vals(array)) if (Get.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat8(item);
            size +%= 1;
          };
        };

        case (#Floats(array)) {
          for (item in Buffer.vals(array)) if (Get.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Float(item);
            size +%= 1;
          };
        };

        case (#Ints(array)) {
          for (item in Buffer.vals(array)) if (Get.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Int(item);
            size +%= 1;
          };
        };

        case (#Nats(array)) {
          for (item in Buffer.vals(array)) if (Get.checkCondition(root, candy, condition)) {
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

  public func pathGet(root: Candy.Candy, candy: Candy.Candy, path: Path.Path): [Candy.Candy] {
    var result = (1, [var candy, #Option(null), #Option(null), #Option(null)], 4, 1):Candies;
    var currentProp = path;

    label pathLoop loop {
      switch (currentProp.0) {
        case (#ROOT) result := (1, [var root, #Option(null), #Option(null), #Option(null)], 4, 1):Candies;
        case (#ALL) result := arrayGetAll(root, result);
        case (#PROP(prop)) result := getAllProps(root, result, prop);
        case (#CONDITION(condition)) result := find(root, result, condition);
        case (_) {};
      };

      switch (currentProp.1) { case (?prop) currentProp := prop; case (_) break pathLoop };
    };

    return Array.tabulate<Candy.Candy>(nat32ToNat(result.3), func(i) = result.1[i]);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func getAll(candy: Candy.Candy, path: ?Path.Path): [Candy.Candy] {
    return switch (path) {
      case (?path) switch (path.0) {
        case (#CONDITION(condition)) [#Bool(Get.checkCondition(candy, candy, condition))];
        case (_) pathGet(candy, candy, path);
      };

      case (_) [];
    };
  };
};
