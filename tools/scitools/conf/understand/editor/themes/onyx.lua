return {
  style = {
    [32] = { -- Default
      fore = "#e3e3e3",
      back = "#1d1d1d"
    },
    [33] = { -- Line Number
      fore = "#000000",
      back = "#A0A0A0"
    },
    [34] = { -- Brace Highlight
      fore = "#bababa",
      back = "#006100",
      bold = true
    },
    [35] = { -- Unmatched Brace
      fore = "#bababa",
      back = "#8a0000",
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
        fore = "#41aa11"
      },
      singleQuotedString = {
        fore = "#41aa11"
      },
      identifier = {
      },
      comment = {
        fore = "#92ff2c",
        italic = true
      },
      keyword = {
        fore = "#ff007f",
        bold = true
      },
      operator = {
        bold = true
      },
      preprocessor = {
        fore = "#DBC900",
        bold = true
      },
      label = {
        fore = "#800000"
      },
      unclosedDoubleQuotedString = {
        back = "#800000",
        eolfilled = true
      },
      unclosedSingleQuotedString = {
        back = "#800000",
        eolfilled = true
      },
      error = {
        fore = "#FFFF00",
        back = "#FF0000",
        eolfilled = true
      },
      inactive = {
        back = "#450505",
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
        back = "#3a3a3a"
      },
      find = {
        back = "#00ffff"
      },
      ref = {
        back = "#92ff2c"
      }
    }
  }
}

