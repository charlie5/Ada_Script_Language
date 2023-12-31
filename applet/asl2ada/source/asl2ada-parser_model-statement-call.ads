with
     asl2ada.parser_Model.Expression,
     ada.Containers.Vectors;


package asl2ada.parser_Model.Statement.call
is
   --  type Kind is (Nil, Block, an_If, a_Loop, a_Goto, an_Exit, a_Null, subprogram_Call);

   type Item is new Statement.item with private;
   type View is access all Item'Class;


   package Forge
   is
      function new_call_Statement (Name : in String) return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   function  Name         (Self : in     Item) return String;

   procedure add_Argument (Self : in out Item;   Argument : in Expression.view);
   function  Arguments    (Self : in     Item)          return Expression.vector;



private

   type Item is new Statement.item with
      record
         Name      : uString;
         Arguments : Expression.vector;
      end record;


end asl2ada.parser_Model.Statement.call;
