with
     asl2ada.Lexeme,
     asl2ada.parser_Model.Statement,

     ada.Strings.text_Buffers,
     ada.Containers.Vectors;



package asl2ada.parser_Model.Handler
is
   --  type Kind is (Nil, Block, an_If, a_Loop, a_Goto, an_Exit, a_Null, subprogram_Call);

   type Item is tagged private;
   type View is access all Item'Class
     with put_Image => put_Image;


   procedure put_Image (Buffer  : in out ada.Strings.text_Buffers.root_Buffer_type'Class;
                        Handler : in     View);


   package Forge
   is
      function new_Handler (Name : in String) return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Name           (Self : in     Item) return String;
   function  Statements     (Self : in     Item) return Statement.vector;

   procedure Statements_are (Self : in out Item;   Now : Statement.vector);


   function  Lexemes        (Self : in     Item) return asl2ada.Lexeme.items;
   procedure add            (Self : in out Item;       Lexeme : asl2ada.Lexeme.item);



private

   type Item is tagged
      record
         Name       : uString;        -- Name of the handled exception.
         Statements : Statement.vector;

         Lexemes : asl2ada.Lexeme.items;
      end record;


end asl2ada.parser_Model.Handler;
