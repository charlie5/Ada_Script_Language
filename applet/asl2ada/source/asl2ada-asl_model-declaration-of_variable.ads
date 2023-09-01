with
     asl2ada.asl_Model.Expression,
     ada.Containers.Vectors;


package asl2ada.asl_Model.Declaration.of_variable
is
   type Item is new Declaration.item with private;
   type View is access all Item'Class;


   package Forge
   is
      function new_variable_Declaration (Identifier : in String) return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Identifier  (Self : in     Item) return String;
   function  my_Type     (Self : in     Item) return String;

   procedure Type_is     (Self : in out Item;   Now : in String);



private

   type Item is new Declaration.item with
      record
         Identifier : uString;
         my_Type    : uString;
      end record;


end asl2ada.asl_Model.Declaration.of_variable;
