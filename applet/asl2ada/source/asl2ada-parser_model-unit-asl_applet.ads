with
     asl2ada.parser_Model.Declaration,
     asl2ada.parser_Model.Statement.block,
     asl2ada.Token;


package asl2ada.parser_Model.Unit.asl_Applet
--
-- Models an applet unit.
--
is
   type Item is new Unit.item with private;
   type View is access all Item'Class;


   procedure Declarations_are (Self : in out Item;   Now : in parser_Model.Declaration.vector);
   function  Declarations     (Self : in     Item)     return parser_Model.Declaration.vector;

   function  do_Block         (Self : access Item)     return Statement.block.view;

   procedure end_when_Found (Self : in out Item);
   function  end_when_Found (Self : in     Item) return Boolean;



private

   type Item is new Unit.item with
      record
         --  Context      : Token.Vector;
         Declarations   :         parser_Model.Declaration.vector;
         open_Block     :         Statement.Block.view;
         do_Block       : aliased Statement.Block.item;
         close_Block    :         Statement.Block.view;
         Handlers       :         Token.Vector;

         end_when_Found :         Boolean := False;
      end record;


end asl2ada.parser_Model.Unit.asl_Applet;
