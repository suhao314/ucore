------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--             S Y S T E M . T A S K I N G . R E N D E Z V O U S            --
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

with System.Compiler_Exceptions;
--  Used for, Exception_ID

package System.Tasking.Rendezvous is
   --  This interface is described in the document
   --  Gnu Ada Runtime Library Interface (GNARLI).

   procedure Task_Entry_Call
     (Acceptor              : Task_ID;
      E                     : Task_Entry_Index;
      Uninterpreted_Data    : System.Address;
      Mode                  : Call_Modes;
      Rendezvous_Successful : out Boolean);
   --  General entry call

   procedure Call_Simple
     (Acceptor           : Task_ID;
      E                  : Task_Entry_Index;
      Uninterpreted_Data : System.Address);
   --  Simple entry call

   procedure Cancel_Task_Entry_Call (Cancelled : out Boolean);
   --  Cancel pending task entry call

   procedure Requeue_Task_Entry
     (Acceptor   : Task_ID;
      E          : Task_Entry_Index;
      With_Abort : Boolean);

   procedure Requeue_Protected_To_Task_Entry
     (Object     : Protection_Access;
      Acceptor   : Task_ID;
      E          : Task_Entry_Index;
      With_Abort : Boolean);

   procedure Selective_Wait
     (Open_Accepts       : Accept_List_Access;
      Select_Mode        : Select_Modes;
      Uninterpreted_Data : out System.Address;
      Index              : out Select_Index);
   --  Selective wait

   procedure Accept_Call
     (E                  : Task_Entry_Index;
      Uninterpreted_Data : out System.Address);
   --  Accept an entry call

   procedure Accept_Trivial (E : Task_Entry_Index);
   --  Accept an entry call that has no parameters and no body

   function Task_Count (E : Task_Entry_Index) return Natural;
   --  Return number of tasks waiting on the entry E (of current task)

   function Callable (T : Task_ID) return Boolean;
   --  Return T'CALLABLE

   procedure Complete_Rendezvous;
   --  Called by acceptor to wake up caller

   procedure Exceptional_Complete_Rendezvous
     (Ex : System.Compiler_Exceptions.Exception_ID);
   --  Called by acceptor to mark the end of the current rendezvous and
   --  propagate an exception to the caller.

end System.Tasking.Rendezvous;
