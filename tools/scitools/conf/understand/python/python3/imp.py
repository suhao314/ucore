import __builtin__

class NullImporter(__builtin__.object):
     def __init__(): pass
     def find_module(): pass
     __new__ = 0

def acquire_lock(): pass
def find_module(): pass
def get_frozen_object(): pass
def get_magic(): pass
def get_suffixes(): pass
def init_builtin(): pass
def init_frozen(): pass
def is_builtin(): pass
def is_frozen(): pass
def load_compiled(): pass
def load_dynamic(): pass
def load_module(): pass
def load_package(): pass
def load_source(): pass
def lock_held(): pass
def new_module(): pass
def release_lock(): pass
def reload(): pass

C_BUILTIN = 6
C_EXTENSION = 3
IMP_HOOK = 9
PKG_DIRECTORY = 5
PY_CODERESOURCE = 8
PY_COMPILED = 2
PY_FROZEN = 7
PY_RESOURCE = 4
PY_SOURCE = 1
SEARCH_ERROR = 0
