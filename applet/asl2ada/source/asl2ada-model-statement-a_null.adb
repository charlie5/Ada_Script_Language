package body asl2ada.Model.Statement.a_null
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


end asl2ada.Model.Statement.a_null;
