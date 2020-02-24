------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--              A D A . T A S K _ I D E N T I F I C A T I O N               --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
-- This specification is adapted from the Ada Reference Manual for use with --
-- GNAT.  In accordance with the copyright of that document, you can freely --
-- copy and modify this specification,  provided that if you redistribute a --
-- modified version,  any changes that you have made are clearly indicated. --
--                                                                          --
------------------------------------------------------------------------------

with System;
with System.Tasking;
with Unchecked_Conversion;

package Ada.Task_Identification is

   type Task_Id is private;

   Null_Task_Id : constant Task_Id;

   function  "=" (Left, Right : Task_Id) return Boolean;
   pragma Inline ("=");

   function Image (T : Task_Id) return String;

   function Current_Task return Task_Id;
   pragma Inline (Current_Task);

   procedure Abort_Task (T : in out Task_Id);
   pragma Inline (Abort_Task);

   function Is_Terminated (T : Task_Id) return Boolean;
   pragma Inline (Is_Terminated);

   function Is_Callable (T : Task_Id) return Boolean;
   pragma Inline (Is_Callable);

private
   type Task_Id is access Integer;

   function Convert_Ids is new
     Unchecked_Conversion (System.Tasking.Task_ID, Task_Id);

   function Convert_Ids is new
     Unchecked_Conversion (Task_Id, System.Tasking.Task_ID);

   Null_Task_ID : constant Task_Id := Convert_Ids (System.Tasking.Null_Task);

end Ada.Task_Identification;
