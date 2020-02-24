------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     A D A . N U M E R I C S . A U X                      --
--                                                                          --
--                                 S p e c                                  --
--                           (C Library Version)                            --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
--           Copyright (c) 1992,1993,1994 NYU, All Rights Reserved          --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT;  see file COPYING.  If not, write --
-- to the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. --
--                                                                          --
------------------------------------------------------------------------------

--  This package provides the basic computational interface for the generic
--  elementary functions. The C library version interfaces with the routines
--  in the C mathematical library, and is thus quite portable, although it may
--  not necessarily meet the requirements for accuracy in the numerics annex.
--  One advantage of using this package is that it will interface directly to
--  hardware instructions, such as the those provided on the Intel 80x87.

package Ada.Numerics.Aux is
pragma Pure (Aux);

   subtype Double is Long_Float; -- implementation dependent

   function Sin (X : Double) return Double;
   pragma Import (C, Sin, "sin");

   function Cos (X : Double) return Double;
   pragma Import (C, Cos, "cos");

   function Tan (X : Double) return Double;
   pragma Import (C, Tan, "tan");

   function Exp (X : Double) return Double;
   pragma Import (C, Exp, "exp");

   function Sqrt (X : Double) return Double;
   pragma Import (C, Sqrt, "sqrt");

   function Log (X : Double) return Double;
   pragma Import (C, Log, "log");

   function Acos (X : Double) return Double;
   pragma Import (C, Acos, "acos");

   function Asin (X : Double) return Double;
   pragma Import (C, Asin, "asin");

   function Atan (X : Double) return Double;
   pragma Import (C, Atan, "atan");

   function Sinh (X : Double) return Double;
   pragma Import (C, Sinh, "sinh");

   function Cosh (X : Double) return Double;
   pragma Import (C, Cosh, "cosh");

   function Tanh (X : Double) return Double;
   pragma Import (C, Tanh, "tanh");

   function Pow (X, Y : Double) return Double;
   pragma Import (C, Pow, "pow");

end Ada.Numerics.Aux;
