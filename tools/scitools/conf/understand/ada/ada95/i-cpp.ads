------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       I N T E R F A C E S . C P P                        --
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

--  Definitions for interfacing to C++ classes

with System;
with System.Storage_Elements;

package Interfaces.CPP is

   --  This package corresponds to Ada.Tags but applied to tagged types
   --  which are 'imported' from C++ and correspond to exactly to a C++
   --  Class.  GNAT doesn't know about the structure od the C++ dispatch
   --  table (Vtable) but always access it through the procedural interface
   --  defined below, thus the iplementation of this package (the body) can
   --  be customized to another C++ compiler without any change in the
   --  compiler code itself as long as this procedural interface is
   --  respected. Note that Ada.Tags defines a very similar procedural
   --  interface to the regular Ada Dispatch Table.

   type Vtable_Ptr is private;

private

   --  Note: these procedures are accessible to Rtsfind, but not visible
   --  to a user who with's the package to get the Vtable_Ptr declaration.

   procedure Set_Vfunction_Address
    (Vptr      : Vtable_Ptr;
      Position : Positive;
      Value    : System.Address);
   --  Given a pointer to a Vtable (Vptr) and a position in the
   --  Vtable, put the address of the virtual function in it.
   --  (used for overriding)

   function Get_Vfunction_Address
     (Vptr     : Vtable_Ptr;
      Position : Positive)
      return     System.Address;
   --  Given a pointer to a Vtable (Vptr) and a position in the Vtable, this
   --  function returns the address of the virtual function stored in it.
   --  (used for dispatching calls)

   procedure Set_Idepth
     (Vptr  : Vtable_Ptr;
      Value : Natural);
   --  Given a pointer to a Vtable, stores the value representing
   --  the depth in the inheritance tree.
   --  (used during elaboration of the tagged type)

   function  Get_Idepth (Vptr : Vtable_Ptr) return Natural;
   --  Given a pointer to a Vtable, retreives the value representing
   --  the depth in the inheritance tree.
   --  (used for membership)

   procedure Set_Ancestor_Vptrs
     (Vptr  : Vtable_Ptr;
      Value : System.Address);
   --  Given a pointer to a Vtable, stores the address of a table that can
   --  be used to store the Vptrs of the ancestors, this table is statically
   --  allocated by the compiler along with the Dispatch Table (Vtable) with
   --  a sufficient size to store all Vptrs ancestors in order to match the
   --  canonical implementation of membership test (see Ada.Tags for details).
   --  (used during elaboration of the tagged type)

   function  Get_Ancestor_Vptrs (Vptr : Vtable_Ptr) return System.Address;
   --  Given a pointer to a Vtable, retreives the address of a
   --  table containing the Vptrs of the ancestors.
   --  (used for membership)

   function Displaced_This
    (Current_This : System.Address;
     Vptr         : Vtable_Ptr;
     Position     : Positive)
     return         System.Address;
   --  Compute the displacement on the "this" pointer in order to be
   --  compatible with MI.
   --  (used for virtual function calls)

   function Vtable_Size
     (Entry_Count : Natural)
      return        System.Storage_Elements.Storage_Count;
   --  Compute the size in 'storage_count' of a vtable of the given size
   --  (used to statically create the vtable)

   procedure Inherit_Vtable
    (Old_Vptr    : Vtable_Ptr;
     New_Vptr    : Vtable_Ptr;
     Entry_Count : Natural);
   --  The Vtable referenced by New_Vptr "inherits" the Entry_Count first
   --  entries of the Vtable referenced by Old_Vptr. This function is also
   --  responsible for inheriting the type specific information used for
   --  the membership implementation
   --  (used to initialize a new Vtable)

   function CPP_Membership
     (Obj_Vptr : Vtable_Ptr;
      Typ_Vptr : Vtable_Ptr)
      return Boolean;
   --  Given the tag of an object and the tag associated to a type, return
   --  true if Obj is in Typ'Class.
   --  (used for classwide membership test)

   type Vtable;
   type Vtable_Ptr is access all Vtable;

   pragma Inline (Set_Vfunction_Address);
   pragma Inline (Get_Vfunction_Address);
   pragma Inline (Set_Idepth);
   pragma Inline (Get_Idepth);
   pragma Inline (Set_Ancestor_Vptrs);
   pragma Inline (Get_Ancestor_Vptrs);
   pragma Inline (Displaced_This);
   pragma Inline (Vtable_Size);
   pragma Inline (Inherit_Vtable);
   pragma Inline (CPP_Membership);

end Interfaces.CPP;
