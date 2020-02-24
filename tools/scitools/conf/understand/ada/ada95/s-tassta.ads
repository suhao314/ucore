------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                 S Y S T E M . T A S K I N G . S T A G E S                --
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

package System.Tasking.Stages is
   --  This interface is described in the document
   --  Gnu Ada Runtime Library Interface (GNARLI).

   pragma Elaborate_Body (System.Tasking.Stages);

   function Current_Master return Master_ID;

   procedure Enter_Master;

   procedure Complete_Master;

   procedure Create_Task
     (Size          : Size_Type;
      Priority      : Integer;
      Num_Entries   : Task_Entry_Index;
      Master        : Master_ID;
      State         : Task_Procedure_Access;
      Discriminants : System.Address;
      Elaborated    : Access_Boolean;
      Chain         : in out Activation_Chain;
      Created_Task  : out Task_ID);

   procedure Activate_Tasks (Chain_Access : Activation_Chain_Access);

   procedure Expunge_Unactivated_Tasks (Chain : in out Activation_Chain);

   procedure Complete_Activation;

   procedure Complete_Task;

   function Terminated (T : Task_ID) return Boolean;

   -------------------------------
   -- RTS Internal Declarations --
   -------------------------------
   --  These declarations are not part of the GNARLI.

   procedure Leave_Task;
   --  Export for abortion

   procedure Init_Master (M : out Master_ID);
   pragma Inline (Init_Master);

   function Increment_Master (M : Master_ID) return Master_ID;
   pragma Inline (Increment_Master);

   function Decrement_Master (M : Master_ID) return Master_ID;
   pragma Inline (Decrement_Master);

end System.Tasking.Stages;
