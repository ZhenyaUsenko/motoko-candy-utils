import Candy "mo:candy3/types";
import Utils "./src/CandyUtils";
import Map "mo:map9/Map";
import { thash } "mo:map9/Map";

actor Test {
  public query func test(): async [Text] {
    let candyValue1: Candy.CandyShared = #Text("John Doe");

    let candyValue2: Candy.CandyShared = #Class([
      { name = "name"; value = #Text("John"); immutable = true },
      { name = "surname"; value = #Text("Doe"); immutable = true },
      { name = "languages"; value = #Array([#Text("English"), #Text("German"), #Text("Russian")]); immutable = true },
      {
        name = "organization";
        value = #Class([
          { name = "name"; value = #Text("ABC"); immutable = true },
          { name = "typeOfActivity"; value = #Text("Programming"); immutable = true },
        ]);
        immutable = true;
      },
    ]);

    let schema1: Utils.Schema = #Text;

    let schema2: Utils.Schema = #Class([
      ("name", #Text),
      ("surname", #Text),
      ("languages", #Array(#Text)),
      ("organization", #StrictClass([
        ("name", #Immutable(#Text)),
        ("typeOfActivity", #Text),
      ])),
    ]);

    let schema3: Utils.Schema = #OneOf([schema1, schema2]);

    let validation1 = Utils.validateShared(candyValue1, schema1); // true

    let validation2 = Utils.validateShared(candyValue2, schema2); // true

    let validation3 = Utils.validateShared(candyValue1, schema2); // false

    let validation4 = Utils.validateShared(candyValue2, schema1); // false

    let validation5 = Utils.validateShared(candyValue1, schema3); // true

    let validation6 = Utils.validateShared(candyValue2, schema3); // true

    return [
      debug_show([validation1, validation2, validation3, validation4, validation5, validation6]),
    ];
  };
};
