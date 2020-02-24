------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W C H _ S T W                        --
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

--  This package contains the routine used to convert strings to wide
--  strings for use by wide character attributes (value, image etc.)

with System.WCh_Con;

package System.WCh_StW is
pragma Pure (WCh_StW);

   function String_To_Wide_String
     (S    : String;
      EM   : System.WCh_Con.WC_Encoding_Method)
      return Wide_String;
   --  This routine simply takes its argument and converts it to wide string
   --  format. In the context of the Wide_Image attribute, the argument is
   --  the corresponding 'Image attribute. Any wide character escape sequences
   --  in the string are converted to the corresponding wide character value.
   --  No syntax checks are made, it is assumed that any such sequences are
   --  validly formed (this must be assured by the caller, and results from
   --  the fact that Wide_Image is only used on strings that have been built
   --  by the compiler, such as images of enumeration literals. If the method
   --  for encoding is a shift-in, shift-out convention, then it is assumed
   --  that normal (non-wide character) mode holds at the start and end of
   --  the argument string. EM indicates the wide character encoding method.

end System.WCh_StW;
