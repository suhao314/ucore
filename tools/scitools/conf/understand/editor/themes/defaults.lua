-- Default Styles
local font = "Courier"
local size = 10
if platform == "mac" then
  font = "Monaco"
  size = 12
elseif platform == "win" then
  font = "Courier New"
  size = 10
elseif platform == "x11" then
  font = "Monospace"
  size = 10
end

return {
  style = {
    [32] = {
      name = tr("Default"),
      font = font,
      size = size,
      desc = tr("The default style.  All text that does not match one of " ..
                "the other styles will be rendered in the default style.")
    },
    [33] = {
      name = tr("Line Number"),
      desc = tr("The line number margin style.  The background color " ..
                "controls the background color of the entire margin.")
    },
    [34] = {
      name = tr("Brace Highlight"),
      desc = tr("The style of matching brace highlights.")
    },
    [35] = {
      name = tr("Unmatched Brace"),
      desc = tr("The style of unmatched brace highlights.")
    }
  },
  common = {
    style = {
      whitespace = {
        name = tr("Whitespace"),
        desc = tr("The style of visible whitespace.  Whitespace must be " ..
                  "made visible for this style to have any effect.")
      },
      number = {
        name = tr("Number"),
        desc = tr("The style of numerical literals.")
      },
      doubleQuotedString = {
        name = tr("Double-quoted String"),
        desc = tr("The style of double-quoted string literals.")
      },
      singleQuotedString = {
        name = tr("Single-quoted String"),
        desc = tr("The style of single-quoted string literals.")
      },
      identifier = {
        name = tr("Identifier"),
        desc = tr("The style of identifiers.")
      },
      comment = {
        name = tr("Comment"),
        desc = tr("The style of comments.")
      },
      keyword = {
        name = tr("Keyword"),
        desc = tr("The style of keywords.")
      },
      operator = {
        name = tr("Operator"),
        desc = tr("The style of operator and punctuation tokens.")
      },
      preprocessor = {
        name = tr("Preprocessor"),
        desc = tr("The style of preprocessor and compiler control text.")
      },
      label = {
        name = tr("Label"),
        desc = tr("The style of labels.")
      },
      unclosedDoubleQuotedString = {
        name = tr("Unclosed Double-quoted String"),
        desc = tr("The style of unclosed double-quoted strings.")
      },
      unclosedSingleQuotedString = {
        name = tr("Unclosed Single-quoted String"),
        desc = tr("The style of unclosed single-quoted strings.")
      },
      error = {
        name = tr("Error"),
        desc = tr("The style of lexical errors.")
      },
      inactive = {
        name = tr("Inactive"),
        desc = tr("The background color of inactive code.")
      },
      selection = {
        name = tr("Selection"),
        desc = tr("The style of selected text.")
      },
      docComment = {
        name = tr("Doc Comment"),
        desc = tr("The style of documentation comments.")
      },
      docKeyword = {
        name = tr("Doc Keyword"),
        desc = tr("The style of keywords within documentation comments.")
      },
      foldMargin = {
        name = tr("Fold Margin"),
        desc = tr("The background color of the fold margin.")
      },
      caret = {
        name = tr("Caret Line Highlight"),
        desc = tr("The background color of the caret line, if caret line is visible.")
      },
      find = {
        name = tr("Find Highlight"),
        desc = tr("The background color of the find highlight indicator")
      },
      ref = {
        name = tr("Reference Highlight"),
        desc = tr("The background color of the reference highlight indicator")
      }
    }
  }
}
