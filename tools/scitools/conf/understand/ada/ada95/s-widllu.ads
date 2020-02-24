------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W I D _ L L U                        --
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

--  This package contains the routine used for WIdth attribute for all
--  non-static unsigned integer (modular integer) subtypes. Note we only
--  have one routine, since this seems a fairly marginal function.

with System.Unsigned_Types;

package System.Wid_LLU is
pragma Pure (Wid_LLU);

   function Width_Long_Long_Unsigned
     (Lo, Hi : System.Unsigned_Types.Long_Long_Unsigned)
      return   Natural;
   --  Compute Width attribute for non-static type derived from a modular
   --  integer type. The arguments Lo, Hi are the bounds of the type.

end System.Wid_LLU;
