package body asl2ada.parser_Model.Statement.a_null
is

   package body Forge
   is

      function new_null_Statement return View
      is
         Result : constant View := new Item;
      begin
         return Result;
      end new_null_Statement;

   end Forge;



   --  overriding
   --  function Image (Self : in Item) return String
   --  is
   --  begin
   --     return Self'Image;
   --  end Image;


end asl2ada.parser_Model.Statement.a_null;
