------------------------------------------------------------------------------
--                                                                          --
--                          GNAT RUNTIME COMPONENTS                         --
--                                                                          --
--                S Y S T E M . U N S I G N E D _ T Y P E S                 --
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

--  This package contains definitions of standard unsigned types that
--  correspond in size to the standard signed types declared in Standard.
--  and (unlike the types in Interfaces have corresponding names).

package System.Unsigned_Types is
pragma Pure (Unsigned_Types);

   type Short_Short_Unsigned is mod 2 ** Short_Short_Integer'Size;
   type Short_Unsigned       is mod 2 ** Short_Integer'Size;
   type Unsigned             is mod 2 ** Integer'Size;
   type Long_Unsigned        is mod 2 ** Long_Integer'Size;
   type Long_Long_Unsigned   is mod 2 ** Long_Long_Integer'Size;

   function Shift_Left
     (Value  : Short_Short_Unsigned;
      Amount : Natural)
     return    Short_Short_Unsigned;

   function Shift_Right
     (Value  : Short_Short_Unsigned;
      Amount : Natural)
      return   Short_Short_Unsigned;

   function Shift_Right_Arithmetic
     (Value  : Short_Short_Unsigned;
      Amount : Natural)
      return   Short_Short_Unsigned;

   function Rotate_Left
     (Value  : Short_Short_Unsigned;
      Amount : Natural)
      return   Short_Short_Unsigned;

   function Rotate_Right
     (Value  : Short_Short_Unsigned;
      Amount : Natural)
      return   Short_Short_Unsigned;

   function Shift_Left
     (Value  : Short_Unsigned;
      Amount : Natural)
     return    Short_Unsigned;

   function Shift_Right
     (Value  : Short_Unsigned;
      Amount : Natural)
      return   Short_Unsigned;

   function Shift_Right_Arithmetic
     (Value  : Short_Unsigned;
      Amount : Natural)
      return   Short_Unsigned;

   function Rotate_Left
     (Value  : Short_Unsigned;
      Amount : Natural)
      return   Short_Unsigned;

   function Rotate_Right
     (Value  : Short_Unsigned;
      Amount : Natural)
      return   Short_Unsigned;

   function Shift_Left
     (Value  : Unsigned;
      Amount : Natural)
     return    Unsigned;

   function Shift_Right
     (Value  : Unsigned;
      Amount : Natural)
      return   Unsigned;

   function Shift_Right_Arithmetic
     (Value  : Unsigned;
      Amount : Natural)
      return   Unsigned;

   function Rotate_Left
     (Value  : Unsigned;
      Amount : Natural)
      return   Unsigned;

   function Rotate_Right
     (Value  : Unsigned;
      Amount : Natural)
      return   Unsigned;

   function Shift_Left
     (Value  : Long_Unsigned;
      Amount : Natural)
     return    Long_Unsigned;

   function Shift_Right
     (Value  : Long_Unsigned;
      Amount : Natural)
      return   Long_Unsigned;

   function Shift_Right_Arithmetic
     (Value  : Long_Unsigned;
      Amount : Natural)
      return   Long_Unsigned;

   function Rotate_Left
     (Value  : Long_Unsigned;
      Amount : Natural)
      return   Long_Unsigned;

   function Rotate_Right
     (Value  : Long_Unsigned;
      Amount : Natural)
      return   Long_Unsigned;

   function Shift_Left
     (Value  : Long_Long_Unsigned;
      Amount : Natural)
     return    Long_Long_Unsigned;

   function Shift_Right
     (Value  : Long_Long_Unsigned;
      Amount : Natural)
      return   Long_Long_Unsigned;

   function Shift_Right_Arithmetic
     (Value  : Long_Long_Unsigned;
      Amount : Natural)
      return   Long_Long_Unsigned;

   function Rotate_Left
     (Value  : Long_Long_Unsigned;
      Amount : Natural)
      return   Long_Long_Unsigned;

   function Rotate_Right
     (Value  : Long_Long_Unsigned;
      Amount : Natural)
      return   Long_Long_Unsigned;

   pragma Convention (Intrinsic, Shift_Left);
   pragma Convention (Intrinsic, Shift_Right);
   pragma Convention (Intrinsic, Shift_Right_Arithmetic);
   pragma Convention (Intrinsic, Rotate_Left);
   pragma Convention (Intrinsic, Rotate_Right);

   pragma Import (Intrinsic, Shift_Left);
   pragma Import (Intrinsic, Shift_Right);
   pragma Import (Intrinsic, Shift_Right_Arithmetic);
   pragma Import (Intrinsic, Rotate_Left);
   pragma Import (Intrinsic, Rotate_Right);

end System.Unsigned_Types;
