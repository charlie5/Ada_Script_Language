package body asl2ada.Model.Statement.block
is

   function Declarations (Self : in Item) return declarative_Region
   is
      Result : declarative_Region;
   begin
      return Result;
   end Declarations;



   function Statements (Self : in Item) return  Statement.vector
   is
   begin
      return Self.Statements;
   end Statements;



   function Handler (Self : in Item) return exception_Handler
   is
      Result : exception_Handler;
   begin
      return Result;
   end Handler;



   procedure Statements_are (Self : in out Item;   Now : in Statement.vector)
   is
   begin
      Self.Statements := Now;
   end Statements_are;


end asl2ada.Model.Statement.block;
