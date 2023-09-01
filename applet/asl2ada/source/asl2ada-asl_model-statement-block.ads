--with
     -- asl2ada.Model.
--       ada.Strings.unbounded,
--       ada.Containers.Vectors;


package asl2ada.asl_Model.Statement.block
is

   type Item is new Statement.item with private;
   type View is access all Item;


   type declarative_Region is null record;


   --  type procedural_Region is
   --     record
   --        Statements : Statement.vector;
   --     end record;


   type exception_Handler is null record;



   function Declarations (Self : in Item) return declarative_Region;
   function Statements   (Self : in Item) return   Statement.vector;
   function Handler      (Self : in Item) return   exception_Handler;

   procedure Statements_are (Self : in out Item;   Now : in Statement.vector);



private

   type Item is new Statement.item with
      record
         Declarations : declarative_Region;
         Statements   : Statement.vector;
         Handler      : exception_Handler;
      end record;


end asl2ada.asl_Model.Statement.block;
