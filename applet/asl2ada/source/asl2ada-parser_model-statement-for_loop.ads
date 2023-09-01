with
     ada.Containers.Vectors;


package asl2ada.parser_Model.Statement.for_loop
is
   --  type Kind is (Nil, Block, an_If, a_Loop, a_Goto, an_Exit, a_Null, subprogram_Call);

   type Item is new Statement.item with private;
   type View is access all Item'Class;


   package Forge
   is
      function new_for_loop_Statement (Variable : in String) return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Variable    (Self : in     Item) return String;
   function  Lower       (Self : in     Item) return String;
   function  Upper       (Self : in     Item) return String;
   function  Statements  (Self : in     Item) return Statement.vector;

   procedure Variable_is    (Self : in out Item;   Now : in String);
   procedure Lower_is       (Self : in out Item;   Now : in String);
   procedure Upper_is       (Self : in out Item;   Now : in String);
   procedure Statements_are (Self : in out Item;   Now : in Statement.vector);

private

   type Item is new Statement.item with
      record
         Variable   : uString;
         Lower      : uString;
         Upper      : uString;
         Statements : Statement.vector;
      end record;


end asl2ada.parser_Model.Statement.for_loop;
