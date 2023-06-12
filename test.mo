import Candy "mo:candy2/types";
import Utils "./src/CandyUtils";
import Map "mo:map/Map";
import { thash } "mo:map/Map";

actor Test {
  public query func test(): async Candy.CandyShared {
    let candy: Candy.Candy = #Class(Map.fromIter<Text, Candy.Property>([
      ("aaa", { name = "aaa"; value = #Text("aaa"); immutable = false }),
      ("bbb", { name = "bbb"; value = #Text("bbb"); immutable = false }),
    ].vals(), thash));

    return Candy.shareCandy(Utils.get(candy, Utils.path("aaa")));
  };
};
