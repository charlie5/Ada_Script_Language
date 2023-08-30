package body asl2ada.Model.Statement.a_raise
is


   package body Forge
   is

      --  function new_raise_Statement (Raises : in an_Exception.view) return View
      --  is
      --     Result : constant View := new Item;
      --  begin
      --     Result.Raises := Raises;
      --     return Result;
      --  end new_raise_Statement;

      function new_raise_Statement (Raises : in Identifier) return View
      is
         Result : constant View := new Item;
      begin
         Result.Raises := +Raises;
         return Result;
      end new_raise_Statement;


   end Forge;



   --  function Raises (Self : in Item) return an_Exception.view
   --  is
   --  begin
   --     return Self.Raises;
   --  end Raises;



   function Raises (Self : in Item) return Identifier
   is
   begin
      return +Self.Raises;
   end Raises;


end asl2ada.Model.Statement.a_raise;
