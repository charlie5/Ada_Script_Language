package body asl2ada.asl_Model.Statement
is

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


end asl2ada.asl_Model.Statement;
