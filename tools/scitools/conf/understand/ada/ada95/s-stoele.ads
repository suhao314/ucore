------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--               S Y S T E M . S T O R A G E _ E L E M E N T S              --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                             --
--                                                                          --
-- This specification is adapted from the Ada Reference Manual for use with --
-- GNAT.  In accordance with the copyright of that document, you can freely --
-- copy and modify this specification,  provided that if you redistribute a --
-- modified version,  any changes that you have made are clearly indicated. --
--                                                                          --
------------------------------------------------------------------------------

package System.Storage_Elements is
pragma Pure (Storage_Elements);
--  Note that we take advantage of the implementation permission to make
--  this unit Pure instead of Preelaborable, see RM ???

-- Changed value to avoid using GNAT Standard attributes
--   type Storage_Offset is range
--     -(2 ** (Standard'Address_Size - 1)) ..
--     +(2 ** (Standard'Address_Size - 1)) - 1;
   type Storage_Offset is range
     -(2 ** (2 - 1)) ..
     +(2 ** (2 - 1)) - 1;

   subtype Storage_Count is Storage_Offset range 0 .. Storage_Offset'Last;
   subtype Storage_Index is Storage_Offset range 1 .. Storage_Offset'Last;

   type Storage_Element is mod 2 ** Storage_Unit;
   for Storage_Element'Size use Storage_Unit;

   type Storage_Array is
     array (Storage_Index range <>) of aliased Storage_Element;
   for Storage_Array'Component_Size use Storage_Unit;

   --  Address arithmetic

   function "+" (Left : Address; Right : Storage_Offset) return Address;
   pragma Convention (Intrinsic, "+");
   pragma Inline ("+");

   function "+" (Left : Storage_Offset; Right : Address) return Address;
   pragma Convention (Intrinsic, "+");
   pragma Inline ("+");

   function "-" (Left : Address; Right : Storage_Offset) return Address;
   pragma Convention (Intrinsic, "-");
   pragma Inline ("-");

   function "-" (Left, Right : Address) return Storage_Offset;
   pragma Convention (Intrinsic, "-");
   pragma Inline ("-");

   function "mod"
     (Left  : Address;
      Right : Storage_Offset)
      return  Storage_Offset;
   pragma Convention (Intrinsic, "mod");
   pragma Inline ("mod");

   --  Conversion to/from integers

   type Integer_Address is mod Memory_Size;

   function To_Address (Value : Integer_Address) return Address;
   pragma Convention (Intrinsic, To_Address);
   pragma Inline (To_Address);

   function To_Integer (Value : Address) return Integer_Address;
   pragma Convention (Intrinsic, To_Integer);
   pragma Inline (To_Integer);

end System.Storage_Elements;
