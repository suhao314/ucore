------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       A D A . I N T E R R U P T S                        --
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

package Ada.Interrupts is

   type Interrupt_Id is new Natural;

   type Parameterless_Handler is
      access protected procedure;

   function Is_Reserved (Interrupt : Interrupt_Id)
      return Boolean;

   function Is_Attached (Interrupt : Interrupt_Id)
      return Boolean;

   function Current_Handler (Interrupt : Interrupt_Id)
      return Parameterless_Handler;

   procedure Attach_Handler
      (New_Handler : Parameterless_Handler;
       Interrupt   : Interrupt_Id);

   procedure Exchange_Handler
      (Old_Handler : out Parameterless_Handler;
       New_Handler : Parameterless_Handler;
       Interrupt   : Interrupt_Id);

   procedure Detach_Handler
      (Interrupt : Interrupt_Id);

   function Reference (Interrupt : Interrupt_Id)
      return System.Address;

end Ada.Interrupts;
