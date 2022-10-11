# Candy Path

## Compare Operators

| Operator                  | Description                                                                |
| :------------------------ | :------------------------------------------------------------------------- |
| `" == "`                  | equal                                                                      |
| `" != "`                  | not equal                                                                  |
| `" <> "`                  | not equal (returns false for mismatched type comparisons, #Empty and null) |
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
| `??`                      | #Empty value                                                               |

## Examples

```ts
import Utils "mo:candy_utils/CandyUtils";

let { get; getAll; path } = Utils;

let candy = #Empty; // our big candy structure here with nested arrays and objects

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

# To JSON

Converts candy to JSON string

# To Text

Converts candy to text if it is primitive or optional primitive, returns null otherwise

Types treated as primitives: text, principal, blob, bool, int(8,16,32,64), nat(8,16,32,64), float
