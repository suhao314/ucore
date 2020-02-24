------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                 S Y S T E M . O B J E C T _ R E A D E R                  --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2009-2012, Free Software Foundation, Inc.         --
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

--  This package implements a simple, minimal overhead reader for object files
--  composed of sections of untyped heterogeneous binary data.

with Interfaces.C_Streams;
with Interfaces;

with System;

package System.Object_Reader is

   --------------
   --  Limits  --
   --------------

   BUFFER_SIZE : constant := 8 * 1024;

   ------------------
   -- Object files --
   ------------------

   type Object_File is abstract tagged private;

   type Object_File_Access is access Object_File'Class;

   ---------------------
   -- Object sections --
   ----------------------

   type Object_Section is private;

   --------------------
   -- Object symbols --
   --------------------

   type Object_Symbol is private;

   ------------------------
   -- Object format type --
   ------------------------

   type Object_Format is
     (Unknown,
      --  Object format has not yet been determined

      ELF32,
      --  Object format is 32-bit ELF

      ELF64,
      --  Object format is 64-bit ELF

      PECOFF,
      --  Object format is Microsoft PECOFF

      PECOFF_PLUS,
      --  Object format is Microsoft PECOFF+

      XCOFF32);
      --  Object format is AIX 32-bit XCOFF

   --  PECOFF | PECOFF_PLUS appears so often as a case choice, would
   --  seem a good idea to have a subtype name covering these two choices ???

   ------------------------------
   -- Object architecture type --
   ------------------------------

   type Object_Arch is
     (Unknown,
      --  The target architecture has not yet been determined

      SPARC,
      --  32-bit SPARC

      SPARC64,
      --  64-bit SPARC

      i386,
      --  Intel IA32

      MIPS,
      --  MIPS Technologies MIPS

      x86_64,
      --  x86-64 (64-bit AMD/Intel)

      IA64,
      --  Intel IA64

      PPC,
      --  32-bit PowerPC

      PPC64);
      --  64-bit PowerPC

   ------------------
   -- Target types --
   ------------------

   subtype Offset is Interfaces.Integer_64;

   subtype uint8  is Interfaces.Unsigned_8;
   subtype uint16 is Interfaces.Unsigned_16;
   subtype uint32 is Interfaces.Unsigned_32;
   subtype uint64 is Interfaces.Unsigned_64;

   subtype int8  is Interfaces.Integer_8;
   subtype int16 is Interfaces.Integer_16;
   subtype int32 is Interfaces.Integer_32;
   subtype int64 is Interfaces.Integer_64;

   type Buffer is array (0 .. BUFFER_SIZE - 1) of uint8;

   -------------------------------------------
   -- Operations on buffers of untyped data --
   -------------------------------------------

   function To_String (Buf : Buffer) return String;
   --  Construct string from C style null-terminated string stored in a buffer

   function Strlen (Buf : Buffer) return int32;
   --  Return the length of a C style null-terminated string

   -------------------------
   -- Opening and closing --
   -------------------------

   function Open (File_Name : String) return Object_File'Class;
   --  Open the object file and initialize the reader

   procedure Close (Obj : in out Object_File);
   --  Close the object file

   -----------------------
   -- Sequential access --
   -----------------------

   procedure Read
     (Obj   : Object_File'Class;
      Addr  : Address;
      Size  : uint32);
   --  Read a number of fixed sized records

   function Read (Obj : Object_File'Class) return uint8;
   function Read (Obj : Object_File'Class) return uint16;
   function Read (Obj : Object_File'Class) return uint32;
   function Read (Obj : Object_File'Class) return uint64;
   function Read (Obj : Object_File'Class) return int8;
   function Read (Obj : Object_File'Class) return int16;
   function Read (Obj : Object_File'Class) return int32;
   function Read (Obj : Object_File'Class) return int64;
   --  Read a scalar

   function Read_Address (Obj : Object_File'Class) return uint64;
   --  Read either a 64 or 32 bit address from the file stream depending on the
   --  address size of the target architecture and promote it to a 64 bit type.

   function Read_LEB128 (Obj : Object_File'Class) return uint32;
   function Read_LEB128 (Obj : Object_File'Class) return int32;
   --  Read a value encoding in Little-Endian Base 128 format

   procedure Read_C_String (Obj : Object_File'Class; B : out Buffer);
   --  Read a C style NULL terminated string at an offset

   function Offset_To_String
     (Obj : Object_File'Class;
      Off : Offset) return String;
   --  Construct a string from a C style NULL terminated string located at an
   --  offset into the object file.

   -------------------
   -- Random access --
   -------------------

   procedure Seek (Obj : Object_File'Class; Off : Offset);
   --  Seek to an absolute offset in bytes

   procedure Tell (Obj : Object_File'Class; Off : out Offset);
   --  Fetch the current offset

   ------------------------
   -- Object information --
   ------------------------

   function Arch (Obj : Object_File'Class) return Object_Arch;
   --  Return the object architecture

   function Format (Obj : Object_File'Class) return Object_Format;
   --  Return the object file format

   function Num_Sections (Obj : Object_File'Class) return uint32;
   --  Return the number of sections composing the object file

   function Get_Section
     (Obj   : Object_File;
      Shnum : uint32) return Object_Section is abstract;
   --  Return the Nth section (numbered from zero)

   function Get_Section
     (Obj      : Object_File'Class;
      Sec_Name : String) return Object_Section;
   --  Return a section by name

   -------------------------
   -- Section information --
   -------------------------

   procedure Seek (Obj : Object_File'Class; Sec : Object_Section);
   --  Seek to a section

   function Name
     (Obj : Object_File;
      Sec : Object_Section) return String is abstract;
   --  Return the name of a section as a string

   function Size (Sec : Object_Section) return uint64;
   --  Return the size of a section in bytes

   function Num (Sec : Object_Section) return uint32;
   --  Return the index of a section from zero

   function Off (Sec : Object_Section) return Offset;
   --  Return the byte offset of the section within the object

   ------------------------------
   -- Symbol table information --
   ------------------------------

   Null_Symbol : constant Object_Symbol;
   --  An empty symbol table entry.

   function Num_Symbols (Obj : Object_File'Class) return uint64;
   --  The number of symbols in the symbol table

   function First_Symbol (Obj : in out Object_File) return Object_Symbol
      is abstract;
   --  Return the first element in the symbol table or Null_Symbol if the
   --  symbol table is empty.

   function Next_Symbol
     (Obj  : in out Object_File;
      Prev : Object_Symbol) return Object_Symbol is abstract;
   --  Return the element following Prev in the symbol table, or Null_Symbol if
   --  Prev is the last symbol in the table.

   function Name
     (Obj : Object_File;
      Sym : Object_Symbol) return String is abstract;
   --  Return the name of the symbol

   function Decoded_Ada_Name
     (Obj : Object_File'Class;
      Sym : Object_Symbol) return String;
   --  Return the the decoded name of a symbol encoded as per exp_dbug.ads

   function Value (Sym : Object_Symbol) return uint64;
   --  Return the name of the symbol

   function Size (Sym : Object_Symbol) return uint64;
   --  Return the size of the symbol in bytes

   function Spans (Sym : Object_Symbol; Addr : uint64) return Boolean;
   --  Determine whether a particular address corresponds to the range
   --  referenced by this symbol.

   ----------------
   -- Exceptions --
   ----------------

   IO_Error : exception;
   --  Input/Output error reading file

   Format_Error : exception;
   --  Encountered a problem parsing the object

private

   package ICS renames Interfaces.C_Streams;

   type Object_File is abstract tagged record
      fp           : ICS.FILEs := ICS.NULL_Stream;
      Arch         : Object_Arch := Unknown;
      Format       : Object_Format := Unknown;

      Num_Sections : uint32 := 0;
      Num_Symbols  : uint64 := 0;
   end record;

   type Object_Section is record
      Num  : uint32 := 0;  --  Index of this section in the section table
      Off  : Offset := 0;  --  First byte of the section
      Size : uint64 := 0;  --  Length of the section in bytes
   end record;

   type Object_Symbol is record
      Num   : uint64 := 0;  --  Index of this symbol in the symbol table
      Off   : Offset := 0;  --  Offset of underlying symbol on disk
      Next  : Offset := 0;  --  Offset of the following symbol
      Value : uint64 := 0;  --  Value associated with this symbol
      Size  : uint64 := 0;  --  Size of the referenced entity
   end record;

   Null_Symbol : constant Object_Symbol := (0, 0, 0, 0, 0);

end System.Object_Reader;
