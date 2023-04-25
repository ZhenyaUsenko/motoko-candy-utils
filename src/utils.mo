import Array "mo:base/Array";
import { nat32ToNat; natToNat32; charToNat32; charIsUppercase; charToLower } "mo:prim";

module {
  public type SearchUtils = (
    chars: [Char],
    size: Nat32,
    sum: Nat32,
  );

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public let DEFAULT_UTILS = ([], 0, 0):SearchUtils;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func textToNat(text: Text): ?Nat {
    var result = 0:Nat32;

    for (char in text.chars()) if (char >= '0' and char <= '9') result := result *% 10 +% (charToNat32(char) -% 48) else return null;

    return ?nat32ToNat(result);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func searchUtils(text: Text): SearchUtils {
    let nextChar = text.chars().next;
    let size = text.size();
    var sum = 0:Nat32;

    let chars = Array.tabulate<Char>(size, func(_) = switch (nextChar()) {
      case (?char) {
        sum +%= charToNat32(char);

        char;
      };

      case (_) '0';
    });

    return (chars, natToNat32(size), sum);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func lowerSearchUtils(text: Text): SearchUtils {
    let nextChar = text.chars().next;
    let size = text.size();
    var sum = 0:Nat32;

    let chars = Array.tabulate<Char>(size, func(_) = switch (nextChar()) {
      case (?char) {
        sum +%= charToNat32(char);

        if (charIsUppercase(char)) charToLower(char) else char;
      };

      case (_) '0';
    });

    return (chars, natToNat32(size), sum);
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func contains(text: Text, searchUtils: SearchUtils): Bool {
    if (searchUtils.1 == 0) return true;

    let chars = Array.init<Char>(nat32ToNat(searchUtils.1), '0');
    let lastSearchIndex = searchUtils.1 -% 1;
    let frontIter = text.chars();
    let backIterNext = text.chars().next;
    var frontSum = 0:Nat32;
    var backSum = 0:Nat32;
    var frontIndex = 0:Nat32;

    if (lastSearchIndex > 0) label frontLoop for (char in frontIter) {
      chars[nat32ToNat(frontIndex)] := char;
      frontSum +%= charToNat32(char);
      frontIndex +%= 1;

      if (frontIndex >= lastSearchIndex) break frontLoop;
    };

    for (char in frontIter) {
      chars[nat32ToNat(frontIndex)] := char;
      frontSum +%= charToNat32(char);

      if (frontSum -% backSum == searchUtils.2) {
        var textIndex = if (frontIndex >= lastSearchIndex) 0:Nat32 else frontIndex +% 1;
        var searchIndex = 0:Nat32;

        label containCheck {
          while (searchIndex <= lastSearchIndex) {
            if (chars[nat32ToNat(textIndex)] != searchUtils.0[nat32ToNat(searchIndex)]) break containCheck;

            textIndex := if (textIndex >= lastSearchIndex) 0:Nat32 else textIndex +% 1;
            searchIndex +%= 1;
          };

          return true;
        };
      };

      backSum +%= switch (backIterNext()) { case (?char) charToNat32(char); case (_) 0 };
      frontIndex := if (frontIndex >= lastSearchIndex) 0 else frontIndex +% 1;
    };

    return false;
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  public func containsLower(text: Text, searchUtils: SearchUtils): Bool {
    if (searchUtils.1 == 0) return true;

    let chars = Array.init<Char>(nat32ToNat(searchUtils.1), '0');
    let lastSearchIndex = searchUtils.1 -% 1;
    let frontIter = text.chars();
    let backIterNext = text.chars().next;
    var frontSum = 0:Nat32;
    var backSum = 0:Nat32;
    var frontIndex = 0:Nat32;

    if (lastSearchIndex > 0) label frontLoop for (char in frontIter) {
      chars[nat32ToNat(frontIndex)] := char;
      frontSum +%= charToNat32(char);
      frontIndex +%= 1;

      if (frontIndex >= lastSearchIndex) break frontLoop;
    };

    for (char in frontIter) {
      let lowerChar = if (charIsUppercase(char)) charToLower(char) else char;

      chars[nat32ToNat(frontIndex)] := lowerChar;
      frontSum +%= charToNat32(lowerChar);

      if (frontSum -% backSum == searchUtils.2) {
        var textIndex = if (frontIndex >= lastSearchIndex) 0:Nat32 else frontIndex +% 1;
        var searchIndex = 0:Nat32;

        label containCheck {
          while (searchIndex <= lastSearchIndex) {
            if (chars[nat32ToNat(textIndex)] != searchUtils.0[nat32ToNat(searchIndex)]) break containCheck;

            textIndex := if (textIndex >= lastSearchIndex) 0:Nat32 else textIndex +% 1;
            searchIndex +%= 1;
          };

          return true;
        };
      };

      backSum +%= switch (backIterNext()) {
        case (?char) if (charIsUppercase(char)) charToNat32(charToLower(char)) else charToNat32(char);
        case (_) 0;
      };

      frontIndex := if (frontIndex >= lastSearchIndex) 0 else frontIndex +% 1;
    };

    return false;
  };
};
