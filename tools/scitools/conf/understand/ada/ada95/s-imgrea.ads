------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . I M G _ R E A L                       --
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

--  Image for fixed and float types (also used for Float_IO/Fixed_IO output)

package System.Img_Real is
pragma Preelaborate (Img_Real);

   function Image_Ordinary_Fixed_Point
     (V    : Long_Long_Float;
      S    : access String;
      Aft  : Natural)
      return Natural;
   --  Computes the image of V and stores the resulting string in S (1 .. N)
   --  according to the rules for image for fixed-point types (RM 3.5(34)),
   --  where Aft is the value of the Aft attribute for the fixed-point type.
   --  This function is used only for ordinary fixed point (see package
   --  System.Img_Decimal for handling of decimal fixed-point). The caller
   --  guarantees that the string is long enough.

   function Image_Floating_Point
     (V    : Long_Long_Float;
      S    : access String;
      Digs : Natural)
      return Natural;
   --  Computes the image of V and stores the resulting string in S (1 .. N)
   --  according to the rules for image for foating-point types (RM 3.5(33)),
   --  where Digs is the value of the Digits attribute for the floating-point
   --  type. The caller guarantees that the string is long enough.

   procedure Set_Image_Real
     (V    : Long_Long_Float;
      S    : out String;
      P    : in out Natural;
      Fore : Natural;
      Aft  : Natural;
      Exp  : Natural);
   --  Sets the image of V starting at S (P + 1), updating P to point to the
   --  last character stored, the caller promises that the buffer is large
   --  enough and no check is made for this. Constraint_Error will not
   --  necessarily beraised if this is violated, since it is perfectly valid
   --  to compile this unit with checks off). The Fore, Aft and Exp values
   --  can be set to any valid values for the case of use from Text_IO.

end System.Img_Real;
