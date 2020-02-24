-- Pascal
return {
  name = "Pascal",
  lexer = 18,
  extensions = "dpr,dpk,pas,dfm,inc,pp",
  keywords = {
    [0] = {
      name = "Keywords",
      keywords =
        [[and array asm begin case cdecl class const constructor
        default destructor div do downto else end end. except
        exit exports external far file finalization finally for
        function goto if implementation in index inherited
        initialization inline interface label library message mod
        near nil not object of on or out overload override packed
        pascal private procedure program property protected public
        published raise read record register repeat resourcestring
        safecall set shl shr stdcall stored string then threadvar
        to try type unit until uses var virtual while with write
        xor]]
    },
    [1] = {
      name = "Classwords",
      keywords =
        [[write read default public protected private property
        published stored]]
    }
  },
  style = {
    [0] = {
      name = "Whitespace",
      style = "whitespace"
    },
    [1] = {
      name = "Identifier",
      style = "identifier"
    },
    [2] = {
      name = "Comment {...}",
      style = "comment"
    },
    [3] = {
      name = "Comment (*...*)",
      style = "comment"
    },
    [4] = {
      name = "Line Comment",
      style = "comment"
    },
    [5] = {
      name = "Preprocessor {$...}",
      style = "preprocessor"
    },
    [6] = {
      name = "Preprocessor (*$...*)",
      style = "preprocessor"
    },
    [7] = {
      name = "Number",
      style = "number"
    },
    [8] = {
      name = "Hex Number",
      style = "number"
    },
    [9] = {
      name = "Keyword",
      style = "keyword"
    },
    [10] = {
      name = "Double Quoted String",
      style = "doubleQuotedString"
    },
    [11] = {
      name = "Unclosed String",
      style = "unclosedDoubleQuotedString"
    },
    [12] = {
      name = "Single Quoted String",
      style = "singleQuotedString"
    },
    [13] = {
      name = "Operator",
      style = "operator"
    },
    [14] = {
      name = "Inline Asm",
      fore = "#008080"
    }
  }
}
