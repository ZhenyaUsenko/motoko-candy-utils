import Candy "mo:candy/types";
import Prim "mo:prim";
import Path "./path";
import Get "./get";

module {
  let { Array_init = initArray; Array_tabulate = tabulateArray; abs; clzNat32; nat32ToNat } = Prim;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  type Candies = (
    id: Nat32,
    data: [var Candy.CandyValue],
    capacity: Nat32,
    size: Nat32,
  );

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func growCandies(candies: Candies, size: Nat32): Candies {
    let newCapacity = 2 **% (33 -% clzNat32(size));
    let newCandies = initArray<Candy.CandyValue>(nat32ToNat(newCapacity), #Empty);

    for (index in candies.1.keys()) newCandies[index] := candies.1[index];

    return (candies.0 +% 1, newCandies, newCapacity, size);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func getAllProps(root: Candy.CandyValue, candies: Candies, prop: Path.Prop): Candies {
    var newCandies = candies;
    var size = 0:Nat32;
    var index = 0:Nat32;

    for (candy in candies.1.vals()) {
      switch (candy) {
        case (#Class(data)) for (item in data.vals()) if (item.name == prop.0) {
          if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

          newCandies.1[nat32ToNat(size)] := item.value;
          size +%= 1;
        };

        case (#Array(value)) if (prop.2) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
          let arraySize = array.size();
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := array[abs(prop.1)];
            size +%= 1;
          };
        };

        case (#Bytes(value)) if (prop.2) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
          let arraySize = array.size();
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat8(array[abs(prop.1)]);
            size +%= 1;
          };
        };

        case (#Floats(value)) if (prop.2) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
          let arraySize = array.size();
          let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

          if (index >= 0 and index < arraySize) {
            if (size >= newCandies.2) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Float(array[abs(prop.1)]);
            size +%= 1;
          };
        };

        case (#Nats(value)) if (prop.2) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
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

  public func arrayGetAll(root: Candy.CandyValue, candies: Candies): Candies {
    var newCandies = candies;
    var size = 0:Nat32;
    var index = 0:Nat32;

    for (candy in candies.1.vals()) {
      switch (candy) {
        case (#Array(value)) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

          for (item in array.vals()) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := item;
            size +%= 1;
          };
        };

        case (#Bytes(value)) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

          for (item in array.vals()) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat8(item);
            size +%= 1;
          };
        };

        case (#Floats(value)) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

          for (item in array.vals()) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Float(item);
            size +%= 1;
          };
        };

        case (#Nats(value)) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

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

  public func find(root: Candy.CandyValue, candies: Candies, condition: Path.Condition): Candies {
    var newCandies = candies;
    var size = 0:Nat32;
    var index = 0:Nat32;

    for (candy in candies.1.vals()) {
      switch (candy) {
        case (#Array(value)) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

          for (item in array.vals()) if (Get.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := item;
            size +%= 1;
          };
        };

        case (#Bytes(value)) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

          for (item in array.vals()) if (Get.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Nat8(item);
            size +%= 1;
          };
        };

        case (#Floats(value)) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

          for (item in array.vals()) if (Get.checkCondition(root, candy, condition)) {
            if (size >= newCandies.2 or (newCandies.0 != candies.0 and size > index)) newCandies := growCandies(newCandies, size);

            newCandies.1[nat32ToNat(size)] := #Float(item);
            size +%= 1;
          };
        };

        case (#Nats(value)) {
          let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

          for (item in array.vals()) if (Get.checkCondition(root, candy, condition)) {
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

  public func pathGet(root: Candy.CandyValue, candy: Candy.CandyValue, path: Path.Path): [Candy.CandyValue] {
    var result = (1, [var candy, #Empty, #Empty, #Empty], 4, 1):Candies;
    var currentProp = path;

    label pathLoop loop {
      switch (currentProp.0) {
        case (#ROOT) result := (1, [var root, #Empty, #Empty, #Empty], 4, 1):Candies;
        case (#ALL) result := arrayGetAll(root, result);
        case (#PROP(prop)) result := getAllProps(root, result, prop);
        case (#CONDITION(condition)) result := find(root, result, condition);
        case (_) {};
      };

      switch (currentProp.1) { case (?prop) currentProp := prop; case (_) break pathLoop };
    };

    return tabulateArray<Candy.CandyValue>(nat32ToNat(result.3), func(i) = result.1[i]);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func getAll(candy: Candy.CandyValue, path: Path.Path): [Candy.CandyValue] {
    return switch (path.0) {
      case (#CONDITION(condition)) [#Bool(Get.checkCondition(candy, candy, condition))];
      case (_) pathGet(candy, candy, path);
    };
  };
};
