package body asl2ada.parser_Model.Operator
is

   function Token (Self : in Item) return asl2ada.Token.item
   is
   begin
      return Self.Token;
   end token;



   procedure Token_is (Self : in out Item;   Now : asl2ada.Token.item)
   is
   begin
      Self.Token := Now;
   end Token_is;


end asl2ada.parser_Model.Operator;
