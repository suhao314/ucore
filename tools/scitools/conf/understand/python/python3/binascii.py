import exceptions
class Error(exceptions.Exception):
    __weakref__ = []
class Incomplete(exceptions.Exception):
    __weakref__ = []
    
def a2b_base64(): pass
def a2b_hex(): pass
def a2b_hqx(): pass
def a2b_qp(): pass
def a2b_uu(): pass
def b2a_base64(): pass
def b2a_hex(): pass
def b2a_hqx(): pass
def b2a_qp(): pass
def b2a_uu(): pass
def crc32(): pass
def crc_hqx(): pass
def hexlify(): pass
def rlecode_hqx(): pass
def rledecode_hqx(): pass
def unhexlify(): pass
