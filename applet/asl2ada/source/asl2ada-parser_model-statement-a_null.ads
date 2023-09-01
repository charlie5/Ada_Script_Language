package asl2ada.parser_Model.Statement.a_null
is
   type Item is new Statement.item with private;
   type View is access all Item'Class;


   package Forge
   is
      function new_null_Statement return View;
   end Forge;



private

   type Item is new Statement.item with null record;


end asl2ada.parser_Model.Statement.a_null;
