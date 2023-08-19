package body asl2ada.Model.Statement.Call
is


   package body Forge
   is
      function new_Call_Statement (Name : in String) return View
      is
         Result : constant View := new Item;
      begin
         Result.Name := +Name;
         return Result;
      end new_Call_Statement;
   end Forge;




   function Name (Self : in Item) return String
   is
   begin
      return +Self.Name;
   end Name;



   procedure add_Argument (Self : in out Item;   Argument : in Expression.view)
   is
   begin
      Self.Arguments.append (Argument);
   end add_Argument;



   function Arguments (Self : in Item) return Expression.vector
   is
   begin
      return Self.Arguments;
   end Arguments;


end asl2ada.Model.Statement.Call;
