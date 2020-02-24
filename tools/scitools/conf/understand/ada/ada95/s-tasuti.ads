------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--              S Y S T E M . T A S K I N G . U T I L I T I E S             --
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

--  This package provides RTS Internal Declarations.
--  These declarations are not part of the GNARLI

with Unchecked_Conversion;

with System.Compiler_Exceptions;
--  Used for, Exception_ID

-- *** tbd added following line to get adadb access to system.task_primitives

with system.task_primitives;

package System.Tasking.Utilities is

   --  Entry queue related types

   type Server_Kind is (Task_Server, PO_Server);

   type Server_Record (Kind : Server_Kind := Task_Server) is record
      case Kind is
         when Task_Server =>
            Called_Task : Task_ID;
            Acceptor_Prev_Call : Entry_Call_Link;

            Acceptor_Prev_Priority : Rendezvous_Priority;
            --  For a task servicing a task entry call,
            --  information about the most recent prior call being serviced.
            --   Not used for protected entry calls;
            --  this function should be performed by GNULLI ceiling locking.

         when PO_Server =>
            Called_PO : Protection_Access;

      end case;
   end record;

   --  Protected Objects related definitions

   Null_PO : constant Protection_Access := null;

   --  ATCB type definitions


   type Ada_Task_Control_Block (Entry_Num : Task_Entry_Index);

   type ATCB_Ptr is access Ada_Task_Control_Block;

   All_Tasks_List : ATCB_Ptr;
   All_Tasks_L : System.Task_Primitives.Lock;
   --  All_Tasks_L should not be locked by a task that holds any other
   --  locks; in other words, All_Tasks_L should be the outermost lock.
   --  Currently, only ATCB locks are locked at the same time as All_Tasks_L.

   function ID_To_ATCB is new
     Unchecked_Conversion (Task_ID, ATCB_Ptr);

   function ATCB_To_ID is new
     Unchecked_Conversion (ATCB_Ptr, Task_ID);

   function ATCB_To_Address is new
     Unchecked_Conversion (ATCB_Ptr, System.Address);

   type Task_Stage is (
      Created,
      --  Task has been created but has not begun activation.

      Can_Activate,
      --  Task has begin activation.

      Active,
      --  Task has completed activation and is executing the task body.

      Await_Dependents,
      --  Task is trying to complete a task master other than itself,
      --  and is waiting for the tasks dependent on that master to become
      --  passive (be complete, terminated, or be waiting on a terminate
      --  alternative).

      Passive,
      --  The task is passive.

      Completing,
      --  The task is committed to becoming complete, but has not yet
      --  satisfied all of the conditions for completion.  This
      --  acts as a claim to completion; once Stage is set to this value,
      --  no other task can continue with completion.

      Complete,
      --  The task is complete.  The task and all of its dependents are
      --  passive; some dependents may still be waiting on terminate
      --  alternatives.

      Terminated);
      --  The task is terminated.  All dependents waiting on terminate
      --  alternatives have been awakened and have terminated themselves.

   type Accepting_State is (
      Not_Accepting,   --  task is not ready to accept any entry call
      Trivial_Accept,   --  "accept E;"
      Simple_Accept,    --  "accept E do ... end E;"
      Select_Wait);     --  most general case

   type Entry_Call_Array is array (ATC_Level_Index) of
     aliased Entry_Call_Record;

   type Entry_Queue_Array is array (Task_Entry_Index range <>) of Entry_Queue;

   --  Notes on protection (synchronization) of TRTS data structures.

   --  Any field of the TCB can be written by the activator of a task when the
   --  task is created, since no other task can access the new task's
   --  state until creation is complete.

   --  The protection for each field is described in a comment starting with
   --  "Protection:".

   --  When a lock is used to protect an ATCB field, this lock is simply named.

   --  Some protection is described in terms of tasks related to the
   --  ATCB being protected.  These are:

   --    Self: The task which is controlled by this ATCB.
   --    Acceptor: A task accepting a call from Self.
   --    Caller: A task calling an entry of Self.
   --    Parent: The task executing the master on which Self depends.
   --    Dependent: A task dependent on Self.
   --    Activator: The task that created Self and initiated its activation.
   --    Created: A task created and activated by Self.

   type Ada_Task_Control_Block (Entry_Num : Task_Entry_Index) is record

      LL_TCB : aliased System.Task_Primitives.Task_Control_Block;
      --  Control block used by the underlying low-level tasking service
      --  (GNULLI).
      --  Protection: This is used only by the GNULLI implementation, which
      --  takes care of all of its synchronization.

      Task_Entry_Point : Task_Procedure_Access;
      --  Information needed to call the procedure containing the code for
      --  the body of this task.
      --  Protection: Part of the synchronization between Self and
      --  Activator.  Activator writes it, once, before Self starts
      --  executing.  Self reads it, once, as part of its execution.

      Task_Arg : System.Address;
      --  The argument to to task procedure.  Currently unused; this will
      --  provide a handle for discriminant information.
      --  Protection: Part of the synchronization between Self and
      --  Activator.  Activator writes it, once, before Self starts
      --  executing.  Thereafter, Self only reads it.

      Stack_Size : Size_Type;
      --  Requested stack size.
      --  Protection: Only used by Self.

      Current_Priority : System.Priority;
      --  Active priority, except that the effects of protected object
      --  priority ceilings are not reflected.  This only reflects explicit
      --  priority changes and priority inherited through task activation
      --  and rendezvous.
      --  Ada 95 notes: In Ada 95, this field will be transferred to the
      --  Priority field of an Entry_Calls component when an entry call
      --  is initiated.  The Priority of the Entry_Calls component will not
      --  change for the duration of the call.  The accepting task can
      --  use it to boost its own priority without fear of its changing in
      --  the meantime.
      --  This can safely be used in the priority ordering
      --  of entry queues.  Once a call is queued, its priority does not
      --  change.
      --  Since an entry call cannot be made while executing
      --  a protected action, the priority of a task will never reflect a
      --  priority ceiling change at the point of an entry call.
      --  Protection: Only written by Self, and only accessed when Acceptor
      --  accepts an entry or when Created activates, at which points Self is
      --  suspended.

      Base_Priority : System.Priority;
      --  Base priority, not changed during entry calls, only changed
      --  via dynamic priorities package.
      --  Protection: Only written by Self, accessed by anyone.

      New_Base_Priority : System.Priority;
      --  New value for Base_Priority (for dynamic priorities package).
      --  Protection: Self.L.

      L : System.Task_Primitives.Lock;
      --  General purpose lock; protects most fields in the ATCB.

      Compiler_Data : System.Address;
      --  Untyped task-specific data needed by the compiler to store
      --  per-task structures.
      --  Protection: Only accessed by Self.

      --  the following declarations are for Rendezvous

      Cond : System.Task_Primitives.Condition_Variable;
      --  Used by Self to wait for a condition to become true.
      --  It is invariant in the GNARL that a task waits only on its
      --  own condition variable.
      --  Protection: Condition variables are always associated with a lock.
      --  The runtime places no restrictions on which lock is used, except
      --  that it must protection the condition upon which the task is waiting.

      All_Tasks_Link : ATCB_Ptr;
      --  Used to link this task to the list of all tasks in the system.
      --  Protection: All_Tasks.L.

      Activation_Link : ATCB_Ptr;
      --  Used to link this task to a list of tasks to be activated.
      --  Protection: Only used by Activator.

      Open_Accepts : Accept_List_Access;
      --  This points to the Open_Accepts array of accept alternatives passed
      --  to the RTS by the compiler-generated code to Selective_Wait.
      --  Protection: Self.L.

      Exception_To_Raise : System.Compiler_Exceptions.Exception_ID;
      Exception_Address : System.Address;
      --  An exception which should be raised by this task when it regains
      --  control, and the address at which it should be raised.
      --  Protection: Read only by Self, under circumstances where it will
      --  be notified by the writer when it is safe to read it:
      --  1. Written by Acceptor, when Self is suspended.
      --  2. Written by Notify_Exception, executed by Self through a
      --     synchronous signal handler, which redirects control to a
      --     routine to read it and raise the exception.

      Chosen_Index : Select_Index;
      --  The index in Open_Accepts of the entry call accepted by a selective
      --  wait executed by this task.
      --  Protection: Written by both Self and Caller.  Usually protected
      --  by Self.L.  However, once the selection is known to have been
      --  written it can be accessed without protection.  This happens
      --  after Self has updated it itself using information from a suspended
      --  Caller, or after Caller has updated it and awakened Self.

      Call : Entry_Call_Link;
      --  The entry call that has been accepted by this task.
      --  Protection: Self.L.  Self will modify this field
      --  when Self.Accepting is False, and will not need the mutex to do so.
      --  Once a task sets Stage=Completing, no other task can access this
      --  field.

      --  The following fields are used to manage the task's life cycle.

      Activator : ATCB_Ptr;
      --  The task that created this task, either by declaring it as a task
      --  object or by executing a task allocator.
      --  Protection: Set by Activator before Self is activated, and
      --  read after Self is activated.

      Parent : ATCB_Ptr;
      Master_of_Task : Master_ID;
      --  The task executing the master of this task, and the ID of this task's
      --  master (unique only among masters currently active within Parent).
      --  Protection: Set by Activator before Self is activated, and
      --  read after Self is activated.

      Master_Within : Master_ID;
      --  The ID of the master currently executing within this task; that is,
      --  the most deeply nested currently active master.
      --  Protection: Only written by Self, and only read by Self or by
      --  dependents when Self is attempting to exit a master.  Since Self
      --  will not write this field until the master is complete, the
      --  synchronization should be adequate to prevent races.

      Activation_Count : Integer;
      --  This is the number of tasks that this task is activating, i.e. the
      --  children that have started activation but have not completed it.
      --  Protection: Self.L and Created.L.  Both mutexes must be locked,
      --  since Self.Activation_Count and Created.Stage must be synchronized.

      Awake_Count : Integer;
      --  Number of tasks dependent on this task (including this task) that are
      --  still "awake": not terminated and not waiting on a terminate
      --  alternative.
      --  Protection: Self.L.  Parent.L must also be locked when this is
      --  updated, so that it can be synchronized with
      --  Parent.Awaited_Dependent_Count, except under special circumstances
      --  where we know that the two can be out of sync without allowing the
      --  parent to terminate before its dependents.

      Awaited_Dependent_Count : Integer;
      --  This is the awake count of a master being completed by this task.
      --  Protection: Self.L.  Dependent.L must also be locked so that
      --  this field and Dependent.Awake_Count can be synchronized, except
      --  under special circumstances where we know that the two can be out
      --  of sync without allowing the parent to terminate before its
      --  dependents.

      Terminating_Dependent_Count : Integer;
      --  This is the count of tasks dependent on a master being completed by
      --  this task which are waiting on a terminate alternative.  Only valid
      --  when there none of the dependents are awake.
      --  Protection: Self.L.

      Pending_Priority_Change : Boolean;
      --  Flag to indicate pending priority change (for dynamic priorities
      --  package). The base priority is updated on the next abortion
      --  completion point (aka. synchronization point).
      --  Protection: Self.L.

      Pending_Action : Boolean;
      --  Unified flag indicating pending action on abortion completion
      --  point (aka. synchronization point). Currently set if:
      --  . Pending_Priority_Change is set or
      --  . Pending_ATC_Level is changed.
      --  Protection: Self.L.

      Pending_ATC_Level : ATC_Level_Base;
      --  The ATC level to which this task is currently being aborted.
      --  Protection: Self.L.

      ATC_Nesting_Level : ATC_Level;
      --  The dynamic level of ATC nesting (currently executing nested
      --  asynchronous select statements) in this task.
      --  Protection: This is only used by Self.  However, decrementing it
      --  in effect deallocates an Entry_Calls component, and care must be
      --  taken that all references to that component are eliminated before
      --  doing the decrement.  This in turn will probably required locking
      --  a protected object (for a protected entry call) or the Acceptor's
      --  lock (for a task entry call).  However, ATC_Nesting_Level itself can
      --  be accessed without a lock.

      Deferral_Level : Natural;
      --  This is the number of times that Defer_Abortion has been called by
      --  this task without a matching Undefer_Abortion call.  Abortion is
      --  only allowed when this zero.
      --  Protection: Only updated by Self; access assumed to be atomic.

      Elaborated : Access_Boolean;
      --  Pointer to a flag indicating that this task's body has been
      --  elaborated.  The flag is created and managed by the
      --  compiler-generated code.
      --  Protection: The field itself is only accessed by Activator.  The flag
      --  that it points to is updated by Master and read by Activator; access
      --  is assumed to be atomic.

      Stage : Task_Stage;
      --  The general stage of the task in it's life cycle.
      --  Protection: Self.L.

      --  beginning of flags

      Cancel_Was_Successful : Boolean;
      --  This indicates that the last attempt to cancel an entry call was
      --  successful.  It needs to be accurate between a call to
      --  *Cancel_*_Entry_Call and the following call to Complete_*_Entry_Call.
      --  These calls cannot be nested; that is, there can be no intervening
      --  *Cancel_*_Entry_Call, so this single field is adequate.
      --  Protection: Accessed only by Self.

      Accepting : Accepting_State;
      --  The ability of this task to accept an entry call.
      --  Protection: Self.L.

      Aborting : Boolean;
      --  Self is in the process of aborting. While set, prevents multiple
      --  abortion signals from being sent by different aborter while abortion
      --  is acted upon. This is essential since an aborter which calls
      --  Abort_To_Level could set the Pending_ATC_Level to yet a lower level
      --  (than the current level), may be preempted and would send the
      --  abortion signal when resuming execution. At this point, the abortee
      --  may have completed abortion to the proper level such that the
      --  signal (and resulting abortion exception) are not handled any more.
      --  In other words, the flag prevents a race between multiple aborters
      --  and the abortee.
      --  Protection: Self.L.

      Suspended_Abortably : Boolean;
      --  Task is suspended with (low-level) abortion deferred, but is
      --  abortable.  This means that the task must be awakened to perform
      --  its own abortion.
      --  Protection: Self.L.

      --  end of flags

      Entry_Calls : Entry_Call_Array;
      --  An array of entry calls.
      --  Protection: The elements of this array are on entry call queues
      --  associated with protected objects or task entries, and are protected
      --  by the protected object lock or Acceptor.L, respectively.

      Entry_Queues : Entry_Queue_Array (1 .. Entry_Num);
      --  An array of task entry queues.
      --  Protection: Self.L.  Once a task has set Self.Stage to Completing, it
      --  has exclusive access to this field.

      Aborter_Link : ATCB_Ptr;
      --  Link to the list of tasks which tries to abort this task but
      --  blocked by another aborter who has already been aborting the task.

      Terminate_Alternative : Boolean;
      --  Task is accepting Select with Terminate Alternative.

   end record;

   --  The following record holds the information used to initialize a task

   type ATCB_Init is record
      Task_Entry_Point : Task_Procedure_Access;
      Task_Arg         : System.Address;
      Stack_Size       : Size_Type;
      Activator        : ATCB_Ptr;
      Parent           : ATCB_Ptr;
      Master_of_Task   : Master_ID;
      Elaborated       : Access_Boolean;
      Entry_Num        : Task_Entry_Index;
      Priority         : System.Priority;
   end record;

   procedure Vulnerable_Complete_Activation
     (T : ATCB_Ptr;
      Completed : Boolean);
   --  Completes the activation by signaling its children.
   --  Completed indicates a call when the task has completed.
   --  Does not defer abortion (unlike Complete_Activation).

   procedure Check_Exception;
   --  Raises an exception pending on Self.
   --  Used to delay exceptions until abortion is undeferred.

   ---------------------------------
   -- Rendezvous related routines --
   ---------------------------------

   procedure Close_Entries (Target : Task_ID);
   --  Close entries, purge entry queues (called by Task_Stages.Complete)
   --  T.Stage must be Completing before this is called.

   procedure Complete_on_Sync_Point (T : Task_ID);
   --  If a task is suspended on an accept, select, or entry call
   --  (but not yet *in* rendezvous) then complete the task.

   procedure Reset_Priority
     (Acceptor_Prev_Priority : Rendezvous_Priority;
      Acceptor               : Task_ID);
   pragma Inline (Reset_Priority);
   --  Reset the priority of a task completing an accept statement to
   --  the value it had before the call.

   procedure Terminate_Alternative;
   --  Called when terminate alternative is selected.
   --  Waits for the parent to terminate the task
   --  or a caller to select an accept alternative.
   --  Assumes that abortion is deferred when called.

   procedure Complete (Target : Task_ID);
   --  Complete task and act on pending abortion.

   ---------------------------------
   -- Task_Stage Related routines --
   ---------------------------------

   procedure Make_Independent;
   --  Remove a task from the master hierarchy.  This includes setting the
   --  master ID to zero (no master) and removing the task from the
   --  All_Tasks_List (which is used to search for masters and dependents).
   --  No master will wait on the termination of an independent task;
   --  such tasks may still be running when the program terminates, at which
   --  point they will be killed by the underlying operating system.
   --  This is a dangerous operation, and should only be used on tasks
   --  that require no finalization.  Independent tasks are intended only
   --  for internal use by the GNARL, to prevent such internal tasks from
   --  preventing a user task from terminating.

   ------------------------------------
   -- Task Abortion related routines --
   ------------------------------------

   procedure Abort_To_Level (Target : Task_ID; L : ATC_Level);
   --  Abort a task to a specified ATC level.

   procedure Abort_Handler (Context : System.Task_Primitives.Pre_Call_State);
   --  Handler to be installed at initialization; it is invoked by a task
   --  when it is the target of an Abort_Task low-level operation.

   procedure Abort_Dependents (Abortee : Task_ID);
   --  Propagate the abortion of a parent into its children.

   procedure Remove_From_All_Tasks_List
      (Source : Utilities.ATCB_Ptr; Result : out Boolean);
   --  Remove an entry from the All_Tasks_List.

end System.Tasking.Utilities;
