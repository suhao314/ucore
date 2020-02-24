return {
 style = {
    [32] = { -- Default
      fore = "#000000",
      back = "#FFFFFF"
    },
    [33] = { -- Line Number
      fore = "#000000",
      back = "#A0A0A0"
    },
    [34] = { -- Brace Highlight
      fore = "#000000",
      back = "#00FF00",
      bold = true
    },
    [35] = { -- Unmatched Brace
      fore = "#000000",
      back = "#FF0000",
      bold = true
    }
  },
  common = {
    style = {
      whitespace = {
        fore = "#808080"
      },
      number = {
        fore = "#008080"
      },
      doubleQuotedString = {
        fore = "#CC0000"
      },
      singleQuotedString = {
        fore = "#800080"
      },
      identifier = {
      },
      comment = {
        fore = "#0000FF",
        italic = true
      },
      keyword = {
        fore = "#000080",
        bold = true
      },
      operator = {
        bold = true
      },
      preprocessor = {
        fore = "#008000",
        bold = true
      },
      label = {
        fore = "#800000"
      },
      unclosedDoubleQuotedString = {
        back = "#E0C0E0",
        eolfilled = true
      },
      unclosedSingleQuotedString = {
        back = "#E0C0E0",
        eolfilled = true
      },
      error = {
        fore = "#FFFF00",
        back = "#FF0000",
        eolfilled = true
      },
      inactive = {
        back = "#FFDDDD",
        eolfilled = true
      },
      selection = {
        back = "#CCCCFF",
        eolfilled = (platform == "mac")
      },
      docComment = {
        fore = "#993300",
        italic = true
      },
      docKeyword = {
        fore = "#663300",
        italic = true,
        bold = true
      },
      foldMargin = {
        back = "#C0C0C0"
      },
      caret = {
        back = "#E9E9E9"
      },
      find = {
        back = "#FF0000"
      },
      ref = {
        back = "#00FF00"
      }
    }
  }
}
