return {
  style = {
    [32] = { -- Default
      fore = "#FFFFFF",
      back = "#000000"
    },
    [33] = { -- Line Number
      fore = "#FFFFFF",
      back = "#A0A0A0"
    },
    [34] = { -- Brace Highlight
      fore = "#FFFFFF",
      back = "#009000",
      bold = true
    },
    [35] = { -- Unmatched Brace
      fore = "#FFFFFF",
      back = "#bc0000",
      bold = true
    }
  },
  common = {
    style = {
      whitespace = {
        fore = "#808080"
      },
      number = {
        fore = "#00D0D0"
      },
      doubleQuotedString = {
        fore = "#DBC900"
      },
      singleQuotedString = {
        fore = "#DBC900"
      },
      identifier = {
      },
      comment = {
        fore = "#00BF00",
        italic = true
      },
      keyword = {
        fore = "#FF0000",
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
        back = "#1f0000",
        eolfilled = true
      },
      unclosedSingleQuotedString = {
        back = "#1f0000",
        eolfilled = true
      },
      error = {
        fore = "#FFFF00",
        back = "#FF0000",
        eolfilled = true
      },
      inactive = {
        back = "#1f0000",
        eolfilled = true
      },
      selection = {
        back = "#4d4d4d",
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
        back = "#262626"
      },
      caret = {
        back = "#1d1d1d"
      },
      find = {
        back = "#ffff7f"
      },
      ref = {
        back = "#55ffff"
      }
    }
  }
}

