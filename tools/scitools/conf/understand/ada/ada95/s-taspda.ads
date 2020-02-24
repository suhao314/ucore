------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--            S Y S T E M . T A S K _ S P E C I F I C _ D A T A             --
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

--  This package contains an interface for manipulation of task specific data

package System.Task_Specific_Data is

   --  The basic approach is that for every task, there is an allocated
   --  instance of the type TSD, which is a private type used to represent
   --  task specific data.

   --  In the non-tasking case, there is one specific instance of the TSD
   --  declared statically in this package, and initialized by the package
   --  body initialization. Together with the interface mechanism provided
   --  in System.Tasking_Soft_Links, this ensures that we can avoid bringing
   --  in the tasking stuff unless tasking is actually active.

   --  In the tasking case, a TSD is allocated for each task, saved in the
   --  TCB, and obtained by calling System.Tasking_Soft_Links.Get_TSD_Address.

   Non_Tasking_TSD : Address;
   --  A pointer to the TSD allocated for the non-tasking case (this gets
   --  fetched by the non-tasking case version of the Get_TSD_Address
   --  routine in System.Tasking_Soft_Links.

   function  Get_Jmpbuf_Address return  Address;
   procedure Set_Jmpbuf_Address (Addr : Address);
   pragma Inline (Get_Jmpbuf_Address);
   pragma Inline (Set_Jmpbuf_Address);
   --  These routines provide a task specific address used to store the
   --  address of the current longjmp/setjmp jump buffer for exception
   --  management (under the current scheme which uses longjmp/setjmp)

   function  Get_GNAT_Exception return  Address;
   procedure Set_GNAT_Exception (Addr : Address);
   pragma Inline (Get_GNAT_Exception);
   pragma Inline (Set_GNAT_Exception);
   --  These routines provide a task specific address used to temporarily
   --  store the address of the current exception during propagation.

   function  Get_Sec_Stack_Addr return  Address;
   procedure Set_Sec_Stack_Addr (Addr : Address);
   pragma Inline (Get_Sec_Stack_Addr);
   pragma Inline (Set_Sec_Stack_Addr);
   --  These routines provide a task specific address used to reference
   --  the currently allocated secondary stack.

   function Create_TSD return Address;
   --  Called from GNULLI when a new thread is created to allocate a new
   --  TSD for the task an return a pointer to this allocated TSD. This
   --  call also performs any required initialization of the TSD.

   procedure Destroy_TSD (TSD_Addr : Address);
   --  Called from GNULLI just before a thread is destroyed to release
   --  the storage for the TSD, after performing any required finalization.

end System.Task_Specific_Data;
