------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                 S Y S T E M . T A S K I N G _ L I B R A R Y              --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 2 $                             --
--                                                                          --
--       Copyright (c) 1991,1992,1993,1994, FSU, All Rights Reserved        --
--                                                                          --
-- GNARL is free software; you can redistribute it  and/or modify it  under --
-- terms  of  the  GNU  Library General Public License  as published by the --
-- Free Software  Foundation;  either version 2, or (at  your  option)  any --
-- later  version.  GNARL is distributed  in the hope that  it will be use- --
-- ful, but but WITHOUT ANY WARRANTY;  without even the implied warranty of --
-- MERCHANTABILITY  or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
-- eral Library Public License  for more details.  You should have received --
-- a  copy of the GNU Library General Public License along with GNARL;  see --
-- file COPYING.LIB.  If not,  write to the  Free Software Foundation,  675 --
-- Mass Ave, Cambridge, MA 02139, USA.                                      --
--                                                                          --
------------------------------------------------------------------------------

--  This package provides library routines that the compiler uses to
--  interface to GARLI.  It is not part of GNARLI itself; it should not
--  have direct access to runtime structures.

with System.Tasking;
package System.Tasking_Library is

   type Entry_Service_Pointer is access
     procedure
       (Object : System.Address;
        P      : out Boolean);
   --  Used to point to the entry service procedure for a protected
   --  type.  The entry service procedure services entry calls waiting
   --  on open barriers by executing the corresponding entry bodies.

   type Service_Record is record
     Entry_Service_Proc : Entry_Service_Pointer;
     Protection_Object  : System.Tasking.Protection_Access;
     Compiler_Object    : System.Address;
   end record;
   type Service_Pointer is access Service_Record;
   --  Service_Record objects are used by the compiler to provide enough
   --  information to allow the entry service procedure of an object to be
   --  called. It is used in cases where the object needing service is not
   --  known until runtime.

   procedure Service_Cancelled_Call
     (Block : in out System.Tasking.Communication_Block);
   --  Service the protected object from which the caller has just removed
   --  a protected entry call, if any.  Block contains the information needed
   --  to determine if a call was removed and on which object it was
   --  queued.

end System.Tasking_Library;

