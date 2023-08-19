package body asl2ada.Model.Unit.asl_Applet
is

   function do_Block (Self : access Item) return Statement.Block.view
   is
   begin
      return Self.do_Block'Access;
   end do_Block;


end asl2ada.Model.Unit.asl_Applet;
