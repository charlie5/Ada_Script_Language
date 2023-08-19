with
     asl2ada.Parser;


package asl2ada.Translator
is
   --  type unit_Kind is (Applet, Class, Module);     -- Kind of compilation unit.


   function translate (Source : in String;   unit_Name : in String;
                                             of_Kind   : in Parser.unit_Kind) return String;

end asl2ada.Translator;
