with
     ada.Containers.Vectors;


package asl2ada.asl_Model.Any
is
   type Item is tagged private;
   type View is access all Item'Class;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype vector  is     vectors.Vector;



private

   type Item is tagged
      record
         null;
      end record;


end asl2ada.asl_Model.Any;
