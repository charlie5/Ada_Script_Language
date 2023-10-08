with
     asl2ada.parser_Model.Handler;


package asl2ada.parser_Model.Statement.block
is

   type Item is new Statement.item with private;
   type View is access all Item;


   package Forge
   is
      function new_Block (Name : in String) return View;
   end Forge;


   type declarative_Region is null record;


   --  type procedural_Region is
   --     record
   --        Statements : Statement.vector;
   --     end record;


   --  type exception_Handler is null record;



   function  Declarations   (Self : in Item) return declarative_Region;
   function  Statements     (Self : in Item) return   Statement.vector;
   function  Handlers       (Self : in Item) return   Handler  .vector;

   procedure Statements_are (Self : in out Item;   Now : in Statement.vector);
   procedure Handlers_are   (Self : in out Item;   Now : in Handler  .vector);



private

   type Item is new Statement.item with
      record
         Name         : uString;
         Declarations : declarative_Region;
         Statements   : Statement.vector;
         Handlers     : Handler  .vector;
      end record;


end asl2ada.parser_Model.Statement.block;
