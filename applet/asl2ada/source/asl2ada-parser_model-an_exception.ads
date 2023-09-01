with
     asl2ada.Lexeme,
     ada.Containers.Vectors;


package asl2ada.parser_Model.an_Exception
is
   type Item is tagged private;
   type View is access all Item'Class;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   package Forge
   is
      function new_Exception (Named : in Identifier) return View;
   end Forge;


   function  Name    (Self : in     Item)     return Identifier;

   function  Lexemes (Self : in     Item)     return asl2ada.Lexeme.items;
   procedure add     (Self : in out Item;   Lexeme : asl2ada.Lexeme.item);



private

   type Item is tagged
      record
         Name    : uString;
         Lexemes : asl2ada.Lexeme.items;
      end record;


end asl2ada.parser_Model.an_Exception;
