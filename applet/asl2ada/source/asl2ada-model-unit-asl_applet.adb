package body asl2ada.Model.Unit.asl_Applet
is

   procedure Declarations_are (Self : in out Item;   Now : in model.Declaration.vector)
   is
   begin
      Self.Declarations := Now;
   end Declarations_are;



   function Declarations (Self : in Item) return model.Declaration.vector
   is
   begin
      return Self.Declarations;
   end Declarations;



   function do_Block (Self : access Item) return Statement.Block.view
   is
   begin
      return Self.do_Block'Access;
   end do_Block;


end asl2ada.Model.Unit.asl_Applet;
