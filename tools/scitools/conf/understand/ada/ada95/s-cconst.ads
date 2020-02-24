-----------------------------------------------------------------------------
--                                                                         --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                         --
--                         C _ C o n s t a n t s                           --
--                                                                         --
--                                 S p e c                                 --
--                                                                         --
--                            $Revision: 2 $                            --
--                                                                         --
--          Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                         --
-- GNARL is free software; you can redistribute it and/or modify it  under --
-- terms  of  the  GNU  Library General Public License as published by the --
-- Free Software Foundation; either version 2, or  (at  your  option)  any --
-- later  version.   GNARL is distributed in the hope that it will be use- --
-- ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
-- MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
-- eral Library Public License for more details.  You should have received --
-- a  copy of the GNU Library General Public License along with GNARL; see --
-- file COPYING. If not, write to the Free Software Foundation,  675  Mass --
-- Ave, Cambridge, MA 02139, USA.                                          --
--                                                                         --
-----------------------------------------------------------------------------

package System.C_Constants is

pthread_t_size : constant Integer := 4;
pthread_attr_t_size : constant Integer := 28;
pthread_mutexattr_t_size : constant Integer := 12;
pthread_mutex_t_size : constant Integer := 32;
pthread_condattr_t_size : constant Integer := 4;
pthread_cond_t_size : constant Integer := 20;
pthread_key_t_size : constant Integer := 4;
pthread_jmp_buf_size : constant Integer := 16;
pthread_sigjmp_buf_size : constant Integer := 16;
Add_Prio : constant Integer := 2;

end System.C_Constants;
