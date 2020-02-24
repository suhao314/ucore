------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                          A D A . D E C I M A L                           --
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

package Ada.Decimal is
pragma Pure (Decimal);

   --  The compiled makes a number of assumptions based on the following five
   --  constants (e.g. there is an assumption that decimal values can always
   --  be represented in 64-bit signed binary form), so code modifications are
   --  required to increase these constants.

   Max_Scale : constant := +18;
   Min_Scale : constant := -18;

   Min_Delta : constant := 1.0E-18;
   Max_Delta : constant := 1.0E+18;

   Max_Decimal_Digits : constant := 18;

   generic
      type Dividend_Type  is delta <> digits <>;
      type Divisor_Type   is delta <> digits <>;
      type Quotient_Type  is delta <> digits <>;
      type Remainder_Type is delta <> digits <>;

   procedure Divide
     (Dividend  : in Dividend_Type;
      Divisor   : in Divisor_Type;
      Quotient  : out Quotient_Type;
      Remainder : out Remainder_Type);

private
   pragma Inline (Divide);

end Ada.Decimal;
