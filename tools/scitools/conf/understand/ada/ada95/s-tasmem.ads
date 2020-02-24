------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                    S Y S T E M . T A S K _ M E M O R Y                   --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 2 $                             --
--                                                                          --
--       Copyright (c) 1991,1992,1993,1994, FSU, All Rights Reserved        --
--                                                                          --
-- GNARL is free software; you can redistribute it  and/or modify it  under --
-- terms  of  the  GNU  Library General Public License  as published by the --
-- Free Software  Foundation;  either version 2, or (at  your  option)  any --
-- later  version.  GNARL is distributed  in the hope that  it will be use- --
-- ful, but but WITHOUT ANY WARRANTY;  without even the implied warranty of --
-- MERCHANTABILITY  or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
-- eral Library Public License  for more details.  You should have received --
-- a  copy of the GNU Library General Public License along with GNARL;  see --
-- file COPYING.LIB.  If not,  write to the  Free Software Foundation,  675 --
-- Mass Ave, Cambridge, MA 02139, USA.                                      --
--                                                                          --
------------------------------------------------------------------------------

with System.Storage_Elements;
--  Used for, Storage_Count

package System.Task_Memory is

   procedure Low_Level_Free (A : System.Address);
   --  Free a previously allocated block, guaranteed to be tasking safe

   function Low_Level_New
     (Size : System.Storage_Elements.Storage_Count)
      return System.Address;
   --  Allocate a block, guaranteed to be tasking safe. The block always has
   --  the maximum possible required alignment for any possible data type.

   function Unsafe_Low_Level_New
     (Size : System.Storage_Elements.Storage_Count)
      return System.Address;
   --  Allocate a block, not guaranteed to be tasking safe. The block always
   --  has the maximum possible required alignment for any possible data type.

end System.Task_Memory;
