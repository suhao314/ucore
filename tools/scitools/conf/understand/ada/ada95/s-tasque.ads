------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                 S Y S T E M . T A S K I N G . Q U E U I N G              --
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

with System.Tasking.Utilities;
--  Used for, Utilities.ATCB_Ptr

package System.Tasking.Queuing is

   procedure Enqueue (E : in out Entry_Queue; Call : Entry_Call_Link);
   --  Enqueue Call at the end of entry_queue E

   procedure Dequeue (E : in out Entry_Queue; Call : Entry_Call_Link);
   --  Dequeue Call from entry_queue E

   function Head (E : in Entry_Queue) return Entry_Call_Link;
   --  Return the head of entry_queue E

   procedure Dequeue_Head
     (E    : in out Entry_Queue;
      Call : out Entry_Call_Link);
   --  Remove and return the head of entry_queue E

   function Onqueue (Call : Entry_Call_Link) return Boolean;
   --  Return True if Call is on any entry_queue at all

   function Count_Waiting (E : in Entry_Queue) return Natural;
   --  Return number of calls on the waiting queue of E

   procedure Select_Task_Entry_Call
     (Acceptor     : System.Tasking.Utilities.ATCB_Ptr;
      Open_Accepts : Accept_List_Access;
      Call         : out Entry_Call_Link;
      Selection    : out Select_Index);
   --  Select an entry for rendezvous

   procedure Select_Protected_Entry_Call
     (Object    : Protection_Access;
      Barriers  : Barrier_Vector;
      Call      : out Entry_Call_Link);
   --  Select an entry of a protected object

end System.Tasking.Queuing;
