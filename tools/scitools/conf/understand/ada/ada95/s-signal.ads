------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                        S Y S T E M . S I G N A L S                       --
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

with System.Tasking;
with Interfaces.C.POSIX_RTE;

package System.Signals is

   pragma Elaborate_Body (System.Signals);

   procedure Bind_Signal_To_Entry
     (T   : System.Tasking.Task_ID;
      E   : System.Tasking.Task_Entry_Index;
      Sig : System.Address);

   procedure Detach_Handler (T : System.Tasking.Task_ID);

   procedure Block_Signal (S : Interfaces.C.POSIX_RTE.Signal);

   procedure Unblock_Signal (S : Interfaces.C.POSIX_RTE.Signal);

   function Is_Blocked (S : Interfaces.C.POSIX_RTE.Signal) return boolean;

   function Is_Ignored (S : Interfaces.C.POSIX_RTE.Signal) return boolean;

   procedure Ignore_Signal (S : Interfaces.C.POSIX_RTE.Signal);

   procedure Unignore_Signal (S : Interfaces.C.POSIX_RTE.Signal);

end System.Signals;
