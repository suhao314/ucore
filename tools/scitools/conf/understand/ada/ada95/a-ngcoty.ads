------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--   A D A . N U M E R I C S . G E N E R I C _ C O M P L E X _ T Y P E S    --
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

generic
   type Real is digits <>;

package Ada.Numerics.Generic_Complex_Types is

pragma Pure (Generic_Complex_Types);

   type Complex is record
      Re, Im : Real'Base;
   end record;

   type Imaginary is private;

   i : constant Imaginary;
   j : constant Imaginary;

   function Re (X : Complex)   return Real'Base;
   function Im (X : Complex)   return Real'Base;
   function Im (X : Imaginary) return Real'Base;

   procedure Set_Re (X  : in out Complex;   Re : in Real'Base);
   procedure Set_Im (X  : in out Complex;   Im : in Real'Base);
   procedure Set_Im (X  :    out Imaginary; Im : in Real'Base);

   function Compose_From_Cartesian (Re, Im : Real'Base) return Complex;
   function Compose_From_Cartesian (Re     : Real'Base) return Complex;
   function Compose_From_Cartesian (Im     : Imaginary) return Complex;

   function Modulus (X     : Complex) return Real'Base;
   function "abs"   (Right : Complex) return Real'Base renames Modulus;

   function Argument (X : Complex)                    return Real'Base;
   function Argument (X : Complex; Cycle : Real'Base) return Real'Base;

   function Compose_From_Polar (
     Modulus, Argument : Real'Base)
     return Complex;

   function Compose_From_Polar (
     Modulus, Argument, Cycle : Real'Base)
     return Complex;

   function "+"       (Right : Complex) return Complex;
   function "-"       (Right : Complex) return Complex;
   function Conjugate (X     : Complex) return Complex;

   function "+"       (Left, Right : Complex) return Complex;
   function "-"       (Left, Right : Complex) return Complex;
   function "*"       (Left, Right : Complex) return Complex;
   function "/"       (Left, Right : Complex) return Complex;

   function "**"      (Left : Complex; Right : Integer) return Complex;

   function "+"       (Right : Imaginary) return Imaginary;
   function "-"       (Right : Imaginary) return Imaginary;
   function Conjugate (X     : Imaginary) return Imaginary renames "-";
   function "abs"     (Right : Imaginary) return Real'Base;

   function "+"       (Left, Right : Imaginary) return Imaginary;
   function "-"       (Left, Right : Imaginary) return Imaginary;
   function "*"       (Left, Right : Imaginary) return Real'Base;
   function "/"       (Left, Right : Imaginary) return Real'Base;

   function "**"      (Left : Imaginary; Right : Integer) return Complex;

   function "<"       (Left, Right : Imaginary) return Boolean;
   function "<="      (Left, Right : Imaginary) return Boolean;
   function ">"       (Left, Right : Imaginary) return Boolean;
   function ">="      (Left, Right : Imaginary) return Boolean;

   function "+"       (Left : Complex;   Right : Real'Base) return Complex;
   function "+"       (Left : Real'Base; Right : Complex)   return Complex;
   function "-"       (Left : Complex;   Right : Real'Base) return Complex;
   function "-"       (Left : Real'Base; Right : Complex)   return Complex;
   function "*"       (Left : Complex;   Right : Real'Base) return Complex;
   function "*"       (Left : Real'Base; Right : Complex)   return Complex;
   function "/"       (Left : Complex;   Right : Real'Base) return Complex;
   function "/"       (Left : Real'Base; Right : Complex)   return Complex;

   function "+"       (Left : Complex;   Right : Imaginary) return Complex;
   function "+"       (Left : Imaginary; Right : Complex)   return Complex;
   function "-"       (Left : Complex;   Right : Imaginary) return Complex;
   function "-"       (Left : Imaginary; Right : Complex)   return Complex;
   function "*"       (Left : Complex;   Right : Imaginary) return Complex;
   function "*"       (Left : Imaginary; Right : Complex)   return Complex;
   function "/"       (Left : Complex;   Right : Imaginary) return Complex;
   function "/"       (Left : Imaginary; Right : Complex)   return Complex;

   function "+"       (Left : Imaginary; Right : Real'Base) return Complex;
   function "+"       (Left : Real'Base; Right : Imaginary) return Complex;
   function "-"       (Left : Imaginary; Right : Real'Base) return Complex;
   function "-"       (Left : Real'Base; Right : Imaginary) return Complex;

   function "*"       (Left : Imaginary; Right : Real'Base) return Imaginary;
   function "*"       (Left : Real'Base; Right : Imaginary) return Imaginary;
   function "/"       (Left : Imaginary; Right : Real'Base) return Imaginary;
   function "/"       (Left : Real'Base; Right : Imaginary) return Imaginary;

private
   type Imaginary is new Real'Base;

   i : constant Imaginary := 1.0;
   j : constant Imaginary := 1.0;

   pragma Inline ("+");
   pragma Inline ("-");
   pragma Inline ("*");
   pragma Inline ("<");
   pragma Inline ("<=");
   pragma Inline (">");
   pragma Inline (">=");
   pragma Inline ("abs");
   pragma Inline (Compose_From_Cartesian);
   pragma Inline (Conjugate);
   pragma Inline (Im);
   pragma Inline (Re);
   pragma Inline (Set_Im);
   pragma Inline (Set_Re);

end Ada.Numerics.Generic_Complex_Types;
