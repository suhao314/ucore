------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                     A D A . R E A L _ T I M E . C O N V                  --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 6763 $                             --
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

--  Provides conversion between Task_Clock.time and Real_Time.Time
--  and Real_Time.Time_Span

with System.Task_Clock;

--  Used for, Stimespec

package Ada.Real_Time.Conv is
   use System;

   function Time_To_Stimespec
     (T    : Real_Time.time)
      return Task_Clock.Stimespec;

   function Stimespec_To_Time
     (T    : Task_Clock.Stimespec)
      return Real_Time.Time;

   function Time_Span_To_Stimespec
     (T    : Real_Time.Time_Span)
      return Task_Clock.Stimespec;

   function Stimespec_To_Time_Span
     (T   : Task_Clock.Stimespec)
      return Real_Time.Time_Span;

end Ada.Real_Time.Conv;
