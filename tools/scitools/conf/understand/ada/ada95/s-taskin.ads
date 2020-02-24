------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                        S Y S T E M . T A S K I N G                       --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 2 $                            --
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

--  This package provides necessary type definitions for compiler interface.

with System.Task_Primitives;
--  Used for,  Task_Primitives.Lock

with System.Compiler_Exceptions;
--  Used for, Exception_ID

package System.Tasking is

   --  Task_ID related definitions

   type Task_ID is private;

   Null_Task : constant Task_ID;

   function Self return Task_ID;
   pragma Inline (Self);

   --  Task size, initial_state and interrupt info.

   type Task_Procedure_Access is access procedure (Arg : System.Address);

   type Task_Storage_Size is new integer;

   type Interrupt_ID is range 0 .. 31;

   --  Some Constants

   Null_Entry : constant := 0;

   Max_Entry : constant := System.Max_Int;

   Interrupt_Entry : constant := -2;

   Cancelled_Entry : constant := -1;

   type Entry_Index is range Interrupt_Entry .. Max_Entry;

   --  PO related definitions

   Null_Protected_Entry : constant := Null_Entry;

   Max_Protected_Entry : constant := Max_Entry;

   type Protected_Entry_Index is new Entry_Index
     range Null_Protected_Entry .. Max_Protected_Entry;

   subtype Positive_Protected_Entry_Index is
     Protected_Entry_Index range  1 .. Protected_Entry_Index'Last;

   type Call_Modes is (Simple_Call, Conditional_Call, Asynchronous_Call);

   --  definition for Protection has to be private. But, currently
   --  generates gnat internal error.

   type Protection (Num_Entries : Protected_Entry_Index) is private;

   type Protection_Access is access all Protection;

   type Communication_Block is private;

   --  Access procedures for Communication_Block.

   function Get_Service_Info (Block : Communication_Block)
      return System.Address;
   function Get_Cancelled (Block : Communication_Block) return Boolean;
   procedure Set_Service_Info
     (Block : in out Communication_Block;
      Service_Info : System.Address);
   procedure Set_Cancelled
     (Block : in out Communication_Block;
      Cancelled : Boolean);

   type Barrier_Vector is array (Protected_Entry_Index range <>) of Boolean;

   --  Rendezvous related definitions

   Null_Task_Entry : constant := Null_Entry;

   Max_Task_Entry : constant := Max_Entry;

   type Task_Entry_Index is new Entry_Index
     range Null_Task_Entry .. Max_Task_Entry;

   No_Rendezvous : constant := 0;

   Max_Select : constant Integer := Integer'Last;
   --  RTS-defined

   subtype Select_Index is Integer range No_Rendezvous .. Max_Select;
--   type Select_Index is range No_Rendezvous .. Max_Select;

   subtype Positive_Select_Index is
     Select_Index range 1 .. Select_Index'Last;

   type Accept_Alternative is record --  should be packed
      Null_Body : Boolean;
      S : Task_Entry_Index;
   end record;

   type Accept_List is
     array (Positive_Select_Index range <>) of Accept_Alternative;

   type Accept_List_Access is access constant Accept_List;

   type Select_Modes is (
     Simple_Mode,
     Else_Mode,
     Terminate_Mode);

   --  Abortion related declarations

   Max_ATC_Nesting : constant Natural := 20;

   type Task_List is array (Positive range <>) of Task_ID;

   --  Task_Stage related types

   type Master_ID is private;

   type Access_Boolean is access all Boolean;

   type Size_Type is new Task_Storage_Size;

   Unspecified_Size : constant Size_Type := Size_Type'First;

   type Activation_Chain is limited private;

   type Activation_Chain_Access is access all Activation_Chain;

   Unspecified_Priority : constant Integer := System.Priority'First - 1;

   -------------------------------------

   --  This part should go to s-taruty.ads when we can move queuing related
   --  stuffs to s-tasque.ad?

   subtype ATC_Level_Base is Integer range 0 .. Max_ATC_Nesting;

   ATC_Level_Infinity : constant ATC_Level_Base := ATC_Level_Base'Last;

   subtype ATC_Level is ATC_Level_Base range
     ATC_Level_Base'First .. ATC_Level_Base'Last - 1;

   subtype ATC_Level_Index is ATC_Level
     range ATC_Level'First + 1 .. ATC_Level'Last;

   -----------------------------------------

   --  This part should go to private part right before the type Protection.

   Priority_Not_Boosted : constant Integer := System.Priority'First - 1;

   subtype Rendezvous_Priority is Integer
     range Priority_Not_Boosted .. System.Priority'Last;

   type Entry_Call_Record;

   type Entry_Call_Link is access all Entry_Call_Record;

   type Entry_Queue is record
      Head : Entry_Call_Link;
      Tail : Entry_Call_Link;
   end record;

   type Entry_Call_Record is record

      Prev : Entry_Call_Link;
      Next : Entry_Call_Link;

      Call_Claimed : Boolean;
      --  This flag is True if the call has been queued
      --  and subsequently claimed
      --  for service or cancellation.
      --  Protection : Test_And_Set/global update or some similar mechanism
      --  (e.g. global mutex).
      --  Caution : on machines were we use Test_And_Set, we may not want this
      --  field packed.  For example, the SPARC atomic ldsub instruction
      --  effects a whole byte.

      Self  : Task_ID;
      Level : ATC_Level;
      --  One of Self and Level are redundant in this implementation, since
      --  each Entry_Call_Record is at Self.Entry_Calls (Level).  Since we must
      --  have access to the entry call record to be reading this, we could
      --  get Self from Level, or Level from Self.  However, this requires
      --  non-portable address arithmetic.

      Mode : Call_Modes;
      Abortable : Boolean;

      Cancel_Requested : Boolean;
--      pragma Atomic (Cancel_Requested);
      --  This field is set when an attempt is made to cancel a call.
      --  It is set monotonically by the cancellation operation, and
      --  read by other operations that may have claimed the call.
      --  In particular, this is checked when a requeue with abortion is
      --  attempted, to determine if making the call abortable should result
      --  in its cancellation.
      --  Protection: Set monotonically by Self.

      Cancelled : Boolean;
      --  The call has been cancelled.
      --  Protection : Self.L.

      Done : Boolean;
      --  The call has been completed.
      --  Protection : Self.L.

      E : Entry_Index;

      Prio : System.Any_Priority;

      --  The above fields are those that there may be some hope of packing.
      --  They are gathered together to allow for compilers that lay records
      --  out contiguously, to allow for such packing.

      Uninterpreted_Data : System.Address;

      Exception_To_Raise : System.Compiler_Exceptions.Exception_ID;
      --  The exception to raise once this call has been completed without
      --  being aborted.

      --  Server : Server_Record;

      Called_Task : Task_ID;
      --  For task entry calls only.

      Acceptor_Prev_Call : Entry_Call_Link;
      --  For task entry calls only.

      Acceptor_Prev_Priority : Rendezvous_Priority;
      --  For task entry calls only.
      --  The priority of the most recent prior call being serviced.
      --  For protected entry calls, this function should be performed by
      --  GNULLI ceiling locking.

      --  Called_PO : Protection_Access;
      --  ??? Compiler bug when compiler queue package as child.
      --  Work-around: declare access type as System.Address cast types.
      --  12-7-94: The bug is still there.
      Called_PO : System.Address;
      --  For protected entry calls only.

   end record;

   type Protected_Entry_Queue_Array is
        array (Protected_Entry_Index range <>) of
        Entry_Queue;

----------------------------------
private

   type Dummy is new Integer;

   type Task_ID is access Dummy;

   Null_Task : constant Task_ID := null;

   type Activation_Chain is new Task_ID;

   type Master_ID is new Integer;

   type Communication_Block is record
      Self         : Task_ID;
      Cancelled    : Boolean;
      Service_Info : System.Address;
   end record;

   type Protection (Num_Entries : Protected_Entry_Index) is record
        L : Task_Primitives.Lock;
        Service_Info : System.Address;
        Pending_Call : Entry_Call_Link;
        Call_In_Progress : Entry_Call_Link;
        Ceiling : System.Priority;
        Old_Base_Priority : System.Priority;
        Pending_Action : Boolean;
        Entry_Queues : Protected_Entry_Queue_Array (1 .. Num_Entries);
   end record;

end System.Tasking;
