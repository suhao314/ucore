------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--              S Y S T E M . S T A N D A R D _ L I B R A R Y               --
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

--  This is a dummy pakage that simply contains with references to the set of
--  packages that are required to be part of every Ada program. A specialized
--  mechanism is required to ensure that these are loaded, since it may be the
--  case in some programs that the only references to these required packages
--  are from C code or from code generated directly by Gigi, an in both cases
--  the binder is not aware of such references.

--  The binder unconditionally includes s-stalib.ali, which ensures that this
--  package and the packages it references are included in all Ada programs.

with System.Tasking_Soft_Links;
--  Referenced directly from generated code

with System.Task_Specific_Data;
--  Referenced directly from exception handling routines

with System;
--  Referenced from System.Secondary_Stack

with System.Storage_Elements;
--  Referenced from System.Secondary_Stack

with Unchecked_Conversion;
--  Referenced from System.Secondary_Stack and System.Task_Specific_Data

with Unchecked_Deallocation;
--  Referenced from System.Secondary_Stack and System.Task_Specific_Data

package System.Standard_Library is
end System.Standard_Library;
