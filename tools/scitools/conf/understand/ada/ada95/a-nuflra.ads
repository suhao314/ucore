------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--            A D A . N U M E R I C S . F L O A T _ R A N D O M             --
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

package Ada.Numerics.Float_Random is

   --  Basic facilities

   type Generator is limited private;

   subtype Uniformly_Distributed is Float range 0.0 .. 1.0;

   function Random (Gen : Generator) return Uniformly_Distributed;

   procedure Reset (Gen : Generator);
   procedure Reset (Gen : Generator; Initiator : Integer);

   --  Advanced facilities

   type State is private;

   procedure Save  (Gen : Generator; To_State   : out State);
   procedure Reset (Gen : Generator; From_State : State);

   Max_Image_Width : constant := 80;

   function Image (Of_State :    State)  return String;
   function Value (Coded_State : String) return State;

private

   pragma Inline (Random);
   pragma Inline (Save);

   type Int_32 is range -2 ** 31 .. 2** 31 - 1;
   type Longer_Float is digits 14;

   type State is record
      X1, X2, P, Q, X : Int_32;
      Scale           : Longer_Float;
   end record;

   Initial_State : constant State :=
      (X1    => 2999 ** 2,               --  Square mod p
       X2    => 1439 ** 2,               --  Square mod q
       P     => 94_833_359,              --  see Blum, Blum & Shub
       Q     => 47_416_679,              --  see Blum, Blum & Shub
       X     => 1,                       --  see Blum, Blum & Shub
       Scale => 1.0 / (94_833_359.0 * 47_416_679.0));

   type Pointer is access State;

   function Create return Pointer;

   type Generator is record
      Point : Pointer := new State' (Initial_State);
   end record;

end Ada.Numerics.Float_Random;
