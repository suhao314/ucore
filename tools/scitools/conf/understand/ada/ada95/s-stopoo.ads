------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                 S Y S T E M . S T O R A G E _ P O O L S                  --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 2 $                             --
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

with Ada.Finalization;
with System.Storage_Elements;

package System.Storage_Pools is

--   type Root_Storage_Pool is abstract
--     new Ada.Finalization.Limited_Controlled with private;
--   use above when private extensions are implemented ???

   type Root_Storage_Pool is abstract
     new Ada.Finalization.Limited_Controlled with null record;

   procedure Allocate
     (Pool                     : in out Root_Storage_Pool;
      Storage_Address          : out Address;
      Size_In_Storage_Elements : in Storage_Elements.Storage_Count;
      Alignment                : in Storage_Elements.Storage_Count)
   is abstract;

   procedure Deallocate
     (Pool                     : in out Root_Storage_Pool;
      Storage_Address          : in Address;
      Size_In_Storage_Elements : in Storage_Elements.Storage_Count;
      Alignment                : in Storage_Elements.Storage_Count)
   is abstract;

   function Storage_Size
     (Pool : Root_Storage_Pool)
      return Storage_Elements.Storage_Count
   is abstract;

private

--   type Root_Storage_Pool is abstract
--     new Ada.Finalization.Limited_Controlled with null record;
--   put in above when private extensions are implemented ???

end System.Storage_Pools;
