class object: pass

class BaseException(object):
   def __delattr__(): pass
   def __getattribute__(): pass
   def __init__(): pass
   def __reduce__(): pass
   def __repr__(): pass
   def __setattr__(): pass
   def __setstate__(): pass
   def __str__(): pass
   def with_traceback(): pass
   __cause__ = None
   __context__ = None
   __dict__ = None
   __suppress_context__ = None
   __traceback__ = None
   __new__ = None
    
class Exception(BaseException):
   def __init__(): pass
   __new__ = None
    
class ArithmeticError(Exception):
   def __init__(): pass
   __new__ = None
    
class AssertionError(Exception):
   def __init__(): pass
   __new__ = None
    
class AttributeError(Exception):
   def __init__(): pass
   __new__ = None
    
class OSError(Exception):
   def __init__(): pass
   def __reduce__(): pass
   def __str__(): pass
   characters_written = None
   errno = None
   filename = None
   strerror = None
   winerror = None
   __new__ = None
    
EnvironmentError = OSError    
IOError = OSError
WindowsError = OSError

class BlockingIOError(OSError):
   def __init__(): pass

class ConnectionError(OSError):
   def __init__(): pass
       
class BrokenPipeError(ConnectionError):
   def __init__(): pass
    
class BufferError(Exception):
   def __init__(): pass
   __new__ = None
    
class Warning(Exception):
     def __init__(): pass
    __new__ = None
    
class BytesWarning(Warning):
   def __init__(): pass
   __new__ = None
    
class ChildProcessError(OSError):
   def __init__(): pass
    
class ConnectionAbortedError(ConnectionError):
   def __init__(): pass
    
class ConnectionRefusedError(ConnectionError):
   def __init__(): pass
    
class ConnectionResetError(ConnectionError):
   def __init__(): pass
   
class DeprecationWarning(Warning):
   def __init__(): pass
   __new__ = None
    
class EOFError(Exception):
   def __init__(): pass
   __new__ = None
            
class FileExistsError(OSError):
   def __init__(): pass
    
class FileNotFoundError(OSError):
   def __init__(): pass
    
class FloatingPointError(ArithmeticError):
   def __init__(): pass
   __new__ = None
    
class FutureWarning(Warning):
   def __init__(): pass
   __new__ = None
    
class GeneratorExit(BaseException):
   def __init__(): pass
   __new__ = None
        
class ImportError(Exception):
   def __init__(): pass
   def __str__(): pass
   msg = None
   name = None
   path = None
    
class ImportWarning(Warning):
   def __init__(): pass
   __new__ = None
   
class SyntaxError(Exception):
   def __init__(): pass
   def __str__(): pass
   filename = None
   lineno = 0
   msg = None
   offset = 0
   print_file_and_line = None
   text = None
    
class IndentationError(SyntaxError):
   def __init__(): pass

class LookupError(Exception):
   def __init__(): pass
   __new__ = None
    
class IndexError(LookupError):
   def __init__(): pass
   __new__ = None
    
class InterruptedError(OSError):
   def __init__(): pass
    
class IsADirectoryError(OSError):
   def __init__(): pass
    
class KeyError(LookupError):
   def __init__(): pass
   def __str__(): pass
   
class KeyboardInterrupt(BaseException):
   def __init__(): pass
   __new__ = None
    
class MemoryError(Exception):
   def __init__(): pass
   __new__ = None
    
class NameError(Exception):
   def __init__(): pass
   __new__ = None
    
class NotADirectoryError(OSError):
   def __init__(): pass
    
class RuntimeError(Exception):
     def __init__(): pass
    __new__ = None
    
class NotImplementedError(RuntimeError):
    def __init__(): pass
    __new__ = None
    
class OverflowError(ArithmeticError):
    def __init__(): pass
    __new__ = None
    
class PendingDeprecationWarning(Warning):
    def __init__(): pass
    __new__ = None
    
class PermissionError(OSError):
    def __init__(): pass
    
class ProcessLookupError(OSError):
    def __init__(): pass
    
class ReferenceError(Exception):
    def __init__(): pass
    __new__ = None
    
class ResourceWarning(Warning):
    def __init__(): pass
    __new__ = None
    
class RuntimeWarning(Warning):
     def __init__(): pass
    __new__ = None
    
class StopIteration(Exception):
     def __init__(): pass
     value = 0
    
class SyntaxWarning(Warning):
     def __init__(): pass
    __new__ = None
    
class SystemError(Exception):
     def __init__(): pass
    __new__ = None
    
class SystemExit(BaseException):
     def __init__(): pass
     code = 0
    
class TabError(IndentationError):
     def __init__(): pass
    
class TimeoutError(OSError):
     def __init__(): pass
    
class TypeError(Exception):
     def __init__(): pass
    __new__ = None
    
class UnboundLocalError(NameError):
     def __init__(): pass
    __new__ = None
    
class ValueError(Exception):
     def __init__(): pass
    __new__ = None
    
class UnicodeError(ValueError):
   def __init__(): pass
   def __str__(): pass
    
class UnicodeDecodeError(UnicodeError):
   def __init__(): pass
   def __str__(): pass
   encoding = 0
   end = 0
   object = None
   reason = None
   start = 0
   __new__ = None
    
class UnicodeEncodeError(UnicodeError):
   def __init__(): pass
   def __str__(): pass
   encoding = 0
   end = 0
   object = None
   reason = None
   start = 0
   __new__ = None
    
class UnicodeTranslateError(UnicodeError):
   def __init__(): pass
   def __str__(): pass
   encoding = 0
   end = 0
   object = None
   reason = None
   start = 0
   __new__ = None
    
class UnicodeWarning(Warning):
     def __init__(): pass
    __new__ = None
    
class UserWarning(Warning):
     def __init__(): pass
    __new__ = None
    
class ZeroDivisionError(ArithmeticError):
     def __init__(): pass
    __new__ = None

class int(object):
     def __abs__(): pass
     def __add__(): pass
     def __and__(): pass
     def __bool__(): pass
     def __ceil__(): pass
     def __divmod__(): pass
     def __eq__(): pass
     def __float__(): pass
     def __floor__(): pass
     def __floordiv__(): pass
     def __format__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getnewargs__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __index__(): pass
     def __int__(): pass
     def __invert__(): pass
     def __le__(): pass
     def __lshift__(): pass
     def __lt__(): pass
     def __mod__(): pass
     def __mul__(): pass
     def __ne__(): pass
     def __neg__(): pass
     def __or__(): pass
     def __pos__(): pass
     def __pow__(): pass
     def __radd__(): pass
     def __rand__(): pass
     def __rdivmod__(): pass
     def __repr__(): pass
     def __rfloordiv__(): pass
     def __rlshift__(): pass
     def __rmod__(): pass
     def __rmul__(): pass
     def __ror__(): pass
     def __round__(): pass
     def __rpow__(): pass
     def __rrshift__(): pass
     def __rshift__(): pass
     def __rsub__(): pass
     def __rtruediv__(): pass
     def __rxor__(): pass
     def __sizeof__(): pass
     def __str__(): pass
     def __sub__(): pass
     def __truediv__(): pass
     def __trunc__(): pass
     def __xor__(): pass
     def bit_length(): pass
     def conjugate(): pass
     def from_bytes(): pass
     def to_bytes(): pass
     denominator = 0
     imag = 0
     numerator = 0
     real = 0
     __new__ = None
        
class bool(int):
     def __and__(): pass
     def __or__(): pass
     def __rand__(): pass
     def __repr__(): pass
     def __ror__(): pass
     def __rxor__(): pass
     def __str__(): pass
     def __xor__(): pass
    __new__ = None
    
class bytearray(object):
     def __add__(): pass
     def __alloc__(): pass
     def __contains__(): pass
     def __delitem__(): pass
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getitem__(): pass
     def __gt__(): pass
     def __iadd__(): pass
     def __imul__(): pass
     def __init__(): pass
     def __iter__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __mul__(): pass
     def __ne__(): pass
     def __reduce__(): pass
     def __reduce_ex__(): pass
     def __repr__(): pass
     def __rmul__(): pass
     def __setitem__(): pass
     def __sizeof__(): pass
     def __str__(): pass
     def append(): pass
     def capitalize(): pass
     def center(): pass
     def clear(): pass
     def copy(): pass
     def count(): pass
     def decode(): pass
     def endswith(): pass
     def expandtabs(): pass
     def extend(): pass
     def find(): pass
     def fromhex(): pass
     def index(): pass
     def insert(): pass
     def isalnum(): pass
     def isalpha(): pass
     def isdigit(): pass
     def islower(): pass
     def sspace(): pass
     def istitle(): pass
     def isupper(): pass
     def join(): pass
     def ljust(): pass
     def lower(): pass
     def lstrip(): pass
     def partition(): pass
     def pop(): pass
     def remove(): pass
     def replace(): pass
     def reverse(): pass
     def rfind(): pass
     def rindex(): pass
     def rjust(): pass
     def rpartition(): pass
     def rsplit(): pass
     def rstrip(): pass
     def split(): pass
     def splitlines(): pass
     def startswith(): pass
     def strip(): pass
     def swapcase(): pass
     def title(): pass
     def translate(): pass
     def upper(): pass
     def zfill(): pass
     @staticmethod
     def maketrans(): pass
     __hash__ = None
     __new__ = None
    
class bytes(object):
     def __add__(): pass
     def __contains__(): pass
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getitem__(): pass
     def __getnewargs__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __iter__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __mul__(): pass
     def __ne__(): pass
     def __repr__(): pass
     def __rmul__(): pass
     def __sizeof__(): pass
     def __str__(): pass
     def capitalize(): pass
     def center(): pass
     def count(): pass
     def decode(): pass
     def endswith(): pass
     def expandtabs(): pass
     def find(): pass
     def fromhex(): pass
     def index(): pass
     def isalnum(): pass
     def isalpha(): pass
     def isdigit(): pass
     def islower(): pass
     def isspace(): pass
     def istitle(): pass
     def isupper(): pass
     def join(): pass
     def ljust(): pass
     def lower(): pass
     def lstrip(): pass
     def partition(): pass
     def replace(): pass
     def rfind(): pass
     def rindex(): pass
     def rjust(): pass
     def rpartition(): pass
     def rsplit(): pass
     def rstrip(): pass
     def split(): pass
     def splitlines(): pass
     def startswith(): pass
     def strip(): pass
     def swapcase(): pass
     def title(): pass
     def translate(): pass
     def upper(): pass
     def zfill(): pass
     @staticmethod
     def maketrans(): pass
     __new__ = None
    
class classmethod(object):
     def __get__(): pass
     def __init__(): pass
     __dict__ = None
     __func__ = None
     __isabstractmethod__ = False
     __new__ = None
    
class complex(object):
     def __abs__(): pass
     def __add__(): pass
     def __bool__(): pass
     def __divmod__(): pass
     def __eq__(): pass
     def __float__(): pass
     def __floordiv__(): pass
     def __format__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getnewargs__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __int__(): pass
     def __le__(): pass
     def __lt__(): pass
     def __mod__(): pass
     def __mul__(): pass
     def __ne__(): pass
     def __neg__(): pass
     def __pos__(): pass
     def __pow__(): pass
     def __radd__(): pass
     def __rdivmod__(): pass
     def __repr__(): pass
     def __rfloordiv__(): pass
     def __rmod__(): pass
     def __rmul__(): pass
     def __rpow__(): pass
     def __rsub__(): pass
     def __rtruediv__(): pass
     def __str__(): pass
     def __sub__(): pass
     def __truediv__(): pass
     def conjugate(): pass
     imag = 0
     real = 0
     __new__ = None
    
class dict(object):
     def __contains__(): pass
     def __delitem__(): pass
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getitem__(): pass
     def __gt__(): pass
     def __init__(): pass
     def __iter__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __ne__(): pass
     def __repr__(): pass
     def __setitem__(): pass
     def __sizeof__(): pass
     def clear(): pass
     def copy(): pass
     def fromkeys(): pass
     def get(): pass
     def items(): pass
     def keys(): pass
     def pop(): pass
     def popitem(): pass
     def setdefault(): pass
     def update(): pass
     def values(): pass
     __hash__ = None
     __new__ = None
    
class enumerate(object):
     def __getattribute__(): pass
     def __iter__(): pass
     def __next__(): pass
     def __reduce__(): pass
     __new__ = 0
    
class filter(object):
     def __getattribute__(): pass
     def __iter__(): pass
     def __next__(): pass
     def __reduce__(): pass
     __new__ = 0
    
class float(object):
     def __abs__(): pass
     def __add__(): pass
     def __bool__(): pass
     def __divmod__(): pass
     def __eq__(): pass
     def __float__(): pass
     def __floordiv__(): pass
     def __format__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getformat__(): pass
     def __getnewargs__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __int__(): pass
     def __le__(): pass
     def __lt__(): pass
     def __mod__(): pass
     def __mul__(): pass
     def __ne__(): pass
     def __neg__(): pass
     def __pos__(): pass
     def __pow__(): pass
     def __radd__(): pass
     def __rdivmod__(): pass
     def __repr__(): pass
     def __rfloordiv__(): pass
     def __rmod__(): pass
     def __rmul__(): pass
     def __round__(): pass
     def __rpow__(): pass
     def __rsub__(): pass
     def __rtruediv__(): pass
     def __setformat__(): pass
     def __str__(): pass
     def __sub__(): pass
     def __truediv__(): pass
     def __trunc__(): pass
     def as_integer_ratio(): pass
     def conjugate(): pass
     def fromhex(): pass
     def hex(): pass
     def is_integer(): pass
     imag = 0
     real = 0
     __new__ = None
    
class frozenset(object):
     def __and__(): pass
     def __contains__(): pass
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __iter__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __ne__(): pass
     def __or__(): pass
     def __rand__(): pass
     def __reduce__(): pass
     def __repr__(): pass
     def __ror__(): pass
     def __rsub__(): pass
     def __rxor__(): pass
     def __sizeof__(): pass
     def __sub__(): pass
     def __xor__(): pass
     def copy(): pass
     def difference(): pass
     def intersection(): pass
     def isdisjoint(): pass
     def issubset(): pass
     def issuperset(): pass
     def symmetric_difference(): pass
     def union(): pass
     __new__ = 0
    
class list(object):
     def __add__(): pass
     def __contains__(): pass
     def __delitem__(): pass
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getitem__(): pass
     def __gt__(): pass
     def __iadd__(): pass
     def __imul__(): pass
     def __init__(): pass
     def __iter__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __mul__(): pass
     def __ne__(): pass
     def __repr__(): pass
     def __reversed__(): pass
     def __rmul__(): pass
     def __setitem__(): pass
     def __sizeof__(): pass
     def append(): pass
     def clear(): pass
     def copy(): pass
     def count(): pass
     def extend(): pass
     def index(): pass
     def insert(): pass
     def pop(): pass
     def remove(): pass
     def reverse(): pass
     def sort(): pass
     __hash__ = None
     __new__ = None
    
class map(object):
     def __getattribute__(): pass
     def __iter__(): pass
     def __next__(): pass
     def __reduce__(): pass
     __new__ = None
    
class memoryview(object):
     def __delitem__(): pass
     def __enter__(): pass
     def __eq__(): pass
     def __exit__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getitem__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __ne__(): pass
     def __repr__(): pass
     def __setitem__(): pass
     def cast(): pass
     def release(): pass
     def tobytes(): pass
     def tolist(): pass
     c_contiguous = False
     contiguous = False
     f_contiguous = False
     format = None
     itemsize = 0
     nbytes = 0
     ndim = 0
     obj = None
     readonly = False
     shape = 0
     strides = 0
     suboffsets = 0
     __new__ = None
        
class property(object):
     def __delete__(): pass
     def __get__(): pass
     def __getattribute__(): pass
     def __init__(): pass
     def __set__(): pass
     def deleter(): pass
     def getter(): pass
     def setter(): pass
     __isabstractmethod__ = False
     fdel = None
     fget = None
     fset = None
     __new__ = None
    
class range(object):
     def __contains__(): pass
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getitem__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __iter__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __ne__(): pass
     def __reduce__(): pass
     def __repr__(): pass
     def __reversed__(): pass
     def count(): pass
     def index(): pass
     start = 0
     step = 0
     stop = 0
     __new__ = None
    
class reversed(object):
     def __getattribute__(): pass
     def __iter__(): pass
     def __length_hint__(): pass
     def __next__(): pass
     def __reduce__(): pass
     def __setstate__(): pass
     __new__ = None
    
class set(object):
     def __and__(): pass
     def __contains__(): pass
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __gt__(): pass
     def __iand__(): pass
     def __init__(): pass
     def __ior__(): pass
     def __isub__(): pass
     def __iter__(): pass
     def __ixor__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __ne__(): pass
     def __or__(): pass
     def __rand__(): pass
     def __reduce__(): pass
     def __repr__(): pass
     def __ror__(): pass
     def __rsub__(): pass
     def __rxor__(): pass
     def __sizeof__(): pass
     def __sub__(): pass
     def __xor__(): pass
     def add(): pass
     def clear(): pass
     def copy(): pass
     def difference(): pass
     def difference_update(): pass
     def discard(): pass
     def intersection(): pass
     def intersection_update(): pass
     def isdisjoint(): pass
     def issubset(): pass
     def issuperset(): pass
     def pop(): pass
     def remove(): pass
     def symmetric_difference(): pass
     def symmetric_difference_update(): pass
     def union(): pass
     def update(): pass
     __hash__ = None
     __new__ = None
    
class slice(object):
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __gt__(): pass
     def __le__(): pass
     def __lt__(): pass
     def __ne__(): pass
     def __reduce__(): pass
     def __repr__(): pass
     def indices(): pass
     start = 0
     step = 0
     stop = 0
     __hash__ = None
     __new__ = None
    
class staticmethod(object):
     def __get__(): pass
     def __init__(): pass
     __dict__ = None
     __func__ = None
     __isabstractmethod__ = None
     __new__ = None
    
class str(object):
     def __add__(): pass
     def __contains__(): pass
     def __eq__(): pass
     def __format__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getitem__(): pass
     def __getnewargs__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __iter__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __mod__(): pass
     def __mul__(): pass
     def __ne__(): pass
     def __repr__(): pass
     def __rmod__(): pass
     def __rmul__(): pass
     def __sizeof__(): pass
     def __str__(): pass
     def capitalize(): pass
     def casefold(): pass
     def center(): pass
     def count(): pass
     def encode(): pass
     def endswith(): pass
     def expandtabs(): pass
     def find(): pass
     def format(): pass
     def format_map(): pass
     def index(): pass
     def isalnum(): pass
     def isalpha(): pass
     def isdecimal(): pass
     def isdigit(): pass
     def isidentifier(): pass
     def islower(): pass
     def isnumeric(): pass
     def isprintable(): pass
     def isspace(): pass
     def istitle(): pass
     def isupper(): pass
     def join(): pass
     def ljust(): pass
     def lower(): pass
     def lstrip(): pass
     def partition(): pass
     def replace(): pass
     def rfind(): pass
     def rindex(): pass
     def rjust(): pass
     def rpartition(): pass
     def rsplit(): pass
     def rstrip(): pass
     def split(): pass
     def splitlines(): pass
     def startswith(): pass
     def strip(): pass
     def swapcase(): pass
     def title(): pass
     def translate(): pass
     def upper(): pass
     def zfill(): pass
     @staticmethod
     def maketrans(): pass
     __new__ = None
    
class super(object):
     def __get__(): pass
     def __getattribute__(): pass
     def __init__(): pass
     def __repr__(): pass
     __self__ = None
     __self_class__ = None
     __thisclass__ = None
     __new__ = None
    
class tuple(object):
     def __add__(): pass
     def __contains__(): pass
     def __eq__(): pass
     def __ge__(): pass
     def __getattribute__(): pass
     def __getitem__(): pass
     def __getnewargs__(): pass
     def __gt__(): pass
     def __hash__(): pass
     def __iter__(): pass
     def __le__(): pass
     def __len__(): pass
     def __lt__(): pass
     def __mul__(): pass
     def __ne__(): pass
     def __repr__(): pass
     def __rmul__(): pass
     def __sizeof__(): pass
     def count(): pass
     def index(): pass
     __new__ = None
    
class type(object):
     def __call__(): pass
     def __delattr__(): pass
     def __dir__(): pass
     def __getattribute__(): pass
     def __init__(): pass
     def __instancecheck__(): pass
     def __prepare__(): pass
     def __repr__(): pass
     def __setattr__(): pass
     def __sizeof__(): pass
     def __subclasscheck__(): pass
     def __subclasses__(): pass
     def mro(): pass
     __abstractmethods__ = None
     __base__ = None
     __bases__ = None
     __basicsize__ = None
     __dict__ = None
     __dictoffset__ = None
     __flags__ = None
     __itemsize__ = None
     __mro__ = None
     __weakrefoffset__ = None
     __new__ = None
    
class zip(object):
     def __getattribute__(): pass
     def __iter__(): pass
     def __next__(): pass
     def __reduce__(): pass
     __new__ = None

def __build_class__(): pass
def __import__(): pass
def abs(): pass
def all(): pass
def any(): pass
def ascii(): pass
def bin(): pass
def callable(): pass
def chr(): pass
def compile(): pass
def delattr(): pass
def dir(): pass
def divmod(): pass
def eval(): pass
def exec(): pass
def format(): pass
def getattr(): pass
def globals(): pass
def hasattr(): pass
def hash(): pass
def hex(): pass
def id(): pass
def input(): pass
def isinstance(): pass
def issubclass(): pass
def iter(): pass
def len(): pass
def locals(): pass
def max(): pass
def min(): pass
def next(): pass
def oct(): pass
def open(): pass
def ord(): pass
def pow(): pass
def print(): pass
def repr(): pass
def round(): pass
def setattr(): pass
def sorted(): pass
def sum(): pass
def vars(): pass

Ellipsis = Ellipsis
False = False
None = None
NotImplemented = NotImplemented
True = True
__debug__ = True


