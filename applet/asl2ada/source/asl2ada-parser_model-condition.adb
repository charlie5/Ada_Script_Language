package body asl2ada.parser_Model.Condition
is

   function Tokens (Self : in Item) return asl2ada.Token.vector
   is
   begin
      return Self.Tokens;
   end Tokens;



   procedure add (Self : in out Item;   Token : asl2ada.Token.item)
   is
   begin
      Self.Tokens.append (Token);
   end add;



   procedure Left_is (Self : in out Item;   Now : in Expression.view)
   is
   begin
      Self.Left := Now;
   end Left_is;



   procedure Right_is    (Self : in out Item;   Now : in Expression.view)
   is
   begin
      Self.Right := Now;
   end Right_is;



   procedure Operator_is (Self : in out Item;   Now : in parser_Model.Operator.view)
   is
   begin
      Self.Operator := Now;
   end Operator_is;




   function Left (Self : in Item) return Expression.view
   is
   begin
      return Self.Left;
   end Left;



   function Right (Self : in Item) return Expression.view
   is
   begin
      return Self.Right;
   end Right;



   function Operator (Self : in Item) return parser_Model.Operator.view
   is
   begin
      return Self.Operator;
   end Operator;


end asl2ada.parser_Model.Condition;
