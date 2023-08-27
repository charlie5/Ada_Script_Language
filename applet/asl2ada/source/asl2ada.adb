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




   function comment_stripped_Source (From : in String) return String
   is
      Source : String renames From;
      Result : String (Source'Range);
      Index  : Natural := 0;
      Skip   : Boolean := False;
   begin
      for i in Source'First .. Source'Last - 1
      loop
         if    Source (i)     = '-'
           and Source (i + 1) = '-'
         then
            Skip := True;
         end if;

         if Skip
         then
            if Source (i) = NL
            then
               Skip           := False;
               Index          := Index + 1;
               Result (Index) := NL;
            end if;
         else
            Index          := Index + 1;
            Result (Index) := Source (i);
         end if;
      end loop;

      if    not Skip
        and Source (Source'Last) /= '-'
      then
         Index          := Index + 1;
         Result (Index) := Source (Source'Last);
      end if;

      return Result (1 .. Index);
   end comment_stripped_Source;




end Asl2Ada;
