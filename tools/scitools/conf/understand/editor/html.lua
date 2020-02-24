-- HTML
return {
  name = "HTML",
  lexer = 4,
  extensions =
    "html,htm,asp,shtml,htd,jsp,php3,phtml," ..
    "php,htt,cfm,tpl,dtd,hta,vxml,docbook",
  keywords = {
    [0] = {
      name = "HTML",
      keywords =
        [[a abbr acronym address applet area b base basefont bdo
        big blockquote body br button caption center cite code
        col colgroup dd del dfn dir div dl dt em fieldset font
        form frame frameset h1 h2 h3 h4 h5 h6 head hr html i
        iframe img input ins isindex kbd label legend li link map
        menu meta noframes noscript object ol optgroup option p
        param pre q s samp script select small span strike strong
        style sub sup table tbody td textarea tfoot th thead title
        tr tt u ul var xml xmlns abbr accept-charset accept
        accesskey action align alink alt archive axis background
        bgcolor border cellpadding cellspacing char charoff charset
        checked cite class classid clear codebase codetype color
        cols colspan compact content coords data datafld dataformatas
        datapagesize datasrc datetime declare defer dir disabled
        enctype event face for frame frameborder headers height
        href hreflang hspace http-equiv id ismap label lang
        language leftmargin link longdesc marginwidth marginheight
        maxlength media method multiple name nohref noresize
        noshade nowrap object onblur onchange onclick ondblclick
        onfocus onkeydown onkeypress onkeyup onload onmousedown
        onmousemove onmouseover onmouseout onmouseup onreset
        onselect onsubmit onunload profile prompt readonly rel
        rev rows rowspan rules scheme scope selected shape size
        span src standby start style summary tabindex target text
        title topmargin type usemap valign value valuetype version
        vlink vspace width text password checkbox radio submit
        reset file hidden image article aside calendar canvas
        card command commandset datagrid datatree footer gauge
        header m menubar menulabel nav progress section switch
        tabbox active command contenteditable ping public !doctype]]
    },
    [1] = {
      name = "JavaScript",
      keywords =
        [[abstract boolean break byte case catch char class const
        continue debugger default delete do double else enum
        export extends final finally float for function goto if
        implements import in instanceof int interface long native
        new package private protected public return short static
        super switch synchronized this throw throws transient try
        typeof var void volatile while with]]
    },
    [2] = {
      name = "VBScript",
      keywords =
        [[addressof alias and as attribute base begin binary
        boolean byref byte byval call case compare const currency
        date decimal declare defbool defbyte defint deflng defcur
        defsng defdbl defdec defdate defstr defobj defvar dim do
        double each else elseif empty end enum eqv erase error
        event exit explicit false for friend function get gosub
        goto if imp implements in input integer is len let lib
        like load lock long loop lset me mid midb mod new next
        not nothing null object on option optional or paramarray
        preserve print private property public raiseevent randomize
        redim rem resume return rset seek select set single static
        step stop string sub then time to true type typeof unload
        until variant wend while with withevents xor]]
    },
    [3] = {
      name = "Python",
      keywords =
        [[and assert break class continue def del elif else except
        exec finally for from global if import in is lambda None
        not or pass print raise return try while yield]]
    },
    [4] = {
      name = "PHP",
      keywords =
        [[and array as bool boolean break case cfunction class
        const continue declare default die directory do double
        echo else elseif empty enddeclare endfor endforeach endif
        endswitch endwhile eval exit extends false float for
        foreach function global if include include_once int integer
        isset list new null object old_function or parent print
        real require require_once resource return static stdclass
        string switch true unset use var while xor abstract catch
        clone exception final implements interface php_user_filter
        private protected public this throw try __class__ __file__
        __function__ __line__ __method__ __sleep __wakeup]]
    },
    [5] = {
      name = "DTD/SGML",
      keywords = [[ELEMENT DOCTYPE ATTLIST ENTITY NOTATION]]
    }
  },
  style = {
    [0] = {
      name = "Text",
      fore = "#000000"
    },
    [1] = {
      name = "Tag",
      fore = "#000080"
    },
    [2] = {
      name = "Unknown Tag",
      fore = "#FF0000"
    },
    [3] = {
      name = "Attribute",
      fore = "#008080"
    },
    [4] = {
      name = "Unknown Attribute",
      fore = "#FF0000"
    },
    [5] = {
      name = "Number",
      style = "number"
    },
    [6] = {
      name = "Double Quoted String",
      style = "doubleQuotedString"
    },
    [7] = {
      name = "Single Quoted String",
      style = "singleQuotedString"
    },
    [8] = {
      name = "Other Inside Tag",
      fore = "#800080"
    },
    [9] = {
      name = "Comment",
      style = "comment"
    },
    [10] = {
      name = "Entity",
      fore = "#800080"
    },
    [11] = {
      name = "XML Tag End",
      fore = "#000080"
    },
    [12] = {
      name = "XML Identifier Start",
      fore = "#0000FF"
    },
    [13] = {
      name = "XML Identifier End",
      fore = "#0000FF"
    },
    [14] = {
      name = "SCRIPT",
      fore = "#000080"
    },
    [15] = {
      name = "ASP <% ... %>",
      back = "#FFFF00"
    },
    [16] = {
      name = "ASP <% ... %>",
      back = "#FFDF00"
    },
    [17] = {
      name = "CDATA"
    },
    [18] = {
      name = "PHP",
      fore = "#0000FF"
    },
    [19] = {
      name = "Unquoted Value",
      fore = "#FF00FF"
    },
    [20] = {
      name = "JSP Comment <%-- ... --%>",
      fore = "#FFFFFF"
    },
    [21] = {
      name = "SGML Tag <! ... >",
      fore = "#000080"
    },
    [22] = {
      name = "SGML Command",
      fore = "#000080",
      bold = true
    },
    [23] = {
      name = "SGML 1st Param",
      fore = "#000080",
      bold = true
    },
    [24] = {
      name = "SGML Double String",
      style = "doubleQuotedString"
    },
    [25] = {
      name = "SGML Single String",
      style = "singleQuotedString"
    },
    [26] = {
      name = "SGML Error",
      style = "error"
    },
    [27] = {
      name = "SGML Special (#xxxx type)"
    },
    [28] = {
      name = "SGML Entity",
      fore = "#800080"
    },
    [29] = {
      name = "SGML Comment",
      style = "comment"
    },
    [31] = {
      name = "SGML Block"
    },
    [40] = {
      name = "JS Start"
    },
    [41] = {
      name = "JS Default",
      style = "whitespace"
    },
    [42] = {
      name = "JS Comment",
      style = "comment"
    },
    [43] = {
      name = "JS Line Comment",
      style = "comment"
    },
    [44] = {
      name = "JS Doc Comment",
      style = "docComment"
    },
    [45] = {
      name = "JS Number",
      style = "number"
    },
    [46] = {
      name = "JS Word",
      style = "identifier"
    },
    [47] = {
      name = "JS Keyword",
      style = "keyword"
    },
    [48] = {
      name = "JS Double Quoted String",
      style = "doubleQuotedString"
    },
    [49] = {
      name = "JS Single Quoted String",
      style = "singleQuotedString"
    },
    [50] = {
      name = "JS Symbol"
    },
    [51] = {
      name = "JS EOL"
    },
    [52] = {
      name = "JS RegEx"
    },
    [55] = {
      name = "ASP JS Start",
      fore = "#7F7F00"
    },
    [56] = {
      name = "ASP JS Default",
      fore = "#000000",
      back = "#DFDF7F",
      bold = true,
      eolfilled = true
    },
    [57] = {
      name = "ASP JS Comment",
      fore = "#007F00",
      back = "#DFDF7F",
      eolfilled = true
    },
    [58] = {
      name = "ASP JS Line Comment",
      fore = "#007F00",
      back = "#DFDF7F"
    },
    [59] = {
      name = "ASP JS Doc Comment",
      fore = "#7F7F7F",
      back = "#DFDF7F",
      bold = true,
      eolfilled = true
    },
    [60] = {
      name = "ASP JS Number",
      fore = "#007F7F",
      back = "#DFDF7F"
    },
    [61] = {
      name = "ASP JS Word",
      fore = "#000000",
      back = "#DFDF7F"
    },
    [62] = {
      name = "ASP JS Keyword",
      fore = "#00007F",
      back = "#DFDF7F",
      bold = true
    },
    [63] = {
      name = "ASP JS Double Quoted String",
      fore = "#7F007F",
      back = "#DFDF7F"
    },
    [64] = {
      name = "ASP JS Single Quoted String",
      fore = "#7F007F",
      back = "#DFDF7F"
    },
    [65] = {
      name = "ASP JS Symbol",
      fore = "#000000",
      back = "#DFDF7F",
      bold = true
    },
    [66] = {
      name = "ASP JS EOL",
      back = "#BFBBB0",
      eolfilled = true
    },
    [67] = {
      name = "ASP JS RegEx",
      back = "#FFBBB0"
    },
    [70] = {
      name = "Embedded VBS Start"
    },
    [71] = {
      name = "Embedded VBS Default",
      back = "#EFEFFF",
      fore = "#000000",
      eolfilled = true
    },
    [72] = {
      name = "Embedded VBS Comment",
      back = "#EFEFFF",
      fore = "#008000",
      eolfilled = true
    },
    [73] = {
      name = "Embedded VBS Number",
      back = "#EFEFFF",
      fore = "#008080",
      eolfilled = true
    },
    [74] = {
      name = "Embedded VBS Keyword",
      back = "#EFEFFF",
      fore = "#000080",
      bold = true,
      eolfilled = true
    },
    [75] = {
      name = "Embedded VBS String",
      back = "#EFEFFF",
      fore = "#800080",
      eolfilled = true
    },
    [76] = {
      name = "Embedded VBS Identifier",
      back = "#EFEFFF",
      fore = "#000080",
      eolfilled = true
    },
    [77] = {
      name = "Embedded VBS Unterminated String",
      back = "#7F7FFF",
      fore = "#000080",
      eolfilled = true
    },
    [80] = {
      name = "ASP VBS Start"
    },
    [81] = {
      name = "ASP VBS Default",
      back = "#CFCFEF",
      fore = "#000000",
      eolfilled = true
    },
    [82] = {
      name = "ASP VBS Comment",
      back = "#CFCFEF",
      fore = "#008000",
      eolfilled = true
    },
    [83] = {
      name = "ASP VBS Number",
      back = "#CFCFEF",
      fore = "#008080",
      eolfilled = true
    },
    [84] = {
      name = "ASP VBS Keyword",
      back = "#CFCFEF",
      fore = "#000080",
      bold = true,
      eolfilled = true
    },
    [85] = {
      name = "ASP VBS String",
      back = "#CFCFEF",
      fore = "#800080",
      eolfilled = true
    },
    [86] = {
      name = "ASP VBS Identifier",
      back = "#CFCFEF",
      fore = "#000080",
      eolfilled = true
    },
    [87] = {
      name = "ASP VBS Unterminated String",
      back = "#7F7FBF",
      fore = "#000080",
      eolfilled = true
    },
    [90] = {
      name = "Embedded Python",
      fore = "#808080"
    },
    [91] = {
      name = "Embedded Python",
      fore = "#808080",
      back = "#EFFFEF",
      eolfilled = true
    },
    [92] = {
      name = "Embedded Python Comment",
      fore = "#007F00",
      back = "#EFFFEF",
      eolfilled = true
    },
    [93] = {
      name = "Embedded Python Number",
      fore = "#007F7F",
      back = "#EFFFEF",
      eolfilled = true
    },
    [94] = {
      name = "Embedded Python Double-quoted String",
      fore = "#7F007F",
      back = "#EFFFEF",
      eolfilled = true
    },
    [95] = {
      name = "Embedded Python Single-quoted String",
      fore = "#7F007F",
      back = "#EFFFEF",
      eolfilled = true
    },
    [96] = {
      name = "Embedded Python Keyword",
      fore = "#00007F",
      bold = true,
      back = "#EFFFEF",
      eolfilled = true
    },
    [97] = {
      name = "Embedded Python Triple Quotes",
      fore = "#7F0000",
      back = "#EFFFEF",
      eolfilled = true
    },
    [98] = {
      name = "Embedded Python Triple Double Quotes",
      fore = "#7F0000",
      back = "#EFFFEF",
      eolfilled = true
    },
    [99] = {
      name = "Embedded Python Class Definition",
      fore = "#0000FF",
      bold = true,
      back = "#EFFFEF",
      eolfilled = true
    },
    [100] = {
      name = "Embedded Python Function Definition",
      fore = "#007F7F",
      bold = true,
      back = "#EFFFEF",
      eolfilled = true
    },
    [101] = {
      name = "Embedded Python Operator",
      bold = true,
      back = "#EFFFEF",
      eolfilled = true
    },
    [102] = {
      name = "Embedded Python Identifier",
      back = "#EFFFEF",
      eolfilled = true
    },
    [104] = {
      name = "PHP Complex Variable",
      style = "identifier",
      italic = true
    },
    [105] = {
      name = "ASP Python",
      fore = "#808080"
    },
    [106] = {
      name = "ASP Python",
      fore = "#808080",
      back = "#CFEFCF",
      eolfilled = true
    },
    [107] = {
      name = "ASP Python Comment",
      fore = "#007F00",
      back = "#CFEFCF",
      eolfilled = true
    },
    [108] = {
      name = "ASP Python Number",
      fore = "#007F7F",
      back = "#CFEFCF",
      eolfilled = true
    },
    [109] = {
      name = "ASP Python Double Quoted String",
      fore = "#7F007F",
      back = "#CFEFCF",
      eolfilled = true
    },
    [110] = {
      name = "ASP Python Single Quoted String",
      fore = "#7F007F",
      back = "#CFEFCF",
      eolfilled = true
    },
    [111] = {
      name = "ASP Python Keyword",
      fore = "#00007F",
      bold = true,
      back = "#CFEFCF",
      eolfilled = true
    },
    [112] = {
      name = "ASP Python Triple Quotes",
      fore = "#7F0000",
      back = "#CFEFCF",
      eolfilled = true
    },
    [113] = {
      name = "ASP Python Triple Double Quotes",
      fore = "#7F0000",
      back = "#CFEFCF",
      eolfilled = true
    },
    [114] = {
      name = "ASP Python Class Definition",
      fore = "#0000FF",
      bold = true,
      back = "#CFEFCF",
      eolfilled = true
    },
    [115] = {
      name = "ASP Python Function Definition",
      fore = "#007F7F",
      bold = true,
      back = "#CFEFCF",
      eolfilled = true
    },
    [116] = {
      name = "ASP Python Operator",
      bold = true,
      back = "#CFEFCF",
      eolfilled = true
    },
    [117] = {
      name = "ASP Python Identifier",
      back = "#CFEFCF",
      eolfilled = true
    },
    [118] = {
      name = "PHP Default",
      style = "identifier"
    },
    [119] = {
      name = "PHP Double Quoted String",
      style = "doubleQuotedString"
    },
    [120] = {
      name = "PHP Single Quoted String",
      style = "singleQuotedString"
    },
    [121] = {
      name = "PHP Keyword",
      style = "keyword"
    },
    [122] = {
      name = "PHP Number",
      style = "number"
    },
    [123] = {
      name = "PHP Variable",
      style = "identifier"
    },
    [124] = {
      name = "PHP Comment",
      style = "comment"
    },
    [125] = {
      name = "PHP Line Comment",
      style = "comment"
    },
    [126] = {
      name = "PHP Variable In String",
      style = "identifier"
    },
    [127] = {
      name = "PHP Operator",
      style = "operator"
    }
  }
}
