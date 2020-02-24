-- CSS
return {
  name = "CSS",
  lexer = 38,
  extensions = "css",
  keywords = {
    [0] = {
      name = "Properties (CSS1)",
      keywords =
        [[color background-color background-image font background-repeat
        background-attachment background-position background
        font-family font-style font-variant font-weight font-size
        word-spacing letter-spacing text-decoration vertical-align
        text-transform text-align text-indent line-height margin-top
        margin-right margin-bottom margin-left margin padding-top
        padding-right padding-bottom padding-left padding
        border-top-width border-right-width border-bottom-width
        border-left-width border-width border-top border-right
        border-bottom border-left border border-color border-style
        width height float clear display white-space list-style-type
        list-style-image list-style-position list-style]]
    },
    [1] = {
      name = "Pseudo Classes",
      keywords =
        [[first-letter first-line link active visited first-child
        focus hover lang before after left right first]]
    },
    [2] = {
      name = "Properties (CSS2)",
      keywords =
        [[border-color border-top-color border-right-color
        border-bottom-color border-left-color border-top-style
        border-right-style border-bottom-style border-left-style
        border-style top right bottom left position z-index direction
        unicode-bidi min-width max-width min-height max-height
        overflow clip visibility content quotes counter-reset
        counter-increment marker-offset size marks page-break-before
        page-break-after page-break-inside page orphans widows
        font-stretch font-size-adjust unicode-range units-per-em
        src panose-1 stemv stemh slope cap-height x-height ascent
        descent widths bbox definition-src baseline centerline
        mathline topline text-shadow caption-side table-layout
        border-collapse border-spacing empty-cells speak-header
        cursor outline outline-width outline-style outline-color
        volume speak pause-before pause-after pause cue-before
        cue-after cue play-during azimuth elevation speech-rate
        voice-family pitch pitch-range stress richness speak-punctuation
        speak-numeral]]
    }
  },
  style = {
    [0] = {
      name = "Whitespace",
      style = "whitespace"
    },
    [1] = {
      name = "Selector (HTML Tag)",
      style = "label"
    },
    [2] = {
      name = "Class Selector ([HtmlTag].classSelector)"
    },
    [3] = {
      name = "Pseudo Class (HtmlTag:pseudoClass)"
    },
    [4] = {
      name = "Unknown Pseudo Class"
    },
    [5] = {
      name = "Operator",
      style = "operator"
    },
    [6] = {
      name = "Property (CSS1)",
      style = "keyword"
    },
    [7] = {
      name = "Unknown Property"
    },
    [8] = {
      name = "Value"
    },
    [9] = {
      name = "Comment",
      style = "comment"
    },
    [10] = {
      name = "ID Selector (#IdSel)"
    },
    [11] = {
      name = "Important"
    },
    [12] = {
      name = "At-rule (@)"
    },
    [13] = {
      name = "Double Quoted String",
      style = "doubleQuotedString"
    },
    [14] = {
      name = "Single Quoted String",
      style = "singleQuotedString"
    },
    [15] = {
      name = "Property (CSS2)",
      style = "keyword"
    },
    [16] = {
      name = "Attribute Selection ([att='val'])"
    }
  }
}
