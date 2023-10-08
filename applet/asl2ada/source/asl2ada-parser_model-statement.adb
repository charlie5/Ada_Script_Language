package body asl2ada.parser_Model.Statement
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





   -----------
   --- Support
   --

   procedure put_Image (Buffer     : in out ada.Strings.text_Buffers.root_Buffer_type'Class;
                        Statement  : in     View)
   is
   begin
      if Statement = null
      then
         Buffer.put ("<null>");
      else
         --  Buffer.put (Statement.Image);
         parser_Model.Statement.item'Class'put_Image (Buffer, Statement.all);
      end if;
   end put_Image;



   --  function Image (Self : in Item) return String
   --  is
   --  begin
   --     return Self'Image;
   --  end Image;


end asl2ada.parser_Model.Statement;
