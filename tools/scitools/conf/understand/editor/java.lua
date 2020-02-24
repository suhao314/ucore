-- Java
return {
  name = "Java",
  lexer = 3,
  extensions = "java",
  properties = {
    ["lexer.cpp.continuation.lines"] = "0"
  },
  keywords = {
    [0] = {
      name = "Primary Keywords",
      keywords =
        [[abstract assert boolean break byte case catch char class
        const continue default do double else extends final finally
        float for future generic goto if implements import inner
        instanceof int interface long native new null outer package
        private protected public rest return short static super
        switch synchronized this throw throws transient try var
        void volatile while false true enum]]
    },
    [1] = {
      name = "Secondary Keywords",
      keywords = [[]]
    },
    [2] = {
      name = "Doc Keywords",
      keywords =
        [[author docRoot deprecated exception link param return
        see serial serialData serialFiel since throws version]]
    }
  },
  style = require "cxx_styles",
  comment = {
    line = "//"
  }
}
