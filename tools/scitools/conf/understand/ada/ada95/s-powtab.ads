------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                  S Y S T E M . P O W T E N _ T A B L E                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                              --
--                                                                          --
--           Copyright (c) 1992,1993,1994 NYU, All Rights Reserved          --
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

--  This package provides a powers of ten table used for real conversions

package System.Powten_Table is
pragma Pure (Powten_Table);

   --  The number of entries in this table is chosen to be large enough to
   --  correspond to the number of decimal digits in a 128-bit integer. It
   --  seems unlikely that Long_Long_Integer will have more than 128-bits
   --  for some time to come!

   Powten : constant array (0 .. 40) of Long_Long_Float :=
      (00 => 1.0E+00,
       01 => 1.0E+01,
       02 => 1.0E+02,
       03 => 1.0E+03,
       04 => 1.0E+04,
       05 => 1.0E+05,
       06 => 1.0E+06,
       07 => 1.0E+07,
       08 => 1.0E+08,
       09 => 1.0E+09,
       10 => 1.0E+10,
       11 => 1.0E+11,
       12 => 1.0E+12,
       13 => 1.0E+13,
       14 => 1.0E+14,
       15 => 1.0E+15,
       16 => 1.0E+16,
       17 => 1.0E+17,
       18 => 1.0E+18,
       19 => 1.0E+19,
       20 => 1.0E+20,
       21 => 1.0E+21,
       22 => 1.0E+22,
       23 => 1.0E+23,
       24 => 1.0E+24,
       25 => 1.0E+25,
       26 => 1.0E+26,
       27 => 1.0E+27,
       28 => 1.0E+28,
       29 => 1.0E+29,
       30 => 1.0E+30,
       31 => 1.0E+31,
       32 => 1.0E+32,
       33 => 1.0E+33,
       34 => 1.0E+34,
       35 => 1.0E+35,
       36 => 1.0E+36,
       37 => 1.0E+37,
       38 => 1.0E+38,
       39 => 1.0E+39,
       40 => 1.0E+40);

end System.Powten_Table;
