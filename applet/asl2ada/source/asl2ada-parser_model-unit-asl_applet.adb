package body asl2ada.parser_Model.Unit.asl_Applet
is

   procedure Declarations_are (Self : in out Item;   Now : in parser_Model.Declaration.vector)
   is
   begin
      Self.Declarations := Now;
   end Declarations_are;



   function Declarations (Self : in Item) return parser_Model.Declaration.vector
   is
   begin
      return Self.Declarations;
   end Declarations;



   function do_Block (Self : access Item) return Statement.Block.view
   is
   begin
      return Self.do_Block'Access;
   end do_Block;



   procedure end_when_Found (Self : in out Item)
   is
   begin
      Self.end_when_Found := True;
   end end_when_Found;



   function end_when_Found (Self : in Item) return Boolean
   is
   begin
      return Self.end_when_Found;
   end end_when_Found;


end asl2ada.parser_Model.Unit.asl_Applet;
