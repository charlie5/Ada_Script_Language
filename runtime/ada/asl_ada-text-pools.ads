package asl_Ada.Text.Pools
is

   function  to_Text (Capacity : in     Natural := 0) return Text.item;
   procedure free    (Self     : in out Text.item);



private


end asl_Ada.Text.Pools;
