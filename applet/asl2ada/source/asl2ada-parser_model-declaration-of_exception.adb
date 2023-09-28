package body asl2ada.parser_Model.Declaration.of_exception
is


   package body Forge
   is

      function new_exception_Declaration (Name : in String) return View
      is
         Result : constant View := new Item;
      begin
         Result.Name := +Name;
         return Result;
      end new_exception_Declaration;

   end Forge;




   function Name (Self : in Item) return String
   is
   begin
      return +Self.Name;
   end Name;



   function  is_Extended (Self : in     Item) return Boolean
   is
   begin
      return not Self.Components.is_Empty;
   end is_Extended;



   function  Components (Self : in     Item) return Declaration.of_Variable.Vector
   is
   begin
      return Self.Components;
   end Components;



   procedure add (Self : in out Item;   the_Component : in Declaration.of_variable.view)
   is
   begin
      Self.Components.append (the_Component);
   end add;


end asl2ada.parser_Model.Declaration.of_exception;
