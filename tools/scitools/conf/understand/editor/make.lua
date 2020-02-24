-- Makefile
return {
  name = "Makefile",
  lexer = 11,
  extensions = "mak",
  patterns = "[Mm]akefile.*",

  -- Override tab settings.
  tabs = {
    use = true
  },
  file = {
    converttabs = false
  },

  style = {
    [1] = {
      name = "Comment",
      style = "comment"
    },
    [2] = {
      name = "Preprocessor",
      style = "preprocessor"
    },
    [3] = {
      name = "Variable",
      style = "label"
    },
    [4] = {
      name = "Operator",
      style = "operator"
    },
    [5] = {
      name = "Target",
      style = "identifier"
    },
    [9] = {
      name = "Error",
      style = "error"
    }
  },
  comment = {
    line = "#"
  }
}
