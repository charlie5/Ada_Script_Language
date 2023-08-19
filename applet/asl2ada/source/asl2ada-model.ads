with
     ada.Containers.indefinite_hashed_Maps,
     ada.Containers.Vectors,
     ada.Strings.Hash;


limited
with
     asl2ada.Model.Unit;


package asl2ada.Model
is
   type Item is tagged private;
   type View is access all Item'Class;


   --  use type asl2ada.Model.Unit.view;
   type    Unit_view is access all asl2ada.Model.Unit.item'Class;
   package Unit_vectors is new ada.Containers.Vectors (Positive, Unit_view);
   subtype Unit_vector  is     Unit_vectors.Vector;


   function  all_Units (Self : in     Item)                      return Unit_vector;
   function  get_Unit  (Self : in     Item;   Named : in String) return Unit_view;
   procedure add       (Self : in out Item;   Unit  : in Unit_view);



private

   package name_Maps_of_Unit is new ada.Containers.indefinite_hashed_Maps (Key_type     => String,
                                                                           Element_type => Unit_view,
                                                                           Hash         => ada.Strings.Hash,
                                                                           equivalent_Keys => "=");
   subtype name_Map_of_Unit is name_Maps_of_Unit.Map;


   type Item is tagged
      record
         unit_Map : name_Map_of_Unit;
      end record;


end asl2ada.Model;
