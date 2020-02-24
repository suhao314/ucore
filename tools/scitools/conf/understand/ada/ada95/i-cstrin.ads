------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                 I N T E R F A C E S . C . S T R I N G S                  --
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

with System.Storage_Elements;

package Interfaces.C.Strings is
pragma Preelaborate (Strings);

   type char_array_access is access all char_array;

   type chars_ptr is private;

   type chars_ptr_array is array (size_t range <>) of chars_ptr;

   Null_Ptr : constant chars_ptr;

   function To_Chars_Ptr
     (Item      : in char_array_access;
      Nul_Check : in Boolean := False)
      return      chars_ptr;

   function New_Char_Array (Chars : in char_array) return chars_ptr;

   function New_String (Str : in String) return chars_ptr;

   procedure Free (Item : in out chars_ptr);

   Dereference_Error : exception;

   function Value (Item : in chars_ptr) return char_array;

   function Value
     (Item   : in chars_ptr;
      Length : in size_t)
      return   char_array;

   function Value (Item : in chars_ptr) return String;

   function Value
     (Item   : in chars_ptr;
      Length : in size_t)
      return   String;

   function Strlen (Item : in chars_ptr) return size_t;

   procedure Update
     (Item   : in chars_ptr;
      Offset : in size_t;
      Chars  : in char_array;
      Check  : Boolean := True);

   procedure Update
     (Item   : in chars_ptr;
      Offset : in size_t;
      Str    : in String;
      Check  : in Boolean := True);

   Update_Error : exception;

private
   type chars_ptr is new System.Storage_Elements.Integer_Address;

   Null_Ptr : constant chars_ptr := 0;
   --  A little cleaner might be To_Integer (System.Null_Address) but this is
   --  non-preelaborable, and in fact we jolly well know this value is zero.
   --  Indeed, given the C interface nature, it is probably more correct to
   --  write zero here (even if Null_Address were non-zero).

end Interfaces.C.Strings;
