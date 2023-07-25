with
     --  asl2ada.Model,
     asl2ada.Unit;


package asl2ada.Parser
is
   type unit_Kind is (Applet, Class, Module);     -- Kind of compilation unit.


   function to_Unit (Source : in String;   unit_Name : in String;
                                           of_Kind   : in unit_Kind) return asl2ada.Unit.view;

end asl2ada.Parser;
