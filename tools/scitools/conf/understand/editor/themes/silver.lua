return {
  style = {
    [32] = { -- Default
      fore = "#000000",
      back = "#b9b9b9"
    },
    [33] = { -- Line Number
      fore = "#000000",
      back = "#7e7e7e"
    },
    [34] = { -- Brace Highlight
      fore = "#000000",
      back = "#08d561",
      bold = true
    },
    [35] = { -- Unmatched Brace
      fore = "#000000",
      back = "#ff0f00",
      bold = true
    }
  },
  common = {
    style = {
      whitespace = {
        fore = "#808080"
      },
      number = {
        fore = "#0DFF77"
      },
      doubleQuotedString = {
        fore = "#0DFF77"
      },
      singleQuotedString = {
        fore = "#0DFF77"
      },
      identifier = {
      },
      comment = {
        fore = "#560CE8",
        italic = true
      },
      keyword = {
        fore = "#FF2E00",
        bold = true
      },
      operator = {
        bold = true
      },
      preprocessor = {
        fore = "#180FE8",
        bold = true
      },
      label = {
        fore = "#800000"
      },
      unclosedDoubleQuotedString = {
        back = "#C58A8A",
        eolfilled = true
      },
      unclosedSingleQuotedString = {
        back = "#C58A8A",
        eolfilled = true
      },
      error = {
        fore = "#FFFF00",
        back = "#FF0000",
        eolfilled = true
      },
      inactive = {
        back = "#C58A8A",
        eolfilled = true
      },
      selection = {
        back = "#9d9d9d",
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
        back = "#A6A6A6"
      },
      caret = {
        back = "#d9d9d9"
      },
      find = {
        back = "#1a034b"
      },
      ref = {
        back = "#00FF00"
      }
    }
  }
}

