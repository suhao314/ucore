------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--               S Y S T E M . S E C O N D A R Y _ S T A C K                --
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

with System.Storage_Elements; use System.Storage_Elements;
with System.Storage_Pools;    use System.Storage_Pools;

package System.Secondary_Stack is

   type Secondary_Stack_Pool is new Root_Storage_Pool with null record;

   function  Storage_Size (Pool : Secondary_Stack_Pool) return Storage_Count;

   procedure Allocate
     (Pool         : in out Secondary_Stack_Pool;
      Address      :    out System.Address;
      Storage_Size : in     Storage_Count;
      Alignment    : in     Storage_Count);

   procedure Deallocate
     (Pool         : in out Secondary_Stack_Pool;
      Address      : in     System.Address;
      Storage_Size : in     Storage_Count;
      Alignment    : in     Storage_Count);

   type Mark_Id is private;
   --  Type used to mark the stack.

   procedure SS_Init (Stk : out Address; Size : Natural);
   --  Initialize the secondary stack with a main stack of the given Size.
   --  All further allocations which do not overflow the main stack will not
   --  generate dynamic (de)allocation calls. If the main Stack overflows
   --  a new chuck of at least the same size will be allocated and linked
   --  to the previous chunk.
   --
   --  Note: the reason that Stk is passed is that SS_Init is called before
   --  the proper interface is established to obtain the address of the
   --  stack using System.Task_Specific_Data.Get_Sec_Stack_Addr.

   procedure SS_Free (Stk : Address);
   --  Release the memory allocated for the Secondary Stack. That is to say,
   --  all the allocated chuncks.

   function SS_Mark return Mark_Id;
   --  Return the Mark corresponding to the current state of the stack

   procedure SS_Release (M : Mark_Id);
   --  Restore the state of the stack corresponding to the mark M. If an
   --  additional chunk have been allocated, it will never be freed during a

   generic
      with procedure Put_Line (S : String);
   procedure SS_Info;
   --  Debugging procedure used to print out secondary Stack allocation
   --  information. This procedure is generic in order to avoid a direct
   --  dependance on a particular IO package.

   SS_Pool : Secondary_Stack_Pool;
   --  the pool for the secondary stack

private

   type Mark_Id is new Integer;

end System.Secondary_Stack;
