------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
-- A D A . S T R I N G S . W I D E _ M A P S . W I D E _ C O N S T A N T S  --
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


with Ada.Characters.Wide_Latin_1; use Ada.Characters.Wide_Latin_1;

package Ada.Strings.Wide_Maps.Wide_Constants is
pragma Preelaborate (Wide_Constants);

   Control_Set           : constant Wide_Maps.Wide_Character_Set;
   Graphic_Set           : constant Wide_Maps.Wide_Character_Set;
   Letter_Set            : constant Wide_Maps.Wide_Character_Set;
   Lower_Set             : constant Wide_Maps.Wide_Character_Set;
   Upper_Set             : constant Wide_Maps.Wide_Character_Set;
   Basic_Set             : constant Wide_Maps.Wide_Character_Set;
   Decimal_Digit_Set     : constant Wide_Maps.Wide_Character_Set;
   Hexadecimal_Digit_Set : constant Wide_Maps.Wide_Character_Set;
   Alphanumeric_Set      : constant Wide_Maps.Wide_Character_Set;
   Special_Graphic_Set   : constant Wide_Maps.Wide_Character_Set;
   ISO_646_Set           : constant Wide_Maps.Wide_Character_Set;
   Character_Set         : constant Wide_Maps.Wide_Character_Set;

   Lower_Case_Map        : constant Wide_Maps.Wide_Character_Mapping;
   --  Maps to lower case for letters, else identity

   Upper_Case_Map        : constant Wide_Maps.Wide_Character_Mapping;
   --  Maps to upper case for letters, else identity

   Basic_Map             : constant Wide_Maps.Wide_Character_Mapping;
   --  Maps to basic letter for letters, else identity

private
   subtype WC is Wide_Character;

   Control_Ranges           : aliased constant Wide_Character_Ranges :=
     ((NUL, US),
      (DEL, APC));

   Control_Set              : constant Wide_Character_Set            :=
                                Control_Ranges'Access;

   Graphic_Ranges           : aliased constant Wide_Character_Ranges :=
     ((' ',          Tilde),
      (WC'Val (256), WC'Last));

   Graphic_Set              : constant Wide_Character_Set            :=
                                Graphic_Ranges'Access;

   Letter_Ranges            : aliased constant Wide_Character_Ranges :=
     (('A',                 'Z'),
      ('a',                 'z'),
      (UC_A_Grave,          UC_O_Diaeresis),
      (UC_O_Oblique_Stroke, LC_O_Diaeresis),
      (LC_O_Oblique_Stroke, LC_Y_Diaeresis));

   Letter_Set               : constant Wide_Character_Set            :=
                                Letter_Ranges'Access;

   Lower_Ranges             : aliased constant Wide_Character_Ranges :=
     (1 => ('a',                 'z'),
      2 => (LC_German_Sharp_S,   LC_O_Diaeresis),
      3 => (LC_O_Oblique_Stroke, LC_Y_Diaeresis));

   Lower_Set                : constant Wide_Character_Set            :=
                                Lower_Ranges'Access;

   Upper_Ranges             : aliased constant Wide_Character_Ranges :=
     (1 => ('A',                 'Z'),
      2 => (UC_A_Grave,          UC_O_Diaeresis),
      3 => (UC_O_Oblique_Stroke, UC_Icelandic_Thorn));

   Upper_Set                : constant Wide_Character_Set            :=
                                Upper_Ranges'Access;

   Basic_Ranges             : aliased constant Wide_Character_Ranges :=
     (1 => ('A',                 'Z'),
      2 => ('a',                 'z'),
      3 => (UC_AE_Diphthong,     UC_AE_Diphthong),
      4 => (LC_AE_Diphthong,     LC_AE_Diphthong),
      5 => (LC_German_Sharp_S,   LC_German_Sharp_S),
      6 => (UC_Icelandic_Thorn,  UC_Icelandic_Thorn),
      7 => (LC_Icelandic_Thorn,  LC_Icelandic_Thorn),
      8 => (UC_Icelandic_Eth,    UC_Icelandic_Eth),
      9 => (LC_Icelandic_Eth,    LC_Icelandic_Eth));

   Basic_Set                : constant Wide_Character_Set            :=
                                Basic_Ranges'Access;

   Decimal_Digit_Ranges     : aliased constant Wide_Character_Ranges :=
     (1 => ('0', '9'));

   Decimal_Digit_Set        : constant Wide_Character_Set :=
                                Decimal_Digit_Ranges'Access;

   Hexadecimal_Digit_Ranges : aliased constant Wide_Character_Ranges :=
     (1 => ('0', '9'),
      2 => ('A', 'F'),
      3 => ('a', 'f'));

   Hexadecimal_Digit_Set    : constant Wide_Character_Set :=
                                Hexadecimal_Digit_Ranges'Access;

   Alphanumeric_Ranges      : aliased constant Wide_Character_Ranges :=
     (1 => ('0',                 '9'),
      2 => ('A',                 'Z'),
      3 => ('a',                 'z'),
      4 => (UC_A_Grave,          UC_O_Diaeresis),
      5 => (UC_O_Oblique_Stroke, LC_O_Diaeresis),
      6 => (LC_O_Oblique_Stroke, LC_Y_Diaeresis));

   Alphanumeric_Set         : constant Wide_Character_Set            :=
                                Alphanumeric_Ranges'Access;

   Special_Graphic_Ranges   : aliased constant Wide_Character_Ranges :=
     (1 => (Wide_Space,          Solidus),
      2 => (Colon,               Commercial_At),
      3 => (Left_Square_Bracket, Grave),
      4 => (Left_Curly_Bracket,  Tilde),
      5 => (No_Break_Space,      Inverted_Question),
      6 => (Multiplication_Sign, Multiplication_Sign),
      7 => (Division_Sign,       Division_Sign));

   Special_Graphic_Set      : constant Wide_Character_Set            :=
                                Special_Graphic_Ranges'Access;

   ISO_646_Ranges           : aliased constant Wide_Character_Ranges :=
     (1 => (NUL, DEL));

   ISO_646_Set              : constant Wide_Character_Set            :=
                                ISO_646_Ranges'Access;

   Character_Ranges         : aliased constant Wide_Character_Ranges :=
     (1 => (NUL, WC'Val (255)));

   Character_Set            : constant Wide_Character_Set :=
                                Character_Ranges'Access;

   Lower_From : aliased constant Wide_Character_Sequence :=
     "ABCDEFGHIJKLMNOPQRSTUVWXYZ"  &
      UC_A_Grave                   &
      UC_A_Acute                   &
      UC_A_Circumflex              &
      UC_A_Tilde                   &
      UC_A_Diaeresis               &
      UC_A_Ring                    &
      UC_AE_Diphthong              &
      UC_C_Cedilla                 &
      UC_E_Grave                   &
      UC_E_Acute                   &
      UC_E_Circumflex              &
      UC_E_Diaeresis               &
      UC_I_Grave                   &
      UC_I_Acute                   &
      UC_I_Circumflex              &
      UC_I_Diaeresis               &
      UC_Icelandic_Eth             &
      UC_N_Tilde                   &
      UC_O_Grave                   &
      UC_O_Acute                   &
      UC_O_Circumflex              &
      UC_O_Tilde                   &
      UC_O_Diaeresis               &
      UC_O_Oblique_Stroke          &
      UC_U_Grave                   &
      UC_U_Acute                   &
      UC_U_Circumflex              &
      UC_U_Diaeresis               &
      UC_Y_Acute                   &
      UC_Icelandic_Thorn;

   Lower_To : aliased constant Wide_Character_Sequence :=
     "abcdefghijklmnopqrstuvwxyz"  &
      LC_A_Grave                   &
      LC_A_Acute                   &
      LC_A_Circumflex              &
      LC_A_Tilde                   &
      LC_A_Diaeresis               &
      LC_A_Ring                    &
      LC_AE_Diphthong              &
      LC_C_Cedilla                 &
      LC_E_Grave                   &
      LC_E_Acute                   &
      LC_E_Circumflex              &
      LC_E_Diaeresis               &
      LC_I_Grave                   &
      LC_I_Acute                   &
      LC_I_Circumflex              &
      LC_I_Diaeresis               &
      LC_Icelandic_Eth             &
      LC_N_Tilde                   &
      LC_O_Grave                   &
      LC_O_Acute                   &
      LC_O_Circumflex              &
      LC_O_Tilde                   &
      LC_O_Diaeresis               &
      LC_O_Oblique_Stroke          &
      LC_U_Grave                   &
      LC_U_Acute                   &
      LC_U_Circumflex              &
      LC_U_Diaeresis               &
      LC_Y_Acute                   &
      LC_Icelandic_Thorn;

   Lower_Case_Map : constant Wide_Character_Mapping :=
     Wide_Character_Mapping' (Lower_From'Access, Lower_To'Access);

   Upper_From : aliased constant Wide_Character_Sequence :=
     "abcdefghijklmnopqrstuvwxyz"  &
      LC_A_Grave                   &
      LC_A_Acute                   &
      LC_A_Circumflex              &
      LC_A_Tilde                   &
      LC_A_Diaeresis               &
      LC_A_Ring                    &
      LC_AE_Diphthong              &
      LC_C_Cedilla                 &
      LC_E_Grave                   &
      LC_E_Acute                   &
      LC_E_Circumflex              &
      LC_E_Diaeresis               &
      LC_I_Grave                   &
      LC_I_Acute                   &
      LC_I_Circumflex              &
      LC_I_Diaeresis               &
      LC_Icelandic_Eth             &
      LC_N_Tilde                   &
      LC_O_Grave                   &
      LC_O_Acute                   &
      LC_O_Circumflex              &
      LC_O_Tilde                   &
      LC_O_Diaeresis               &
      LC_O_Oblique_Stroke          &
      LC_U_Grave                   &
      LC_U_Acute                   &
      LC_U_Circumflex              &
      LC_U_Diaeresis               &
      LC_Y_Acute                   &
      LC_Icelandic_Thorn;

   Upper_To : aliased constant Wide_Character_Sequence :=
     "ABCDEFGHIJKLMNOPQRSTUVWXYZ"  &
      UC_A_Grave                   &
      UC_A_Acute                   &
      UC_A_Circumflex              &
      UC_A_Tilde                   &
      UC_A_Diaeresis               &
      UC_A_Ring                    &
      UC_AE_Diphthong              &
      UC_C_Cedilla                 &
      UC_E_Grave                   &
      UC_E_Acute                   &
      UC_E_Circumflex              &
      UC_E_Diaeresis               &
      UC_I_Grave                   &
      UC_I_Acute                   &
      UC_I_Circumflex              &
      UC_I_Diaeresis               &
      UC_Icelandic_Eth             &
      UC_N_Tilde                   &
      UC_O_Grave                   &
      UC_O_Acute                   &
      UC_O_Circumflex              &
      UC_O_Tilde                   &
      UC_O_Diaeresis               &
      UC_O_Oblique_Stroke          &
      UC_U_Grave                   &
      UC_U_Acute                   &
      UC_U_Circumflex              &
      UC_U_Diaeresis               &
      UC_Y_Acute                   &
      UC_Icelandic_Thorn;

   Upper_Case_Map : constant Wide_Character_Mapping :=
     Wide_Character_Mapping' (Upper_From'Access, Upper_To'Access);

   Basic_From : aliased constant Wide_Character_Sequence :=
      UC_A_Grave                    &
      UC_A_Acute                    &
      UC_A_Circumflex               &
      UC_A_Tilde                    &
      UC_A_Diaeresis                &
      UC_A_Ring                     &
      UC_C_Cedilla                  &
      UC_E_Grave                    &
      UC_E_Acute                    &
      UC_E_Circumflex               &
      UC_E_Diaeresis                &
      UC_I_Grave                    &
      UC_I_Acute                    &
      UC_I_Circumflex               &
      UC_I_Diaeresis                &
      UC_N_Tilde                    &
      UC_O_Grave                    &
      UC_O_Acute                    &
      UC_O_Circumflex               &
      UC_O_Tilde                    &
      UC_O_Diaeresis                &
      UC_O_Oblique_Stroke           &
      UC_U_Grave                    &
      UC_U_Acute                    &
      UC_U_Circumflex               &
      UC_U_Diaeresis                &
      UC_Y_Acute                    &
      LC_A_Grave                    &
      LC_A_Acute                    &
      LC_A_Circumflex               &
      LC_A_Tilde                    &
      LC_A_Diaeresis                &
      LC_A_Ring                     &
      LC_C_Cedilla                  &
      LC_E_Grave                    &
      LC_E_Acute                    &
      LC_E_Circumflex               &
      LC_E_Diaeresis                &
      LC_I_Grave                    &
      LC_I_Acute                    &
      LC_I_Circumflex               &
      LC_I_Diaeresis                &
      LC_N_Tilde                    &
      LC_O_Grave                    &
      LC_O_Acute                    &
      LC_O_Circumflex               &
      LC_O_Tilde                    &
      LC_O_Diaeresis                &
      LC_O_Oblique_Stroke           &
      LC_U_Grave                    &
      LC_U_Acute                    &
      LC_U_Circumflex               &
      LC_U_Diaeresis                &
      LC_Y_Acute                    &
      LC_Y_Diaeresis;

   Basic_To : aliased constant Wide_Character_Sequence :=
      'A'                           &  -- UC_A_Grave
      'A'                           &  -- UC_A_Acute
      'A'                           &  -- UC_A_Circumflex
      'A'                           &  -- UC_A_Tilde
      'A'                           &  -- UC_A_Diaeresis
      'A'                           &  -- UC_A_Ring
      'C'                           &  -- UC_C_Cedilla
      'E'                           &  -- UC_E_Grave
      'E'                           &  -- UC_E_Acute
      'E'                           &  -- UC_E_Circumflex
      'E'                           &  -- UC_E_Diaeresis
      'I'                           &  -- UC_I_Grave
      'I'                           &  -- UC_I_Acute
      'I'                           &  -- UC_I_Circumflex
      'I'                           &  -- UC_I_Diaeresis
      'N'                           &  -- UC_N_Tilde
      'O'                           &  -- UC_O_Grave
      'O'                           &  -- UC_O_Acute
      'O'                           &  -- UC_O_Circumflex
      'O'                           &  -- UC_O_Tilde
      'O'                           &  -- UC_O_Diaeresis
      'O'                           &  -- UC_O_Oblique_Stroke
      'U'                           &  -- UC_U_Grave
      'U'                           &  -- UC_U_Acute
      'U'                           &  -- UC_U_Circumflex
      'U'                           &  -- UC_U_Diaeresis
      'Y'                           &  -- UC_Y_Acute
      'a'                           &  -- LC_A_Grave
      'a'                           &  -- LC_A_Acute
      'a'                           &  -- LC_A_Circumflex
      'a'                           &  -- LC_A_Tilde
      'a'                           &  -- LC_A_Diaeresis
      'a'                           &  -- LC_A_Ring
      'c'                           &  -- LC_C_Cedilla
      'e'                           &  -- LC_E_Grave
      'e'                           &  -- LC_E_Acute
      'e'                           &  -- LC_E_Circumflex
      'e'                           &  -- LC_E_Diaeresis
      'i'                           &  -- LC_I_Grave
      'i'                           &  -- LC_I_Acute
      'i'                           &  -- LC_I_Circumflex
      'i'                           &  -- LC_I_Diaeresis
      'n'                           &  -- LC_N_Tilde
      'o'                           &  -- LC_O_Grave
      'o'                           &  -- LC_O_Acute
      'o'                           &  -- LC_O_Circumflex
      'o'                           &  -- LC_O_Tilde
      'o'                           &  -- LC_O_Diaeresis
      'o'                           &  -- LC_O_Oblique_Stroke
      'u'                           &  -- LC_U_Grave
      'u'                           &  -- LC_U_Acute
      'u'                           &  -- LC_U_Circumflex
      'u'                           &  -- LC_U_Diaeresis
      'y'                           &  -- LC_Y_Acute
      'y';                             -- LC_Y_Diaeresis

   Basic_Map : constant Wide_Character_Mapping :=
     Wide_Character_Mapping' (Basic_From'Access, Basic_To'Access);

end Ada.Strings.Wide_Maps.Wide_Constants;
