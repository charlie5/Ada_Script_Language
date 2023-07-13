with
     lace.wide_Text;


package asl_Ada.Text
is

   type Item is private;

   function  to_Text (Capacity : in     Natural := 0)  return Item;
   function  to_Text (From     : in     String  := "") return Item;
   procedure free    (Self     : in out Item);




private

   package lace_Text renames lace.wide_Text;


   type lace_Text_view is access all lace_Text.item;

   type Item is
      record
         Data : lace_Text_view;
      end record;


end asl_Ada.Text;
