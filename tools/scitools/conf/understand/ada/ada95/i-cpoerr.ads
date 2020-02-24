------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--              I N T E R F A C E S . C . P O S I X _ E R R O R             --
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

--  This package contains those parts of the package POSIX defined in P1003.5
--  (Ada binding to POSIX.1) needed to interface to Pthreads.

with Interfaces.C.System_Constants; use Interfaces.C.System_Constants;
--  Used for, various constants
use Interfaces.C;

package Interfaces.C.POSIX_Error is

   type Return_Code is new int;

   Failure : constant Return_Code := -1;

   type Error_Code is new int;

   subtype EC is Error_Code;
   --  Synonym used only in this package

   function Get_Error_Code return Error_Code;
   pragma Import (C, Get_Error_Code, "get_errno");
   --  An interface to the error number of the current thread.  This is updated
   --  by Pthreads at each context switch.

   --  Error number definitions.  These definitions are derived from
   --  /usr/include/errno.h and /usr/include/sys/errno.h. These are SunOS
   --  errors; they have not yet been checked fsor POSIX complience.

   --  Error number definitions.

   Operation_Not_Permitted            : constant EC := EPERM;
   No_Such_File_Or_Directory          : constant EC := ENOENT;
   No_Such_Process                    : constant EC := ESRCH;
   Interrupted_Operation              : constant EC := EINTR;
   Input_Output_Error                 : constant EC := EIO;
   No_Such_Device_Or_Address          : constant EC := ENXIO;
   Argument_List_Too_Long             : constant EC := E2BIG;
   Exec_Format_Error                  : constant EC := ENOEXEC;
   Bad_File_Descriptor                : constant EC := EBADF;
   No_Child_Process                   : constant EC := ECHILD;
   Resource_Temporarily_Unavailable   : constant EC := EAGAIN;
   Not_Enough_Space                   : constant EC := ENOMEM;
   Permission_Denied                  : constant EC := EACCES;
   Resource_Busy                      : constant EC := EFAULT;
   File_Exists                        : constant EC := ENOTBLK;
   Improper_Link                      : constant EC := EBUSY;
   No_Such_Operation_On_Device        : constant EC := EEXIST;
   Not_A_Directory                    : constant EC := EXDEV;
   Is_A_Directory                     : constant EC := ENODEV;
   Invalid_Argument                   : constant EC := ENOTDIR;
   Too_Many_Open_Files_In_System      : constant EC := EISDIR;
   Too_Many_Open_Files                : constant EC := EINVAL;
   Priority_Ceiling_Violation         : constant EC := EINVAL;
   Inappropriate_IO_Control_Operation : constant EC := ENFILE;
   File_Too_Large                     : constant EC := EMFILE;
   No_Space_Left_On_Device            : constant EC := ENOTTY;
   Invalid_Seek                       : constant EC := ETXTBSY;
   Read_Only_File_System              : constant EC := EFBIG;
   Too_Many_Links                     : constant EC := ENOSPC;
   Broken_Pipe                        : constant EC := ESPIPE;
   Operation_Not_Implemented          : constant EC := ENOSYS;
   Operation_Not_Supported            : constant EC := ENOTSUP;

end Interfaces.C.POSIX_Error;
