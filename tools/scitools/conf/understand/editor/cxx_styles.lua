-- The C++ lexer handles several languages.
-- All share a common style configuration.
return {
  [0] = {
    name = "Whitespace",
    style = "whitespace"
  },
  [1] = {
    name = "Block Comment",
    style = "comment"
  },
  [2] = {
    name = "Line Comment",
    style = "comment"
  },
  [3] = {
    name = "Doc Comment",
    style = "comment"
  },
  [4] = {
    name = "Number",
    style = "number"
  },
  [5] = {
    name = "Keyword",
    style = "keyword"
  },
  [6] = {
    name = "String",
    style = "doubleQuotedString"
  },
  [7] = {
    name = "Character",
    style = "singleQuotedString"
  },
  [8] = {
    name = "UUID"
  },
  [9] = {
    name = "Preprocessor",
    style = "preprocessor"
  },
  [10] = {
    name = "Operator",
    style = "operator"
  },
  [11] = {
    name = "Identifier",
    style = "identifier"
  },
  [12] = {
    name = "Unclosed String",
    style = "unclosedDoubleQuotedString"
  },
  [13] = {
    name = "Verbatim String",
    style = "doubleQuotedString"
  },
  [14] = {
    name = "Regex"
  },
  [15] = {
    name = "Doc Line Comment",
    style = "comment"
  },
  [16] = {
    name = "Secondary Keyword",
    style = "keyword"
  },
  [17] = {
    name = "Doc Keyword",
    style = "comment"
  },
  [18] = {
    name = "Invalid Doc Keyword",
    style = "comment"
  }
}
