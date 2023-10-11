with
     asl2ada.Token,
     asl2ada.parser_Model.Any,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Expression
is
   type Item is tagged private;
   type View is access all Item'Class;

   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Parts     (Self : in     Item)      return Any.vector;
   procedure add       (Self : in out Item;   Part : in Any.view);

   function  Tokens    (Self : in     Item)    return asl2ada.Token.vector;
   procedure add       (Self : in out Item;   Token : asl2ada.Token.item);

   function  to_String (Self : in     Item) return String;



private

   type Item is tagged
      record
         Tokens : asl2ada.Token.vector;
         Parts  : Any.vector;
      end record;


end asl2ada.parser_Model.Expression;
