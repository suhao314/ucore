-- Tcl/Tk
return {
  name = "Tcl",
  lexer = 25,
  extensions = "tcl",
  keywords = {
    [0] = {
      name = "Tcl Keywords",
      keywords =
        [[after append array auto_execok auto_import auto_load
        auto_load_index auto_qualify beep bgerror binary break case
        catch cd clock close concat continue dde default echo else
        elseif  encoding eof error eval exec exit expr fblocked
        fconfigure fcopy file fileevent flush for foreach format
        gets glob global history http if incr info interp join
        lappend lindex linsert list llength load loadTk lrange
        lreplace lsearch lset lsort memory msgcat namespace open
        package pid pkg::create pkg_mkIndex Platform-specific proc
        puts pwd re_syntax read regexp registry regsub rename
        resource return scan seek set socket source split string
        subst switch tclLog tclMacPkgSearch tclPkgSetup tclPkgUnknown
        tell time trace unknown unset update uplevel upvar variable
        vwait while]]
    },
    [1] = {
      name = "Tk Keywords",
      keywords =
        [[bell bind bindtags bitmap button canvas checkbutton
        clipboard colors console cursors destroy entry event focus
        font frame grab grid image Inter-client keysyms label
        labelframe listbox lower menu menubutton message option
        options pack panedwindow photo place radiobutton raise scale
        scrollbar selection send spinbox text tk tk_chooseColor
        tk_chooseDirectory tk_dialog tk_focusNext tk_getOpenFile
        tk_messageBox tk_optionMenu tk_popup tk_setPalette tkerror
        tkvars tkwait toplevel winfo wish wm]]
    }
  },
  style = {
    [0] = {
      name = "Whitespace",
      style = "whitespace"
    },
    [1] = {
      name = "Comment",
      style = "comment"
    },
    [2] = {
      name = "Line Comment",
      style = "comment"
    },
    [3] = {
      name = "Number",
      style = "number"
    },
    [4] = {
      name = "Quoted Keyword",
      style = "doubleQuotedString"
    },
    [5] = {
      name = "String",
      style = "doubleQuotedString"
    },
    [6] = {
      name = "Operator",
      style = "operator"
    },
    [7] = {
      name = "Identifier",
      style = "identifier"
    },
    [8] = {
      name = "Substitution"
    },
    [9] = {
      name = "Brace Substitution"
    },
    [10] = {
      name = "Modifier"
    },
    [11] = {
      name = "Expand"
    },
    [12] = {
      name = "Keyword",
      style = "keyword"
    },
    [13] = {
      name = "Keyword 2",
      style = "keyword"
    },
    [14] = {
      name = "Keyword 3",
      style = "keyword"
    },
    [15] = {
      name = "Keyword 4",
      style = "keyword"
    },
    [16] = {
      name = "Keyword 5",
      style = "keyword"
    },
    [17] = {
      name = "Keyword 6",
      style = "keyword"
    },
    [18] = {
      name = "Keyword 7",
      style = "keyword"
    },
    [19] = {
      name = "Keyword 8",
      style = "keyword"
    },
    [20] = {
      name = "Box Comment",
      style = "comment"
    },
    [21] = {
      name = "Block Comment",
      style = "comment"
    }
  }
}
