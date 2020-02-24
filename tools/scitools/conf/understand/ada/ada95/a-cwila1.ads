------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--           A D A . C H A R A C T E R S . W I D E _ L A T I N 1            --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
--           Copyright (c) 1992,1993,1994 NYU, All Rights Reserved          --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT;  see file COPYING.  If not, write --
-- to the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. --
--                                                                          --
------------------------------------------------------------------------------


package Ada.Characters.Wide_Latin_1 is
pragma Pure (Wide_Latin_1);

   subtype WC is Wide_Character;

   ------------------------
   -- Control Characters --
   ------------------------

   NUL                  : constant WC := WC'Val (0);
   SOH                  : constant WC := WC'Val (1);
   STX                  : constant WC := WC'Val (2);
   ETX                  : constant WC := WC'Val (3);
   EOT                  : constant WC := WC'Val (4);
   ENQ                  : constant WC := WC'Val (5);
   ACK                  : constant WC := WC'Val (6);
   BEL                  : constant WC := WC'Val (7);
   BS                   : constant WC := WC'Val (8);
   HT                   : constant WC := WC'Val (9);
   LF                   : constant WC := WC'Val (10);
   VT                   : constant WC := WC'Val (11);
   FF                   : constant WC := WC'Val (12);
   CR                   : constant WC := WC'Val (13);
   SO                   : constant WC := WC'Val (14);
   SI                   : constant WC := WC'Val (15);

   DLE                  : constant WC := WC'Val (16);
   DC1                  : constant WC := WC'Val (17);
   DC2                  : constant WC := WC'Val (18);
   DC3                  : constant WC := WC'Val (19);
   DC4                  : constant WC := WC'Val (20);
   NAK                  : constant WC := WC'Val (21);
   SYN                  : constant WC := WC'Val (22);
   ETB                  : constant WC := WC'Val (23);
   CAN                  : constant WC := WC'Val (24);
   EM                   : constant WC := WC'Val (25);
   SUB                  : constant WC := WC'Val (26);
   ESC                  : constant WC := WC'Val (27);
   FS                   : constant WC := WC'Val (28);
   GS                   : constant WC := WC'Val (29);
   RS                   : constant WC := WC'Val (30);
   US                   : constant WC := WC'Val (31);

   -------------------------------------
   -- ISO 646 Graphic Wide_Characters --
   -------------------------------------

   Space                : constant WC := ' ';  -- WC'Val(32)
   Exclamation          : constant WC := '!';  -- WC'Val(33)
   Quotation            : constant WC := '"';  -- WC'Val(34)
   Number_Sign          : constant WC := '#';  -- WC'Val(35)
   Dollar_Sign          : constant WC := '$';  -- WC'Val(36)
   Percent_Sign         : constant WC := '%';  -- WC'Val(37)
   Ampersand            : constant WC := '&';  -- WC'Val(38)
   Apostrophe           : constant WC := ''';  -- WC'Val(39)
   Left_Parenthesis     : constant WC := '(';  -- WC'Val(40)
   Right_Parenthesis    : constant WC := ')';  -- WC'Val(41)
   Asterisk             : constant WC := '*';  -- WC'Val(42)
   Plus_Sign            : constant WC := '+';  -- WC'Val(43)
   Comma                : constant WC := ',';  -- WC'Val(44)
   Hyphen               : constant WC := '-';  -- WC'Val(45)
   Minus_Sign           : WC renames Hyphen;
   Full_Stop            : constant WC := '.';  -- WC'Val(46)
   Solidus              : constant WC := '/';  -- WC'Val(47)

   --  Decimal digits '0' though '9' are at positions 48 through 57

   Colon                : constant WC := ':';  -- WC'Val(58)
   Semicolon            : constant WC := ';';  -- WC'Val(59)
   Less_Than_Sign       : constant WC := '<';  -- WC'Val(60)
   Equals_Sign          : constant WC := '=';  -- WC'Val(61)
   Greater_Than_Sign    : constant WC := '>';  -- WC'Val(62)
   Question             : constant WC := '?';  -- WC'Val(63)

   Commercial_At        : constant WC := '@';  -- WC'Val(64)

   --  Letters 'A' through 'Z' are at positions 65 through 90

   Left_Square_Bracket  : constant WC := '[';  -- WC'Val (91)
   Reverse_Solidus      : constant WC := '\';  -- WC'Val (92)
   Right_Square_Bracket : constant WC := ']';  -- WC'Val (93)
   Circumflex           : constant WC := '^';  -- WC'Val (94)
   Low_Line             : constant WC := '_';  -- WC'Val (95)

   Grave                : constant WC := '`';  -- WC'Val (96)
   LC_A                 : constant WC := 'a';  -- WC'Val (97)
   LC_B                 : constant WC := 'b';  -- WC'Val (98)
   LC_C                 : constant WC := 'c';  -- WC'Val (99)
   LC_D                 : constant WC := 'd';  -- WC'Val (100)
   LC_E                 : constant WC := 'e';  -- WC'Val (101)
   LC_F                 : constant WC := 'f';  -- WC'Val (102)
   LC_G                 : constant WC := 'g';  -- WC'Val (103)
   LC_H                 : constant WC := 'h';  -- WC'Val (104)
   LC_I                 : constant WC := 'i';  -- WC'Val (105)
   LC_J                 : constant WC := 'j';  -- WC'Val (106)
   LC_K                 : constant WC := 'k';  -- WC'Val (107)
   LC_L                 : constant WC := 'l';  -- WC'Val (108)
   LC_M                 : constant WC := 'm';  -- WC'Val (109)
   LC_N                 : constant WC := 'n';  -- WC'Val (110)
   LC_O                 : constant WC := 'o';  -- WC'Val (111)
   LC_P                 : constant WC := 'p';  -- WC'Val (112)
   LC_Q                 : constant WC := 'q';  -- WC'Val (113)
   LC_R                 : constant WC := 'r';  -- WC'Val (114)
   LC_S                 : constant WC := 's';  -- WC'Val (115)
   LC_T                 : constant WC := 't';  -- WC'Val (116)
   LC_U                 : constant WC := 'u';  -- WC'Val (117)
   LC_V                 : constant WC := 'v';  -- WC'Val (118)
   LC_W                 : constant WC := 'w';  -- WC'Val (119)
   LC_X                 : constant WC := 'x';  -- WC'Val (120)
   LC_Y                 : constant WC := 'y';  -- WC'Val (121)
   LC_Z                 : constant WC := 'z';  -- WC'Val (122)
   Left_Curly_Bracket   : constant WC := '{';  -- WC'Val (123)
   Vertical_Line        : constant WC := '|';  -- WC'Val (124)
   Right_Curly_Bracket  : constant WC := '}';  -- WC'Val (125)
   Tilde                : constant WC := '~';  -- WC'Val (126)
   DEL                  : constant WC := WC'Val (127);

   --------------------------------------
   -- ISO 6429 Control Wide_Characters --
   --------------------------------------

   IS4 : WC renames FS;
   IS3 : WC renames GS;
   IS2 : WC renames RS;
   IS1 : WC renames US;

   Reserved_128         : constant WC := WC'Val (128);
   Reserved_129         : constant WC := WC'Val (129);
   BPH                  : constant WC := WC'Val (130);
   NBH                  : constant WC := WC'Val (131);
   Reserved_132         : constant WC := WC'Val (132);
   NEL                  : constant WC := WC'Val (133);
   SSA                  : constant WC := WC'Val (134);
   ESA                  : constant WC := WC'Val (135);
   HTS                  : constant WC := WC'Val (136);
   HTJ                  : constant WC := WC'Val (137);
   VTS                  : constant WC := WC'Val (138);
   PLD                  : constant WC := WC'Val (139);
   PLU                  : constant WC := WC'Val (140);
   RI                   : constant WC := WC'Val (141);
   SS2                  : constant WC := WC'Val (142);
   SS3                  : constant WC := WC'Val (143);

   DCS                  : constant WC := WC'Val (144);
   PU1                  : constant WC := WC'Val (145);
   PU2                  : constant WC := WC'Val (146);
   STS                  : constant WC := WC'Val (147);
   CCH                  : constant WC := WC'Val (148);
   MW                   : constant WC := WC'Val (149);
   SPA                  : constant WC := WC'Val (150);
   EPA                  : constant WC := WC'Val (151);

   SOS                  : constant WC := WC'Val (152);
   Reserved_153         : constant WC := WC'Val (153);
   SCI                  : constant WC := WC'Val (154);
   CSI                  : constant WC := WC'Val (155);
   ST                   : constant WC := WC'Val (156);
   OSC                  : constant WC := WC'Val (157);
   PM                   : constant WC := WC'Val (158);
   APC                  : constant WC := WC'Val (159);

   -----------------------------------
   -- Other Graphic Wide_Characters --
   -----------------------------------

   --  Wide_Character positions 160 (16#A0#) .. 175 (16#AF#)

   No_Break_Space              : constant WC := WC'Val (160);
   NBSP                        : WC renames No_Break_Space;
   Inverted_Exclamation        : constant WC := WC'Val (161);
   Cent_Sign                   : constant WC := WC'Val (162);
   Pound_Sign                  : constant WC := WC'Val (163);
   Currency_Sign               : constant WC := WC'Val (164);
   Yen_Sign                    : constant WC := WC'Val (165);
   Broken_Bar                  : constant WC := WC'Val (166);
   Section_Sign                : constant WC := WC'Val (167);
   Diaeresis                   : constant WC := WC'Val (168);
   Copyright_Sign              : constant WC := WC'Val (169);
   Feminine_Ordinal_Indicator  : constant WC := WC'Val (170);
   Left_Angle_Quotation        : constant WC := WC'Val (171);
   Not_Sign                    : constant WC := WC'Val (172);
   Soft_Hyphen                 : constant WC := WC'Val (173);
   Registered_Trade_Mark_Sign  : constant WC := WC'Val (174);
   Macron                      : constant WC := WC'Val (175);

   --  Wide_Character positions 176 (16#B0#) .. 191 (16#BF#)

   Degree_Sign                 : constant WC := WC'Val (176);
   Ring_Above                  : WC renames Degree_Sign;
   Plus_Minus_Sign             : constant WC := WC'Val (177);
   Superscript_Two             : constant WC := WC'Val (178);
   Superscript_Three           : constant WC := WC'Val (179);
   Acute                       : constant WC := WC'Val (180);
   Micro_Sign                  : constant WC := WC'Val (181);
   Pilcrow_Sign                : constant WC := WC'Val (182);
   Paragraph_Sign              : WC renames Pilcrow_Sign;
   Middle_Dot                  : constant WC := WC'Val (183);
   Cedilla                     : constant WC := WC'Val (184);
   Superscript_One             : constant WC := WC'Val (185);
   Masculine_Ordinal_Indicator : constant WC := WC'Val (186);
   Right_Angle_Quotation       : constant WC := WC'Val (187);
   Fraction_One_Quarter        : constant WC := WC'Val (188);
   Fraction_One_Half           : constant WC := WC'Val (189);
   Fraction_Three_Quarters     : constant WC := WC'Val (190);
   Inverted_Question           : constant WC := WC'Val (191);

   --  Wide_Character positions 192 (16#C0#) .. 207 (16#CF#)

   UC_A_Grave                  : constant WC := WC'Val (192);
   UC_A_Acute                  : constant WC := WC'Val (193);
   UC_A_Circumflex             : constant WC := WC'Val (194);
   UC_A_Tilde                  : constant WC := WC'Val (195);
   UC_A_Diaeresis              : constant WC := WC'Val (196);
   UC_A_Ring                   : constant WC := WC'Val (197);
   UC_AE_Diphthong             : constant WC := WC'Val (198);
   UC_C_Cedilla                : constant WC := WC'Val (199);
   UC_E_Grave                  : constant WC := WC'Val (200);
   UC_E_Acute                  : constant WC := WC'Val (201);
   UC_E_Circumflex             : constant WC := WC'Val (202);
   UC_E_Diaeresis              : constant WC := WC'Val (203);
   UC_I_Grave                  : constant WC := WC'Val (204);
   UC_I_Acute                  : constant WC := WC'Val (205);
   UC_I_Circumflex             : constant WC := WC'Val (206);
   UC_I_Diaeresis              : constant WC := WC'Val (207);

   --  Wide_Character positions 208 (16#D0#) .. 223 (16#DF#)

   UC_Icelandic_Eth            : constant WC := WC'Val (208);
   UC_N_Tilde                  : constant WC := WC'Val (209);
   UC_O_Grave                  : constant WC := WC'Val (210);
   UC_O_Acute                  : constant WC := WC'Val (211);
   UC_O_Circumflex             : constant WC := WC'Val (212);
   UC_O_Tilde                  : constant WC := WC'Val (213);
   UC_O_Diaeresis              : constant WC := WC'Val (214);
   Multiplication_Sign         : constant WC := WC'Val (215);
   UC_O_Oblique_Stroke         : constant WC := WC'Val (216);
   UC_U_Grave                  : constant WC := WC'Val (217);
   UC_U_Acute                  : constant WC := WC'Val (218);
   UC_U_Circumflex             : constant WC := WC'Val (219);
   UC_U_Diaeresis              : constant WC := WC'Val (220);
   UC_Y_Acute                  : constant WC := WC'Val (221);
   UC_Icelandic_Thorn          : constant WC := WC'Val (222);
   LC_German_Sharp_S           : constant WC := WC'Val (223);

   --  Wide_Character positions 224 (16#E0#) .. 239 (16#EF#)

   LC_A_Grave                  : constant WC := WC'Val (224);
   LC_A_Acute                  : constant WC := WC'Val (225);
   LC_A_Circumflex             : constant WC := WC'Val (226);
   LC_A_Tilde                  : constant WC := WC'Val (227);
   LC_A_Diaeresis              : constant WC := WC'Val (228);
   LC_A_Ring                   : constant WC := WC'Val (229);
   LC_AE_Diphthong             : constant WC := WC'Val (230);
   LC_C_Cedilla                : constant WC := WC'Val (231);
   LC_E_Grave                  : constant WC := WC'Val (232);
   LC_E_Acute                  : constant WC := WC'Val (233);
   LC_E_Circumflex             : constant WC := WC'Val (234);
   LC_E_Diaeresis              : constant WC := WC'Val (235);
   LC_I_Grave                  : constant WC := WC'Val (236);
   LC_I_Acute                  : constant WC := WC'Val (237);
   LC_I_Circumflex             : constant WC := WC'Val (238);
   LC_I_Diaeresis              : constant WC := WC'Val (239);

   --  Wide_Character positions 240 (16#F0#) .. 255 (16#FF)

   LC_Icelandic_Eth            : constant WC := WC'Val (240);
   LC_N_Tilde                  : constant WC := WC'Val (241);
   LC_O_Grave                  : constant WC := WC'Val (242);
   LC_O_Acute                  : constant WC := WC'Val (243);
   LC_O_Circumflex             : constant WC := WC'Val (244);
   LC_O_Tilde                  : constant WC := WC'Val (245);
   LC_O_Diaeresis              : constant WC := WC'Val (246);
   Division_Sign               : constant WC := WC'Val (247);
   LC_O_Oblique_Stroke         : constant WC := WC'Val (248);
   LC_U_Grave                  : constant WC := WC'Val (249);
   LC_U_Acute                  : constant WC := WC'Val (250);
   LC_U_Circumflex             : constant WC := WC'Val (251);
   LC_U_Diaeresis              : constant WC := WC'Val (252);
   LC_Y_Acute                  : constant WC := WC'Val (253);
   LC_Icelandic_Thorn          : constant WC := WC'Val (254);
   LC_Y_Diaeresis              : constant WC := WC'Val (255);

end Ada.Characters.Wide_Latin_1;
