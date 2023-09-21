with
     asl2ada.Parser;


package asl2ada.Generator
is
   --  type unit_Kind is (Applet, Class, Module);     -- Kind of compilation unit.


   function to_applet_spec_Ada_Source   (Source : in String;   unit_Name : in String) return String;
   function to_applet_body_Ada_Source   (Source : in String;   unit_Name : in String) return String;
   function to_applet_launch_Ada_Source (Source : in String;   unit_Name : in String) return String;

end asl2ada.Generator;
