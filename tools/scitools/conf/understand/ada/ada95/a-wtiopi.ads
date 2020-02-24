------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--            A D A . W I D E _ T E X T _ I O . P I C T U R E S             --
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

package Ada.Wide_Text_IO.Pictures is

   type Picture is private;

   function Valid (Item : in String) return Boolean;

   function To_Picture (Item : in String) return Picture;

   function To_String (Item : in Picture) return String;

   Max_Picture_Length : constant := 30;

   Picture_Error : exception;

   --  Localization features:

   Max_Currency_Length : constant := 10;

   subtype Currency_Length_Range is
     Integer range 1 .. Max_Currency_Length;

   type Locale (Length : Currency_Length_Range := 1) is record
      Currency    : Wide_String (1 .. Length) := "$";
      Fill        : Wide_Character            := '*';
      Separator   : Wide_Character            := ',';
      Radix_Mark  : Wide_Character            := '.';
   end record;

   generic
      type Num is delta <> digits <>;

   package Edited_Output is

      Default_Locale  : Locale;

      function Length (Pic     : in Picture;
                       Symbols : in Locale := Default_Locale)
        return Natural;

      function Image (Item    : in Num;
                      Pic     : in Picture;
                      Symbols : in Locale  := Default_Locale)
        return Wide_String;

      procedure Put (File    : in File_Type;
                     Item    : in Num;
                     Pic     : in Picture;
                     Symbols : in Locale  := Default_Locale);

      procedure Put (Item    : in Num;
                     Pic     : in Picture;
                     Symbols : in Locale  := Default_Locale);

      procedure Put (To      : out Wide_String;
                     Item    : in Num;
                     Pic     : in Picture;
                     Symbols : in Locale  := Default_Locale);

   end Edited_Output;

private

   type Picture is record
      Length : Natural;
      Data   : String (1 .. 30);
   end record;

end Ada.Wide_Text_IO.Pictures;
