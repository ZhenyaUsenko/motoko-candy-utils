import Buffer "mo:stablebuffer/StableBuffer";
import Candy "mo:candy2/types";
import Debug "mo:base/Debug";
import Map "mo:map7/Map";
import Set "mo:map7/Set";
import { thash } "mo:map7/Map";

module {
  public type Schema = {
    #Text;
    #Principal;
    #Blob;
    #Bool;
    #Int;
    #Int8;
    #Int16;
    #Int32;
    #Int64;
    #Nat;
    #Nat8;
    #Nat16;
    #Nat32;
    #Nat64;
    #Float;
    #Bytes;
    #Floats;
    #Ints;
    #Nats;
    #Any;
    #Mutable: Schema;
    #Immutable: Schema;
    #Option: Schema;
    #Class: [(Text, Schema)];
    #StrictClass: [(Text, Schema)];
    #Map: (Schema, Schema);
    #Set: Schema;
    #Array: Schema;
    #OneOf: [Schema];
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func validate(candy: Candy.Candy, schema: Schema): Bool {
    return switch(schema) {
      case (#Text) switch (candy) { case (#Text(_)) true; case (_) false };
      case (#Principal) switch (candy) { case (#Principal(_)) true; case (_) false };
      case (#Blob) switch (candy) { case (#Blob(_)) true; case (_) false };
      case (#Bool) switch (candy) { case (#Bool(_)) true; case (_) false };
      case (#Int) switch (candy) { case (#Int(_)) true; case (_) false };
      case (#Int8) switch (candy) { case (#Int8(_)) true; case (_) false };
      case (#Int16) switch (candy) { case (#Int16(_)) true; case (_) false };
      case (#Int32) switch (candy) { case (#Int32(_)) true; case (_) false };
      case (#Int64) switch (candy) { case (#Int64(_)) true; case (_) false };
      case (#Nat) switch (candy) { case (#Nat(_)) true; case (_) false };
      case (#Nat8) switch (candy) { case (#Nat8(_)) true; case (_) false };
      case (#Nat16) switch (candy) { case (#Nat16(_)) true; case (_) false };
      case (#Nat32) switch (candy) { case (#Nat32(_)) true; case (_) false };
      case (#Nat64) switch (candy) { case (#Nat64(_)) true; case (_) false };
      case (#Float) switch (candy) { case (#Float(_)) true; case (_) false };
      case (#Bytes) switch (candy) { case (#Bytes(_)) true; case (_) false };
      case (#Floats) switch (candy) { case (#Floats(_)) true; case (_) false };
      case (#Ints) switch (candy) { case (#Ints(_)) true; case (_) false };
      case (#Nats) switch (candy) { case (#Nats(_)) true; case (_) false };
      case (#Any) true;
      case (#Mutable(_)) Debug.trap("#Mutable variant can only be used for class properties");
      case (#Immutable(_)) Debug.trap("#Immutable variant can only be used for class properties");

      case (#Option(optionSchema)) switch (candy) {
        case (#Option(?value)) return validate(value, optionSchema);
        case (#Option(null)) return true;
        case (_) return false;
      };

      case (#Class(classSchema)) switch (candy) {
        case (#Class(props)) {
          if (Map.size(props) < classSchema.size()) return false;

          for ((keySchema, valueSchema) in classSchema.vals()) {
            switch (Map.get(props, thash, keySchema)) {
              case (?prop) switch (valueSchema) {
                case (#Mutable(valueSchema)) {
                  if (prop.immutable or not validate(prop.value, valueSchema)) return false;
                };

                case (#Immutable(valueSchema)) {
                  if (not prop.immutable or not validate(prop.value, valueSchema)) return false;
                };

                case (_) {
                  if (not validate(prop.value, valueSchema)) return false;
                };
              };

              case (_) return false;
            };
          };

          return true;
        };

        case (_) return false;
      };

      case (#StrictClass(classSchema)) switch (candy) {
        case (#Class(props)) {
          if (Map.size(props) != classSchema.size()) return false;

          for ((keySchema, valueSchema) in classSchema.vals()) {
            switch (Map.get(props, thash, keySchema)) {
              case (?prop) switch (valueSchema) {
                case (#Mutable(valueSchema)) {
                  if (prop.immutable or not validate(prop.value, valueSchema)) return false;
                };

                case (#Immutable(valueSchema)) {
                  if (not prop.immutable or not validate(prop.value, valueSchema)) return false;
                };

                case (_) {
                  if (not validate(prop.value, valueSchema)) return false;
                };
              };

              case (_) return false;
            };
          };

          return true;
        };

        case (_) return false;
      };

      case (#Map(keySchema, valueSchema)) switch (candy) {
        case (#Map(map)) {
          for ((key, value) in Map.entries(map)) {
            if (not validate(key, keySchema) or not validate(value, valueSchema)) return false;
          };

          return true;
        };

        case (_) return false;
      };

      case (#Set(keySchema)) switch (candy) {
        case (#Set(set)) {
          for (key in Set.keys(set)) {
            if (not validate(key, keySchema)) return false;
          };

          return true;
        };

        case (_) false;
      };

      case (#Array(itemSchema)) switch (candy) {
        case (#Array(array)) {
          for (item in Buffer.vals(array)) {
            if (not validate(item, itemSchema)) return false;
          };

          return true;
        };

        case (_) return false;
      };

      case (#OneOf(schemaItems)) {
        for (subSchema in schemaItems.vals()) {
          if (validate(candy, subSchema)) return true;
        };

        return false;
      };
    };
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func validateShared(candy: Candy.CandyShared, schema: Schema): Bool {
    return switch(schema) {
      case (#Text) switch (candy) { case (#Text(_)) true; case (_) false };
      case (#Principal) switch (candy) { case (#Principal(_)) true; case (_) false };
      case (#Blob) switch (candy) { case (#Blob(_)) true; case (_) false };
      case (#Bool) switch (candy) { case (#Bool(_)) true; case (_) false };
      case (#Int) switch (candy) { case (#Int(_)) true; case (_) false };
      case (#Int8) switch (candy) { case (#Int8(_)) true; case (_) false };
      case (#Int16) switch (candy) { case (#Int16(_)) true; case (_) false };
      case (#Int32) switch (candy) { case (#Int32(_)) true; case (_) false };
      case (#Int64) switch (candy) { case (#Int64(_)) true; case (_) false };
      case (#Nat) switch (candy) { case (#Nat(_)) true; case (_) false };
      case (#Nat8) switch (candy) { case (#Nat8(_)) true; case (_) false };
      case (#Nat16) switch (candy) { case (#Nat16(_)) true; case (_) false };
      case (#Nat32) switch (candy) { case (#Nat32(_)) true; case (_) false };
      case (#Nat64) switch (candy) { case (#Nat64(_)) true; case (_) false };
      case (#Float) switch (candy) { case (#Float(_)) true; case (_) false };
      case (#Bytes) switch (candy) { case (#Bytes(_)) true; case (_) false };
      case (#Floats) switch (candy) { case (#Floats(_)) true; case (_) false };
      case (#Ints) switch (candy) { case (#Ints(_)) true; case (_) false };
      case (#Nats) switch (candy) { case (#Nats(_)) true; case (_) false };
      case (#Any) true;
      case (#Mutable(_)) Debug.trap("#Mutable variant can only be used for class properties");
      case (#Immutable(_)) Debug.trap("#Immutable variant can only be used for class properties");

      case (#Option(optionSchema)) switch (candy) {
        case (#Option(?value)) return validateShared(value, optionSchema);
        case (#Option(null)) return true;
        case (_) return false;
      };

      case (#Class(classSchema)) switch (candy) {
        case (#Class(props)) {
          if (props.size() < classSchema.size()) return false;

          for ((keySchema, valueSchema) in classSchema.vals()) label schemaPropIteration {
            for (prop in props.vals()) {
              if (prop.name == keySchema) {
                switch (valueSchema) {
                  case (#Mutable(valueSchema)) {
                    if (prop.immutable or not validateShared(prop.value, valueSchema)) return false;
                  };

                  case (#Immutable(valueSchema)) {
                    if (not prop.immutable or not validateShared(prop.value, valueSchema)) return false;
                  };

                  case (_) {
                    if (not validateShared(prop.value, valueSchema)) return false;
                  };
                };

                break schemaPropIteration;
              };
            };

            return false;
          };

          return true;
        };

        case (_) return false;
      };

      case (#StrictClass(classSchema)) switch (candy) {
        case (#Class(props)) {
          if (props.size() != classSchema.size()) return false;

          for ((keySchema, valueSchema) in classSchema.vals()) label schemaPropIteration {
            for (prop in props.vals()) {
              if (prop.name == keySchema) {
                switch (valueSchema) {
                  case (#Mutable(valueSchema)) {
                    if (prop.immutable or not validateShared(prop.value, valueSchema)) return false;
                  };

                  case (#Immutable(valueSchema)) {
                    if (not prop.immutable or not validateShared(prop.value, valueSchema)) return false;
                  };

                  case (_) {
                    if (not validateShared(prop.value, valueSchema)) return false;
                  };
                };

                break schemaPropIteration;
              };
            };

            return false;
          };

          return true;
        };

        case (_) return false;
      };

      case (#Map(keySchema, valueSchema)) switch (candy) {
        case (#Map(map)) {
          for ((key, value) in map.vals()) {
            if (not validateShared(key, keySchema) or not validateShared(value, valueSchema)) return false;
          };

          return true;
        };

        case (_) return false;
      };

      case (#Set(keySchema)) switch (candy) {
        case (#Set(set)) {
          for (key in set.vals()) {
            if (not validateShared(key, keySchema)) return false;
          };

          return true;
        };

        case (_) false;
      };

      case (#Array(itemSchema)) switch (candy) {
        case (#Array(array)) {
          for (item in array.vals()) {
            if (not validateShared(item, itemSchema)) return false;
          };

          return true;
        };

        case (_) return false;
      };

      case (#OneOf(schemaItems)) {
        for (subSchema in schemaItems.vals()) {
          if (validateShared(candy, subSchema)) return true;
        };

        return false;
      };
    };
  };
};
