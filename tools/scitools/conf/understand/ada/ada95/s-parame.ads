------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                    S Y S T E M . P A R A M E T E R S                     --
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

--  This package defines some system dependent parameters for GNAT. These
--  constants are referenced at compile time and by the runtime library,
--  and may be changed to customize a particular variant of GNAT.

package System.Parameters is
pragma Pure (Parameters);

   Count_Max : constant := Integer'Last;
   --  Upper bound of type Ada.Text_IO.Count

   Field_Max : constant := 100;
   --  Upper bound of type Ada.Text_IO.Field

   Exception_Msg_Max : constant := 200;
   --  Maximum length of message in exception occurrence

   Max_Line_Length : constant := 512;
   --  Maximum source line length. This can be set to any value up to
   --  2**15 - 1, a limit imposed by the assumption that column numbers
   --  can be stored in 16 bits (see Types.Column_Number).

   Max_Name_Length : constant := 1024;
   --  Maximum length of unit name (including all dots, and " (spec)") and
   --  of file names in the library, must be at least Max_Line_Length, but
   --  can be larger.

   Max_Instantiations : constant := 2000;
   --  Maximum number of instantiations permitted (to stop runaway cases
   --  of nested instantiations). These situations probably only occur in
   --  specially concocted test cases.

   Max_Static_Aggregate_Size : constant := 65_536;
   --  Maximum size of aggregate that is built statically (see Sem_Aggr)

   Tag_Errors : constant Boolean := False;
   --  If set to true, then brief form error messages will be prefaced by
   --  the string "error:"

end System.Parameters;
