-- XML
return {
  name = "XML",
  lexer = 5,
  extensions = "xml",
  style = {
    [1] = {
      name = "Tag",
      style = "keyword"
    },
    [2] = {
      name = "Unknown Tag",
      style = "keyword"
    },
    [3] = {
      name = "Attribute",
      style = "label"
    },
    [4] = {
      name = "Unknown Attribute",
      style = "label"
    },
    [5] = {
      name = "Number",
      style = "number"
    },
    [6] = {
      name = "Double-quoted String",
      style = "doubleQuotedString"
    },
    [7] = {
      name = "Single-quoted String",
      style = "singleQuotedString"
    },
    [8] = {
      name = "Other Inside Tag",
      style = "keyword"
    },
    [9] = {
      name = "Comment",
      style = "comment"
    },
    [10] = {
      name = "Entity"
    },
    [11] = {
      name = "XML style tag end '/>'",
      style = "keyword"
    },
    [12] = {
      name = "XML identifier start '<?'",
      style = "keyword"
    },
    [13] = {
      name = "XML identifier end '?>'",
      style = "keyword"
    },
    [17] = {
      name = "CDATA"
    },
    [18] = {
      name = "Question"
    },
    [19] = {
      name = "Unquoted Value"
    },
    [21] = {
      name = "SGML Tag <! ... >",
      style = "keyword"
    },
    [22] = {
      name = "SGML Command"
    },
    [23] = {
      name = "SGML 1st Param"
    },
    [24] = {
      name = "SGML Double-quoted String",
      style = "doubleQuotedString"
    },
    [25] = {
      name = "SGML Single-quoted String",
      style = "singleQuotedString"
    },
    [26] = {
      name = "SGML Error",
      style = "error"
    },
    [27] = {
      name = "SGML Special (#xxxx type)"
    },
    [28] = {
      name = "SGML Entity"
    },
    [29] = {
      name = "SGML Comment",
      style = "comment"
    },
    [31] = {
      name = "SGML Block"
    }
  }
}
