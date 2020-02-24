------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W C H _ W T S                        --
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

--  This package contains the routine used to convert wide strings to
--  strings for use by wide character attributes (value, image etc.)

with System.WCh_Con;

package System.WCh_WtS is
pragma Pure (WCh_WtS);

   function Wide_String_To_String
     (S    : Wide_String;
      EM   : System.WCh_Con.WC_Encoding_Method)
      return String;
   --  This routine simply takes its argument and converts it to a string,
   --  using the internal compiler escape sequence convention (defined in
   --  package Widechar) to translate characters that are out of range
   --  of type String. In the context of the Wide_Value attribute, the
   --  argument is the original attribute argument, and the result is used
   --  in a call to the corresponding Value attribute function. If the method
   --  for encoding is a shift-in, shift-out convention, then it is assumed
   --  that normal (non-wide character) mode holds at the start and end of
   --  the result string. EM indicates the wide character encoding method.

end System.WCh_WtS;
