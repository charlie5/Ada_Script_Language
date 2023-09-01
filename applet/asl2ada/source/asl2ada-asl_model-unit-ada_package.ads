package asl2ada.asl_Model.Unit.ada_Package
--
-- Models a compilation unit.
--
is
   type Item is new Unit.item with private;
   type View is access all Item'Class;



private

   type Item is new Unit.item with
      record
         null;
      end record;


   procedure dummy;


end asl2ada.asl_Model.Unit.ada_Package;
