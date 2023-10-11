with
     asl2ada.parser_Model.Expression,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Declaration.of_record
is
   type Item is new Declaration.item with private;
   type View is access all Item'Class;


   package Forge
   is
      function new_record_Declaration (Identifier : in String) return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Identifier  (Self : in     Item) return String;



private

   type Item is new Declaration.item with
      record
         Identifier : uString;
      end record;


end asl2ada.parser_Model.Declaration.of_record;
