------------------------------------------------------------------------------
--                                                                          --
--                          GNAT RUNTIME COMPONENTS                         --
--                                                                          --
--                    S Y S T E M . A S S E R T I O N S                     --
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

--  This module contains the definition of the exception that is raised
--  when an assertion made using pragma Assert fails (i.e. the given
--  expression evaluates to False. It also contains the routines used
--  to raise this assertion with an associated message.

with System.Parameters;

package System.Assertions is

   Assert_Msg : String (1 .. System.Parameters.Exception_Msg_Max);
   Assert_Msg_Length : Natural := 0;
   --  Characters and length of message passed to Raise_Assert_Failure
   --  The initial length of zero indicates that no message has been set
   --  yet (and Assert_Message will return the null string in such cases)

   Assert_Failure : exception;
   --  Exception raised when assertion fails

   procedure Raise_Assert_Failure (Msg : String);
   --  Called to raise Assert_Failure with given message

end System.Assertions;
