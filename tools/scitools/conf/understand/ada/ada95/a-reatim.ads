------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                          A D A . R E A L _ T I M E                       --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 6763 $                             --
--                                                                          --
-- This specification is adapted from the Ada Reference Manual for use with --
-- GNAT.  In accordance with the copyright of that document, you can freely --
-- copy and modify this specification,  provided that if you redistribute a --
-- modified version,  any changes that you have made are clearly indicated. --
--                                                                          --
------------------------------------------------------------------------------


with System.Task_Clock;
--  Used for, Stimespec and associated constants

with System.Task_Clock.Machine_Specifics;
--  Used for, Stimespec_Ticks

with System.Tasking;
--  Used for, Protection


package Ada.Real_Time is
   use System;

   type Time is private;
   Time_First : constant Time;
   Time_Last  : constant Time;
   Time_Unit  : constant := 10#1.0#E-9;

   type Time_Span is private;
   Time_Span_First : constant Time_Span;
   Time_Span_Last  :  constant Time_Span;
   Time_Span_Zero  :  constant Time_Span;
   Time_Span_Unit  :  constant Time_Span;

   Tick : constant Time_Span;
   function Clock return Time;

   function "+"  (Left : Time;      Right : Time_Span) return Time;
   function "+"  (Left : Time_Span; Right : Time)      return Time;
   function "-"  (Left : Time;      Right : Time_Span) return Time;
   function "-"  (Left : Time;      Right : Time)      return Time_Span;

   function "<"  (Left, Right : Time) return Boolean;
   function "<=" (Left, Right : Time) return Boolean;
   function ">"  (Left, Right : Time) return Boolean;
   function ">=" (Left, Right : Time) return Boolean;

   function "+"  (Left, Right : Time_Span)             return Time_Span;
   function "-"  (Left, Right : Time_Span)             return Time_Span;
   function "-"  (Right : Time_Span)                   return Time_Span;
   function "*"  (Left : Time_Span; Right : Integer)   return Time_Span;
   function "*"  (Left : Integer;   Right : Time_Span) return Time_Span;
   function "/"  (Left, Right : Time_Span)             return Integer;
   function "/"  (Left : Time_Span; Right : Integer)   return Time_Span;

   function "abs" (Right : Time_Span) return Time_Span;

   function "<"  (Left, Right : Time_Span) return Boolean;
   function "<=" (Left, Right : Time_Span) return Boolean;
   function ">"  (Left, Right : Time_Span) return Boolean;
   function ">=" (Left, Right : Time_Span) return Boolean;

   function To_Duration  (FD : Time_Span) return Duration;
   function To_Time_Span (D : Duration)   return Time_Span;

   function Nanoseconds  (NS : integer) return Time_Span;
   function Microseconds (US : integer) return Time_Span;
   function Milliseconds (MS : integer) return Time_Span;

   type Seconds_Count is new integer range -integer'Last .. integer'Last;

   procedure Split
     (T : Time;
      S : out Seconds_Count;
      D : out Time_Span);

   function Time_Of
     (S    : Seconds_Count;
      D    : Time_Span)
      return Time;

private
   type Time is new Task_Clock.Stimespec;

   Time_First : constant Time := Time (Task_Clock.Stimespec_First);

   Time_Last :  constant Time := Time (Task_Clock.Stimespec_Last);

   type Time_Span is new Task_Clock.Stimespec;

   Time_Span_First : constant Time_Span :=
     Time_Span (Task_Clock.Stimespec_First);

   Time_Span_Last :  constant Time_Span :=
     Time_Span (Task_Clock.Stimespec_Last);

   Time_Span_Zero :  constant Time_Span :=
     Time_Span (Task_Clock.Stimespec_Zero);

   Time_Span_Unit :  constant Time_Span :=
     Time_Span (Task_Clock.Stimespec_Unit);

   Tick :           constant Time_Span :=
     Time_Span (Task_Clock.Machine_Specifics.Stimespec_Ticks);

end Ada.Real_Time;
