with
     asl2ada.parser_Model.Declaration.of_Variable,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Declaration.of_exception
is
   type Item is new Declaration.item with private;
   type View is access all Item'Class;


   package Forge
   is
      function new_exception_Declaration (Name : in String) return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Name        (Self : in     Item) return String;
   function  is_Extended (Self : in     Item) return Boolean;
   function  Components  (Self : in     Item) return Declaration.of_Variable.Vector;

   procedure add (Self : in out Item;   the_Component : in Declaration.of_variable.view);



private

   type Item is new Declaration.item with
      record
         Name       : uString;
         Components : Declaration.of_Variable.Vector;
      end record;


end asl2ada.parser_Model.Declaration.of_exception;
