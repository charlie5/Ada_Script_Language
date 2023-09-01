package body asl2ada.parser_Model.Unit
is

   procedure Name_is (Self : in out Item;   Now : in String)
   is
   begin
      Self.Name := to_unbounded_String (Now);
   end Name_is;


   function Name (Self : in Item) return String
   is
   begin
      return to_String (Self.Name);
   end Name;



   procedure Context_is (Self : in out Item;   Now : in context_Clauses)
   is
   begin
      Self.Context := Now;
   end Context_is;


   function Context (Self : in Item) return Unit.context_Clauses
   is
   begin
      return Self.Context;
   end Context;




   --  procedure procedural_Region_is (Self : in out Item;   Now : in procedural_Region_t)
   --  is
   --  begin
   --     Self.procedural_Region := Now;
   --  end procedural_Region_is;
   --
   --
   --  function  procedural_Region    (Self : in     Item)     return procedural_Region_t
   --  is
   --  begin
   --     return Self.procedural_Region;
   --  end procedural_Region;


end asl2ada.parser_Model.Unit;
