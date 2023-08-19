package body asl2ada.Model.Expression
is

   function Parts (Self : in Item) return Any.vector
   is
   begin
      return Self.Parts;
   end Parts;



   procedure add (Self : in out Item;   Part : Any.view)
   is
   begin
      Self.Parts.append (Part);
   end add;



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




   function to_String (Self : in Item) return String
   is
      use Token,
          ada.Strings.unbounded;
      Result : uString;
   begin
      for Each of Self.Tokens
      loop
         --  log (+Each.Text);

         if Each.Kind = string_literal_Token
         then
            append (Result, Each.string_Value);
         else
            append (Result, Each.Lexeme.Text);
         end if;
      end loop;

      return +Result;
   end to_String;


end asl2ada.Model.Expression;
