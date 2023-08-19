with
     asl2ada.Model.Statement.block,
     asl2ada.Token;


package asl2ada.Model.Unit.asl_Applet
--
-- Models an applet unit.
--
is
   type Item is new Unit.item with private;
   type View is access all Item'Class;


   function do_Block (Self : access Item) return Statement.Block.view;



private

   type Item is new Unit.item with
      record
         --  Context      : Token.Vector;
         Declarations : Token.Vector;
         open_Block   : Statement.Block.view;
         do_Block     : aliased Statement.Block.item;
         close_Block  : Statement.Block.view;
         Handlers     : Token.Vector;
      end record;


end asl2ada.Model.Unit.asl_Applet;
