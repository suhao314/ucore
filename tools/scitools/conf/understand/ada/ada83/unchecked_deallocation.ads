--******************************************************************************
--
--	procedure UNCHECKED_DEALLOCATION
--
--******************************************************************************

generic
  type OBJECT is limited private;
  type NAME   is access OBJECT;
procedure UNCHECKED_DEALLOCATION(X : in out NAME);



