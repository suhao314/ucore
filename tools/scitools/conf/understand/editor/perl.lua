-- Perl
return {
  name = "Perl",
  lexer = 6,
  extensions = "pl,pm,pod,cgi,upl",
  keywords = {
    [0] = {
      name = "Keywords",
      keywords =
        [[NULL __FILE__ __LINE__ __PACKAGE__ __DATA__ __END__
        AUTOLOAD BEGIN CORE DESTROY END EQ GE GT INIT LE LT NE
        CHECK abs accept alarm and atan2 bind binmode bless caller
        chdir chmod chomp chop chown chr chroot close closedir
        cmp connect continue cos crypt dbmclose dbmopen defined
        delete die do dump each else elsif endgrent endhostent
        endnetent endprotoent endpwent endservent eof eq eval
        exec exists exit exp fcntl fileno flock for foreach fork
        format formline ge getc getgrent getgrgid getgrnam
        gethostbyaddr gethostbyname gethostent getlogin getnetbyaddr
        getnetbyname getnetent getpeername getpgrp getppid
        getpriority getprotobyname getprotobynumber getprotoent
        getpwent getpwnam getpwuid getservbyname getservbyport
        getservent getsockname getsockopt glob gmtime goto grep
        gt hex if index int ioctl join keys kill last lc lcfirst
        le length link listen local localtime lock log lstat lt
        map mkdir msgctl msgget msgrcv msgsnd my ne next no not
        oct open opendir or ord our pack package pipe pop pos
        print printf prototype push quotemeta qu rand read readdir
        readline readlink readpipe recv redo ref rename require
        reset return reverse rewinddir rindex rmdir scalar seek
        seekdir select semctl semget semop send setgrent sethostent
        setnetent setpgrp setpriority setprotoent setpwent
        setservent setsockopt shift shmctl shmget shmread shmwrite
        shutdown sin sleep socket socketpair sort splice split
        sprintf sqrt srand stat study sub substr symlink syscall
        sysopen sysread sysseek system syswrite tell telldir tie
        tied time times truncate uc ucfirst umask undef unless
        unlink unpack unshift untie until use utime values vec
        wait waitpid wantarray warn while write xor]]
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
      name = "POD Beginning of Line"
    },
    [4] = {
      name = "Number",
      style = "number"
    },
    [5] = {
      name = "Keyword",
      style = "keyword"
    },
    [6] = {
      name = "Double-quoted String",
      style = "doubleQuotedString"
    },
    [7] = {
      name = "Single-quoted String",
      style = "singleQuotedString"
    },
    [10] = {
      name = "Operator",
      style = "operator"
    },
    [11] = {
      name = "Identifier",
      style = "identifier"
    },
    [12] = {
      name = "Scalar"
    },
    [13] = {
      name = "Array"
    },
    [14] = {
      name = "Hash"
    },
    [15] = {
      name = "Symbol Table"
    },
    [17] = {
      name = "Regex"
    },
    [18] = {
      name = "Substitution"
    },
    [19] = {
      name = "Long Quote (Obsolete)"
    },
    [20] = {
      name = "Back Ticks"
    },
    [21] = {
      name = "Data Section"
    },
    [22] = {
      name = "Here-Doc Delimiter"
    },
    [23] = {
      name = "Here-Doc Single Quoted"
    },
    [24] = {
      name = "Here-Doc Double Quoted"
    },
    [25] = {
      name = "Here-Doc Back Ticks"
    },
    [26] = {
      name = "q (Single Quoted String)"
    },
    [27] = {
      name = "qq (Double Quoted String)"
    },
    [28] = {
      name = "qx (Back Ticks)"
    },
    [29] = {
      name = "qr (Regex)"
    },
    [30] = {
      name = "qw (Array)"
    },
    [31] = {
      name = "POD Verbatim Paragraph"
    }
  },
  comment = {
    line = "#"
  }
}
