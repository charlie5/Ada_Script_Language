package asl2ada.asl_Model.Call
is

   type Item is tagged
      record
         Name      : uString;     -- Subprogram name.
         Arguments :  Strings;
      end record;

   type View is access all Item'Class;


end asl2ada.asl_Model.Call;
