------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--            S Y S T E M . T A S K I N G _ S O F T _ L I N K S             --
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

--  This package contains a set of subprogram access variables that access
--  some basic tasking primitives that are called from non-tasking code (e.g.
--  the defer/undefer abort that surrounds a finalization action). To avoid
--  dragging in the tasking all the time, we use a system of soft links where
--  the links are initialized to dummy non-tasking versions, and then if the
--  tasking is initialized, they are reset to the real tasking versions.

package System.Tasking_Soft_Links is

   --  First we have the access subprogram types used to establish the links.
   --  The approach is to establish variables containing access subprogram
   --  values which by default point to dummy no tasking versions of routines.

   --  Note: the reason that Get_Address_Call has a dummy parameter is that
   --  there is a bug in GNAT with access to subprograms with no params ???

   type No_Param_Proc    is access procedure;
   type Get_Address_Call is access function (Dummy : Boolean) return Address;

   type Proc_SS1 is access procedure (X : Address);
   type Proc_SS2 is access procedure (X : out Address; Y : Integer);

   --  Declarations for the no tasking versions of the required routines

   procedure Abort_Defer_NT;
   --  Defer task abortion (non-tasking case, does nothing)

   procedure Abort_Undefer_NT;
   --  Undefer task abortion (non-tasking case, does nothing)

   procedure Task_Lock_NT;
   --  Lock out other tasks (non-tasking case, does nothing)

   procedure Task_Unlock_NT;
   --  Release lock set by Task_Lock (non-tasking case, does nothing)

   procedure SS_Init_NT (Stk : out Address; Size : Natural);
   --  Initialization of the secondary stack (if no sec-stack does nothing)

   procedure SS_Free_NT (Stk : Address);
   --  Release the secondary stack (if no sec-stack does nothing)

   function Get_TSD_Address_NT (Dummy : Boolean) return Address;
   --  Obtain pointer to TSD (non-tasking case, gets special global TSD that
   --  is allocated and initialized by the System.Task_Specific_Data package)

   Abort_Defer : No_Param_Proc := Abort_Defer_NT'Access;
   --  Defer task abortion (task/non-task case as appropriate)

   Abort_Undefer : No_Param_Proc := Abort_Undefer_NT'Access;
   --  Undefer task abortion (task/non-task case as appropriate)

   Get_TSD_Address : Get_Address_Call := Get_TSD_Address_NT'Access;
   --  Get pointer to task specific data  (task/non-task case as appropriate)

   Lock_Task : No_Param_Proc := Task_Lock_NT'Access;
   --  Locks out other tasks. Preceding a section of code by Task_Lock and
   --  following it by Task_Unlock creates a critical region. This is used
   --  for ensuring that a region of non-tasking code (such as code used to
   --  allocate memory) is tasking safe. Note that it is valid for calls to
   --  Task_Lock/Task_Unlock to be nested, and this must work properly, i.e.
   --  only the corresponding outer level Task_Unlock will actually unlock.

   Unlock_Task : No_Param_Proc := Task_Unlock_NT'Access;
   --  Releases lock previously set by call to Lock_Task. In the nested case,
   --  all nested locks must be released before other tasks competing for the
   --  tasking lock are released.

   SS_Init : Proc_SS2 := SS_Init_NT'Access;

   SS_Free : Proc_SS1 := SS_Free_NT'Access;

end System.Tasking_Soft_Links;
