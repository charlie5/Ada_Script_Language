package body asl2ada.Model.Declaration.of_variable
is


   package body Forge
   is

      function new_variable_Declaration (Identifier : in String) return View
      is
         Result : constant View := new Item;
      begin
         Result.Identifier := +Identifier;
         return Result;
      end new_variable_Declaration;

   end Forge;




   function Identifier (Self : in Item) return String
   is
   begin
      return +Self.Identifier;
   end Identifier;



   function my_Type (Self : in Item) return String
   is
   begin
      return +Self.my_Type;
   end my_Type;




   procedure Type_is (Self : in out Item;   Now : in String)
   is
   begin
      Self.my_Type := +Now;
   end Type_is;


end asl2ada.Model.Declaration.of_variable;
