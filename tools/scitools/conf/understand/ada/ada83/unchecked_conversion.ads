--******************************************************************************
--
--	function UNCHECKED_CONVERSION
--
--******************************************************************************

generic
   type SOURCE is limited private;
   type TARGET is limited private;
function UNCHECKED_CONVERSION(S : SOURCE) return TARGET;


