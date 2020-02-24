------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     S Y S T E M . I M G _ W C H A R                      --
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

--  Wide_Character'Image

with System.WCh_Con;

package System.Img_WChar is
pragma Preelaborate (Img_WChar);

   function Image_Wide_Character
     (V    : Wide_Character;
      S    : access String;
      EM   : System.WCh_Con.WC_Encoding_Method)
      return Natural;
   --  Computes Wode_Character'Image (V) and stores the result in S (1 .. N)
   --  where N is the length of the image string. The value of N is returned
   --  as the result. The caller guarantees that the string is long enough.
   --  The argument EM is a constant representing the encoding method in use.
   --  The encoding method used is guaranteed to be consistent across a
   --  given program execution and to correspond to the method used in the
   --  source programs.

end System.Img_WChar;
