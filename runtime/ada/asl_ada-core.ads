with
     ada.unchecked_Conversion,
     System;


package Asl_Ada.core
is

   procedure log (Message : in wide_String := "");     -- TODO: Add formatting support ?



   subtype address_Buffer is String (1 .. system.Address'Size / 8);

   function to_Buffer  is new ada.unchecked_Conversion (system.Address, address_Buffer);
   function to_Address is new ada.unchecked_Conversion (address_Buffer, system.Address);
   

end Asl_Ada.core;
