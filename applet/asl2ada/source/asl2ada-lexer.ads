with
     asl2ada.Lexeme,
     asl2ada.Token;


package asl2ada.Lexer
is

   function to_Tokens  (Source : in String) return Token.items;

   Error : exception;

end asl2ada.Lexer;
