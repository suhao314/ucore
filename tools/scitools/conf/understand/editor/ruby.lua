-- Ruby
return {
  name = "Ruby",
  lexer = 22,
  extensions = "rb,rbw",
  keywords = {
    [0] = {
      name = "Keywords",
      keywords =
        [[__FILE__ and def end in or self unless __LINE__ begin
        defined? ensure module redo super until BEGIN break do
        false next rescue then when END case else for nil retry
        true while alias class elsif if not return undef yield]]
    }
  },
  style = {
    [0] = {
      name = "Whitespace",
      style = "whitespace"
    },
    [1] = {
      name = "Error",
      style = "error"
    },
    [2] = {
      name = "Comment",
      style = "comment"
    },
    [3] = {
      name = "POD",
      fore = "#004000",
      back = "#C0FFC0",
      eolfilled = true
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
      name = "Class Name",
      fore = "#0000FF",
      bold = true
    },
    [9] = {
      name = "Def Name",
      fore = "#007F7F",
      bold = true
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
      name = "Regex",
      fore = "#000000",
      back = "#A0FFA0"
    },
    [13] = {
      name = "Global",
      fore = "#800080"
    },
    [14] = {
      name = "Symbol",
      fore = "#C0A030"
    },
    [15] = {
      name = "Module Name",
      fore = "#A000A0",
      bold = true
    },
    [16] = {
      name = "Instance Variable",
      fore = "#B00080"
    },
    [17] = {
      name = "Class Variable",
      fore = "#8000B0"
    },
    [18] = {
      name = "Backticks",
      fore = "#FFFF00",
      back = "#A08080"
    },
    [19] = {
      name = "DATASECTION",
      fore = "#600000",
      back = "#FFF0D8",
      eolfilled = true
    },
    [20] = {
      name = "HERE_DELIM",
      fore = "#000000",
      back = "#DDD0DD"
    },
    [21] = {
      name = "HERE_Q",
      fore = "#7F007F",
      back = "#DDD0DD",
      bold =  false,
      eolfilled = true
    },
    [22] = {
      name = "HERE_QQ",
      fore = "#7F007F",
      back = "#DDD0DD",
      bold = true,
      eolfilled = true
    },
    [23] = {
      name = "HERE_QX",
      fore = "#7F007F",
      back = "#DDD0DD",
      italic = true,
      eolfilled = true
    },
    [24] = {
      name = "STRING_Q",
      fore = "#7F007F",
      bold = false
    },
    [25] = {
      name = "STRING_QQ",
      fore = "#7F007F"
    },
    [26] = {
      name = "STRING_QX",
      fore = "#FFFF00",
      back = "#A08080"
    },
    [27] = {
      name = "STRING_QR",
      fore = "#000000",
      back = "#A0FFA0"
    },
    [28] = {
      name = "STRING_QW",
      fore = "#000000",
      back = "#FFFFE0"
    },
    [29] = {
      name = "Demoted Keyword"
    },
    [30] = {
      name = "STDIN",
      back = "#FF8080"
    },
    [31] = {
      name = "STDOUT",
      back = "#FF8080"
    },
    [40] = {
      name = "STDERR",
      back = "#FF8080"
    }
  }
}
