package asl2ada.parser_Model.Unit.asl_Module
is
   type Item is new Unit.item with private;
   type View is access all Item'Class;



private

   type Item is new Unit.item with
      record
         null;
      end record;


   procedure dummy;


end asl2ada.parser_Model.Unit.asl_Module;
