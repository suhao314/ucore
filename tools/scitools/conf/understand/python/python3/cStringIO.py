import __builtin__

class StringI(__builtin__.object):
     def __iter__(): pass
     def close(): pass
     def flush(): pass
     def getvalue(): pass
     def isatty(): pass
     def next(): pass
     def read(): pass
     def readline(): pass
     def readlines(): pass
     def reset(): pass
     def seek(): pass
     def tell(): pass
     def truncate(): pass
     closed = True
     
class StringO(__builtin__.object):
     def __iter__(): pass
     def close(): pass
     def flush(): pass
     def getvalue(): pass
     def isatty(): pass
     def next(): pass
     def read(): pass
     def readline(): pass
     def readlines(): pass
     def reset(): pass
     def seek(): pass
     def tell(): pass
     def truncate(): pass
     def write(): pass
     def writelines(): pass
     closed = True
     softspace = False
     
cInputType = StringI
OutputType = StringO     

def StringIO(): pass
cStringIO_CAPI = 0
