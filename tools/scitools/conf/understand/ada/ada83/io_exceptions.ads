   
--******************************************************************************
--
--	package IO_EXCEPTIONS
--
--******************************************************************************

package IO_EXCEPTIONS is

   STATUS_ERROR : exception;
   MODE_ERROR   : exception;
   NAME_ERROR   : exception;
   USE_ERROR    : exception;
   DEVICE_ERROR : exception;
   END_ERROR    : exception;
   DATA_ERROR   : exception;
   LAYOUT_ERROR : exception;

end IO_EXCEPTIONS;

--******************************************************************************
--
--	package AUX_IO_EXCEPTIONS
--
--******************************************************************************

package AUX_IO_EXCEPTIONS is

   LOCK_ERROR      : exception;
   EXISTENCE_ERROR : exception;
   KEY_ERROR       : exception;

end AUX_IO_EXCEPTIONS;
