-- Editor Settings
return {
  text = {
    antialias = true
  },

  whitespace = {
    mode = 0,
    eol = false
  },

  caret = {
    line = {
      visible = true     
    },
    policy = {
      y = {
        slop = false,
        strict = false,
        jumps = true,
        even = true,
        slopval = 0
      },
      x = {
        slop = true,
        strict = true,
        jumps = false,
        even = true,
        slopval = 8
      }
    }
  },

  tabs = {
    use = true,
    width = 4
  },

  indent = {
    guide = 0,
    width = 4,
    auto = {
      enabled = true,
      newline = true,
      tab = 0,
      triggers = ":#{}",
      barebrace = 0
    },
  },

  edge = {
   mode = 0,
   column = 80
  },

  chars = {
    word = "abcdefghijklmnopqrstuvwxyz" ..
           "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
           "0123456789_"
  },

  file = {
    encoding = "System",
    eol = (platform == "win") and 0 or 2,
    convert = false,
    newline = true,
    converttabs = false,
    trimws = false
  },

  margin = {
    left = 4,
    right = 0,
    [0] = {
      ["type"] = 1,
      width = -1
    },
    [1] = {
      ["type"] = 0,
      mask = 0x1FFFFFF,
      width = 16,
      sensitive = true
    },
    [2] = {
      ["type"] = 0,
      mask = 0xFE000000,
      width = 16,
      sensitive = true
    }
  },

  properties = {
    ["styling.within.preprocessor"] = "1",
    ["lexer.cpp.track.preprocessor"] = "0",
    ["lexer.cpp.update.preprocessor"] = "0",
    ["fold.cpp.explicit.start"] = "//{{",
    ["fold.cpp.explicit.end"] = "//}}",
    ["fold"] = "1",
    ["fold.at.else"] = "1",
    ["fold.comment"] = "1",
    ["fold.comment.python"] = "1",
    ["fold.compact"] = "0",
    ["fold.html"] = "1",
    ["fold.html.preprocessor"] = "1",
    ["fold.preprocessor"] = "1",
    ["fold.quotes.python"] = "1",
    ["tab.timmy.whinge.level"] = "1"
  },

  fold = {
     flags = 0x10
  },

  marker = {
    [23] = {
      symbol = 22,
      fore = "#000000",
      back = "#C0C0C0"
    },
    [24] = {
      symbol = 2,
      fore = "#000000",
      back = "#FF0000"
    },
    [25] = {
      symbol = 13,
      fore = "#FFFFFF",
      back = "#000000"
    },
    [26] = {
      symbol = 15,
      fore = "#FFFFFF",
      back = "#000000"
    },
    [27] = {
      symbol = 11,
      fore = "#FFFFFF",
      back = "#000000"
    },
    [28] = {
      symbol = 10,
      fore = "#FFFFFF",
      back = "#000000"
    },
    [29] = {
      symbol = 9,
      fore = "#FFFFFF",
      back = "#000000"
    },
    [30] = {
      symbol = 12,
      fore = "#FFFFFF",
      back = "#000000"
    },
    [31] = {
      symbol = 14,
      fore = "#FFFFFF",
      back = "#000000"
    }
  },

  indicator = {
    find = {
      kind = 7,
      outline = 70,
      under = true
    },
    ref = {
      kind = 7,
      alpha = 65,
      outline = 70,
      under = true
    },
    chardiff = {
      kind = 7,
      back = "#FFFFFF",
      alpha = 0,
      under = true,
      internal = true
    },
    persistentHighlight0 = {
      kind = 7,
      back = "#FFFF00",
      alpha = 255,
      under = true
    },
    persistentHighlight1 = {
      kind = 7,
      back = "#00FF00",
      alpha = 255,
      under = true
    },
    persistentHighlight2 = {
      kind = 7,
      back = "#0DD5FC",
      alpha = 255,
      under = true
    },
    persistentHighlight3 = {
      kind = 7,
      back = "#FF5CCE",
      alpha = 255,
      under = true
    }
  },

  wrap = {
    mode = 0,
    flags = 0,
    location = 0,
    indent = 0
  },

  scroll = {
    width = {
      fixed = false
    }
  },
  
  layout = {
    cache = 2
  },

  reload = {
    mode = 0
  },

  ["print"] = {
    style = {
      size = 10
    },
    color = {
      mode = 0
    },
    wrap = {
      mode = 1
    },
    name = {
      ["abs"] = false
    },
    ["date"] = {
      ["mod"] = false,
      long = true
    }
  },

  copypaste = {
    linenumber = false,
    preformat = true
  },

  autocomplete = {
    enabled = false,
    suggest = true,
    ignorecase = true
  },

  browse = {
    activate = {
      enabled = true
    },
    updateib = {
      enabled = true,
      modifier = 0
    },
    visitsource = {
      enabled = true,
      modifier = 0
    }
  },

  unused = {
    enabled = false
  },

  themes = {
    current = "understand",
    defaults = require "themes/defaults",
    understand = require "themes/understand",
    terminal = require "themes/terminal",
    onyx = require "themes/onyx",
    aqua = require "themes/aqua",
    silver = require "themes/silver"
  },
  actions = require "actions",
  settings = require "settings"
}
