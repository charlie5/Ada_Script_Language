package body asl2ada.parser_Model.Statement.end_when
is


   package body Forge
   is

      function new_end_when_Statement  return View
      is
         Result : constant View := new Item;
      begin
         return Result;
      end new_end_when_Statement;


   end Forge;



   function Condition (Self : in Item) return parser_Model.Condition.view
   is
   begin
      return Self.Condition;
   end Condition;



   procedure Condition_is (Self : in out Item;   Now : in parser_Model.Condition.view)
   is
   begin
      Self.Condition := Now;
   end Condition_is;


end asl2ada.parser_Model.Statement.end_when;
