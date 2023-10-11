with
     asl2ada.Token,
     asl2ada.parser_Model.Expression,
     asl2ada.parser_Model.Operator,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Condition
is
   type Item is tagged private;
   type View is access all Item'Class;

   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Tokens      (Self : in     Item)    return asl2ada.Token.vector;
   procedure add         (Self : in out Item;   Token : asl2ada.Token.item);


   procedure Left_is     (Self : in out Item;   Now : in Expression.view);
   procedure Right_is    (Self : in out Item;   Now : in Expression.view);
   procedure Operator_is (Self : in out Item;   Now : in Operator  .view);


   function  Left        (Self : in     Item) return Expression.view;
   function  Right       (Self : in     Item) return Expression.view;
   function  Operator    (Self : in     Item) return parser_Model.Operator.view;



private

   type Item is tagged
      record
         Tokens      : asl2ada.Token          .vector;
         Left, Right : parser_Model.Expression.view;
         Operator    : parser_Model.Operator  .view;
      end record;


end asl2ada.parser_Model.Condition;
