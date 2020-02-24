--******************************************************************************
--
--	package STANDARD
--
--******************************************************************************

package STANDARD is
-- This is the Digital Equipment Corporation VAX/VMS version of the
-- Ada standard and system packages.

   type BOOLEAN is (FALSE, TRUE);
   -- The predefined relational operators for this type are as follows:

   -- function "="   (LEFT, RIGHT : BOOLEAN) return BOOLEAN;
   -- function "/="  (LEFT, RIGHT : BOOLEAN) return BOOLEAN;
   -- function "<"   (LEFT, RIGHT : BOOLEAN) return BOOLEAN;
   -- function "<="  (LEFT, RIGHT : BOOLEAN) return BOOLEAN;
   -- function ">"   (LEFT, RIGHT : BOOLEAN) return BOOLEAN;
   -- function ">="  (LEFT, RIGHT : BOOLEAN) return BO0LEAN;

   -- The predefined logical operators and the predefined logical negation
   -- operator are as follows:

   -- function "and" (LEFT, RIGHT : BOOLEAN) return BOOLEAN;
   -- function "or"  (LEFT, RIGHT : BOOLEAN) return BOOLEAN;
   -- function "xor" (LEFT, RIGHT : BOOLEAN) return BOOLEAN;
   -- function "not" (LEFT, RIGHT : BOOLEAN) return BOOLEAN;

   -- The universal type universal_integer is predefined.

   type INTEGER is range -2147483648 .. 2147483647;

   -- The predefined operators for this type are as follows:

   -- function "="   (LEFT, RIGHT : INTEGER) return BOOLEAN;
   -- function "/="  (LEFT, RIGHT : INTEGER) return BOOLEAN;
   -- function "<"   (LEFT, RIGHT : INTEGER) return BOOLEAN;
   -- function "<="  (LEFT, RIGHT : INTEGER) return BOOLEAN;
   -- function ">"   (LEFT, RIGHT : INTEGER) return BOOLEAN;
   -- function ">="  (LEFT, RIGHT : INTEGER) return BOOLEAN;

   -- function "+"   (RIGHT : INTEGER) return INTEGER;
   -- function "-"   (RIGHT : INTEGER) return INTEGER;
   -- function "abs" (RIGHT : INTEGER) return INTEGER;

   -- function "+"   (LEFT, RIGHT : INTEGER) return INTEGER;
   -- function "-"   (LEFT, RIGHT : INTEGER) return INTEGER;
   -- function "*"   (LEFT, RIGHT : INTEGER) return INTEGER;
   -- function "/"   (LEFT, RIGHT : INTEGER) return INTEGER;
   -- function "rem" (LEFT, RIGHT : INTEGER) return INTEGER;
   -- function "mod" (LEFT, RIGHT : INTEGER) return INTEGER;

   -- function "**"  (LEFT, : INTEGER; RIGHT : INTEGER) return INTEGER;

   -- An implementation may provide additional predefined integer types.
   -- It is recommended that the names of such additional types end
   -- with INTEGER as in SHORT_INTEGER or LONG_INTEGER. The specification
   -- of each operator  for the type universal_integer, or for
   -- any additional predefined integer type, is obtained by replacing
   -- INTEGER by the name of the type in the specification of the
   -- corresponding operator of the type INTEGER, except for the right
   -- operand of the exponentiating operator.

   type SHORT_INTEGER is range -32768 .. 32767;
   type SHORT_SHORT_INTEGER is range -128 .. 127;
   type LONG_INTEGER is range -2147483648 .. 2147483647;
   type LONG_LONG_INTEGER is range -2147483648 .. 2147483647;

   -- The universal type universal_real is predefined.

   type FLOAT is digits 6 range -1.70141E+38 .. 1.70141E+38;

   -- The predefined operators for this type are as follows:

   -- function "="   (LEFT, RIGHT : FLOAT) return BOOLEAN;
   -- function "/="  (LEFT, RIGHT : FLOAT) return BOOLEAN;
   -- function "<"   (LEFT, RIGHT : FLOAT) return BOOLEAN;
   -- function "<="  (LEFT, RIGHT : FLOAT) return BOOLEAN;
   -- function ">"   (LEFT, RIGHT : FLOAT) return BOOLEAN;
   -- function ">="  (LEFT, RIGHT : FLOAT) return BOOLEAN;

   -- function "+"   (RIGHT : FLOAT) return FLOAT;
   -- function "-"   (RIGHT : FLOAT) return FLOAT;
   -- function "abs" (RIGHT : FLOAT) return FLOAT;

   -- function "+"   (LEFT, RIGHT : FLOAT) return FLOAT;
   -- function "-"   (LEFT, RIGHT : FLOAT) return FLOAT;
   -- function "*"   (LEFT, RIGHT : FLOAT) return FLOAT;
   -- function "/"   (LEFT, RIGHT : FLOAT) return FLOAT;

   -- function "**"  (LEFT : FLOAT; RIGHT : INTEGER) return FLOAT;

   -- An implementation may provide additional predefined floating point
   -- types. It is recommended that the names of such additional types
   -- end with FLOAT as in SHORT_FLOAT or LONG_FLOAT. The specification
   -- of each operator for the type universal_real, or for any additional
   -- predefined floating point type, is obtained by replacing FLOAT by
   -- the name of the type in the specification of the corresponding
   -- operator of the type FLOAT.

   type SHORT_FLOAT is digits 14 range -1.7014118346047E+38 .. 1.7014118346047E38;
   type LONG_FLOAT is digits 14 range -1.7014118346047E+38 .. 1.7014118346047E+38;
   type LONG_LONG_FLOAT is digits 32 range -5.948657467861588254287966331400E+4931 ..
				  5.948657467861588254287966331400E+4931;

   -- In addition, the following operators are predefined for universal types:

   -- function "*"  (LEFT  : universal_integer;
   --                RIGHT : universal_real)    return universal_real;
   -- function "*"  (LEFT  : universal_real;
   --                RIGHT : universal_integer) return universal_real;
   -- function "/"  (LEFT  : universal_real;
   --                RIGHT : universal_integer) return universal_real;
                                                         
   -- The type universal_fixed is predefined. The only operators
   -- declared for this type are

   -- function "*"  (LEFT  : any_fixed_point_type;
   --                RIGHT : any_fixed_point_type) return universal_fixed;
   -- function "/"  (LEFT  : any_fixed_point_type;
   --                RIGHT : any_fixed_point_type) return universal_fixed;

   -- The following characters form the standard ASCII character set.
   -- Character literals corresponding to control characters are not
   -- identifiers; they are indicated in italics in this definition.

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

   for CHARACTER use --  128 ASCII character set without holes
        ( 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16, 17,
         18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
         36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53,
         54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71,
         72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89,
         90, 91, 92, 93, 94, 95, 96, 97, 98, 99,100,101,102,103,104,105,106,107,
        108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,
        126,127 );

   -- The predefined operators for the type CHARACTER are the same
   -- as for any enumeration type.

   --***************************************************************************
   --
   --	package ASCII
   --
   --***************************************************************************

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

   -- Predefined subtypes:

   subtype NATURAL is INTEGER range 0 .. INTEGER'LAST;
   subtype POSITIVE is INTEGER range 1 .. INTEGER'LAST;

   -- Predefined string type:

   type STRING is array(POSITIVE range<>) of CHARACTER;
   pragma PACK(STRING);

   -- The predefined operators for this type are as follows:

   -- function "="  (LEFT, RIGHT : STRING) return BOOLEAN;
   -- function "/"  (LEFT, RIGHT : STRING) return BOOLEAN;
   -- function "<"  (LEFT, RIGHT : STRING) return BOOLEAN;
   -- function "<=" (LEFT, RIGHT : STRING) return BOOLEAN;
   -- function ">"  (LEFT, RIGHT : STRING) return BOOLEAN;
   -- function ">=" (LEFT, RIGHT : STRING) return BOOLEAN;

   -- function "&"  (LEFT  : STRING;
   --                RIGHT : STRING)    return STRING;
   -- function "&"  (LEFT  : CHARACTER;
   --                RIGHT : STRING)    return STRING;
   -- function "&"  (LEFT  : STRING;
   --                RIGHT : CHARACTER) return STRING;
   -- function "&"  (LEFT  : CHARACTER;
   --                RIGHT : CHARACTER) return STRING;

   type DURATION is delta 1.00000E-04 range -131072.0000 .. 131071.9999;

   -- The predefined operators for the type DURATION are the same as for
   -- any fixed point type.

   -- The predefined exceptions:
     
      CONSTRAINT_ERROR : exception;
      NUMERIC_ERROR    : exception;
      PROGRAM_ERROR    : exception;
      STORAGE_ERROR    : exception;
      TASKING_ERROR    : exception;

   end STANDARD;
