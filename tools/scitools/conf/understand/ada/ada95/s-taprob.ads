------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--      S Y S T E M . T A S K I N G . P R O T E C T E D _ O B J E C T S     --
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

package System.Tasking.Protected_Objects is
   --  This interface is described in the document
   --  Gnu Ada Runtime Library Interface (GNARLI).

   pragma Elaborate_Body (System.Tasking.Protected_Objects);

   procedure Initialize_Protection
     (Object           : Protection_Access;
      Ceiling_Priority : Integer;
      Service_Info     : System.Address);
   --  Initialize the Object parameter so that it can be used by the runtime
   --  to keep track of the runtime state of a protected object.

   procedure Finalize_Protection
     (Object : Protection_Access);
   --  Remove any remaining calls on entry queues for the corresponding
   --  object.  Deallocate any resources allocated for this object
   --  by the runtime.

   procedure Lock
     (Object : Protection_Access);
   --  Lock a protected object for write access.  Upon return, the caller
   --  owns the lock to this object, and no other call to Lock or
   --  Lock_Read_Only with the same argument will return until the
   --  corresponding call to Unlock has been made by the caller.

   procedure Lock_Read_Only
     (Object : Protection_Access);
   --  Lock a protected object for read access.  Upon return, the caller
   --  owns the lock for read access, and no other calls to Lock
   --  with the same argument will return until the corresponding call
   --  to Unlock has been made by the caller.  Other cals to Lock_Read_Only
   --  may (but need not) return before the call to Unlock, and the
   --  corresponding callers will also own the lock for read access.

   procedure Unlock
     (Object : Protection_Access);
   --  Relinquish ownership of the lock for the object represented by
   --  the Object parameter.  If this ownership was for write access, or
   --  if it was for read access where there are no other read access
   --  locks outstanding, one (or more, in the case of Lock_Read_Only)
   --  of the tasks waiting on this lock (if any) will be given the
   --  lock and allowed to return from the Lock or Lock_Read_Only call.

   procedure Protected_Entry_Call
     (Object    : Protection_Access;
      E         : Protected_Entry_Index;
      Uninterpreted_Data : System.Address;
      Mode      : Call_Modes;
      Block     : out Communication_Block);
   --  Pend a protected entry call on the protected object represented
   --  by Object.  A pended call is not queued; it may be executed immediately
   --  or queued, depending on the state of the entry barrier.
   --  E---The index representing the entry to be called.
   --  Uninterpreted_Data---This will be returned by Next_Entry_Call
   --   when this call is serviced.  It can be used by the compiler
   --   to pass information between the caller and the server, in particular
   --   entry parameters.
   --  Mode---The kind of call to be pended.
   --  Block---Information passed between one runtime call and another
   --   by the compiler.

   procedure Wait_For_Completion (Block : in out Communication_Block);
   --  Wait for the completion of a queued protected entry call.
   --  Block passes information between this and other runtime calls.

   procedure Wait_Until_Abortable (Block : in out Communication_Block);
   --  Wait for an entry call to be queued abortably for the first time.
   --  Block passes information between this and other runtime calls.

   procedure Cancel_Protected_Entry_Call (Block : in out Communication_Block);
   --  Attempt to cancel the most recent protected entry call.  If the call is
   --  not queued abortably, wait until it is or until it has completed.
   --  If the call is actually cancelled, the called object will be
   --  locked on return from this call. Get_Cancelled (Block) can be
   --  used to determine if the cancellation took place; there
   --  may be entries needing service in this case.
   --  Block passes information between this and other runtime calls.

   procedure Next_Entry_Call
     (Object    : Protection_Access;
      Barriers  : Barrier_Vector;
      Uninterpreted_Data : out System.Address;
      E         : out Protected_Entry_Index);
   --  Determine the next entry call on Object to be serviced.
   --   If there is a call pending on this object, it will be given
   --   preference; if a pending call cannot be serviced, it will be
   --   queued abortably at this point.
   --  Barriers---A vector of barrier flags indexed by the corresponding
   --   entry indices.
   --  Uninterpreted_Data---The value passed in the Protected_Entry_Call
   --   the Uninterpreted_Data parameter to Protected_Entry_Call when this
   --   call was pended.
   --  E---The index of the call to be serviced.

   procedure Complete_Entry_Body
     (Object           : Protection_Access;
      Pending_Serviced : out Boolean);
   --  Indicate to the runtime system that the call most recently returned
   --   from Next_Entry_Call on Object has been serviced.
   --  Pending_Serviced---True if the call just completed was a pending
   --   call, that is, a call that was never queued.

   procedure Exceptional_Complete_Entry_Body
     (Object           : Protection_Access;
      Pending_Serviced : out Boolean;
      Ex               : System.Compiler_Exceptions.Exception_ID);
   --  Perform all of the functions of Complete_Entry_Body.  In addition,
   --  report in Ex the exception whose propagation terminated the entry
   --  body to the runtime system.

   procedure Requeue_Protected_Entry
     (Object     : Protection_Access;
      New_Object : Protection_Access;
      E          : Protected_Entry_Index;
      With_Abort : Boolean);
   --  If Object = New_Object, queue the protected entry call on Object
   --   currently being serviced on the queue corresponding to the entry
   --   represented by E.
   --  If Object /= New_Object, pend the protected entry call on
   --   Object currently being serviced as an entry call to entry E
   --   of New_Object.
   --  With_Abort---True if the call is to be queued abortably, false
   --   otherwise.

   procedure Requeue_Task_To_Protected_Entry
     (New_Object : Protection_Access;
      E          : Protected_Entry_Index;
      With_Abort : Boolean);
   --  Pend the task entry call currently being serviced as entry E
   --   on New_Object.
   --  With_Abort---True if the call is to be queued abortably, false
   --   otherwise.

   function Protected_Count
     (Object : Protection;
      E      : Protected_Entry_Index)
      return   Natural;
   --  Return the number of entry calls to E on Object.

   procedure Broadcast_Program_Error
     (Object : Protection_Access);

   procedure Raise_Pending_Exception
     (Block : Communication_Block);
   --  Raise any exceptions that may have been raised in the runtime, but
   --  which could not be propagated at that time.

end System.Tasking.Protected_Objects;
