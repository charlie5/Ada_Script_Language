with
     asl2ada.Parser,
     asl2ada.parser_Model.Unit;


package asl2ada.Translator
is
   --  type unit_Kind is (Applet, Class, Module);     -- Kind of compilation unit.


   --  function to_applet_spec_Ada_Source   (Source : in String;   unit_Name : in String) return String;
   --  function to_applet_body_Ada_Source   (Source : in String;   unit_Name : in String) return String;
   --  function to_applet_launch_Ada_Source (Source : in String;   unit_Name : in String) return String;

   function to_applet_spec_Ada_Source   (the_Unit : in asl2ada.parser_Model.Unit.view;   unit_Name : in String) return String;
   function to_applet_body_Ada_Source   (the_Unit : in asl2ada.parser_Model.Unit.view;   unit_Name : in String) return String;
   function to_applet_launch_Ada_Source (the_Unit : in asl2ada.parser_Model.Unit.view;   unit_Name : in String) return String;

end asl2ada.Translator;
