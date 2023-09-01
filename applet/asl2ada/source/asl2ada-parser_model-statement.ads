with
     asl2ada.Lexeme,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Statement
is
   --  type Kind is (Nil, Block, an_If, a_Loop, a_Goto, an_Exit, a_Null, subprogram_Call);

   type Item is tagged private;
   type View is access all Item'Class;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;

   function  Lexemes (Self : in     Item) return asl2ada.Lexeme.items;
   procedure add     (Self : in out Item;       Lexeme : asl2ada.Lexeme.item);



private

   type Item is tagged
      record
         Lexemes : asl2ada.Lexeme.items;
      end record;


end asl2ada.parser_Model.Statement;
