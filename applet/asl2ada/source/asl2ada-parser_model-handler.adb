package body asl2ada.parser_Model.Handler
is

   package body Forge
   is

      function new_Handler (Name : in String) return View
      is
         Result : constant View := new Item;
      begin
         Result.Name := +Name;
         return Result;
      end new_Handler;

   end Forge;



   function Name (Self : in Item) return String
   is
   begin
      return +Self.Name;
   end Name;



   function Statements (Self : in Item) return Statement.Vector
   is
   begin
      return Self.Statements;
   end statements;



   procedure Statements_are (Self : in out Item;   Now : in Statement.vector)
   is
   begin
      Self.Statements := Now;
   end Statements_are;



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




   -----------
   --- Support
   --

   procedure put_Image (Buffer  : in out ada.Strings.text_Buffers.root_Buffer_type'Class;
                        Handler : in     View)
   is
   begin
      if Handler = null
      then
         Buffer.put ("<null>");
      else
         parser_Model.Handler.item'Class'put_Image (Buffer, Handler.all);
      end if;
   end put_Image;



end asl2ada.parser_Model.Handler;
