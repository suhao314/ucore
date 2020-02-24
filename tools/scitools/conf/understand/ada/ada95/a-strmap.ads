------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     A D A . S T R I N G S . M A P S                      --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                             --
--                                                                          --
-- This specification is adapted from the Ada Reference Manual for use with --
-- GNAT.  In accordance with the copyright of that document, you can freely --
-- copy and modify this specification,  provided that if you redistribute a --
-- modified version,  any changes that you have made are clearly indicated. --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package Ada.Strings.Maps is
pragma Preelaborate (Maps);

   --------------------------------
   -- Character Set Declarations --
   --------------------------------

   type Character_Set is private;
   --  Representation for a set of character values:

   Null_Set : constant Character_Set;

   ---------------------------
   -- Constructors for Sets --
   ---------------------------

   type Character_Range is record
      Low  : Character;
      High : Character;
   end record;
   --  Represents Character range Low .. High

   type Character_Ranges is array (Positive range <>) of Character_Range;

   function To_Set    (Ranges : in Character_Ranges) return Character_Set;

   function To_Set    (Span   : in Character_Range)  return Character_Set;

   function To_Ranges (Set    : in Character_Set)    return Character_Ranges;

   ----------------------------------
   -- Operations on Character Sets --
   ----------------------------------

   function "="   (Left, Right : in Character_Set) return Boolean;

   function "not" (Right       : in Character_Set) return Character_Set;
   function "and" (Left, Right : in Character_Set) return Character_Set;
   function "or"  (Left, Right : in Character_Set) return Character_Set;
   function "xor" (Left, Right : in Character_Set) return Character_Set;
   function "-"   (Left, Right : in Character_Set) return Character_Set;

   pragma Import (Intrinsic, "=");
   pragma Import (Intrinsic, "not");
   pragma Import (Intrinsic, "and");
   pragma Import (Intrinsic, "or");
   pragma Import (Intrinsic, "xor");
   --  These are not intrinsic in the RM, so this is not quite right ???

   function Is_In
     (Element : in Character;
      Set     : in Character_Set)
      return    Boolean;

   function Is_Subset
     (Elements : in Character_Set;
      Set      : in Character_Set)
      return     Boolean;

   function "<="
     (Left  : in Character_Set;
      Right : in Character_Set)
      return  Boolean
   renames Is_Subset;

   subtype Character_Sequence is String;
   --  Alternative representation for a set of character values

   function To_Set (Sequence  : in Character_Sequence) return Character_Set;

   function To_Set (Singleton : in Character)          return Character_Set;

   function To_Sequence (Set : in Character_Set) return Character_Sequence;

   ------------------------------------
   -- Character Mapping Declarations --
   ------------------------------------

   type Character_Mapping is private;
   --  Representation for a character to character mapping:

   function Value
     (Map     : in Character_Mapping;
      Element : in Character)
      return    Character;

   Identity : constant Character_Mapping;

   ----------------------------
   -- Operations on Mappings --
   ----------------------------

   function To_Mapping
     (From, To : in Character_Sequence)
      return     Character_Mapping;

   function To_Domain
     (Map  : in Character_Mapping)
      return Character_Sequence;

   function To_Range
     (Map  : in Character_Mapping)
      return Character_Sequence;

   type Character_Mapping_Function is
      access function (From : in Character) return Character;

   ------------------
   -- Private Part --
   ------------------

private
   pragma Inline (Is_In);
   pragma Inline (Value);

   type Character_Set is array (Character) of Boolean;
   pragma Pack (Character_Set);

   Null_Set : constant Character_Set := (others => False);

   type Character_Mapping is array (Character) of Character;
   pragma Pack (Character_Mapping);

   Identity : constant Character_Mapping :=
     (NUL                         &  -- NUL                             0
      SOH                         &  -- SOH                             1
      STX                         &  -- STX                             2
      ETX                         &  -- ETX                             3
      EOT                         &  -- EOT                             4
      ENQ                         &  -- ENQ                             5
      ACK                         &  -- ACK                             6
      BEL                         &  -- BEL                             7
      BS                          &  -- BS                              8
      HT                          &  -- HT                              9
      LF                          &  -- LF                             10
      VT                          &  -- VT                             11
      FF                          &  -- FF                             12
      CR                          &  -- CR                             13
      SO                          &  -- SO                             14
      SI                          &  -- SI                             15
      DLE                         &  -- DLE                            16
      DC1                         &  -- DC1                            17
      DC2                         &  -- DC2                            18
      DC3                         &  -- DC3                            19
      DC4                         &  -- DC4                            20
      NAK                         &  -- NAK                            21
      SYN                         &  -- SYN                            22
      ETB                         &  -- ETB                            23
      CAN                         &  -- CAN                            24
      EM                          &  -- EM                             25
      SUB                         &  -- SUB                            26
      ESC                         &  -- ESC                            27
      FS                          &  -- FS                             28
      GS                          &  -- GS                             29
      RS                          &  -- RS                             30
      US                          &  -- US                             31
      ' '                         &  -- ' '                            32
      '!'                         &  -- '!'                            33
      '"'                         &  -- '"'                            34
      '#'                         &  -- '#'                            35
      '$'                         &  -- '$'                            36
      '%'                         &  -- '%'                            37
      '&'                         &  -- '&'                            38
      '''                         &  -- '''                            39
      '('                         &  -- '('                            40
      ')'                         &  -- ')'                            41
      '*'                         &  -- '*'                            42
      '+'                         &  -- '+'                            43
      ','                         &  -- ','                            44
      '-'                         &  -- '-'                            45
      '.'                         &  -- '.'                            46
      '/'                         &  -- '/'                            47
      '0'                         &  -- '0'                            48
      '1'                         &  -- '1'                            49
      '2'                         &  -- '2'                            50
      '3'                         &  -- '3'                            51
      '4'                         &  -- '4'                            52
      '5'                         &  -- '5'                            53
      '6'                         &  -- '6'                            54
      '7'                         &  -- '7'                            55
      '8'                         &  -- '8'                            56
      '9'                         &  -- '9'                            57
      ':'                         &  -- ':'                            58
      ';'                         &  -- ';'                            59
      '<'                         &  -- '<'                            60
      '='                         &  -- '='                            61
      '>'                         &  -- '>'                            62
      '?'                         &  -- '?'                            63
      '@'                         &  -- '@'                            64
      'A'                         &  -- 'A'                            65
      'B'                         &  -- 'B'                            66
      'C'                         &  -- 'C'                            67
      'D'                         &  -- 'D'                            68
      'E'                         &  -- 'E'                            69
      'F'                         &  -- 'F'                            70
      'G'                         &  -- 'G'                            71
      'H'                         &  -- 'H'                            72
      'I'                         &  -- 'I'                            73
      'J'                         &  -- 'J'                            74
      'K'                         &  -- 'K'                            75
      'L'                         &  -- 'L'                            76
      'M'                         &  -- 'M'                            77
      'N'                         &  -- 'N'                            78
      'O'                         &  -- 'O'                            79
      'P'                         &  -- 'P'                            80
      'Q'                         &  -- 'Q'                            81
      'R'                         &  -- 'R'                            82
      'S'                         &  -- 'S'                            83
      'T'                         &  -- 'T'                            84
      'U'                         &  -- 'U'                            85
      'V'                         &  -- 'V'                            86
      'W'                         &  -- 'W'                            87
      'X'                         &  -- 'X'                            88
      'Y'                         &  -- 'Y'                            89
      'Z'                         &  -- 'Z'                            90
      '['                         &  -- '['                            91
      '\'                         &  -- '\'                            92
      ']'                         &  -- ']'                            93
      '^'                         &  -- '^'                            94
      '_'                         &  -- '_'                            95
      '`'                         &  -- '`'                            96
      'a'                         &  -- 'a'                            97
      'b'                         &  -- 'b'                            98
      'c'                         &  -- 'c'                            99
      'd'                         &  -- 'd'                           100
      'e'                         &  -- 'e'                           101
      'f'                         &  -- 'f'                           102
      'g'                         &  -- 'g'                           103
      'h'                         &  -- 'h'                           104
      'i'                         &  -- 'i'                           105
      'j'                         &  -- 'j'                           106
      'k'                         &  -- 'k'                           107
      'l'                         &  -- 'l'                           108
      'm'                         &  -- 'm'                           109
      'n'                         &  -- 'n'                           110
      'o'                         &  -- 'o'                           111
      'p'                         &  -- 'p'                           112
      'q'                         &  -- 'q'                           113
      'r'                         &  -- 'r'                           114
      's'                         &  -- 's'                           115
      't'                         &  -- 't'                           116
      'u'                         &  -- 'u'                           117
      'v'                         &  -- 'v'                           118
      'w'                         &  -- 'w'                           119
      'x'                         &  -- 'x'                           120
      'y'                         &  -- 'y'                           121
      'z'                         &  -- 'z'                           122
      '{'                         &  -- '{'                           123
      '|'                         &  -- '|'                           124
      '}'                         &  -- '}'                           125
      '~'                         &  -- '~'                           126
      DEL                         &  -- DEL                           127
      Reserved_128                &  -- Reserved_128                  128
      Reserved_129                &  -- Reserved_129                  129
      BPH                         &  -- BPH                           130
      NBH                         &  -- NBH                           131
      Reserved_132                &  -- Reserved_132                  132
      NEL                         &  -- NEL                           133
      SSA                         &  -- SSA                           134
      ESA                         &  -- ESA                           135
      HTS                         &  -- HTS                           136
      HTJ                         &  -- HTJ                           137
      VTS                         &  -- VTS                           138
      PLD                         &  -- PLD                           139
      PLU                         &  -- PLU                           140
      RI                          &  -- RI                            141
      SS2                         &  -- SS2                           142
      SS3                         &  -- SS3                           143
      DCS                         &  -- DCS                           144
      PU1                         &  -- PU1                           145
      PU2                         &  -- PU2                           146
      STS                         &  -- STS                           147
      CCH                         &  -- CCH                           148
      MW                          &  -- MW                            149
      SPA                         &  -- SPA                           150
      EPA                         &  -- EPA                           151
      SOS                         &  -- SOS                           152
      Reserved_153                &  -- Reserved_153                  153
      SCI                         &  -- SCI                           154
      CSI                         &  -- CSI                           155
      ST                          &  -- ST                            156
      OSC                         &  -- OSC                           157
      PM                          &  -- PM                            158
      APC                         &  -- APC                           159
      No_Break_Space              &  -- No_Break_Space                160
      Inverted_Exclamation        &  -- Inverted_Exclamation          161
      Cent_Sign                   &  -- Cent_Sign                     162
      Pound_Sign                  &  -- Pound_Sign                    163
      Currency_Sign               &  -- Currency_Sign                 164
      Yen_Sign                    &  -- Yen_Sign                      165
      Broken_Bar                  &  -- Broken_Bar                    166
      Section_Sign                &  -- Section_Sign                  167
      Diaeresis                   &  -- Diaeresis                     168
      Copyright_Sign              &  -- Copyright_Sign                169
      Feminine_Ordinal_Indicator  &  -- Feminine_Ordinal_Indicator    170
      Left_Angle_Quotation        &  -- Left_Angle_Quotation          171
      Not_Sign                    &  -- Not_Sign                      172
      Soft_Hyphen                 &  -- Soft_Hyphen                   173
      Registered_Trade_Mark_Sign  &  -- Registered_Trade_Mark_Sign    174
      Macron                      &  -- Macron                        175
      Degree_Sign                 &  -- Degree_Sign                   176
      Plus_Minus_Sign             &  -- Plus_Minus_Sign               177
      Superscript_Two             &  -- Superscript_Two               178
      Superscript_Three           &  -- Superscript_Three             179
      Acute                       &  -- Acute                         180
      Micro_Sign                  &  -- Micro_Sign                    181
      Pilcrow_Sign                &  -- Pilcrow_Sign                  182
      Middle_Dot                  &  -- Middle_Dot                    183
      Cedilla                     &  -- Cedilla                       184
      Superscript_One             &  -- Superscript_One               185
      Masculine_Ordinal_Indicator &  -- Masculine_Ordinal_Indicator   186
      Right_Angle_Quotation       &  -- Right_Angle_Quotation         187
      Fraction_One_Quarter        &  -- Fraction_One_Quarter          188
      Fraction_One_Half           &  -- Fraction_One_Half             189
      Fraction_Three_Quarters     &  -- Fraction_Three_Quarters       190
      Inverted_Question           &  -- Inverted_Question             191
      UC_A_Grave                  &  -- UC_A_Grave                    192
      UC_A_Acute                  &  -- UC_A_Acute                    193
      UC_A_Circumflex             &  -- UC_A_Circumflex               194
      UC_A_Tilde                  &  -- UC_A_Tilde                    195
      UC_A_Diaeresis              &  -- UC_A_Diaeresis                196
      UC_A_Ring                   &  -- UC_A_Ring                     197
      UC_AE_Diphthong             &  -- UC_AE_Diphthong               198
      UC_C_Cedilla                &  -- UC_C_Cedilla                  199
      UC_E_Grave                  &  -- UC_E_Grave                    200
      UC_E_Acute                  &  -- UC_E_Acute                    201
      UC_E_Circumflex             &  -- UC_E_Circumflex               202
      UC_E_Diaeresis              &  -- UC_E_Diaeresis                203
      UC_I_Grave                  &  -- UC_I_Grave                    204
      UC_I_Acute                  &  -- UC_I_Acute                    205
      UC_I_Circumflex             &  -- UC_I_Circumflex               206
      UC_I_Diaeresis              &  -- UC_I_Diaeresis                207
      UC_Icelandic_Eth            &  -- UC_Icelandic_Eth              208
      UC_N_Tilde                  &  -- UC_N_Tilde                    209
      UC_O_Grave                  &  -- UC_O_Grave                    210
      UC_O_Acute                  &  -- UC_O_Acute                    211
      UC_O_Circumflex             &  -- UC_O_Circumflex               212
      UC_O_Tilde                  &  -- UC_O_Tilde                    213
      UC_O_Diaeresis              &  -- UC_O_Diaeresis                214
      Multiplication_Sign         &  -- Multiplication_Sign           215
      UC_O_Oblique_Stroke         &  -- UC_O_Oblique_Stroke           216
      UC_U_Grave                  &  -- UC_U_Grave                    217
      UC_U_Acute                  &  -- UC_U_Acute                    218
      UC_U_Circumflex             &  -- UC_U_Circumflex               219
      UC_U_Diaeresis              &  -- UC_U_Diaeresis                220
      UC_Y_Acute                  &  -- UC_Y_Acute                    221
      UC_Icelandic_Thorn          &  -- UC_Icelandic_Thorn            222
      LC_German_Sharp_S           &  -- LC_German_Sharp_S             223
      LC_A_Grave                  &  -- LC_A_Grave                    224
      LC_A_Acute                  &  -- LC_A_Acute                    225
      LC_A_Circumflex             &  -- LC_A_Circumflex               226
      LC_A_Tilde                  &  -- LC_A_Tilde                    227
      LC_A_Diaeresis              &  -- LC_A_Diaeresis                228
      LC_A_Ring                   &  -- LC_A_Ring                     229
      LC_AE_Diphthong             &  -- LC_AE_Diphthong               230
      LC_C_Cedilla                &  -- LC_C_Cedilla                  231
      LC_E_Grave                  &  -- LC_E_Grave                    232
      LC_E_Acute                  &  -- LC_E_Acute                    233
      LC_E_Circumflex             &  -- LC_E_Circumflex               234
      LC_E_Diaeresis              &  -- LC_E_Diaeresis                235
      LC_I_Grave                  &  -- LC_I_Grave                    236
      LC_I_Acute                  &  -- LC_I_Acute                    237
      LC_I_Circumflex             &  -- LC_I_Circumflex               238
      LC_I_Diaeresis              &  -- LC_I_Diaeresis                239
      LC_Icelandic_Eth            &  -- LC_Icelandic_Eth              240
      LC_N_Tilde                  &  -- LC_N_Tilde                    241
      LC_O_Grave                  &  -- LC_O_Grave                    242
      LC_O_Acute                  &  -- LC_O_Acute                    243
      LC_O_Circumflex             &  -- LC_O_Circumflex               244
      LC_O_Tilde                  &  -- LC_O_Tilde                    245
      LC_O_Diaeresis              &  -- LC_O_Diaeresis                246
      Division_Sign               &  -- Division_Sign                 247
      LC_O_Oblique_Stroke         &  -- LC_O_Oblique_Stroke           248
      LC_U_Grave                  &  -- LC_U_Grave                    249
      LC_U_Acute                  &  -- LC_U_Acute                    250
      LC_U_Circumflex             &  -- LC_U_Circumflex               251
      LC_U_Diaeresis              &  -- LC_U_Diaeresis                252
      LC_Y_Acute                  &  -- LC_Y_Acute                    253
      LC_Icelandic_Thorn          &  -- LC_Icelandic_Thorn            254
      LC_Y_Diaeresis);               -- LC_Y_Diaeresis                255

end Ada.Strings.Maps;
