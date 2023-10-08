package body asl2ada.parser_Model.Statement.block
is

   package body Forge
   is

      function new_Block (Name : in String) return View
      is
         Result : constant View := new Item;
      begin
         Result.Name := +Name;
         return Result;
      end new_Block;

   end Forge;




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



   function Handlers (Self : in Item) return Handler.vector
   is
   begin
      return Self.Handlers;
   end Handlers;



   procedure Statements_are (Self : in out Item;   Now : in Statement.vector)
   is
   begin
      Self.Statements := Now;
   end Statements_are;



   procedure Handlers_are (Self : in out Item;   Now : in Handler.vector)
   is
   begin
      Self.Handlers := Now;
   end Handlers_are;


end asl2ada.parser_Model.Statement.block;
