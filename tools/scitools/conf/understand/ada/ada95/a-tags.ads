------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                             A D A . T A G S                              --
--                                                                          --
--                                 S p e c                                  --
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

with System;
with System.Storage_Elements;

package Ada.Tags is

   type Tag is private;

   function Expanded_Name (T : Tag) return String;

   function External_Tag (T : Tag) return String;

   function Internal_Tag (External : String) return Tag;

   Tag_Error : exception;

private

   --  DT stands for Dispatch Table

   procedure Set_Prim_Op_Address
     (DTptr    : Tag;
      Position : Positive;
      Value    : System.Address);
   --  Given a pointer to a dispatch Table (DTptr) and a position in the
   --  dispatch Table put the address of the virtual function in it (used for
   --  overriding)

   function Get_Prim_Op_Address
     (DTptr    : Tag;
      Position : Positive)
      return     System.Address;
   --  Given a pointer to a dispatch Table (DTptr) and a position in the DT
   --  this function returns the address of the virtual function stored in it
   --  (used for dispatching calls)

   procedure Set_Inheritance_Depth
     (DTptr : Tag;
      Value : Natural);
   --  Given a pointer to a dispatch Table, stores the value representing the
   --  depth in the inheritance tree.  (used during elaboration of the tagged
   --  type)

   function  Get_Inheritance_Depth (DTptr : Tag) return Natural;
   --  Given a pointer to a dispatch Table, retreives the value representing
   --  the depth in the inheritance tree.  (used for membership)

   procedure Set_Ancestor_Tags
     (DTptr : Tag;
      Value : System.Address);
   --  Given a pointer to a dispatch Table, stores the address of a table
   --  containing the DTptrs of the ancestors (used during elaboration of the
   --  tagged type)

   function  Get_Ancestor_Tags (DTptr : Tag) return System.Address;

   --  Given a pointer to a dispatch Table, retreives the address of a table
   --  containing the DTptrs of the ancestors (used for membership)

   function DT_Size
     (Entry_Count : Natural)
      return        System.Storage_Elements.Storage_Count;
   --  give the size in 'storage_count' of the dispatch Table (used to create
   --  statically the dispatch Table)

   procedure Inherit_DT
    (Old_DTptr   : Tag;
     New_DTptr   : Tag;
     Entry_Count : Natural);
   --  the dispatch Table referenced by New_DTptr 'inherits' the Entry_Count
   --  first entries of the dispatch Table referenced by Old_DTptr (used when
   --  deriving and the root type is CPP_Class)

   function CW_Membership (Obj_Tag : Tag; Typ_Tag : Tag) return Boolean;
   --  Given the tag of an object and the tag associated to a type, return
   --  true if Obj is in Typ'Class.

   type Address_Array is array (Natural range <>) of System.Address;

   type Dispatch_Table;
   type Tag is access all Dispatch_Table;

   pragma Inline (Set_Prim_Op_Address);
   pragma Inline (Get_Prim_Op_Address);
   pragma Inline (Set_Inheritance_Depth);
   pragma Inline (Get_Inheritance_Depth);
   pragma Inline (Set_Ancestor_Tags);
   pragma Inline (Get_Ancestor_Tags);
   pragma Inline (DT_Size);
   pragma Inline (Inherit_DT);
   pragma Inline (CW_Membership);
end Ada.Tags;
