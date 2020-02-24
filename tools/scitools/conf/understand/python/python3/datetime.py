import __builtin__


class timedelta(__builtin__.object):
     def __abs__(): pass
     def __add__(): pass
     def __div__(): pass
     def __eq__(): pass
     def __floordiv__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __le__(): pass
     def __lt__(): pass
     def __mul__(): pass
     def __ne__(): pass
     def __neg__(): pass
     def __nonzero__(): pass
     def __pos__(): pass
     def __radd__(): pass
     def __rdiv__(): pass
     def __reduce__(): pass
     def __repr__(): pass
     def __rfloordiv__(): pass
     def __rmul__(): pass
     def __rsub__(): pass
     def __str__(): pass
     def __sub__(): pass
     def total_seconds(): pass
     days = 0
     microseconds = 0
     seconds = 0
     __new__ = 0
     max = timedelta(999999999, 86399, 999999)
     min = timedelta(-999999999)
     resolution = timedelta(0, 0, 1)


class date(__builtin__.object):
     def __add__(): pass
     def __eq__(): pass
     def __format__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __le__(): pass
     def __lt__(): pass
     def __ne__(): pass
     def __radd__(): pass
     def  __reduce__(): pass
     def  __repr__(): pass
     def  __rsub__(): pass
     def  __str__(): pass
     def  __sub__(): pass
     def  ctime(): pass
     def  isocalendar(): pass
     def  isoformat(): pass
     def  isoweekday(): pass
     def  replace(): pass
     def  strftime(): pass
     def  timetuple(): pass
     def  toordinal(): pass
     def  weekday(): pass
     day = 0
     month = 0
     year = 0
     __new__ = 0
     fromordinal = 0
     fromtimestamp = 0
     max = date(9999, 12, 31)
     min = date(1, 1, 1)
     resolution = timedelta(1)
     today = 0

class datetime(date):
     def __add__(): pass
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __le__(): pass
     def __lt__(): pass
     def __ne__(): pass
     def __radd__(): pass
     def __reduce__(): pass
     def __repr__(): pass
     def __rsub__(): pass
     def __str__(): pass
     def __sub__(): pass
     def astimezone(): pass
     def ctime(): pass
     def date(): pass
     def dst(): pass
     def isoformat(): pass
     def replace(): pass
     def time(): pass
     def timetuple(): pass
     def timetz(): pass
     def tzname(): pass
     def utcoffset(): pass
     def utctimetuple(): pass
     
     hour = 0
     microsecond = 0
     minute = 0
     second = 0
     tzinfo = 0
     
     __new__ = 0
     combine = 0
     fromtimestamp = 0
     max = datetime(9999, 12, 31, 23, 59, 59, 999999)
     min = datetime(1, 1, 1, 0, 0)
     now = 0
     resolution = timedelta(0, 0, 1)
     strptime = 0
     utcfromtimestamp = 0
     utcnow = 0

class time(__builtin__.object):
     def __eq__(): pass
     def __format__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __le__(): pass
     def __lt__(): pass
     def __ne__(): pass
     def __nonzero__(): pass
     def __reduce__(): pass
     def __repr__(): pass
     def __str__(): pass
     def dst(): pass
     def isoformat(): pass
     def replace(): pass
     def strftime(): pass
     def tzname(): pass
     def utcoffset(): pass
     
     hour = 0
     microsecond = 0
     minute = 0 
     second = 0
     tzinfo = 0
     __new__ = 0
     max = time(23, 59, 59, 999999)
     min = time(0, 0)
     resolution = timedelta(0, 0, 1)

class tzinfo(__builtin__.object):
     def __getattribute__(): pass
     def __reduce__(): pass
     def dst(): pass
     def fromutc(): pass
     def tzname(): pass
     def utcoffset(): pass
     
     __new__ = 0

MAXYEAR = 9999
MINYEAR = 1
datetime_CAPI = 0
