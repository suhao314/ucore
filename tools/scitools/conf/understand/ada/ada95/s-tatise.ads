------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--             S Y S T E M . T A S K _ T I M E R _ S E R V I C E            --
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

--  Server to manage delays. Written in terms of System.Real_Time.Time
--  and System.Task_Clock.Time.

with Ada.Calendar;
--  Used for, Calendar.Time

with Ada.Real_Time;
--  Used for, Real_Time.Time
--            Real_Time.Time_Span

with System.Task_Clock;
--  Used for, Stimespec

package System.Task_Timer.Service is

   protected Timer is
      pragma Priority (Priority'Last);

      --  The following Enqueue entries enqueue elements in wake-up time
      --  order using a single timer queue (time in System.Real_Time.Time).

      entry Enqueue_Time_Span
        (T : in Ada.Real_Time.Time_Span;
         D : access Delay_Block);
      entry Enqueue_Duration
         (T : in Duration;
         D : access Delay_Block);
      entry Enqueue_Real_Time
        (T : in Ada.Real_Time.Time;
         D : access Delay_Block);
      entry Enqueue_Calendar_Time
        (T : in Ada.Calendar.Time;
         D : access Delay_Block);
--  private
--  Private protected operations are not currently supported by the
--  compiler.
      procedure Service (T : out System.Task_Clock.Stimespec);
      procedure Time_Enqueue
        (T : in Task_Clock.Stimespec;
         D : access Delay_Block);
   end Timer;

end System.Task_Timer.Service;
