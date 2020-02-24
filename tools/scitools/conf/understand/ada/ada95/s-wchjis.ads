------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W C H _ J I S                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
--           Copyright (c) 1992,1993,1994 NYU, All Rights Reserved          --
--                                                                          --
-- The GNAT library is free software; you can redistribute it and/or modify --
-- it under terms of the GNU Library General Public License as published by --
-- the Free Software  Foundation; either version 2, or (at your option) any --
-- later version.  The GNAT library is distributed in the hope that it will --
-- be useful, but WITHOUT ANY WARRANTY;  without even  the implied warranty --
-- of MERCHANTABILITY  or  FITNESS FOR  A PARTICULAR PURPOSE.  See the  GNU --
-- Library  General  Public  License for  more  details.  You  should  have --
-- received  a copy of the GNU  Library  General Public License  along with --
-- the GNAT library;  see the file  COPYING.LIB.  If not, write to the Free --
-- Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.        --
--                                                                          --
------------------------------------------------------------------------------

--  This package contains routines used for converting between internal
--  JIS codes and the two external forms we support (EUC and Shift-JIS)

package System.WCh_JIS is
pragma Pure (WCh_JIS);

   function EUC_To_JIS (EUC1, EUC2 : Character) return Wide_Character;
   --  Given the two bytes of a EUC representation, return the
   --  corresponding JIS code wide character. Raises Constraint_Error
   --  if the two characters are not a valid EUC encoding.

   procedure JIS_To_EUC
     (J    : in Wide_Character;
      EUC1 : out Character;
      EUC2 : out Character);

   --  Given a wide character in JIS form, produce the corresponding
   --  two bytes of the EUC representation of this character. This is
   --  only used if J is not in the normal ASCII range, i.e. on entry
   --  we know that Wide_Character'Pos (J) >= 16#0080# and that we
   --  thus require a two byte EUC representation (ASCII codes appear
   --  unchanged as a single byte in EUC). No error checking is performed,
   --  the input code is assumed to be in an appropriate range.

   procedure JIS_To_Shift_JIS
     (J   : in Wide_Character;
      SJ1 : out Character;
      SJ2 : out Character);
   --  Given a wide character code in JIS form, produce the corresponding
   --  two bytes of the Shift-JIS representation of this character. This
   --  is only used if J is not in the normal ASCII range, i.e. on entry
   --  we know that Wide_Character'Pos (J) >= 16#0080# and that we
   --  thus require a two byte EUC representation (ASCII codes appear
   --  unchanged as a single byte in EUC). No error checking is performed,
   --  the input code is assumed to be in an appropriate range (note in
   --  particular that input codes in the range 16#0080#-16#00FF#, i.e.
   --  Hankaku Kana, do not appear, since Shift JIS has no representation
   --  for such codes.

   function Shift_JIS_To_JIS (SJ1, SJ2 : Character) return Wide_Character;
   --  Given the two bytes of a Shift-JIS representation, return the
   --  corresponding JIS code wide character. Raises Constraint_Error if
   --  the two characters are not a valid shift-JIS encoding.

end System.WCh_JIS;
