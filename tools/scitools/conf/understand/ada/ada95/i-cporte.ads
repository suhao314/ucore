------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                I N T E R F A C E S . C . P O S I X _ R T E               --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 2 $                            --
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

--  This package interfaces with the POSIX real-time extensions. It may
--  also implement some of them using UNIX operations. It is not a complete
--  interface, it only includes what is needed to implement the Ada runtime.

with System;

--  temporarily, should really only be for 1 ???
with Interfaces.C.POSIX_Error; use Interfaces.C.POSIX_Error;
--  Used for, Return_Code

with Interfaces.C.System_Constants;
use Interfaces.C;
--  Used for, various constants

package Interfaces.C.POSIX_RTE is

   pragma Elaborate_Body (Interfaces.C.POSIX_RTE);

   Alignment : constant := Natural'Min (1, 8);

   NSIG : constant := System_Constants.NSIG;
   --  Maximum number of signal entries

   type Signal is new int;

   type Signal_Set is private;

   procedure sigaddset
     (set : access Signal_Set;
      sig : in Signal;
      Result : out POSIX_Error.Return_Code);

   procedure sigdelset
     (set : access Signal_Set;
      sig : in Signal;
      Result : out POSIX_Error.Return_Code);

   procedure sigfillset
     (set : access Signal_Set;
      Result : out POSIX_Error.Return_Code);

   procedure sigemptyset
     (set : access Signal_Set;
      Result : out POSIX_Error.Return_Code);

   function sigismember
     (set : access Signal_Set;
      sig : Signal)
     return Return_Code;
   pragma Import (C, sigismember, "sigismember");

   type sigval is record
      u0 : int;
   end record;
   --  This is not used at the moment, need to update to reflect
   --  any changes in the Pthreads signal.h in the future

   type struct_siginfo is record
      si_signo : Signal;
      si_code : int;
      si_value : sigval;
   end record;

   type siginfo_ptr is access struct_siginfo;

   type sigset_t_ptr is access Signal_Set;

   SIG_ERR : constant := System_Constants.SIG_ERR;
   SIG_DFL : constant := System_Constants.SIG_DFL;
   SIG_IGN : constant := System_Constants.SIG_IGN;
   --  constants for sa_handler

   type struct_sigaction is record

      sa_handler : System.Address;
      --  address of signal handler

      sa_mask : aliased Signal_Set;
      --  Additional signals to be blocked during
      --  execution of signal-catching function

      sa_flags : int;
      --  Special flags to affect behavior of signal

   end record;

   type sigaction_ptr is access struct_sigaction;

   --  Signal catching function (signal handler) has the following profile :

   --  procedure Signal_Handler
   --    (signo   : Signal;
   --     info    : siginfo_ptr;
   --     context : sigcontext_ptr);

   SA_NOCLDSTOP : constant := System_Constants.SA_NOCLDSTOP;
   --  Don't send a SIGCHLD on child stop

   SA_SIGINFO : constant := System_Constants.SA_SIGINFO;
   --  sa_flags flags for struct_sigaction

   SIG_BLOCK   : constant := System_Constants.SIG_BLOCK;
   SIG_UNBLOCK : constant := System_Constants.SIG_UNBLOCK;
   SIG_SETMASK : constant := System_Constants.SIG_SETMASK;
   --  sigprocmask flags (how)

   type jmp_buf is array
     (1 .. System_Constants.jmp_buf_size) of unsigned;
   for jmp_buf'Alignment use Alignment;


   type sigjmp_buf is array
     (1 .. System_Constants.sigjmp_buf_size) of unsigned;
   for sigjmp_buf'Alignment use Alignment;

   type jmp_buf_ptr is access jmp_buf;

   type sigjmp_buf_ptr is access sigjmp_buf;
   --  Environment for long jumps

   procedure sigaction
     (sig    : Signal;
      act    : access struct_sigaction;
      oact   : access struct_sigaction;
      Result : out Return_Code);
   pragma Inline (sigaction);
   --  install new sigaction structure and obtain old one

   procedure sigaction
     (sig    : Signal;
      oact   : access struct_sigaction;
      Result : out Return_Code);
   pragma Inline (sigaction);
   --  Same thing as above, but without the act parameter. By passing null
   --  pointer we can find out the action associated with it.
   --  WE WANT TO MAKE THIS VERSION TO INCLUDE THE PREVIOUS sigaction.
   --  TO BE FIXED LATER ???

   procedure sigprocmask
     (how    : int;
      set    : access Signal_Set;
      oset   : access Signal_Set;
      Result : out Return_Code);
   pragma Inline (sigprocmask);
   --  Install new signal mask and obtain old one

   procedure sigsuspend
     (mask   : access Signal_Set;
      Result : out Return_Code);
   pragma Inline (sigsuspend);
   --  Suspend waiting for signals in mask and resume after
   --  executing handler or take default action

   procedure sigpending
     (set    : access Signal_Set;
      Result : out Return_Code);
   pragma Inline (sigpending);
   --  get pending signals on thread and process

   procedure longjmp (env : jmp_buf; val : int);
   pragma Inline (longjmp);
   --  execute a jump across procedures according to setjmp

   procedure siglongjmp (env : sigjmp_buf; val : int);
   pragma Inline (siglongjmp);
   --  execute a jump across procedures according to sigsetjmp

   procedure setjmp (env : jmp_buf; Result : out Return_Code);
   pragma Inline (setjmp);
   --  set up a jump across procedures and return here with longjmp

   procedure sigsetjmp
     (env      : sigjmp_buf;
      savemask : int;
      Result   : out Return_Code);
   pragma Inline (sigsetjmp);
   --  Set up a jump across procedures and return here with siglongjmp

   SIGKILL                    : constant Signal := System_Constants.SIGKILL;
   SIGSTOP                    : constant Signal := System_Constants.SIGSTOP;
   --  Signals which cannot be masked

   --  Some synchronous signals (cannot be used for interrupt entries)

   SIGALRM                    : constant Signal := System_Constants.SIGALRM;

   SIGILL                     : constant Signal := System_Constants.SIGILL;
   SIGFPE                     : constant Signal := System_Constants.SIGFPE;
   SIGSEGV                    : constant Signal := System_Constants.SIGSEGV;

   SIGABRT                    : constant Signal := System_Constants.SIGABRT;

   --  Signals which can be used for Interrupt Entries.

   SIGHUP                     : constant Signal := System_Constants.SIGHUP;
   SIGINT                     : constant Signal := System_Constants.SIGINT;
   SIGQUIT                    : constant Signal := System_Constants.SIGQUIT;
   SIGPIPE                    : constant Signal := System_Constants.SIGPIPE;
   SIGTERM                    : constant Signal := System_Constants.SIGTERM;
   SIGUSR1                    : constant Signal := System_Constants.SIGUSR1;
   SIGUSR2                    : constant Signal := System_Constants.SIGUSR2;
   SIGCHLD                    : constant Signal := System_Constants.SIGCHLD;
   SIGCONT                    : constant Signal := System_Constants.SIGCONT;
   SIGTSTP                    : constant Signal := System_Constants.SIGTSTP;
   SIGTTIN                    : constant Signal := System_Constants.SIGTTIN;
   SIGTTOU                    : constant Signal := System_Constants.SIGTTOU;

   --  OS specific signals

   type Signal_Array is array (positive range <>) of Signal;

   OS_Specific_Sync_Signals :
      Signal_Array (System_Constants.OS_Specific_Sync_Sigs'Range);

   OS_Specific_Async_Signals :
      Signal_Array (System_Constants.OS_Specific_Async_Sigs'Range);

private
   type Signal_Set is array
      (1 .. System_Constants.sigset_t_size) of unsigned;
   for Signal_Set'Alignment use Alignment;

end Interfaces.C.POSIX_RTE;
