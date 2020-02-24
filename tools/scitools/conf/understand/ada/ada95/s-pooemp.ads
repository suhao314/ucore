------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                    S Y S T E M . P O O L _ E M P T Y                     --
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

with System.Storage_Pools;
with System.Storage_Elements;

package System.Pool_Empty is

pragma Elaborate_Body;
--  Needed to ensure that library routines can execute allocators

   ----------------
   -- Empty_Pool --
   ----------------

   --  Allocation strategy:

   --    Raise storage Error on Allocate

   --  Used in the compiler for access types with 'STORAGE_SIZE = 0
   --  Avoid any overhead for Init/Finalize

   type Empty_Pool is new
     System.Storage_Pools.Root_Storage_Pool with null record;

   function Storage_Size
     (Pool : Empty_Pool)
      return System.Storage_Elements.Storage_Count;

   procedure Allocate
     (Pool         : in out Empty_Pool;
      Address      : out System.Address;
      Storage_Size : System.Storage_Elements.Storage_Count;
      Alignment    : System.Storage_Elements.Storage_Count);

   procedure Deallocate
     (Pool         : in out Empty_Pool;
      Address      : System.Address;
      Storage_Size : System.Storage_Elements.Storage_Count;
      Alignment    : System.Storage_Elements.Storage_Count);

   procedure Initialize (Pool : in out Empty_Pool);
   procedure Finalize   (Pool : in out Empty_Pool);

   --  The only actual instance of this type

   Empty_Pool_Object : Empty_Pool;

end System.Pool_Empty;
