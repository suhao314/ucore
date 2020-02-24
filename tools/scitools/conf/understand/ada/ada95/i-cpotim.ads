------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--             I N T E R F A C E S . C . P O S I X _ T I M E R S            --
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

with Interfaces.C.POSIX_Error; use Interfaces.C.POSIX_Error;
--  Used for Return_Code

package Interfaces.C.POSIX_Timers is

   type time_t is new long;

   type Nanoseconds is new long;

   subtype Fractional_Second is Nanoseconds range 0 .. 10#1#E9 - 1;
   --  This is dependent on the stdtypes.h header file.

   type timespec is record
      tv_sec : time_t;
      tv_nsec : Fractional_Second;
   end record;

   timespec_First : constant timespec :=
     timespec' (time_t'First, Fractional_Second'First);

   timespec_Last : constant timespec :=
     timespec' (time_t'Last, Fractional_Second'Last);

   timespec_Zero : constant timespec :=
     timespec' (time_t'First, Fractional_Second'First);

   timespec_Unit : constant timespec :=
     timespec' (time_t'First, Fractional_Second'First + 1);
   --  This is dependent on the POSIX.4 implementation; the draft standard
   --  only says that fields of these names and types (with Integer for long)
   --  will be in the record.  There may be other fields, and these do not
   --  have to be in the indicated position.  This should really be done by
   --  getting the sizes and offsets using get_POSIX_Constants and building
   --  the record to match using representation clauses.

   --  temporarily, should really only be for 1???
   type clock_id_t is private;

   CLOCK_REALTIME : constant clock_id_t;

   procedure clock_gettime
     (ID     : clock_id_t;
      CT     : out timespec;
      Result : out Return_Code);

private

   type clock_id_t is new long;
   --  This clock_id_t is defined as an long in POSIX

   CLOCK_REALTIME : constant clock_id_t := 0;
   --  We currently implement only Realtime clock.

end Interfaces.C.POSIX_Timers;
