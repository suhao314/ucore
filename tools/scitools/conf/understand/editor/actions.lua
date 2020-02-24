-- Actions
return {
  zoomin = {
    name = tr("Zoom &In"),
    sequence = 16,
    message = 2333,
    desc = tr("Increase font size.")
  },
  zoomout = {
    name = tr("Zoom &Out"),
    sequence = 17,
    message = 2334,
    desc = tr("Decrease font size.")
  },
  resetzoom = {
    name = tr("&Reset Zoom"),
    message = 10035,
    desc = tr("Restore default zoom.")
  },
  undo = {
    name = tr("&Undo"),
    sequence = 11,
    altsequence = tr("Alt+Backspace"),
    message = 2176,
    desc = tr("Undo the previous edit.")
  },
  redo = {
    name = tr("&Redo"),
    sequence = 12,
    altsequence = tr("Alt+Shift+Backspace"),
    message = 2011,
    desc = tr("Redo the previous undo.")
  },
  cut = {
    name = tr("&Cut"),
    sequence = 8,
    altsequence = tr("Shift+Del"),
    message = 2177,
    desc = tr("Cut the selected text to the clipboard.")
  },
  copy = {
    name = tr("C&opy"),
    sequence = 9,
    altsequence = tr("Ctrl+Ins"),
    message = 2178,
    desc = tr("Copy the selected text to the clipboard.")
  },
  paste = {
    name = tr("&Paste"),
    sequence = 10,
    altsequence = tr("Shift+Ins"),
    message = 2179,
    desc = tr("Paste the clipboard text into the document.")
  },
  selectall = {
    name = tr("&Select All"),
    sequence = 26,
    message = 2013,
    desc = tr("Select the entire document.")
  },
  autocomplete = {
    name = tr("Auto-complete"),
    sequence = tr("Esc"),
    message = 10000,
    desc = tr("Invoke the auto-complete list.")
  },
  find = {
    name = tr("Fin&d && Replace..."),
    sequence = tr("Ctrl+Alt+F"),
    message = 10005,
    desc = tr("Show the find/replace dialog.")
  },
  incfind = {
    name = tr("&Incremental Find..."),
    message = 10008,
    desc = tr("Invoke the incremental find and search forward.")
  },
  setfind = {
    name = tr("Use Selection for Find"),
    sequence = tr("Ctrl+E"),
    message = 10001,
    desc = tr("Fill the find buffer with the current selection.")
  },
  setreplace = {
    name = tr("Use Selection for Replace"),
    sequence = tr("Ctrl+Shift+E"),
    message = 10013,
    desc = tr("Fill the replace buffer with the current selection.")
  },
  findsel = {
    name = tr("Find Selection"),
    sequence = tr("Ctrl+F3"),
    message = 10009,
    desc = tr("Fill find buffer and find next match.")
  },
  findnext = {
    name = tr("Find Next"),
    sequence = 23,
    message = 10002,
    desc = tr("Find next match.")
  },
  findprev = {
    name = tr("Find Previous"),
    sequence = 24,
    message = 10003,
    desc = tr("Find previous match.")
  },
  gotoline = {
    name = tr("Go to &Line..."),
    sequence = tr("Ctrl+L"),
    message = 10004,
    desc = tr("Show the go to line dialog.")
  },
  replace = {
    name = tr("Replace"),
    message = 10010,
    desc = tr("Replace the current selection.")
  },
  replaceandfind = {
    name = tr("Replace and Find Next"),
    message = 10011,
    desc = tr("Replace the current selection and find the next match.")
  },
  replaceall = {
    name = tr("Replace All"),
    message = 10012,
    desc = tr("Replace all matches.")
  },
  commentsel = {
    name = tr("Co&mment Selection"),
    sequence = tr("Ctrl+."),
    message = 10014,
    desc = tr("Comment the selected range.")
  },
  uncommentsel = {
    name = tr("Uncomme&nt Selection"),
    sequence = tr("Ctrl+Shift+."),
    message = 10015,
    desc = tr("Uncomment the selected range.")
  },
  jump = {
    objname = tr("Jump to Matching Token"),
    sequence = tr("Ctrl+J"),
    message = 10016,
    desc = tr("Jump to the matching token.")
  },
  selectblock = {
    name = tr("Select Block"),
    sequence = tr("Ctrl+Shift+J"),
    message = 10017,
    desc = tr("Select the current block.")
  },
  revert = {
    name = tr("Revert"),
    sequence = tr("Ctrl+Shift+Meta+R"),
    message = 10018,
    desc = tr("Revert file to the saved copy.")
  },
  cutline = {
    name = tr("Cut Line"),
    sequence = tr("Ctrl+K"),
    message = 2337,
    desc = tr("Cut the current line to the clipboard.")
  },
  deleteline = {
    name = tr("Delete Line"),
    sequence = tr("Ctrl+Shift+K"),
    message = 2338,
    desc = tr("Delete the current line.")
  },
  copyline = {
    name = tr("Copy Line"),
    sequence = tr("Ctrl+Shift+T"),
    message = 2455,
    desc = tr("Copy the current line to the clipboard.")
  },
  transposeline = {
    name = tr("Transpose Line"),
    sequence = tr("Ctrl+T"),
    message = 2339,
    desc = tr("Transpose the current line with the line above.")
  },
  duplicatesel = {
    name = tr("Duplicate Selection"),
    sequence = tr("Ctrl+D"),
    message = 2469,
    desc = tr("Duplicate the current selection.")
  },
  lowercase = {
    name = tr("&Lowercase"),
    sequence = tr("Ctrl+U"),
    message = 2340,
    desc = tr("Convert the current selection to lowercase.")
  },
  uppercase = {
    name = tr("&Uppercase"),
    sequence = tr("Ctrl+Shift+U"),
    message = 2341,
    desc = tr("Convert the current selection to uppercase.")
  },
  foldall = {
    name = tr("F&old All"),
    objname = tr("Fold/Unfold All"),
    sequence = tr("Ctrl+Shift+H"),
    message = 10019,
    desc = tr("Toggle all fold points.")
  },
  backspace = {
    name = tr("Backspace"),
    sequence = tr("Backspace"),
    message = 2326,
    desc = tr("Delete the character before the caret.")
  },
  delete = {
    name = tr("Delete"),
    sequence = tr("Del"),
    message = 2180,
    desc = tr("Delete the character after the caret.")
  },
  deletetoend = {
    name = tr("Delete to End of Line"),
    sequence = tr("Ctrl+Shift+Del"),
    message = 2396,
    desc = tr("Delete to the end of the line.")
  },
  deletefromstart = {
    name = tr("Delete from Start of Line"),
    sequence = tr("Ctrl+Shift+Backspace"),
    message = 2395,
    desc = tr("Delete from the start of the line.")
  },
  deletewordright = {
    name = tr("Delete Word Right"),
    sequence = tr("Ctrl+Del"),
    message = 2336,
    desc = tr("Delete to the end of the word.")
  },
  deletewordleft = {
    name = tr("Delete Word Left"),
    sequence = tr("Ctrl+Backspace"),
    message = 2335,
    desc = tr("Delete from the start of the word.")
  },
  linedown = {
    name = tr("Line Down"),
    sequence = tr("Down"),
    message = 2300,
    desc = tr("Move the caret down one line.")
  },
  lineup = {
    name = tr("Line Up"),
    sequence = tr("Up"),
    message = 2302,
    desc = tr("Move the caret up one line.")
  },
  linescrolldown = {
    name = tr("Line Scroll Down"),
    sequence = tr("Ctrl+Down"),
    message = 2342,
    desc = tr("Scroll down one line.")
  },
  linescrollup = {
    name = tr("Line Scroll Up"),
    sequence = tr("Ctrl+Up"),
    message = 2343,
    desc = tr("Scroll up one line.")
  },
  lineend = {
    name = tr("Line End"),
    sequence = tr("End"),
    message = 2314,
    desc = tr("Move the caret to the end of the line.")
  },
  linehome = {
    name = tr("Line Home"),
    sequence = tr("Home"),
    message = 2331,
    desc = tr("Move the caret to the start of the line.")
  },
  linestart = {
    name = tr("Line Start"),
    message = 10036,
    desc = tr("Move the caret to the start of the line.")
  },
  pageup = {
    name = tr("Page Up"),
    sequence = tr("PgUp"),
    message = 2320,
    desc = tr("Move the caret up by one page.")
  },
  pagedown = {
    name = tr("Page Down"),
    sequence = tr("PgDown"),
    message = 2322,
    desc = tr("Move the caret down by one page.")
  },
  record = {
    name = tr("R&ecord Macro"),
    sequence = tr("Ctrl+Alt+M"),
    message = 10020,
    desc = tr("Start/stop macro recording."),
    icon = ":icons/macro_record_start.png",
    alticon = ":icons/macro_record_stop.png",
    checkable = true
  },
  replay = {
    name = tr("Re&play Macro"),
    sequence = tr("Ctrl+M"),
    message = 10021,
    desc = tr("Replay last macro."),
    icon = ":icons/macro_play.png"
  },
  savemacro = {
    name = tr("&Save Macro..."),
    sequence = tr("Ctrl+Shift+M"),
    message = 10044,
    desc = tr("Save the current macro.")
  },
  capitalize = {
    name = tr("Capitalize"),
    sequence = tr("Ctrl+Alt+U"),
    message = 10022,
    desc = tr("Capitalize the current word.")
  },
  anchorsel = {
    name = tr("Anchor Selection"),
    sequence = (platform == "mac") and tr("Meta+Space") or tr("Ctrl+Space"),
    message = 10023,
    desc = tr("Toggle the selection anchor.")
  },
  invertcase = {
    name = tr("Invert Case"),
    sequence = tr("Ctrl+Shift+I"),
    message = 10024,
    desc = tr("Invert the case of the current word.")
  },
  cuttoend = {
    name = tr("Cut to End of Line"),
    sequence = tr("Ctrl+Alt+K"),
    message = 10025,
    desc = tr("Cut to the end of the current line.")
  },
  cutfromstart = {
    name = tr("Cut from Start of Line"),
    sequence = tr("Ctrl+Shift+Alt+K"),
    message = 10026,
    desc = tr("Cut from the start of the current line.")
  },
  cutwordleft = {
    name = tr("Cut Word Left"),
    sequence = tr("Ctrl+Alt+Backspace"),
    message = 10037,
    desc = tr("Cut from the start of the word.")
  },
  cutwordright = {
    name = tr("Cut Word Right"),
    sequence = tr("Ctrl+Alt+Del"),
    message = 10038,
    desc = tr("Cut to the end of the word.")
  },
  incfindprev = {
    name = tr("Incremental Find Previous..."),
    message = 10027,
    desc = tr("Invoke the incremental find and search backward.")
  },
  hideinactive = {
    name = tr("Hide I&nactive Lines"),
    objname = tr("Hide/Show Inactive Lines"),
    sequence = tr("Ctrl+Alt+I"),
    message = 10028,
    desc = tr("Toggle the visibility of inactive regions.")
  },
  togglebookmark = {
    objname = tr("Add/Remove Bookmark"),
    name = tr("Toggle Bookmark"),
    message = 10031,
    desc = tr("Toggle bookmark for the current line.")
  },
  nextbookmark = {
    name = tr("Next Bookmark"),
    message = 10032,
    desc = tr("Jump to the next bookmark.")
  },
  prevbookmark = {
    name = tr("Previous Bookmark"),
    message = 10033,
    desc = tr("Jump to the previous bookmark.")
  },
  tab = {
    name = tr("Tab"),
    sequence = tr("Tab"),
    message = 2327,
    desc = tr("Increase indent by the width of a tab.")
  },
  backtab = {
    name = tr("Back Tab"),
    sequence = tr("Shift+Tab"),
    message = 2328,
    desc = tr("Decrease indent by the width of a tab.")
  },
  newline = {
    name = tr("Newline"),
    sequence = tr("Return"),
    altsequence = (platform == "mac") and tr("Enter") or "",
    message = 2329,
    desc = tr("Add newline.")
  },
  docstart = {
    name = tr("Document Start"),
    sequence = tr("Ctrl+Home"),
    message = 2316,
    desc = tr("Move the caret to the beginning of the document.")
  },
  docend = {
    name = tr("Document End"),
    sequence = tr("Ctrl+End"),
    message = 2318,
    desc = tr("Move the caret to the end of the document.")
  },
  overtype = {
    name = tr("Toggle Overtype"),
    sequence = tr("Ins"),
    message = 2324,
    desc = tr("Toggle overtype mode.")
  },
  wrap = {
    name = tr("&Soft Wrap"),
    sequence = tr("Ctrl+Alt+W"),
    message = 10034,
    desc = tr("Toggle the wrap mode of the document."),
    checkable = true
  },
  center = {
    name = tr("Center on Caret"),
    message = 2619,
    desc = tr("Center the scroll position around the caret")
  },
  sortselection = {
    name = tr("Sort Selection"),
    message = 10039,
    desc = tr("Sort the lines in the current selection.")
  },
  inserttab = {
    name = tr("Insert Tab"),
    message = 10040,
    desc = tr("Insert tab character.")
  },
  indentsel = {
    name = tr("Reindent Selection"),
    message = 10041,
    desc = tr("Reindent the current selection.")
  },
  indentfile = {
    name = tr("Reindent File"),
    message = 10042,
    desc = tr("Reindent the current file.")
  },
  toggleautocomplete = {
    name = tr("Toggle Auto-complete"),
    message = 10043,
    desc = tr("Toggle auto-complete mode.")
  },
  persistenthighlight = {
    name = tr("Toggle Persistent Highlight"),
    message = 10045,
    desc = tr("Toggle the entities highlighted state.")
  },
  persistenthighlightclear = {
    name = tr("Clear Persistent Highlights"),
    message = 10046,
    desc = tr("Clear all persistent highlights in editor.")
  }
}
