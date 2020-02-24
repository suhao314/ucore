-- VHDL
return {
  name = "VHDL",
  lexer = 64,
  extensions = "vhd,vhdl",
  keywords = {
    [0] = {
      name = "Keywords",
      keywords =
        [[access after alias all architecture array assert attribute
        begin block body buffer bus case component configuration
        constant disconnect downto else elsif end entity exit
        file for function generate generic group guarded if impure
        in inertial inout is label library linkage literal loop
        map new next null of on open others out package port
        postponed procedure process pure range record register
        reject report return select severity shared signal subtype
        then to transport type unaffected units until use variable
        wait when while with abs and mod nand nor not or rem rol
        ror sla sll sra srl xnor xor]]
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
      name = "Bang Comment",
      style = "comment"
    },
    [3] = {
      name = "Number",
      style = "number"
    },
    [4] = {
      name = "String",
      style = "doubleQuotedString"
    },
    [5] = {
      name = "Operator",
      style = "operator"
    },
    [6] = {
      name = "Identifier",
      style = "identifier"
    },
    [7] = {
      name = "Unclosed String",
      style = "unclosedDoubleQuotedString"
    },
    [8] = {
      name = "Keyword",
      style = "keyword"
    },
    [15] = {
      name = "Character",
      style = "singleQuotedString"
    }
  },
  comment = {
    line = "--"
  }
}
