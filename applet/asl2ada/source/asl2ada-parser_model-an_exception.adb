package body asl2ada.parser_Model.an_Exception
is

   package body Forge
   is

      function new_Exception (Named : in Identifier) return View
      is
         Result : View := new Item;
      begin
         Result.Name := +Named;
         return Result;
      end new_Exception;

   end Forge;



   function Name (Self : in Item) return Identifier
   is
   begin
      return +Self.Name;
   end Name;



   function Lexemes (Self : in Item) return asl2ada.Lexeme.items
   is
   begin
      return Self.Lexemes;
   end Lexemes;



   procedure add (Self : in out Item;   Lexeme : asl2ada.Lexeme.item)
   is
   begin
      Self.Lexemes.append (Lexeme);
   end add;


end asl2ada.parser_Model.an_Exception;
