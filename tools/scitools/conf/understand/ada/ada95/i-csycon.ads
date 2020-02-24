-----------------------------------------------------------------------------
--                                                                         --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                         --
--         I n t e r f a c e s . C . S Y S T E M _ C o n s t a n t s       --
--                                                                         --
--                                 S p e c                                 --
--                                                                         --
--                            $Revision: 2 $                            --
--                                                                         --
--       Copyright (c) 1991,1992,1993,1994, FSU, All Rights Reserved       --
--                                                                         --
-- GNARL is free software; you can redistribute it and/or modify it  under --
-- terms  of  the  GNU  Library General Public License as published by the --
-- Free Software Foundation; either version 2, or  (at  your  option)  any --
-- later  version.   GNARL is distributed in the hope that it will be use- --
-- ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
-- MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
-- eral Library Public License for more details.  You should have received --
-- a  copy of the GNU Library General Public License along with GNARL; see --
-- file COPYING.LIB.  If not,  write to the  Free Software Foundation, 675 --
-- Mass Ave, Cambridge, MA 02139, USA.                                     --
--                                                                         --
-----------------------------------------------------------------------------

package Interfaces.C.System_Constants is

   pthread_t_size : constant Integer := 1;
   pthread_attr_t_size : constant Integer := 13;
   pthread_mutexattr_t_size : constant Integer := 3;
   pthread_mutex_t_size : constant Integer := 8;
   pthread_condattr_t_size : constant Integer := 1;
   pthread_cond_t_size : constant Integer := 5;
   pthread_key_t_size : constant Integer := 1;
   jmp_buf_size : constant Integer := 12;
   sigjmp_buf_size : constant Integer := 19;
   sigset_t_size : constant Integer := 4;
   SIG_BLOCK : constant := 1;
   SIG_UNBLOCK : constant := 2;
   SIG_SETMASK : constant := 3;
   SA_NOCLDSTOP : constant := 131072;
   SA_SIGINFO : constant := 8;
   SIG_ERR : constant := -1;
   SIG_DFL : constant := 0;
   SIG_IGN : constant := 1;
   SIGNULL : constant := 0;
   SIGHUP  : constant := 1;
   SIGINT  : constant := 2;
   SIGQUIT : constant := 3;
   SIGILL  : constant := 4;
   SIGABRT : constant := 6;
   SIGFPE  : constant := 8;
   SIGKILL : constant := 9;
   SIGSEGV : constant := 11;
   SIGPIPE : constant := 13;
   SIGALRM : constant := 14;
   SIGTERM : constant := 15;
   SIGSTOP : constant := 23;
   SIGTSTP : constant := 24;
   SIGCONT : constant := 25;
   SIGCHLD : constant := 18;
   SIGTTIN : constant := 26;
   SIGTTOU : constant := 27;
   SIGUSR1 : constant := 16;
   SIGUSR2 : constant := 17;
   NSIG    : constant := 44;
   --  OS specific signals represented as an array
   type Sig_Array is array (positive range <>) of integer;
   OS_Specific_Sync_Sigs : Sig_Array :=
     (NSIG, 5, 7, 10);
   OS_Specific_Async_Sigs : Sig_Array :=
     (NSIG, 12, 21, 22, 30, 31, 28, 29, 20);
   --  End of OS specific signals representation
   EPERM    : constant := 1;
   ENOENT   : constant := 2;
   ESRCH    : constant := 3;
   EINTR    : constant := 4;
   EIO      : constant := 5;
   ENXIO    : constant := 6;
   E2BIG    : constant := 7;
   ENOEXEC  : constant := 8;
   EBADF    : constant := 9;
   ECHILD   : constant := 10;
   EAGAIN   : constant := 11;
   ENOMEM   : constant := 12;
   EACCES   : constant := 13;
   EFAULT   : constant := 14;
   ENOTBLK  : constant := 15;
   EBUSY    : constant := 16;
   EEXIST   : constant := 17;
   EXDEV    : constant := 18;
   ENODEV   : constant := 19;
   ENOTDIR  : constant := 20;
   EISDIR   : constant := 21;
   EINVAL   : constant := 22;
   ENFILE   : constant := 23;
   EMFILE   : constant := 24;
   ENOTTY   : constant := 25;
   ETXTBSY  : constant := 26;
   EFBIG    : constant := 27;
   ENOSPC   : constant := 28;
   ESPIPE   : constant := 29;
   EROFS    : constant := 30;
   EMLINK   : constant := 31;
   EPIPE    : constant := 32;
   ENAMETOOLONG : constant := 78;
   ENOTEMPTY    : constant := 93;
   EDEADLK  : constant := 45;
   ENOLCK   : constant := 46;
   ENOSYS   : constant := 89;
   ENOTSUP  : constant := 48;
   NO_PRIO_INHERIT : constant := 0;
   PRIO_INHERIT : constant := 1;
   PRIO_PROTECT : constant := 2;
   Add_Prio : constant Integer := 2;

end Interfaces.C.System_Constants;

