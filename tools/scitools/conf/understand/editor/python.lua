-- Python
return {
  name = "Python",
  lexer = 2,
  extensions = "py,pyw",
  patterns = "[Ss][Cc]ons.*",
  keywords = {
    [0] = {
      name = "Keywords",
      keywords =
        [[and assert break class continue def del elif else except
        exec finally for from global if import in is lambda None
        not or pass print raise return try while yield]]
    },
    [1] = {
      name = "Highlighted Identifiers",
      keywords = [[]]
    }
  },
  style = {
    [0] = {
      name = "Whitespace",
      style = "whitespace"
    },
    [1] = {
      name = "Comment",
      style = "comment"
    },
    [2] = {
      name = "Number",
      style = "number"
    },
    [3] = {
      name = "Double-quoted String",
      style = "doubleQuotedString"
    },
    [4] = {
      name = "Single-quoted String",
      style = "singleQuotedString"
    },
    [5] = {
      name = "Keyword",
      style = "keyword"
    },
    [6] = {
      name = "Triple-quotes",
      style = "singleQuotedString"
    },
    [7] = {
      name = "Triple-double-quotes",
      style = "doubleQuotedString"
    },
    [8] = {
      name = "Class Definition",
      style = "identifier"
    },
    [9] = {
      name = "Function Definition",
      style = "identifier"
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
      name = "Comment Block",
      style = "comment"
    },
    [13] = {
      name = "Unclosed String",
      style = "unclosedDoubleQuotedString"
    },
    [14] = {
      name = "Highlighted Identifier",
      fore = "#407090"
    },
    [15] = {
      name = "Decorator",
      fore = "#805000"
    }
  }
}
