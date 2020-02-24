import __builtin__
import exceptions

class lock(__builtin__.object):
     def __enter__(): pass
     def __exit__(): pass
     def acquire(): pass
     def acquire_lock(): pass
     def locked(): pass
     def locked_lock(): pass
     def release(): pass
     def release_lock(): pass
     
LockType = lock

class error(exceptions.Exception):
     __weakref__ = 0
     def __init__(): pass
     __new__ = 0

def allocate(): pass
def allocate_lock(): pass
def exit(): pass
def exit_thread(): pass
def get_ident(): pass
def interrupt_main(): pass
def stack_size(): pass
def start_new(): pass
def start_new_thread(): pass
