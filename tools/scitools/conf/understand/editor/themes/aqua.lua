return {
  style = {
    [32] = { -- Default
      fore = "#000000",
      back = "#FFFFFF"
    },
    [33] = { -- Line Number
      fore = "#000000",
      back = "#00FFEA"
    },
    [34] = { -- Brace Highlight
      fore = "#000000",
      back = "#09cc4a",
      bold = true
    },
    [35] = { -- Unmatched Brace
      fore = "#000000",
      back = "#cc1b14",
      bold = true
    }
  },
  common = {
    style = {
      whitespace = {
        fore = "#808080"
      },
      number = {
        fore = "#00CCBB"
      },
      doubleQuotedString = {
        fore = "#00CCBB"
      },
      singleQuotedString = {
        fore = "#00CCBB"
      },
      identifier = {
      },
      comment = {
        fore = "#007F75",
        italic = true
      },
      keyword = {
        fore = "#267F78",
        bold = true
      },
      operator = {
        bold = true
      },
      preprocessor = {
        fore = "#00FFEA",
        bold = true
      },
      label = {
        fore = "#800000"
      },
      unclosedDoubleQuotedString = {
        back = "#ffaa99",
        eolfilled = true
      },
      unclosedSingleQuotedString = {
        back = "#ffaa99",
        eolfilled = true
      },
      error = {
        fore = "#FFFF00",
        back = "#FF0000",
        eolfilled = true
      },
      inactive = {
        back = "#ffaa99",
        eolfilled = true
      },
      selection = {
        back = "#00d6c1",
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
        back = "#007F75"
      },
      caret = {
        back = "#8AFFF0"
      },
      find = {
        back = "#ff19e3"
      },
      ref = {
        back = "#cc4000"
      }
    }
  }
}

