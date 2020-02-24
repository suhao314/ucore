------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                  A D A . T A S K _ A T T R I B U T E S                   --
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

with Ada.Task_Identification;

generic
   type Attribute is private;
   Initial_Value : in Attribute;

package Ada.Task_Attributes is

   type Attribute_Handle is access all Attribute;

   function Value
     (T    : Ada.Task_Identification.Task_Id :=
               Ada.Task_Identification.Current_Task)
      return Attribute;

   function Reference
     (T    : Ada.Task_Identification.Task_Id :=
               Ada.Task_Identification.Current_Task)
      return Attribute_Handle;

   procedure Set_Value
     (Val : Attribute;
      T   : Ada.Task_Identification.Task_Id :=
              Ada.Task_Identification.Current_Task);

   procedure Reinitialize
     (T :   Ada.Task_Identification.Task_Id :=
              Ada.Task_Identification.Current_Task);

private
   pragma Inline (Value);
   pragma Inline (Set_Value);
   pragma Inline (Reinitialize);

end Ada.Task_Attributes;
