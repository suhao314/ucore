------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                   S Y S T E M . D W A R F _ L I N E S                    --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--           Copyright (C) 2009-2011, Free Software Foundation, Inc.        --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  This package provides routines to read DWARF line number information from
--  a generic object file with as little overhead as possible. This allows
--  conversions from PC addresses to human readable source locations.
--
--  Objects must be built with debugging information, however only the
--  .debug_line section of the object file is referenced. In cases
--  where object size is a consideration it's possible to strip all
--  other .debug sections, which will decrease the size of the object
--  significantly.

with Ada.Exceptions.Traceback;
with System.Object_Reader;

package System.Dwarf_Lines is

   package AET renames Ada.Exceptions.Traceback;
   package SOR renames System.Object_Reader;

   type Dwarf_Context is private;
   --  Type encapsulation the state of the Dwarf reader

   procedure Open (File_Name : String; C : in out Dwarf_Context);
   procedure Close (C : in out Dwarf_Context);
   --  Open and close files

   procedure Dump (C : in out Dwarf_Context);
   --  Dump each row found in the object's .debug_lines section to standard out

   function Symbolic_Traceback
     (Cin          : Dwarf_Context;
      Traceback    : AET.Tracebacks_Array;
      Suppress_Hex : Boolean := False) return String;
   --  Generate a string for a traceback suitable for displaying to the user.
   --  If Suppress_Hex is True, then hex addresses are not included.

   Dwarf_Error : exception;
   --  Raised if a problem is encountered parsing DWARF information. Can be a
   --  result of a logic error or malformed DWARF information.

private

   --  The following section numbers reference

   --    "DWARF Debugging Information Format, Version 3"

   --  published by the Standards Group, http://freestandards.org.

   --  6.2.2 State Machine Registers

   type Line_Info_Registers is record
      Address        : SOR.uint64;
      File           : SOR.uint32;
      Line           : SOR.uint32;
      Column         : SOR.uint32;
      Is_Stmt        : Boolean;
      Basic_Block    : Boolean;
      End_Sequence   : Boolean;
      Prologue_End   : Boolean;
      Epilouge_Begin : Boolean;
      ISA            : SOR.uint32;
      Is_Row         : Boolean;
   end record;

   --  6.2.4 The Line Number Program Prologue

   MAX_OPCODE_LENGTHS : constant := 256;

   type Opcodes_Lengths_Array is array
     (SOR.uint32 range 1 .. MAX_OPCODE_LENGTHS) of SOR.uint8;

   type Line_Info_Prologue is record
      Unit_Length       : SOR.uint32;
      Version           : SOR.uint16;
      Prologue_Length   : SOR.uint32;
      Min_Isn_Length    : SOR.uint8;
      Default_Is_Stmt   : SOR.uint8;
      Line_Base         : SOR.int8;
      Line_Range        : SOR.uint8;
      Opcode_Base       : SOR.uint8;
      Opcode_Lengths    : Opcodes_Lengths_Array;
      Includes_Offset   : SOR.Offset;
      File_Names_Offset : SOR.Offset;
   end record;

   type Dwarf_Context is record
      Obj            : SOR.Object_File_Access;
      Prologue       : Line_Info_Prologue;
      Registers      : Line_Info_Registers;
      Next_Prologue  : SOR.Offset;
      End_Of_Section : SOR.Offset;
   end record;

end System.Dwarf_Lines;
