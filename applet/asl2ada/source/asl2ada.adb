package body Asl2Ada
is

   procedure dlog (Message : in String)
   is
   begin
      if debugging
      then
         ada.Text_IO.put_Line (Message);
      end if;
   end dlog;



   procedure dlog (new_Lines : in ada.Text_IO.positive_Count := 1)
   is
   begin
      if debugging
      then
         ada.Text_IO.new_Line (new_Lines);
      end if;
   end dlog;



   procedure log (Message : in String)
   is
   begin
      ada.Text_IO.put_Line (Message);
   end log;



   procedure log (new_Lines : in ada.Text_IO.positive_Count := 1)
   is
   begin
      ada.Text_IO.new_Line (new_Lines);
   end log;


end Asl2Ada;
