with
     asl2ada.Token,
     asl2ada.Error,
     ada.Strings.text_Buffers,
     ada.Containers.Vectors;


package asl2ada.Lexer
is

   function to_Tokens (Source : in String;   Errors : in out Error.items) return Token.vector;

   Error : exception;



   -----------------
   --- Applet tokens
   --

   type applet_Tokens is
      record
         Context      : Token.Vector;
         Declarations : Token.Vector;
         open_Block   : Token.Vector;
         do_Block     : Token.Vector;
         close_Block  : Token.Vector;
         Handlers     : Token.Vector;
      end record;

   function to_applet_Tokens (From        : in Token.Vector;
                              applet_Name : in String) return applet_Tokens;




   ----------------
   --- Block Tokens
   --

   type block_Tokens is
      record
         Declarations : Token.Vector;
         Statements   : Token.Vector;
         Handlers     : Token.Vector;
      end record;

   function to_block_Tokens (From : in Token.Vector) return block_Tokens;



end asl2ada.Lexer;
