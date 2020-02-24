------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--    S Y S T E M . F I N A L I Z A T I O N _ I M P L E M E N T A T I O N   --
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

--  ??? this package should be a private package. It is set as public for now
--  in order to simplify testing

package System.Finalization_Implementation is
pragma Preelaborate (Finalization_Implementation);

   type Root;

   subtype Finalizable     is            Root'Class;
   type    Finalizable_Ptr is access all Root'Class;

   type Root is abstract tagged record
      Prev : Finalizable_Ptr;
      Next : Finalizable_Ptr;
   end record;

   procedure Initialize (Object : in out Root) is abstract;
   procedure Finalize   (Object : in out Root) is abstract;
   procedure Adjust     (Object : in out Root);

   -------------------------------------------------
   --  Finalization Management Abstract Interface --
   -------------------------------------------------

   Global_Final_List : Finalizable_Ptr;
   --  This list stores the controlled objects defined in library-level
   --  packages. They will be finalized after the main program completion.

   procedure Finalize_Global_List;
   --  The procedure to be called in order to finalize the global list;

   procedure Attach_To_Final_List
     (L   : in out Finalizable_Ptr;
      Obj : in out Finalizable);
   --  Put the finalizable object on a list of finalizable elements.

   procedure Detach_From_Final_List
     (L   : in out Finalizable_Ptr;
      Obj : in out Finalizable);
   --  Remove the specified object from the Final list and reset its
   --  pointers to null.

   procedure Finalize_List (L : Finalizable_Ptr);
   --  Call Finalize on each element of the list L;

   procedure Finalize_One
     (From : in out Finalizable_Ptr;
      Obj  : in out Finalizable);
   --  Call Finalize on Obj and remove it from the list From.

   -----------------------------
   -- Record Controller Types --
   -----------------------------

   --  Definition of the types of the controller component that is included
   --  in records containing controlled components. This controller is
   --  attached to the finalization chain of the upper-level and carries
   --  the pointer of the finalization chain for the lower level

   type Limited_Record_Controller is new Root with record
      F : System.Finalization_Implementation.Finalizable_Ptr;
   end record;

   procedure Initialize (Object : in out Limited_Record_Controller);
   --  Does nothing

   procedure Finalize (Object : in out Limited_Record_Controller);
   --  Finalize the controlled components of the enclosing record by
   --  following the list starting at Object.F

   type Record_Controller is
      new Limited_Record_Controller with record
         My_Address : System.Address;
      end record;

   procedure Initialize (Object : in out Record_Controller);
   --  Initialize the field My_Address to the Object'Address

   procedure Adjust (Object : in out Record_Controller);
   --  Adjust the components and their finalization pointers by substracting
   --  by the offset of the target and the source addresses of the assignment

   --  Inherit Finalize from Limited_Record_Controller

end System.Finalization_Implementation;
