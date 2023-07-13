with
     lace.wide_Text;


package asl_Ada.Text
is
   type Item is private;


   function  to_Text (From : in     wide_String := "") return Item;
   procedure destroy (Self : in out Item);



private

   package lace_Text      renames       lace.wide_Text;
   type    lace_Text_view is access all lace_Text.item;

   type Item is
      record
         Data : lace_Text_view;
      end record;


end asl_Ada.Text;
