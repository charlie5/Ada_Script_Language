with
     asl2ada.asl_Model.Statement;


package asl2ada.asl_Model.Unit
--
-- Models a compilation unit.
--
is
   type Item is tagged private;
   type View is access all Item'Class;


   procedure Name_is (Self : in out Item;   Now : in String);
   function  Name    (Self : in     Item)     return String;


   type context_Clauses is
      record
         Withs : asl2ada.Strings;
         Uses  : asl2ada.Strings;
      end record;

   procedure Context_is (Self : in out Item;   Now : in context_Clauses);
   function  Context    (Self : in     Item)     return context_Clauses;



   --  type procedural_Region_t is
   --     record
   --        Statements : Statement.vector;
   --     end record;
   --
   --  procedure procedural_Region_is (Self : in out Item;   Now : in procedural_Region_t);
   --  function  procedural_Region    (Self : in     Item)     return procedural_Region_t;



private

   use ada.Strings.unbounded;

   type Item is tagged
      record
         Name              : uString;
         Context           : Context_Clauses;
         --  procedural_Region : procedural_Region_t;
      end record;

end asl2ada.asl_Model.Unit;
