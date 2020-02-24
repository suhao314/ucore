unit DateUtils;
interface
   uses SysUtils, Types;

const
   DayMonday = 1;
   DayTuesday = 2;
   DayWednesday = 3;
   DayThursday = 4;
   DayFriday = 5;
   DaySaturday = 6;
   DaySunday = 7;

const
   OneHour: TDateTime = 1 / HoursPerDay;
   OneMinute: TDateTime = 1 / MinsPerDay;
   OneSecond: TDateTime = 1 / SecsPerDay;
   OneMillisecond: TDateTime = 1 / MSecsPerDay;

const 
   RecodeLeaveFieldAsIs = High(Word);

function CompareDate(const A, B: TDateTime): TValueRelationship;
function CompareDateTime(const A, B: TDateTime): TValueRelationship;
function CompareTime(const A, B: TDateTime): TValueRelationship;
function DateOf(const AValue: TDateTime): TDateTime;
function DateTimeToJulianDate(const AValue: TDateTime): Double;
function DateTimeToModifiedJulianDate(const AValue: TDateTime): Double;
function DateTimeToModifiedJulianDate(const AValue: TDateTime): Double;
function DateTimeToUnix(const AValue: TDateTime): Int64;
function DayOf(const AValue: TDateTime): Word;
function DayOfTheMonth(const AValue: TDateTime): Word;


function DayOfTheWeek(const AValue: TDateTime): Word;
function DayOfTheYear(const AValue: TDateTime): Word;
function DaysBetween(const ANow, AThen: TDateTime): Integer;
function DaysInAMonth(const AYear, AMonth: Word): Word;
function DaysInAYear(const AYear: Word): Word;
function DaysInMonth(const AValue: TDateTime): Word;
function DaysInYear(const AValue: TDateTime): Word;
function DaySpan(const ANow, AThen: TDateTime): Double;
procedure DecodeDateDay(const AValue: TDateTime; out AYear, ADayOfYear: Word);
procedure DecodeDateMonthWeek(const AValue: TDateTime; out AYear, AMonth, AWeekOfMonth, ADayOfWeek: Word);
procedure DecodeDateTime(const AValue: TDateTime; out AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word);
procedure DecodeDateWeek(const AValue: TDateTime; out AYear, AWeekOfYear, ADayOfWeek: Word);
procedure DecodeDayOfWeekInMonth(const AValue: TDateTime; out AYear, AMonth, ANthDayOfWeek, ADayOfWeek: Word);
function EncodeDateDay(const AYear, ADayOfYear: Word): TDateTime;
function EncodeDateMonthWeek(const AYear, AMonth, AWeekOfMonth: Word; const ADayOfWeek: Word = 1): TDateTime;
function EncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word):TDateTime;
function EncodeDateWeek(const AYear, AWeekOfYear: Word; const ADayOfWeek: Word = 1): TDateTime;
function EncodeDayOfWeekInMonth(const AYear, AMonth, ANthDayOfWeek, ADayOfWeek: Word): TDateTime;
function EndOfADay(const AYear, ADayOfYear: Word): TDateTime; overload;
function EndOfADay(const AYear, AMonth, ADay: Word): TDateTime; overload;
function EndOfAMonth(const AYear, AMonth: Word): TDateTime;
function EndOfAWeek(const AYear, AWeekOfYear: Word; const ADayOfWeek: Word = 7): TDateTime;
function EndOfAYear(const AYear): TDateTime;
function EndOfTheDay(const AValue: TDateTime): TDateTime;
function EndOfTheMonth(const AValue: TDateTime): TDateTime;
function EndOfTheWeek(const AValue: TDateTime): TDateTime;
function EndOfTheYear(const AValue: TDateTime): TDateTime;
function HourOf(const AValue: TDateTime): Word;
function HourOfTheDay(const AValue: TDateTime): Word;
function HourOfTheMonth(const AValue: TDateTime): Word;
function HourOfTheWeek(const AValue: TDateTime): Word;
function HourOfTheYear(const AValue: TDateTime): Word;
function HoursBetween(const ANow, AThen: TDateTime): Int64;
function HourSpan(const ANow, AThen: TDateTime): Double;
function IncDay(const AValue: TDateTime; const ANumberOfDays: Integer = 1): TDateTime;
function IncHour(const AValue: TDateTime; const ANumberOfHours: Int64 = 1): TDateTime;
function IncMilliSecond(const AValue: TDateTime; const ANumberOfMilliSeconds: Int64 = 1): TDateTime;
function IncMinute(const AValue: TDateTime; const ANumberOfMinutes: Int64 = 1): TDateTime;
function IncSecond(const AValue: TDateTime; const ANumberOfSeconds: Int64 = 1): TDateTime;
function IncWeek(const AValue: TDateTime; const ANumberOfWeeks: Integer = 1): TDateTime;
function IncYear(const AValue: TDateTime; const ANumberOfYears: Integer = 1): TDateTime;
function IsInLeapYear(const AValue: TDateTime): Boolean;
function IsPM(const AValue: TDateTime): Boolean;
function IsSameDay(const AValue, ABasis: TDateTime): Boolean;
function IsToday(const AValue: TDateTime): Boolean;
function IsValidDate(const AYear, AMonth, ADay: Word): Boolean;
function IsValidDateDay(const AYear, ADayOfYear: Word): Boolean;
function IsValidDateMonthWeek(const AYear, AMonth, AWeekOfMonth, ADayOfWeek: Word): Boolean;
function IsValidDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
function IsValidDateWeek(const AYear, AWeekOfYear, ADayOfWeek: Word): Boolean;
function IsValidTime(const AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
function JulianDateToDateTime(const AValue: Double): TDateTime;
function MilliSecondOf(const AValue: TDateTime): Word;
function MilliSecondOfTheDay(const AValue: TDateTime): LongWord;
function MilliSecondOfTheHour(const AValue: TDateTime): LongWord;
function MilliSecondOfTheMinute(const AValue: TDateTime): LongWord;
function MilliSecondOfTheMonth(const AValue: TDateTime): LongWord;
function MilliSecondOfTheSecond(const AValue: TDateTime): Word;
function MilliSecondOfTheWeek(const AValue: TDateTime): LongWord;
function MilliSecondOfTheYear(const AValue: TDateTime): Int64;
function MilliSecondsBetween(const ANow, AThen: TDateTime): Int64;
function MilliSecondSpan(const ANow, AThen: TDateTime): Double;
function MinuteOf(const AValue: TDateTime): Word;
function MinuteOfTheDay(const AValue: TDateTime): Word;
function MinuteOfTheHour(const AValue: TDateTime): Word;
function MinuteOfTheMonth(const AValue: TDateTime): Word;
function MinuteOfTheWeek(const AValue: TDateTime): Word;
function MinuteOfTheYear(const AValue: TDateTime): LongWord;
function MinutesBetween(const ANow, AThen: TDateTime): Int64;
function MinuteSpan(const ANow, AThen: TDateTime): Double;
function ModifiedJulianDateToDateTime(const AValue: Double): TDateTime;
function MonthOf(const AValue: TDateTime): Word;
function MonthOfTheYear(const AValue: TDateTime): Word;
function MonthsBetween(const ANow, AThen: TDateTime): Integer;
function MonthSpan(const ANow, AThen: TDateTime): Double;
function NthDayOfWeek(const AValue: TDateTime): Word;
function RecodeDate(const AValue: TDateTime; const AYear, AMonth, ADay: Word): TDateTime;
function RecodeDateTime(const AValue: TDateTime; const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word): TDateTime;
function RecodeDay(const AValue: TDateTime; const ADay: Word): TDateTime;
function RecodeHour(const AValue: TDateTime; const AHour: Word): TDateTime;
function RecodeMilliSecond(const AValue: TDateTime; const AMilliSecond: Word): TDateTime;
function RecodeMinute(const AValue: TDateTime; const AMinute: Word): TDateTime;
function RecodeMonth(const AValue: TDateTime; const AMonth: Word): TDateTime;
function RecodeSecond(const AValue: TDateTime; const ASecond: Word): TDateTime;
function RecodeTime(const AValue: TDateTime; const AHour, AMinute, ASecond, AMilliSecond: Word): TDateTime;
function RecodeYear(const AValue: TDateTime; const AYear: Word): TDateTime;
function SameDate(const A, B: TDateTime): Boolean;
function SameDateTime(const A, B: TDateTime): Boolean;
function SameTime(const A, B: TDateTime): Boolean;
function SecondOf(const AValue: TDateTime): Word;
function SecondOfTheDay(const AValue: TDateTime): LongWord;
function SecondOfTheHour(const AValue: TDateTime): Word;
function SecondOfTheMinute(const AValue: TDateTime): Word;
function SecondOfTheMonth(const AValue: TDateTime): LongWord;
function SecondOfTheWeek(const AValue: TDateTime): LongWord;
function SecondOfTheYear(const AValue: TDateTime): LongWord;
function SecondsBetween(const ANow, AThen: TDateTime): Int64;
function SecondSpan(const ANow, AThen: TDateTime): Double;
function StartOfADay(const AYear, ADayOfYear: Word): TDateTime; overload;
function StartOfADay(const AYear, AMonth, ADay: Word): TDateTime; overload;
function StartOfAMonth(const AYear, AMonth: Word): TDateTime;
function StartOfAWeek(const AYear, AWeekOfYear: Word; const ADayOfWeek: Word = 1): TDateTime;
function StartOfAYear(const AYear): TDateTime;
function StartOfTheDay(const AValue: TDateTime): TDateTime;
function StartOfTheMonth(const AValue: TDateTime): TDateTime;
function StartOfTheWeek(const AValue: TDateTime): TDateTime;
function StartOfTheYear(const AValue: TDateTime): TDateTime;
function TimeOf(const AValue: TDateTime): TDateTime;
function Today: TDateTime;
function Tomorrow: TDateTime;
function TryEncodeDateDay(const AYear, ADayOfYear: Word; out AValue: TDateTime): Boolean;
function TryEncodeDateMonthWeek(const AYear, AMonth, AWeekOfMonth, ADayOfWeek: Word; out AValue: TDateTime): Boolean;
function TryEncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word; out AValue: TDateTime): Boolean;
function TryEncodeDateWeek(const AYear, AWeekOfYear: Word; out AValue: TDateTime; const ADayOfWeek: Word = 1): Boolean;
function TryEncodeDayOfWeekInMonth(const AYear, AMonth, ANthDayOfWeek,
                                   ADayOfWeek: Word; out AValue: TDateTime): Boolean;
function TryJulianDateToDateTime(const AValue: Double; out ADateTime: TDateTime): Boolean;
function TryModifiedJulianDateToDateTime(const AValue: Double; out ADateTime: TDateTime): Boolean;
function TryRecodeDateTime(const AValue: TDateTime; const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word; out AResult: TDateTime): Boolean;
function UnixToDateTime(const AValue: Int64): TDateTime;
function WeekOf(const AValue: TDateTime): Word;
function WeekOfTheMonth(const AValue: TDateTime): Word; overload;
function WeekOfTheMonth(const AValue: TDateTime; var AYear, AMonth: Word): Word; overload;
function WeekOfTheYear(const AValue: TDateTime): Word; overload;
function WeekOfTheYear(const AValue: TDateTime; var AYear): Word; overload;
function WeeksBetween(const ANow, AThen: TDateTime): Integer;
function WeeksInAYear(const AYear: Word): Word;
function WeeksInYear(const AValue: TDateTime): Word;
function WeekSpan(const ANow, AThen: TDateTime): Double;
function WithinPastDays(const ANow, AThen: TDateTime; const ADays: Integer): Boolean;
function WithinPastHours(const ANow, AThen: TDateTime; const AHours: Int64): Boolean;
function WithinPastMilliSeconds(const ANow, AThen: TDateTime; const AMilliSeconds: Int64): Boolean;
function WithinPastMinutes(const ANow, AThen: TDateTime; const AMinutes: Int64): Boolean;
function WithinPastMonths(const ANow, AThen: TDateTime; const AMonths: Integer): Boolean;
function WithinPastSeconds(const ANow, AThen: TDateTime; const ASeconds: Int64): Boolean;
function WithinPastWeeks(const ANow, AThen: TDateTime; const AWeeks: Integer): Boolean;
function WithinPastYears(const ANow, AThen: TDateTime; const AYears: Integer): Boolean;
function YearOf(const AValue: TDateTime): Word;
function YearsBetween(const ANow, AThen: TDateTime): Integer;
function YearSpan(const ANow, AThen: TDateTime): Double;
function Yesterday: TDateTime;

implementation
end.












