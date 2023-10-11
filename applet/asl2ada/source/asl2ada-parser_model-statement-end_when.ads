with
     asl2ada.parser_Model.Condition,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Statement.end_when
is
   type Item is new Statement.item with private;
   type View is access all Item'Class;


   package Forge
   is
      function new_end_when_Statement return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   procedure Condition_is (Self : in out Item;   Now : in Condition.view);
   function  Condition    (Self : in Item)         return Condition.view;



private

   type Item is new Statement.item with
      record
         Condition : parser_Model.Condition.view;
      end record;


end asl2ada.parser_Model.Statement.end_when;
