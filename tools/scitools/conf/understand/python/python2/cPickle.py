import exceptions

class PickleError(exceptions.Exception):
     def __str__(self): pass
     __weakref__ = 1
class PicklingError(PickleError): pass

class UnpickleableError(PicklingError):
     def __str__(self): pass
     
class UnpicklingError(PickleError): pass

class BadPickleGet(UnpicklingError): pass

def Pickler(): pass
def Unpickler(): pass
def dump(): pass
def dumps(): pass
def load(): pass
def loads(): pass

HIGHEST_PROTOCOL = 2
__version__ = '1.71'
compatible_formats = ['1.0', '1.1', '1.2', '1.3', '2.0']
format_version = '2.0'
