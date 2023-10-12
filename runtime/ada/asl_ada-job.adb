package body Asl_Ada.Job
is

   procedure Due_is (Self : in out Item;   Now : in ada.Calendar.Time)
   is
   begin
      Self.Due := Now;
   end Due_is;



   function Due (Self : in Item) return ada.Calendar.Time
   is
   begin
      return Self.Due;
   end Due;


end Asl_Ada.Job;
