with
     ada.wide_Text_IO;


package body Asl_Ada.core
is

   procedure log (Message : in wide_String := "")
   is
      use ada.wide_Text_IO;
   begin
      put_Line (Message);
   end log;

end Asl_Ada.core;
