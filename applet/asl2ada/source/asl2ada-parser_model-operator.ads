with
     asl2ada.Token,
     --  asl2ada.parser_Model.Any,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Operator
is
   type Item is tagged private;
   type View is access all Item'Class;

   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   procedure Token_is (Self : in out Item;  Now : asl2ada.Token.item);
   function  Token    (Self : in     Item) return asl2ada.Token.item;



private

   type Item is tagged
      record
         Token : asl2ada.Token.item;
      end record;


end asl2ada.parser_Model.Operator;
