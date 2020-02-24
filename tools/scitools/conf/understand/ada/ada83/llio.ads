package low_level_io is 
   type devicetype is (console_printer_data,
                   console_printer_control,
                   console_keyboard_data,
                   console_keyboard_control);
   subtype datatype is character;
   type console_control_type is new integer;
   procedure send_control(device : devicetype; data : in out datatype);  
   procedure receive_control(device : devicetype; data : in out datatype);  
   procedure send_control(device : devicetype; data : in console_control_type);  
   procedure receive_control(device : devicetype; data : in console_control_type);  
end;
