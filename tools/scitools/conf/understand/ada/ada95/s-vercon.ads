------------------------------------------------------------------------------
--                                                                          --
--                          GNAT RUNTIME COMPONENTS                         --
--                                                                          --
--               S Y S T E M . V E R S I O N _ C O N T R O L                --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
--        Copyright (c) 1992,1993,1994,1995 NYU, All Rights Reserved        --
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

--  This module contains the runtime routine for implementation of the
--  Version and Body_Version attributes, as well as the string type that
--  is returned as a result of using these attributes.

with System.Unsigned_Types;

package System.Version_Control is

   subtype Version_String is String (1 .. 8);
   --  Eight character string returned by Get_version_String;

   function Get_Version_String
     (V    : System.Unsigned_Types.Unsigned)
      return Version_String;
   --  The version information in the executable file is stored as unsigned
   --  integers. This routine converts the unsigned integer into an eight
   --  character string containing its hexadecimal digits (with lower case
   --  letters).

end System.Version_Control;
