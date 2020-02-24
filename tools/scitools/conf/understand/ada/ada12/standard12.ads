package STANDARD is

   type BOOLEAN is (FALSE, TRUE);

   type INTEGER is range -2147483648 .. 2147483647;

   subtype NATURAL is INTEGER range 0..2147483647;

   subtype POSITIVE is INTEGER range 1..2147483647;

   type FLOAT is digits 6 range -1.70141E+38 .. 1.70141E+38;

   type CHARACTER is

      (nul,   soh,   stx,   etx,     eot,   enq,   ack,   bel,
       bs,    ht,    lf,    vt,      ff,    cr,    so,    si,
       dle,   dc1,   dc2,   dc3,     dc4,   nak,   syn,   etb,
       can,   em,    sub,   esc,     fs,    gs,    rs,    us,

       ' ',   '!',   '"',   '#',     '$',   '%',   '&',   ''',
       '(',   ')',   '*',   '+',     ',',   '-',   '.',   '/',
       '0',   '1',   '2',   '3',     '4',   '5',   '6',   '7',
       '8',   '9',   ':',   ';',     '<',   '=',   '>',   '?',
       '@',   'A',   'B',   'C',     'D',   'E',   'F',   'G',
       'H',   'I',   'J',   'K',     'L',   'M',   'N',   'O',
       'P',   'Q',   'R',   'S',     'T',   'U',   'V',   'W',
       'X',   'Y',   'Z',   '[',     '\',   ']',   '^',   '_',
       '`',   'a',   'b',   'c',     'd',   'e',   'f',   'g',
       'h',   'i',   'j',   'k',     'l',   'm',   'n',   'o',
       'p',   'q',   'r',   's',     't',   'u',   'v',   'w',
       'x',   'y',   'z',   '{',     '|',   '}',   '~',   del);

   type WIDE_CHARACTER is

      (nul,   soh,   stx,   etx,     eot,   enq,   ack,   bel,
       bs,    ht,    lf,    vt,      ff,    cr,    so,    si,
       dle,   dc1,   dc2,   dc3,     dc4,   nak,   syn,   etb,
       can,   em,    sub,   esc,     fs,    gs,    rs,    us,

       ' ',   '!',   '"',   '#',     '$',   '%',   '&',   ''',
       '(',   ')',   '*',   '+',     ',',   '-',   '.',   '/',
       '0',   '1',   '2',   '3',     '4',   '5',   '6',   '7',
       '8',   '9',   ':',   ';',     '<',   '=',   '>',   '?',
       '@',   'A',   'B',   'C',     'D',   'E',   'F',   'G',
       'H',   'I',   'J',   'K',     'L',   'M',   'N',   'O',
       'P',   'Q',   'R',   'S',     'T',   'U',   'V',   'W',
       'X',   'Y',   'Z',   '[',     '\',   ']',   '^',   '_',
       '`',   'a',   'b',   'c',     'd',   'e',   'f',   'g',
       'h',   'i',   'j',   'k',     'l',   'm',   'n',   'o',
       'p',   'q',   'r',   's',     't',   'u',   'v',   'w',
       'x',   'y',   'z',   '{',     '|',   '}',   '~',   del); 

   type Wide_Wide_Character is
      (nul,   soh,   stx,   etx,     eot,   enq,   ack,   bel,
       bs,    ht,    lf,    vt,      ff,    cr,    so,    si,
       dle,   dc1,   dc2,   dc3,     dc4,   nak,   syn,   etb,
       can,   em,    sub,   esc,     fs,    gs,    rs,    us,

       ' ',   '!',   '"',   '#',     '$',   '%',   '&',   ''',
       '(',   ')',   '*',   '+',     ',',   '-',   '.',   '/',
       '0',   '1',   '2',   '3',     '4',   '5',   '6',   '7',
       '8',   '9',   ':',   ';',     '<',   '=',   '>',   '?',
       '@',   'A',   'B',   'C',     'D',   'E',   'F',   'G',
       'H',   'I',   'J',   'K',     'L',   'M',   'N',   'O',
       'P',   'Q',   'R',   'S',     'T',   'U',   'V',   'W',
       'X',   'Y',   'Z',   '[',     '\',   ']',   '^',   '_',
       '`',   'a',   'b',   'c',     'd',   'e',   'f',   'g',
       'h',   'i',   'j',   'k',     'l',   'm',   'n',   'o',
       'p',   'q',   'r',   's',     't',   'u',   'v',   'w',
       'x',   'y',   'z',   '{',     '|',   '}',   '~',   del); 


   package ASCII is
      --  Control characters:

      NUL     : constant CHARACTER := nul;
      SOH     : constant CHARACTER := soh;
      STX     : constant CHARACTER := stx;
      ETX     : constant CHARACTER := etx;
      EOT     : constant CHARACTER := eot;
      ENQ     : constant CHARACTER := enq;
      ACK     : constant CHARACTER := ack;
      BEL     : constant CHARACTER := bel;
      BS      : constant CHARACTER := bs;
      HT      : constant CHARACTER := ht;
      LF      : constant CHARACTER := lf;
      VT      : constant CHARACTER := vt;
      FF      : constant CHARACTER := ff;
      CR      : constant CHARACTER := cr;
      SO      : constant CHARACTER := so;
      SI      : constant CHARACTER := si;
      DLE     : constant CHARACTER := dle;
      DC1     : constant CHARACTER := dc1;
      DC2     : constant CHARACTER := dc2;
      DC3     : constant CHARACTER := dc3;
      DC4     : constant CHARACTER := dc4;
      NAK     : constant CHARACTER := nak;
      SYN     : constant CHARACTER := syn;
      ETB     : constant CHARACTER := etb;
      CAN     : constant CHARACTER := can;
      EM      : constant CHARACTER := em;
      SUB     : constant CHARACTER := sub;
      ESC     : constant CHARACTER := esc;
      FS      : constant CHARACTER := fs;
      GS      : constant CHARACTER := gs;
      RS      : constant CHARACTER := rs;
      US      : constant CHARACTER := us;
      DEL     : constant CHARACTER := del;

      -- Other characters:

      EXCLAM     : constant CHARACTER := '!';
      QUOTATION  : constant CHARACTER := '"';
      SHARP      : constant CHARACTER := '#';
      DOLLAR     : constant CHARACTER := '$';
      PERCENT    : constant CHARACTER := '%';
      AMPERSAND  : constant CHARACTER := '&';
      COLON      : constant CHARACTER := ':';
      SEMICOLON  : constant CHARACTER := ';';
      QUERY      : constant CHARACTER := '?';
      AT_SIGN    : constant CHARACTER := '@';
      L_BRACKET  : constant CHARACTER := '[';
      BACK_SLASH : constant CHARACTER := '\';
      R_BRACKET  : constant CHARACTER := ']';
      CIRCUMFLEX : constant CHARACTER := '^';
      UNDERLINE  : constant CHARACTER := '_';
      GRAVE      : constant CHARACTER := '`';
      L_BRACE    : constant CHARACTER := '{';
      BAR        : constant CHARACTER := '|';
      R_BRACE    : constant CHARACTER := '}';
      TILDE      : constant CHARACTER := '~';

      -- Lower case letters:

      LC_A : constant CHARACTER := 'a';
      LC_B : constant CHARACTER := 'b';
      LC_C : constant CHARACTER := 'c';
      LC_D : constant CHARACTER := 'd';
      LC_E : constant CHARACTER := 'e';
      LC_F : constant CHARACTER := 'f';
      LC_G : constant CHARACTER := 'g';
      LC_H : constant CHARACTER := 'h';
      LC_I : constant CHARACTER := 'i';
      LC_J : constant CHARACTER := 'j';
      LC_K : constant CHARACTER := 'k';
      LC_L : constant CHARACTER := 'l';
      LC_M : constant CHARACTER := 'm';
      LC_N : constant CHARACTER := 'n';
      LC_O : constant CHARACTER := 'o';
      LC_P : constant CHARACTER := 'p';
      LC_Q : constant CHARACTER := 'q';
      LC_R : constant CHARACTER := 'r';
      LC_S : constant CHARACTER := 's';
      LC_T : constant CHARACTER := 't';
      LC_U : constant CHARACTER := 'u';
      LC_V : constant CHARACTER := 'v';
      LC_W : constant CHARACTER := 'w';
      LC_X : constant CHARACTER := 'x';
      LC_Y : Constant CHARACTER := 'y';
      LC_Z : Constant CHARACTER := 'z';

   end ASCII;

   type STRING is array(POSITIVE range<>) of CHARACTER;
   pragma pack (string);

   type WIDE_STRING is array(POSITIVE range<>) of WIDE_CHARACTER;
   pragma pack (wide_string);

   type WIDE_WIDE_STRING is array(POSITIVE range<>) of WIDE_WIDE_CHARACTER;
   pragma pack (wide_string);

   type DURATION is delta 1.00000E-04 range -131072.0000 .. 131071.9999;
   
   CONSTRAINT_ERROR : exception;
   PROGRAM_ERROR    : exception;
   STORAGE_ERROR    : exception;
   TASKING_ERROR    : exception;

end STANDARD;







