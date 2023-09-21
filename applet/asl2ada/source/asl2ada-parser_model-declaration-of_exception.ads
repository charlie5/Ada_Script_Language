with
     asl2ada.parser_Model.Expression,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Declaration.of_exception
is
   type Item is new Declaration.item with private;
   type View is access all Item'Class;


   package Forge
   is
      function new_exception_Declaration (Identifier : in String) return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Identifier  (Self : in     Item) return String;



private

   type Item is new Declaration.item with
      record
         Identifier : uString;
      end record;


end asl2ada.parser_Model.Declaration.of_exception;
