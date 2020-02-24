-- C
return {
  name = "C",
  lexer = 3,
  extensions = "c,h",
  keywords = {
    [0] = {
      name = "Primary Keywords",
      keywords = require "c_keywords"
    },
    [1] = {
      name = "Secondary Keywords",
      keywords = ""
    },
    [2] = {
      name = "Doc Keywords",
      keywords = ""
    }
  },
  style = require "cxx_styles",
  comment = {
    line = "//"
  },
  match = {
    keyword = {
      start = "if ifdef ifndef elif else",
      ["end"] = "endif elif else"
    }
  }
}
