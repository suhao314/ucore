------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                    S Y S T E M . I M G _ D E C I M A L                   --
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

--  Image for decimal fixed types where the size of the corresponding integer
--  type does not exceed Integer'Size (also used for Text_IO.Decimal_IO output)

package System.Img_Decimal is
pragma Preelaborate (Img_Decimal);

   function Image_Decimal
     (V     : Integer;
      S     : access String;
      Scale : Integer)
      return  Natural;
   --  Compute 'Image of V, the integer value (in units of delta) of a decimal
   --  type whose Scale is as given. The image is stored in S (1 .. N), where
   --  N is the returned result. The image is given by the rules in RM 3.5(34)
   --  for fixed-point type image functions.

   procedure Set_Image_Decimal
     (V     : Integer;
      S     : out String;
      P     : in out Natural;
      Scale : Integer;
      Fore  : Natural;
      Aft   : Natural;
      Exp   : Natural);
   --  Sets the image of V, where V is the integer value (in units of delta)
   --  of a decimal type with the given Scale, starting at S (P + 1), updating
   --  P to point to the last character stored, the caller promises that the
   --  buffer is large enough and no check is made for this. Constraint_Error
   --  will not necessarily be raised if this requirement is violated, since
   --  it is perfectly valid to compile this unit with checks off. The Fore,
   --  Aft and Exp values can be set to any valid values for the case of use
   --  by Text_IO.Decimal_IO.

   procedure Set_Decimal_Digits
     (Digs  : in out String;
      NDigs : Natural;
      S     : out String;
      P     : in out Natural;
      Scale : Integer;
      Fore  : Natural;
      Aft   : Natural;
      Exp   : Natural);
   --  This procedure has the same semantics as Set_Image_Decimal, except that
   --  the value in Digs (1 .. NDigs) is given as a string of decimal digits
   --  preceded by either a minus sign or a space (i.e. the integer image of
   --  the value in units of delta). The call may destroy the value in Digs,
   --  which is why Digs is in-out (this happens if rounding is required).
   --  Set_Decimal_Digits is shared by all the decimal image routines.

end System.Img_Decimal;
