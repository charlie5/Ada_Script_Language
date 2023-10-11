package body asl2ada.parser_Model.Statement.assignment
is


   package body Forge
   is

      function new_assignment_Statement (Variable : in String) return View
      is
         Result : constant View := new Item;
      begin
         Result.Variable := +Variable;
         return Result;
      end new_assignment_Statement;

   end Forge;




   function Variable (Self : in Item) return String
   is
   begin
      return +Self.Variable;
   end Variable;



   procedure Expression_is (Self : in out Item;   Now : in parser_Model.Expression.view)
   is
   begin
      Self.Expression := Now;
   end Expression_is;



   function Expression (Self : in Item) return parser_Model.Expression.view
   is
   begin
      return Self.Expression;
   end Expression;


end asl2ada.parser_Model.Statement.assignment;
