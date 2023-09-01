with
     asl2ada.asl_Model.Unit,
     ada.unchecked_Conversion;


package body asl2ada.asl_Model
is

   function all_Units (Self : in Item) return Unit_vector
   is
      Result : Unit_vector;
   begin
      for Each of Self.unit_Map
      loop
         Result.append (Each);
      end loop;

      return Result;
   end all_Units;




   function get_Unit (Self : in Item;   Named : in String) return Unit_view
   is
   begin
      return Self.Unit_map (Named);
   end get_Unit;




   procedure add (Self : in out Item;   Unit : in Unit_view)
   is
   begin
      Self.Unit_map.insert (Unit.Name,
                            Unit);
   end add;



   ---------------
   --- Identifiers
   --

   function is_Valid (Name : Identifier) return Boolean
   is
      First : constant identifier_Character := Name (Name'First);
   begin
      return First /= '_'
         and First not in '0' .. '9';
   end is_Valid;



   function "+" (Name : in Identifier) return String
   is
      function convert is new ada.unchecked_Conversion (identifier_Character, Character);
      Result : String (Name'Range);
   begin
      for i in Name'Range
      loop
         Result (i) := convert (Name (i));
      end loop;

      return Result;
   end "+";



   function "+" (Name : in String) return Identifier
   is
      function convert is new ada.unchecked_Conversion (Character, identifier_Character);
      Result : Identifier (Name'Range);
   begin
      for i in Name'Range
      loop
         Result (i) := convert (Name (i));
      end loop;

      return Result;
   end "+";



   function "+" (Name : in Identifier) return uString
   is
      use ada.Strings.unbounded;
   begin
      return to_unbounded_String (+Name);
   end "+";



   function "+" (Name : in uString) return Identifier
   is
      use ada.Strings.unbounded;
   begin
      return +to_String (Name);
   end "+";


end asl2ada.asl_Model;
