# Candy Path

## Compare Operators

| Operator                  | Description                                                                |
| :------------------------ | :------------------------------------------------------------------------- |
| `" == "`                  | equal                                                                      |
| `" != "`                  | not equal                                                                  |
| `" <> "`                  | not equal (returns false for mismatched type comparisons and null)         |
| `" > "`                   | greater                                                                    |
| `" >= "`                  | greater or equal                                                           |
| `" < "`                   | less                                                                       |
| `" <= "`                  | less or equal                                                              |
| `" ~= "`                  | text contains                                                              |
| `" ~~= "`                 | text contains (case insensitive)                                           |
| `" !~= "`                 | text does not contain                                                      |
| `" !~~= "`                | text does not contain (case insensitive)                                   |

## And/Or Operators

| Operator                  | Description                                                                |
| :------------------------ | :------------------------------------------------------------------------- |
| `" & "`                   | and                                                                        |
| `" \| "`                  | or                                                                         |

## Property/Reference/Value Operators

| Operator                  | Description                                                                |
| :------------------------ | :------------------------------------------------------------------------- |
| `.`                       | get next property or array item                                            |
| `[...]`                   | array find                                                                 |
| `@`                       | reference current array item                                               |
| `$`                       | reference root candy                                                       |
| `*`                       | get all array items                                                        |
| `?`                       | null value                                                                 |

## Examples

```ts
import Utils "mo:candy_utils/CandyUtils";

let { get; getAll; path } = Utils;

let candy = #Option(null); // our big candy structure here with nested arrays and objects

let candy1 = get(candy, path("books.0.author.name"));

let candy2 = get(candy, path("books.-2.author.name"));

let candy3 = get(candy, path("books[author.name ~= John].author.name"));

let candy4 = get(candy, path("books[author.name == $.mostPopularAuthor].pageNumber")));

let candy5 = get(candy, path("books[author.name == $.mostPopularAuthor | pageNumber < @.numberOfPurchases].pageNumber"));

let candy6 = get(candy, path("books.0.author.name == John"));

let candy7 = getAll(candy, path("books.*.author.name"));
```

## Roadmap
1) add support for type casts
2) add support for parenthesis to prioritise and/or conditions
3) add deep search operator

# Candy Schema

## Examples

```ts
import Candy "mo:candy/types";
import Utils "mo:candy_utils/CandyUtils";

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
  ("organization", #Class([
    ("name", #Text),
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
```

## Notes

- Validation for immutability is not supported yet
- Class with a broader set of properties than the schema is valid
- Type is required for Option validation (it is currently not possible to validate that an Option is strictly null)

# To JSON

Converts candy to JSON string

# To Text

Converts candy to text if it is primitive or optional primitive, returns null otherwise

Types treated as primitives: text, principal, blob, bool, int(8,16,32,64), nat(8,16,32,64), float
