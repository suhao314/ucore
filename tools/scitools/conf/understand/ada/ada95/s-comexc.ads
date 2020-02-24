------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--            S Y S T E M . C O M P I L E R _ E X C E P T I O N S           --
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

with System.Task_Primitives;
--  Uses, Task_Primitives.Machine_Exceptions
--        Task_Primitives.Error_Information

package System.Compiler_Exceptions is
   --  This interface is described in the document
   --  Gnu Ada Runtime Library Interface (GNARLI).

   type Exception_ID is private;
   Null_Exception      : constant Exception_ID;
   Constraint_Error_ID : constant Exception_ID;
   Numeric_Error_ID    : constant Exception_ID;
   Program_Error_ID    : constant Exception_ID;
   Storage_Error_ID    : constant Exception_ID;
   Tasking_Error_ID    : constant Exception_ID;

   type Pre_Call_State is private;

   procedure Raise_Exception (E : Exception_ID);

   procedure Notify_Exception
     (Which              : System.Task_Primitives.Machine_Exceptions;
      Info               :  System.Task_Primitives.Error_Information;
      Modified_Registers : Pre_Call_State);

   function Current_Exception return Exception_ID;

   subtype Exception_ID_String is String (1 .. 16);

   function Image
     (E    : Exception_ID)
      return Exception_ID_String;

private
   type Exception_ID is new Integer;

   Null_Exception      : constant Exception_ID := 0;
   Constraint_Error_ID : constant Exception_ID := 1;
   Numeric_Error_ID    : constant Exception_ID := 2;
   Program_Error_ID    : constant Exception_ID := 3;
   Storage_Error_ID    : constant Exception_ID := 4;
   Tasking_Error_ID    : constant Exception_ID := 5;

   type tmp is record
      d : integer;
   end record;

   type Pre_Call_State is access tmp;
end System.Compiler_Exceptions;
