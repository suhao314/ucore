------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                     S Y S T E M . T A S K _ C L O C K                    --
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

--  This package interfaces with the Ada RTS and defines the low-level
--  timer operations.

package System.Task_Clock is

   type Stimespec is private;

   Stimespec_First : constant Stimespec;

   Stimespec_Last  : constant Stimespec;

   Stimespec_Zero  : constant Stimespec;

   Stimespec_Unit  : constant Stimespec;

   Stimespec_Sec_Unit : constant Stimespec;

   function Stimespec_Seconds (TV : Stimespec) return Integer;

   function Stimespec_NSeconds (TV : Stimespec) return Integer;

   function Time_Of (S, NS : Integer) return Stimespec;

   function Stimespec_To_Duration (TV : Stimespec) return Duration;

   function Duration_To_Stimespec (Time : Duration) return Stimespec;

   function "-"  (TV : Stimespec) return Stimespec;

   function "+"  (LTV, RTV : Stimespec) return Stimespec;

   function "-"  (LTV, RTV : Stimespec) return Stimespec;

   function "*" (TV : Stimespec; N : Integer) return Stimespec;

   function "/" (TV : Stimespec; N : integer) return Stimespec;

   function "/" (LTV, RTV : Stimespec) return Integer;

   function "<"  (LTV, RTV : Stimespec) return Boolean;

   function "<=" (LTV, RTV : Stimespec) return Boolean;

   function ">"  (LTV, RTV : Stimespec) return Boolean;

   function ">=" (LTV, RTV : Stimespec) return Boolean;

private

   --  Stimespec is represented in 64-bit Integer. It represents seconds and
   --  nanoseconds together and is symmetric around Zero.
   --  For example, 1 second and 1 nanosecond is represented as "100000001"

   subtype Time_Base is Long_Long_Integer range -Long_Long_Integer'Last ..
     Long_Long_Integer'Last;

   type Stimespec is record
      Val : Time_Base;
   end record;

   Stimespec_First : constant Stimespec :=
     Stimespec' (Val => -Long_Long_Integer'Last);

   Stimespec_Last : constant Stimespec :=
     Stimespec' (Val => Long_Long_Integer'Last);

   Stimespec_Zero : constant Stimespec := Stimespec' (Val => 0);

   Stimespec_Unit : constant Stimespec := Stimespec' (Val => 1);

   Stimespec_Sec_Unit : constant Stimespec := Stimespec' (Val => 10#1#E9);

end System.Task_Clock;
