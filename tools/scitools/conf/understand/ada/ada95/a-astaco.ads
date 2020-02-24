------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--         A D A . S Y N C H R O N O U S _ T A S K _ C O N T R O L          --
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
--Helen: Added this file to implement asynchronous_task_control.

with Ada.Task_Identification;

package Ada.Asynchronous_Task_Control is
   procedure Hold(T : in Ada.Task_Identification.Task_ID);
   procedure Continue(T : in Ada.Task_Identification.Task_ID);
   function Is_Held(T : Ada.Task_Identification.Task_ID) 
      return Boolean;
end Ada.Asynchronous_Task_Control;
