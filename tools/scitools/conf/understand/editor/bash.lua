-- Bash
return {
  name = "Bash",
  lexer = 62,
  extensions = "sh,bash",
  patterns = "configure",
  keywords = {
    [0] = {
      name = "Keywords",
      keywords =
        [[alias ar asa awk banner basename bash bc bdiff break
        bunzip2 bzip2 cal calendar case cat cc cd chmod cksum clear
        cmp col comm compress continue cp cpio crypt csplit ctags
        cut date dc dd declare deroff dev df diff diff3 dircmp
        dirname do done du echo ed egrep elif else env esac eval
        ex exec exit expand export expr false fc fgrep fi file find
        fmt fold for function functions getconf getopt getopts grep
        gres hash head help history iconv id if in integer jobs
        join kill local lc let line ln logname look ls m4 mail mailx
        make man mkdir more mt mv newgrp nl nm nohup ntps od pack
        paste patch pathchk pax pcat perl pg pr print printf ps pwd
        read readonly red return rev rm rmdir sed select set sh
        shift size sleep sort spell split start stop strings strip
        stty sum suspend sync tail tar tee test then time times
        touch tr trap true tsort tty type typeset ulimit umask
        unalias uname uncompress unexpand uniq unpack unset until
        uudecode uuencode vi vim vpax wait wc whence which while
        who wpaste wstart xargs zcat chgrp chown chroot dir dircolors
        factor groups hostid install link md5sum mkfifo mknod nice
        pinky printenv ptx readlink seq sha1sum shred stat su tac
        unlink users vdir whoami yes]]
    }
  },
  style = {
    [0] = {
      name = "Whitespace",
      style = "whitespace"
    },
    [1] = {
      name = "Error",
      style = "error"
    },
    [2] = {
      name = "Comment",
      style = "comment"
    },
    [3] = {
      name = "Number",
      style = "number"
    },
    [4] = {
      name = "Keyword",
      style = "keyword"
    },
    [5] = {
      name = "Double Quoted String",
      style = "doubleQuotedString"
    },
    [6] = {
      name = "Single Quoted String",
      style = "singleQuotedString"
    },
    [7] = {
      name = "Operator",
      style = "operator"
    },
    [8] = {
      name = "Identifier",
      style = "identifier"
    },
    [9] = {
      name = "Scalar"
    },
    [10] = {
      name = "Parameter Expansion"
    },
    [11] = {
      name = "Back Ticks"
    },
    [12] = {
      name = "Here-Doc Delimiter"
    },
    [13] = {
      name = "Here-Doc Single Quoted"
    }
  },
  comment = {
    line = "#"
  }
}
