------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                     S Y S T E M . T A S K _ T I M E R                    --
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
-- TBD: Added the following with - if it is not there, why is system.task_clock visible.
with system.task_clock;
package System.Task_Timer is

   type Delay_Block is private;
   --  An object of this type is passed by the compiler to the Wait
   --  entry of each delay object
   --  (e.g. Ada.Calendar.Delays.Delay_Object.Wait).  This is used by
   --  the delay object implementation to queue the delay request and
   --  suspend the task.

private

   --  Signal_Object provides a simple suspension capability.

   protected type Signal_Object is
      pragma Priority (Priority'Last);
      entry Wait;
      procedure Signal;
      function Wait_Count return Integer;
   private
      Open   : Boolean := False;
   end Signal_Object;

   type Q_Link is access all Delay_Block;
   type Delay_Block is record
      S_O      : Signal_Object;
      T        : Task_Clock.Stimespec;    --  wake up time
      Next     : Q_Link;
      Previous : Q_Link;
   end record;
   subtype Q_Rec is Delay_Block;

end System.Task_Timer;
