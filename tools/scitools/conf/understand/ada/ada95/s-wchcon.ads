------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                       S Y S T E M . W C H _ C O N                        --
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

--  This package defines the codes used to identify the encoding method for
--  wide characters in string and character constants. This is needed both
--  at compile time and at runtime (for the wide character runtime routines)

package System.WCh_Con is
pragma Pure (WCh_Con);

   type WC_Encoding_Method is range 0 .. 3;
   --  Type covering the range of values used to represent wide character
   --  encoding methods. An enumeration type might be a little neater, but
   --  more trouble than it's worth, given the need to pass these values
   --  from the compiler to the backend, and to record them in the ALI file.

   WCEM_Hex : constant WC_Encoding_Method := 0;
   --       The wide character with code 16#abcd# is represented by the
   --       escape sequence ESC a b c d (five characters, where abcd are
   --       ASCII hex characters, using upper case for letters). This
   --       method is easy to deal with in external environments that do
   --       not support wide characters, and covers the whole BMP. This
   --       is the default encoding method.

   WCEM_Upper : constant WC_Encoding_Method := 1;
   --       The wide character with encoding 16#abcd#, where the upper bit
   --       is on (i.e. a is in the range 8-F) is represented as two bytes
   --       16#ab# and 16#cd#. The second byte may never be a format control
   --       character, but is not required to be in the upper half. This
   --       method can be also used for shift-JIS or EUC where the internal
   --       coding matches the external coding.

   WCEM_Shift_JIS : constant WC_Encoding_Method := 2;
   --       A wide character is represented by a two character sequence
   --       16#ab# and 16#cd#, with the restrictions described for upper
   --       half encoding as described above. The internal character code
   --       is the corresponding JIS character according to the standard
   --       algorithm for Shift-JIS conversion. See the body of package
   --       System.JIS_Conversions for further details.

   WCEM_EUC : constant WC_Encoding_Method := 3;
   --       A wide character is represented by a two character sequence
   --       16#ab# and 16#cd#, with both characters being in the upper half.
   --       The internal character code is the corresponding JIS character
   --       according to the EUC encoding algorithm. See the body of package
   --       System.JIS_Conversions for further details.

end System.WCh_Con;
