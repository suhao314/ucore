------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                          A D A . S T R E A M S                           --
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


package Ada.Streams is
pragma Pure (Streams);

   type Root_Stream_Type is abstract tagged limited private;

   -- Changed value to avoid using GNAT Standard attributes
   --type Stream_Element is mod 2 ** Standard'Storage_Unit;
   type Stream_Element is mod 2 ** 1;

   -- Changed value to avoid using GNAT Standard attributes
   --type Stream_Element_Offset is range
   --  -(2 ** (Standard'Address_Size - 1)) ..
   --  +(2 ** (Standard'Address_Size - 1)) - 1;
   type Stream_Element_Offset is range
     -(2 ** (2 - 1)) ..
     +(2 ** (2 - 1)) - 1;

   subtype Stream_Element_Count is
      Stream_Element_Offset range 0 .. Stream_Element_Offset'Last;

   type Stream_Element_Array is
      array (Stream_Element_Offset range <>) of Stream_Element;

   procedure Read
     (Stream : in out Root_Stream_Type;
      Item   : out Stream_Element_Array;
      Last   : out Stream_Element_Offset)
   is abstract;

   procedure Write
     (Stream : in out Root_Stream_Type;
      Item   : in Stream_Element_Array)
   is abstract;

private

   type Root_Stream_Type is abstract tagged limited null record;

end Ada.Streams;
