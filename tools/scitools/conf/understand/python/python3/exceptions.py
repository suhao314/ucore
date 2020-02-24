import __builtin__

class BaseException(__builtin__.object):
     def __delattr__(): pass
     def __getattribute__(): pass
     def __getitem__(): pass
     def __getslice__(): pass
     def __init__(): pass
     def __reduce__(): pass
     def __repr__(): pass
     def __setattr__(): pass
     def __setstate__(): pass
     def __str__(): pass
     def __unicode__(): pass
     
     __dict__ = 0
     args = 0
     message = 0
     __new__ = 0
    
class Exception(BaseException):
     def __init__(): pass
     __new__ = 0
    
class StandardError(Exception):
     def __init__(): pass
     __new__ = 0

class ArithmeticError(StandardError):
     def __init__(): pass
     __new__ = 0
     
class AssertionError(StandardError):
     def __init__(): pass
     __new__ = 0
    
class AttributeError(StandardError):
     def __init__(): pass
     __new__ = 0
    
class BufferError(StandardError):
     def __init__(): pass
     __new__ = 0
    
class Warning(Exception):
     def __init__(): pass
     __new__ = 0
     
class BytesWarning(Warning):
     def __init__(): pass
     __new__ = 0
    
class DeprecationWarning(Warning):
     def __init__(): pass
     __new__ = 0
    
class EOFError(StandardError):
     def __init__(): pass
     __new__ = 0
    
class EnvironmentError(StandardError):
     def __init__(): pass
     def __reduce__(): pass
     def __str__(): pass
     errno = 0
     filename = ''
     strerror = 0
     __new__ = 0
    
class FloatingPointError(ArithmeticError):
     def __init__(): pass
     __new__ = 0
     
class FutureWarning(Warning):
     def __init__(): pass
     __new__ = 0
    
class GeneratorExit(BaseException):
     def __init__(): pass
     __new__ = 0
     
    
class IOError(EnvironmentError):
     def __init__(): pass
     __new__ = 0
     
class ImportError(StandardError):
     def __init__(): pass
     __new__ = 0
    
class ImportWarning(Warning):
     def __init__(): pass
     __new__ = 0
    
class IndentationError(SyntaxError):
     def __init__(): pass
     __new__ = 0
    
class IndexError(LookupError):
     def __init__(): pass
     __new__ = 0
    
class KeyError(LookupError):
     def __init__(): pass
     def __str__(): pass
     __new__ = 0
    
class KeyboardInterrupt(BaseException):
     def __init__(): pass
     __new__ = 0
     
    
class LookupError(StandardError):
     def __init__(): pass
     __new__ = 0
    
class MemoryError(StandardError):
     def __init__(): pass
     __new__ = 0
    
class NameError(StandardError):
     def __init__(): pass
     __new__ = 0

class NotImplementedError(RuntimeError):
     def __init__(): pass
     __new__ = 0
     
class OSError(EnvironmentError):
     def __init__(): pass
     __new__ = 0
    
class OverflowError(ArithmeticError):
     def __init__(): pass
     __new__ = 0

class PendingDeprecationWarning(Warning):
     def __init__(): pass
     __new__ = 0
    
class ReferenceError(StandardError):
     def __init__(): pass
     __new__ = 0
    
class RuntimeError(StandardError):
     def __init__(): pass
     __new__ = 0
     
class RuntimeWarning(Warning):
     def __init__(): pass
     __new__ = 0
        
class StopIteration(Exception):
     def __init__(): pass
     __new__ = 0
     
class SyntaxError(StandardError):
     def __init__(): pass
     def __str__(): pass
     filename = ''
     lineno = 0
     msg = ''
     offset = 0
     print_file_and_line = 0
     text = ''
     __new__ = 0
    
class SyntaxWarning(Warning):
     def __init__(): pass
     __new__ = 0
     
class SystemError(StandardError):
     def __init__(): pass
     __new__ = 0
     
class SystemExit(BaseException):
     def __init__(): pass
     code = 0
     __new__ = 0
    
class TabError(IndentationError):
     def __init__(): pass
     __new__ = 0
     
class TypeError(StandardError):
     def __init__(): pass
     __new__ = 0
     
    
class UnboundLocalError(NameError):
     def __init__(): pass
     __new__ = 0
     
class UnicodeDecodeError(UnicodeError):
     def __init__(): pass
     def __str__(): pass
     encoding = 0
     end = 0
     object = 0
     reason = 0
     start = 0
     __new__ = 0

class UnicodeEncodeError(UnicodeError):
     def __init__(): pass
     def __str__(): pass
     encoding = 0
     end = 0
     object = 0
     reason = 0
     start = 0
     __new__ = 0
      
class UnicodeError(ValueError):
     def __init__(): pass
     __new__ = 0
     
class UnicodeTranslateError(UnicodeError):
     def __init__(): pass
     def __str__(): pass
     encoding = 0
     end = 0
     object = 0
     reason = 0
     start = 0
     __new__ = 0
    
class UnicodeWarning(Warning):
     def __init__(): pass
     __new__ = 0
    
class UserWarning(Warning):
     def __init__(): pass
     __new__ = 0
    
class ValueError(StandardError):
     def __init__(): pass
     __new__ = 0
    
    
class WindowsError(OSError):
     def __init__(): pass
     def __str__(): pass
     errno = 0
     filename = ''
     strerror = 0
     winerror = 0
     __new__ = 0

class ZeroDivisionError(ArithmeticError):
     def __init__(): pass
     __new__ = 0

