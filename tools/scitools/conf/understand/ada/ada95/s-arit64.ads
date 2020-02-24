------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . A R I T H _ 6 4                       --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
-- The GNAT library is free software; you can redistribute it and/or modify --
-- it under terms of the GNU Library General Public License as published by --
-- the Free Software  Foundation; either version 2, or (at your option) any --
-- later version.  The GNAT library is distributed in the hope that it will --
-- be useful, but WITHOUT ANY WARRANTY;  without even  the implied warranty --
-- of MERCHANTABILITY  or  FITNESS FOR  A PARTICULAR PURPOSE.  See the  GNU --
-- Library  General  Public  License for  more  details.  You  should  have --
-- received  a copy of the GNU  Library  General Public License  along with --
-- the GNAT library;  see the file  COPYING.LIB.  If not, write to the Free --
-- Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.        --
--                                                                          --
------------------------------------------------------------------------------

--  This unit provides software routines for doing arithmetic on 64-bit
--  signed integer values in cases where either overflow checking is
--  required, or intermediate results are longer than 64 bits.


with Interfaces;

package System.Arith_64 is

   subtype Int64 is Interfaces.Integer_64;

   function Add_With_Ovflo_Check (X, Y : Int64) return Int64;
   --  Raises Constraint_Error if sum of operands overflows 64 bits,
   --  otherwise returns the 64-bit signed integer sum.

   function Subtract_With_Ovflo_Check (X, Y : Int64) return Int64;
   --  Raises Constraint_Error if difference of operands overflows 64
   --  bits, otherwise returns the 64-bit signed integer difference.

   function Multiply_With_Ovflo_Check (X, Y : Int64) return Int64;
   --  Raises Constraint_Error if product of operands overflows 64
   --  bits, otherwise returns the 64-bit signed integer difference.

   function Divide_With_Ovflo_Check (X, Y : Int64) return Int64;
   --  Raises Constraint_Error if quotient of operands overflows 64
   --  bits, otherwise returns the 64-bit signed integer difference.
   --  The overflow cases are when Y is zero, or X is the largest
   --  negative integer, and Y is minus one.

   procedure Scaled_Divide
     (X, Y, Z : Int64;
      Q, R    : out Int64;
      Round   : Boolean);
   --  Performs the division of (X * Y) / Z, storing the quotient in Q
   --  and the remainder in R. Constraint_Error is raised if Z is zero,
   --  or if the quotient does not fit in 64-bits. Round indicates if
   --  the result should be rounded. If Round is False, then Q, R are
   --  the normal quotient and remainder from a truncating division.
   --  If Round is True, then Q is the rounded quotient. the remainder
   --  R is not affected by the setting of the Round flag.

   procedure Double_Divide
     (X, Y, Z : Int64;
      Q, R    : out Int64;
      Round   : Boolean);
   --  Performs the division X / (Y * Z), storing the quotient in Q and
   --  the remainder in R. Constraint_Error is raised if Y or Z is zero.
   --  Round indicates if the result should be rounded. If Round is False,
   --  then Q, R are the normal quotient and remainder from a truncating
   --  division. If Round is True, then Q is the rounded quotient. The
   --  remainder R is not affected by the setting of the Round flag.

end System.Arith_64;
