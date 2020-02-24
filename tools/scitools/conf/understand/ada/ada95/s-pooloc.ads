------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                    S Y S T E M . P O O L _ L O C A L                     --
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
with System.Pool_Global;

package System.Pool_Local is

pragma Elaborate_Body;
--  Needed to ensure that library routines can execute allocators

   ----------------------------
   -- Unbounded_Reclaim_Pool --
   ----------------------------

   --  Allocation strategy:

   --    Call to malloc/free for each Allocate/Deallocate
   --    no user specifiable size
   --    Space of allocated objects is reclaimed at pool finalization
   --    Manages a list of allocated objects

   --  Default pool in the compiler for access types locally declared

   type Unbounded_Reclaim_Pool is new
     System.Pool_Global.Unbounded_No_Reclaim_Pool with
       record
          First : System.Address := Null_Address;
       end record;

   --  function Storage_Size is inherited

   procedure Allocate
     (Pool         : in out Unbounded_Reclaim_Pool;
      Address      : out System.Address;
      Storage_Size : System.Storage_Elements.Storage_Count;
      Alignment    : System.Storage_Elements.Storage_Count);

   procedure Deallocate
     (Pool         : in out Unbounded_Reclaim_Pool;
      Address      : System.Address;
      Storage_Size : System.Storage_Elements.Storage_Count;
      Alignment    : System.Storage_Elements.Storage_Count);

   procedure Finalize (Pool : in out Unbounded_Reclaim_Pool);

end System.Pool_Local;
