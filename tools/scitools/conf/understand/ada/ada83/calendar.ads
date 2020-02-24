--******************************************************************************
--
--	package CALENDAR
--
--******************************************************************************

package CALENDAR is

   type TIME is private;

   subtype YEAR_NUMBER is INTEGER range 1901 .. 2099;
   subtype MONTH_NUMBER is INTEGER range 1 .. 12;
   subtype DAY_NUMBER is INTEGER range 1 .. 31;
   subtype DAY_DURATION is DURATION range 0.0 .. 86_400.0;

   function CLOCK return TIME;

   function YEAR   (DATE : TIME) return YEAR_NUMBER;
   function MONTH  (DATE : TIME) return MONTH_NUMBER;
   function DAY    (DATE : TIME) return DAY_NUMBER;
   function SECONDS(DATE : TIME) return DAY_DURATION;

   procedure SPLIT (DATE    : in TIME;
                    YEAR    : out YEAR_NUMBER;
                    MONTH   : out MONTH_NUMBER;
                    DAY     : out DAY_NUMBER;
                    SECONDS : out DAY_DURATION);

   function TIME_OF(YEAR    : YEAR_NUMBER;
                    MONTH   : MONTH_NUMBER;
                    DAY     : DAY_NUMBER;
                    SECONDS : DAY_DURATION := 0.0) return TIME;

   function "+"  (LEFT  : TIME;
                  RIGHT : DURATION) return TIME;
   function "+"  (LEFT  : DURATION;
                  RIGHT : TIME)     return TIME;
   function "-"  (LEFT  : TIME;
                  RIGHT : DURATION) return TIME;
   function "-"  (LEFT  : TIME;
                  RIGHT : TIME)     return DURATION;

   function "<"  (LEFT, RIGHT : TIME) return BOOLEAN;
   function "<=" (LEFT, RIGHT : TIME) return BOOLEAN;
   function ">"  (LEFT, RIGHT : TIME) return BOOLEAN;
   function ">=" (LEFT, RIGHT : TIME) return BOOLEAN;

   TIME_ERROR : exception;
   -- can be raised by TIME_OF, "+", AND "-"

private
   -- implementation-dependent
   type TIME is new integer;
end CALENDAR;
