------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                   I N T E R F A C E S . F O R T R A N                    --
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

with Ada.Numerics.Generic_Complex_Types;
pragma Elaborate_All (Ada.Numerics.Generic_Complex_Types);

package Interfaces.Fortran is
pragma Pure (Fortran);

   type Fortran_Integer  is new Integer;
   type Real             is new Float;
   type Double_Precision is new Long_Float;
   type Logical          is new Boolean;

   package Single_Precision_Complex_Types is
      new Ada.Numerics.Generic_Complex_Types (Real);

   type Complex is new Single_Precision_Complex_Types.Complex;

   type Imaginary is new Single_Precision_Complex_Types.Imaginary;
   i : constant Imaginary := Imaginary (Single_Precision_Complex_Types.i);
   j : constant Imaginary := Imaginary (Single_Precision_Complex_Types.j);

   type Character_Set is new Character;

   type Fortran_Character is array (Positive range <>) of Character_Set;
   pragma Pack (Fortran_Character);

   function To_Fortran (Item : in Character)     return Character_Set;
   function To_Ada     (Item : in Character_Set) return Character;

   function To_Fortran (Item : in String)            return Fortran_Character;
   function To_Ada     (Item : in Fortran_Character) return String;

   procedure To_Fortran
     (Item   : in String;
      Target : out Fortran_Character;
      Last   : out Natural);

   procedure To_Ada
     (Item   : in Fortran_Character;
      Target : out String;
      Last   : out Natural);

end Interfaces.Fortran;
