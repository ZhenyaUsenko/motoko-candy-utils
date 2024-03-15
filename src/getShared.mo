import Candy "mo:candy3/types";
import CompareCandyShared "./compareCandyShared";
import CompareValueShared "./compareValueShared";
import Path "./path";
import { abs } "mo:prim";

module {
  public func getProp(candy: Candy.CandyShared, prop: Path.Prop): Candy.CandyShared {
    switch (candy) {
      case (#Class(data)) {
        for (item in data.vals()) if (item.name == prop.0) return item.value;
      };

      case (#Array(array)) if (prop.2) {
        let arraySize = array.size();
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) array[abs(prop.1)] else #Option(null);
      };

      case (#Bytes(array)) if (prop.2) {
        let arraySize = array.size();
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Nat8(array[abs(prop.1)]) else #Option(null);
      };

      case (#Floats(array)) if (prop.2) {
        let arraySize = array.size();
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Float(array[abs(prop.1)]) else #Option(null);
      };

      case (#Ints(array)) if (prop.2) {
        let arraySize = array.size();
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Int(array[abs(prop.1)]) else #Option(null);
      };

      case (#Nats(array)) if (prop.2) {
        let arraySize = array.size();
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Nat(array[abs(prop.1)]) else #Option(null);
      };

      case (_) return #Option(null);
    };

    return #Option(null);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func arrayGetAll(candy: Candy.CandyShared): Candy.CandyShared {
    switch (candy) {
      case (#Array(array)) if (array.size() > 0) return array[0];
      case (#Bytes(array)) if (array.size() > 0) return #Nat8(array[0]);
      case (#Floats(array)) if (array.size() > 0) return #Float(array[0]);
      case (#Ints(array)) if (array.size() > 0) return #Int(array[0]);
      case (#Nats(array)) if (array.size() > 0) return #Nat(array[0]);
      case (_) return #Option(null);
    };

    return #Option(null);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func pathGet(root: Candy.CandyShared, candy: Candy.CandyShared, path: Path.Path): Candy.CandyShared {
    var result = candy;
    var currentProp = path;

    label pathLoop loop {
      switch (currentProp.0) {
        case (#ROOT) result := root;
        case (#ALL) result := arrayGetAll(result);
        case (#PROP(prop)) result := getProp(result, prop);
        case (#CONDITION(condition)) result := find(root, result, condition);
        case (_) {};
      };

      switch (currentProp.1) { case (?prop) currentProp := prop; case (_) break pathLoop };
    };

    return result;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func find(root: Candy.CandyShared, candy: Candy.CandyShared, condition: Path.Condition): Candy.CandyShared {
    switch (candy) {
      case (#Array(array)) {
        for (item in array.vals()) {
          if (checkCondition(root, item, condition)) return item;
        };
      };

      case (#Bytes(array)) {
        for (item in array.vals()) {
          let nat8 = #Nat8(item);

          if (checkCondition(root, nat8, condition)) return nat8;
        };
      };

      case (#Floats(array)) {
        for (item in array.vals()) {
          let float = #Float(item);

          if (checkCondition(root, float, condition)) return float;
        };
      };

      case (#Ints(array)) {
        for (item in array.vals()) {
          let int = #Int(item);

          if (checkCondition(root, int, condition)) return int;
        };
      };

      case (#Nats(array)) {
        for (item in array.vals()) {
          let nat = #Nat(item);

          if (checkCondition(root, nat, condition)) return nat;
        };
      };

      case (_) return #Option(null);
    };

    return #Option(null);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func checkCondition(root: Candy.CandyShared, candy: Candy.CandyShared, condition: Path.Condition): Bool {
    let mathes = switch (condition.2.10) {
      case (?path) CompareCandyShared.compare(pathGet(root, candy, condition.0), condition.1, pathGet(root, candy, path));
      case (_) CompareValueShared.compare(pathGet(root, candy, condition.0), condition.1, condition.2);
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

  public func getShared(candy: Candy.CandyShared, path: ?Path.Path): Candy.CandyShared {
    return switch (path) {
      case (?path) switch (path.0) {
        case (#CONDITION(condition)) #Bool(checkCondition(candy, candy, condition));
        case (_) pathGet(candy, candy, path);
      };

      case (_) #Option(null);
    };
  };
};
