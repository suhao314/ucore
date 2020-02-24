-- JavaScript
return {
  name = "JavaScript",
  lexer = 3,
  extensions = "js",
  keywords = {
    [0] = {
      name = "Primary Keywords",
      keywords =
        [[abstract boolean break byte case catch char class const
        continue debugger default delete do double else enum export
        extends final finally float for function goto if implements
        import in instanceof int interface long native new package
        private protected public return short static super switch
        synchronized this throw throws transient try typeof var
        void volatile while with]]
    },
    [1] = {
      name = "Secondary Keywords",
      keywords = [[]]
    }
  },
  style = require "cxx_styles",
  comment = {
    line = "//"
  }
}
