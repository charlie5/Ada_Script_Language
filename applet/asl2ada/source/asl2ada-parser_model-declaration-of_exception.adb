package body asl2ada.parser_Model.Declaration.of_exception
is


   package body Forge
   is

      function new_exception_Declaration (Identifier : in String) return View
      is
         Result : constant View := new Item;
      begin
         Result.Identifier := +Identifier;
         return Result;
      end new_exception_Declaration;

   end Forge;




   function Identifier (Self : in Item) return String
   is
   begin
      return +Self.Identifier;
   end Identifier;


end asl2ada.parser_Model.Declaration.of_exception;
