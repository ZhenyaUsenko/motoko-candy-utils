import Candy "mo:candy/types";
import Prim "mo:prim";
import Path "./path";
import CompareValue "./compareValue";
import CompareCandy "./compareCandy";

module {
  let { abs } = Prim;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func getProp(root: Candy.CandyValue, candy: Candy.CandyValue, prop: Path.Prop): Candy.CandyValue {
    switch (candy) {
      case (#Class(data)) for (item in data.vals()) if (item.name == prop.0) return item.value;

      case (#Array(value)) if (prop.2) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        let arraySize = array.size();
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) array[abs(prop.1)] else #Empty;
      };

      case (#Bytes(value)) if (prop.2) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        let arraySize = array.size();
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Nat8(array[abs(prop.1)]) else #Empty;
      };

      case (#Floats(value)) if (prop.2) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        let arraySize = array.size();
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Float(array[abs(prop.1)]) else #Empty;
      };

      case (#Nats(value)) if (prop.2) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };
        let arraySize = array.size();
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Nat(array[abs(prop.1)]) else #Empty;
      };

      case (_) return #Empty;
    };

    return #Empty;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func arrayGetAll(root: Candy.CandyValue, candy: Candy.CandyValue): Candy.CandyValue {
    switch (candy) {
      case (#Array(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

        if (array.size() > 0) return array[0];
      };

      case (#Bytes(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

        if (array.size() > 0) return #Nat8(array[0]);
      };

      case (#Floats(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

        if (array.size() > 0) return #Float(array[0]);
      };

      case (#Nats(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

        if (array.size() > 0) return #Nat(array[0]);
      };

      case (_) return #Empty;
    };

    return #Empty;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func pathGet(root: Candy.CandyValue, candy: Candy.CandyValue, path: Path.Path): Candy.CandyValue {
    var result = candy;
    var currentProp = path;

    label pathLoop loop {
      switch (currentProp.0) {
        case (#ROOT) result := root;
        case (#ALL) result := arrayGetAll(root, result);
        case (#PROP(prop)) result := getProp(root, result, prop);
        case (#CONDITION(condition)) result := find(root, result, condition);
        case (_) {};
      };

      switch (currentProp.1) { case (?prop) currentProp := prop; case (_) break pathLoop };
    };

    return result;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func find(root: Candy.CandyValue, candy: Candy.CandyValue, condition: Path.Condition): Candy.CandyValue {
    switch (candy) {
      case (#Array(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

        for (item in array.vals()) if (checkCondition(root, item, condition)) return item;
      };

      case (#Bytes(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

        for (item in array.vals()) {
          let nat8 = #Nat8(item);

          if (checkCondition(root, nat8, condition)) return nat8;
        };
      };

      case (#Floats(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

        for (item in array.vals()) {
          let float = #Float(item);

          if (checkCondition(root, float, condition)) return float;
        };
      };

      case (#Nats(value)) {
        let array = switch (value) { case (#frozen(value)) value; case (#thawed(value)) value };

        for (item in array.vals()) {
          let nat = #Nat(item);

          if (checkCondition(root, nat, condition)) return nat;
        };
      };

      case (_) return #Empty;
    };

    return #Empty;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func checkCondition(root: Candy.CandyValue, candy: Candy.CandyValue, condition: Path.Condition): Bool {
    let mathes = switch (condition.2.10) {
      case (?path) CompareCandy.compare(pathGet(root, candy, condition.0), condition.1, pathGet(root, candy, path));
      case (_) CompareValue.compare(pathGet(root, candy, condition.0), condition.1, condition.2);
    };

    return ((
      mathes and (switch (condition.3) { case (?and1) checkCondition(root, candy, and1); case (_) true })
    ) or (
      switch (condition.4) { case (?or1) checkCondition(root, candy, or1); case (_) false }
    )) and (
      switch (condition.5) { case (?and2) checkCondition(root, candy, and2); case (_) true }
    );
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func get(candy: Candy.CandyValue, path: Path.Path): Candy.CandyValue {
    return switch (path.0) {
      case (#CONDITION(condition)) #Bool(checkCondition(candy, candy, condition));
      case (_) pathGet(candy, candy, path);
    };
  };
};
