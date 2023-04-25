import Buffer "mo:stablebuffer/StableBuffer";
import Candy "mo:candy/types";
import CompareCandy "./compareCandy";
import CompareValue "./compareValue";
import Map "mo:map/Map";
import Path "./path";
import { abs } "mo:prim";
import { thash } "mo:map/Map";

module {
  public func getProp(root: Candy.Candy, candy: Candy.Candy, prop: Path.Prop): Candy.Candy {
    switch (candy) {
      case (#Class(data)) {
        switch (Map.get(data, thash, prop.0)) { case (?item) return item.value; case (_) {} };
      };

      case (#Array(array)) if (prop.2) {
        let arraySize = Buffer.size(array);
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) Buffer.get(array, abs(prop.1)) else #Option(null);
      };

      case (#Bytes(array)) if (prop.2) {
        let arraySize = Buffer.size(array);
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Nat8(Buffer.get(array, abs(prop.1))) else #Option(null);
      };

      case (#Floats(array)) if (prop.2) {
        let arraySize = Buffer.size(array);
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Float(Buffer.get(array, abs(prop.1))) else #Option(null);
      };

      case (#Ints(array)) if (prop.2) {
        let arraySize = Buffer.size(array);
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Int(Buffer.get(array, abs(prop.1))) else #Option(null);
      };

      case (#Nats(array)) if (prop.2) {
        let arraySize = Buffer.size(array);
        let index = if (prop.1 < 0) arraySize + prop.1 else prop.1;

        return if (index >= 0 and index < arraySize) #Nat(Buffer.get(array, abs(prop.1))) else #Option(null);
      };

      case (_) return #Option(null);
    };

    return #Option(null);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func arrayGetAll(root: Candy.Candy, candy: Candy.Candy): Candy.Candy {
    switch (candy) {
      case (#Array(array)) if (Buffer.size(array) > 0) return Buffer.get(array, 0);
      case (#Bytes(array)) if (Buffer.size(array) > 0) return #Nat8(Buffer.get(array, 0));
      case (#Floats(array)) if (Buffer.size(array) > 0) return #Float(Buffer.get(array, 0));
      case (#Ints(array)) if (Buffer.size(array) > 0) return #Int(Buffer.get(array, 0));
      case (#Nats(array)) if (Buffer.size(array) > 0) return #Nat(Buffer.get(array, 0));
      case (_) return #Option(null);
    };

    return #Option(null);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func pathGet(root: Candy.Candy, candy: Candy.Candy, path: Path.Path): Candy.Candy {
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

  public func find(root: Candy.Candy, candy: Candy.Candy, condition: Path.Condition): Candy.Candy {
    switch (candy) {
      case (#Array(array)) {
        for (item in Buffer.vals(array)) {
          if (checkCondition(root, item, condition)) return item;
        };
      };

      case (#Bytes(array)) {
        for (item in Buffer.vals(array)) {
          let nat8 = #Nat8(item);

          if (checkCondition(root, nat8, condition)) return nat8;
        };
      };

      case (#Floats(array)) {
        for (item in Buffer.vals(array)) {
          let float = #Float(item);

          if (checkCondition(root, float, condition)) return float;
        };
      };

      case (#Ints(array)) {
        for (item in Buffer.vals(array)) {
          let int = #Int(item);

          if (checkCondition(root, int, condition)) return int;
        };
      };

      case (#Nats(array)) {
        for (item in Buffer.vals(array)) {
          let nat = #Nat(item);

          if (checkCondition(root, nat, condition)) return nat;
        };
      };

      case (_) return #Option(null);
    };

    return #Option(null);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func checkCondition(root: Candy.Candy, candy: Candy.Candy, condition: Path.Condition): Bool {
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

  public func get(candy: Candy.Candy, path: ?Path.Path): Candy.Candy {
    return switch (path) {
      case (?path) switch (path.0) {
        case (#CONDITION(condition)) #Bool(checkCondition(candy, candy, condition));
        case (_) pathGet(candy, candy, path);
      };

      case (_) #Option(null);
    };
  };
};
