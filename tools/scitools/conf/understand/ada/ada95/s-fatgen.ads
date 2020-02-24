------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                       S Y S T E M . F A T _ G E N                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
-- This  specification comes from the Generic Primitive Functions standard. --
-- In accordance  with the copyright of that document,  you can freely copy --
-- and modify this specification,  provided that if you do redistribute it, --
-- then any changes that you have made must be clearly indicated.           --
--                                                                          --
------------------------------------------------------------------------------

--  This generic package provides a target independent implementation of the
--  floating-point attributes that denote functions. The implementations here
--  are portable, but very slow. The runtime contains a set of instantiations
--  of this package for all predefined floating-point types, and these should
--  be replaced by efficient assembly language code where possible.

generic
    type T is digits <>;

package System.Fat_Gen is

   subtype UI is Integer;
   --  The runtime representation of universal integer for the purposes of
   --  this package is integer. The expander generates conversions for the
   --  actual type used. For functions returning universal integer, there
   --  is no problem, since the result always is in range of integer. For
   --  input arguments, the expander has to do some special casing to deal
   --  with the (very annoying!) cases of out of range values. If we used
   --  Long_Long_Integer to represent universal, then there would be no
   --  problem, but the resulting inefficiency would be annoying.

   function Adjacent          (X, Towards : T)              return T;

   function Ceiling           (X : T)                       return T;

   function Compose           (Fraction : T; Exponent : UI) return T;

   function Copy_Sign         (Value, Sign : T)             return T;

   function Exponent          (X : T)                       return UI;

   function Floor             (X : T)                       return T;

   function Fraction          (X : T)                       return T;

   function Leading_Part      (X : T; Radix_Digits : UI)    return T;

   function Machine           (X : T)                       return T;

   function Model             (X : T)                       return T;

   function Pred              (X : T)                       return T;

   function Remainder         (X, Y : T)                    return T;

   function Rounding          (X : T)                       return T;

   function Scaling           (X : T; Adjustment : UI)      return T;

   function Succ              (X : T)                       return T;

   function Truncation        (X : T)                       return T;

   function Unbiased_Rounding (X : T)                       return T;

private
   pragma Inline (Machine);
   pragma Inline (Model);

end System.Fat_Gen;
