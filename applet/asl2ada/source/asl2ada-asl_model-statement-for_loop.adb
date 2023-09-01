package body asl2ada.asl_Model.Statement.for_loop
is


   package body Forge
   is
      function new_for_loop_Statement (Variable : in String) return View
      is
         Result : constant View := new Item;
      begin
         Result.Variable := +Variable;
         return Result;
      end new_for_loop_Statement;
   end Forge;




   function Variable (Self : in Item) return String
   is
   begin
      return +Self.Variable;
   end Variable;



   function Lower (Self : in Item) return String
   is
   begin
      return +Self.Lower;
   end Lower;



   function Upper (Self : in Item) return String
   is
   begin
      return +Self.Upper;
   end Upper;



   function  Statements  (Self : in     Item) return Statement.vector
   is
   begin
      return Self.Statements;
   end Statements;




   procedure Variable_is (Self : in out Item;   Now : in String)
   is
   begin
      Self.Variable := +Now;
   end Variable_is;



   procedure Lower_is (Self : in out Item;   Now : in String)
   is
   begin
      Self.Lower := +Now;
   end Lower_is;


   procedure Upper_is (Self : in out Item;   Now : in String)
   is
   begin
      Self.Upper := +Now;
   end Upper_is;


   procedure Statements_are (Self : in out Item;   Now : in Statement.vector)
   is
   begin
      Self.Statements := Now;
   end Statements_are;


end asl2ada.asl_Model.Statement.for_loop;
