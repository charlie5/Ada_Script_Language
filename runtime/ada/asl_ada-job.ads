with
     ada.Calendar;


package Asl_Ada.Job
is
   type Item is abstract tagged private;
   type View is access all Item'Class;


   procedure perform (Self : in out Item)
   is abstract;

   procedure Due_is (Self : in out Item;   Now : in ada.Calendar.Time);
   function  Due    (Self : in     Item)     return ada.Calendar.Time;

   Never : constant ada.Calendar.Time;



private

   type Item is abstract tagged
      record
         Due : ada.Calendar.Time := ada.Calendar.Clock;
      end record;


   use ada.Calendar;

   Never : constant ada.Calendar.Time := Time_of (Year    =>  Year_Number'First,
                                                  Month   => Month_Number'First,
                                                  Day     =>   Day_Number'First);
end Asl_Ada.Job;
