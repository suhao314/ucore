-- C++
return {
  name = "C++",
  lexer = 3,
  extensions = "cpp,cxx,cc,h,hpp,hxx,hh",
  keywords = {
    [0] = {
      name = "Primary Keywords",
      keywords = require "c_keywords"
    },
    [1] = {
      name = "Secondary Keywords",
      keywords = require "cxx_keywords"
    },
    [2] = {
      name = "Doc Keywords",
      keywords = require "doxygen_keywords"
    }
  },
  style = require "cxx_styles",
  comment = {
    line = "//"
  },
  chars = {
    word =
      "abcdefghijklmnopqrstuvwxyz" ..
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
      "0123456789_~"
  },
  match = {
    keyword = {
      start = "if ifdef ifndef elif else",
      ["end"] = "endif elif else"
    }
  }
}
