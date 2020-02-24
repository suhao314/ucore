------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                     S Y S T E M . F I L E _ A U X                        --
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

--  This package contains interfaces to C routines used by the direct
--  and sequential I/O implementations.

with Interfaces.C;
with Interfaces.C.Strings;

package System.File_Aux is

   -------------
   -- C types --
   -------------

   subtype C_Int      is Interfaces.C.Int;
   subtype C_Long_Int is Interfaces.C.Long;
   subtype C_Size_T   is Interfaces.C.Size_T;
   subtype C_Char_Ptr is Interfaces.C.Strings.Chars_Ptr;
   type    C_File_Ptr is new System.Address;
   type    C_Void_Ptr is new System.Address;

   -----------------
   -- C functions --
   -----------------

   function C_Fclose (Stream : C_File_Ptr) return C_Int;
   pragma Import (C, C_Fclose, "fclose");

   function C_Feof (File : C_File_Ptr) return C_Int;
   pragma Import (C, C_Feof, "feof");

   function C_Fflush (Stream : C_File_Ptr) return C_Int;
   pragma Import (C, C_Fflush, "fflush");

   function C_Fopen
     (Filename : C_Char_Ptr;
      Mode     : C_Char_Ptr)
      return     C_File_Ptr;
   pragma Import (C, C_Fopen, "fopen");

   function C_Fread
     (Ptr    : C_Void_Ptr;
      Size   : C_Size_T;
      Nmemb  : C_Size_T;
      Stream : C_File_Ptr)
      return   C_Size_T;
   pragma Import (C, C_Fread, "fread");

   function C_Fseek
     (Stream : C_File_Ptr;
      Offset : C_Long_Int;
      Whence : C_Int)
      return   C_Int;
   pragma Import (C, C_Fseek, "fseek");

   function C_Ftell (Stream : C_File_Ptr) return C_Long_Int;
   pragma Import (C, C_Ftell, "ftell");

   function C_Fwrite
     (Ptr    : C_Void_Ptr;
      Size   : C_Size_T;
      Nmemb  : C_Size_T;
      Stream : C_File_Ptr)
      return   C_Size_T;
   pragma Import (C, C_Fwrite, "fwrite");

   function C_Mktemp (S : C_Char_Ptr) return C_Char_Ptr;
   pragma Import (C, C_Mktemp, "mktemp");

   function C_Null return C_Void_Ptr;
   pragma Import (C, C_Null, "null_function");

   function C_Remove (Filename : C_Char_Ptr) return C_Int;
   pragma Import (C, C_Remove, "remove");

   function C_Seek_End return C_Int;
   pragma Import (C, C_Seek_End, "seek_end_function");

   function C_Seek_Set return C_Int;
   pragma Import (C, C_Seek_Set, "seek_set_function");

   function C_Tmpfile return C_File_Ptr;
   pragma Import (C, C_Tmpfile, "tmpfile");

   function C_Tmpnam (S : C_Char_Ptr) return C_Char_Ptr;
   pragma Import (C, C_Tmpnam, "tmpnam");

end System.File_Aux;
