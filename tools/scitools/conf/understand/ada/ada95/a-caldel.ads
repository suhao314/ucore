------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                   A D A . C A L E N D A R . D E L A Y S                  --
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

--  This package implements Calendar.Time delays using protected objects.

with System;
with System.Task_Timer;

package Ada.Calendar.Delays is

   --  The Wait entries suspend the caller until the requested timeout has
   --  expired.  The Dealy_Block parameter provides the GNARL with working
   --  storage.

   protected Delay_Object is
      pragma Priority (System.Priority'Last);
      entry Wait (T : Duration; D : access System.Task_Timer.Delay_Block);
   end Delay_Object;

   protected Delay_Until_Object is
      pragma Priority (System.Priority'Last);
      entry Wait (T : Time; D : access System.Task_Timer.Delay_Block);
   end Delay_Until_Object;

   procedure Delay_For (D : Duration);

   procedure Delay_Until (T : Time);

end Ada.Calendar.Delays;
