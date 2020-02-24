--**********
--* Helen
--*   Added some declarations here to agree with Ada95 manual
--********

------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                       A D A . E X C E P T I O N S                        --
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


package Ada.Exceptions is

   type Exception_Id is private;
   Null_Id : constant Exception_Id;
   function Exception_Name(Id : Exception_Id) return String;

   type Exception_Occurrence is private;
   type Exception_Occurrence_Access is access all Exception_Occurrence;
   Null_Occurrence : constant Exception_Occurrence;

   procedure Raise_Exception (E : in Exception_Id; Message : in String := "");
   function Exception_Message(X : Exception_Occurrence) return String;
   procedure Reraise_Occurrence   (X : Exception_Occurrence);

   function Exception_Identity(X : Exception_Occurrence) return Exception_Id;
   function Exception_Name        (X : Exception_Occurrence) return String;
   function Exception_Information (X : Exception_Occurrence) return String;

   procedure Save_Occurrence(Target : out Exception_Occurrence;
                             Source : in Exception_Occurrence);
   function Save_Occurrence(Source : Exception_Occurrence)
                            return Exception_Occurrence_Access;
private
   --  Dummy definitions for now (body not implemented yet) ???

   type Exception_Id is new Integer;
   Null_Id : constant Exception_Id := 0;

   type Exception_Occurrence is new Integer;
   Null_Occurrence : constant Exception_Occurrence := 0;

end Ada.Exceptions;
