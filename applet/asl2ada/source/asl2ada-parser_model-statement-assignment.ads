with
     asl2ada.parser_Model.Expression,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Statement.assignment
is
   --  type Kind is (Nil, Block, an_If, a_Loop, a_Goto, an_Exit, a_Null, subprogram_Call);

   type Item is new Statement.item with private;
   type View is access all Item'Class;


   package Forge
   is
      function new_assignment_Statement (Variable : in String) return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Variable      (Self : in     Item) return String;

   procedure Expression_is (Self : in out Item;   Now : in Expression.view);
   function  Expression    (Self : in     Item)     return Expression.view;



private

   type Item is new Statement.item with
      record
         Variable   : uString;
         Expression : parser_Model.Expression.view;
      end record;


end asl2ada.parser_Model.Statement.assignment;
