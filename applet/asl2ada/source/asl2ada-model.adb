with
   asl2ada.Model.Unit;


package body asl2ada.Model
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


end asl2ada.Model;
