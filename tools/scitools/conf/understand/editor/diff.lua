-- Diff
return {
  name = "Diff",
  lexer = 16,
  extensions = "diff,patch",
  style = {
    [0] = {
      name = "Default",
      fore = "#000000",
      back = "#FFFFFF",
      eolfilled = true
    },
    [1] = {
      name = "Comment",
      fore = "#FFFFFF",
      back = "#3333EE",
      eolfilled = true
    },
    [2] = {
      name = "Command",
      fore = "#FFFFFF",
      back = "#3333EE",
      eolfilled = true
    },
    [3] = {
      name = "Source File",
      fore = "#FFFFFF",
      back = "#5555EE",
      eolfilled = true
    },
    [4] = {
      name = "Postion Setting",
      fore = "#FFFFFF",
      back = "#3333EE",
      eolfilled = true
    },
    [5] = {
      name = "Line Removal",
      fore = "#FFFFFF",
      back = "#550000",
      eolfilled = true
    },
    [6] = {
      name = "Line Addition",
      fore = "#FFFFFF",
      back = "#007700",
      eolfilled = true
    },
    [7] = {
      name = "Line Change",
      fore = "#FFFFFF",
      back = "#3333EE",
      eolfilled = true
    }
  }
}
