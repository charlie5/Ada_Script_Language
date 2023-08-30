with
     ada.Containers.indefinite_hashed_Maps,
     ada.Containers.Vectors,
     ada.Strings.Hash;

limited
with
     asl2ada.Model.Unit;

private
with
     ada.unchecked_Conversion;


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



   ---------------
   --- Identifiers
   --

   type identifier_Character is ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                                 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
                                 '_',
                                 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');

   type Identifier is array (Positive range <>) of identifier_Character;


   function is_Valid (Name : in Identifier) return Boolean;

   function "+"      (Name : in Identifier) return String;
   function "+"      (Name : in String)     return Identifier;

   function "+"      (Name : in Identifier) return uString;
   function "+"      (Name : in uString)    return Identifier;



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



   ---------------
   --- Identifiers
   --

   for identifier_Character'Size use Character'Size;

   function convert is new ada.unchecked_Conversion (Character, Integer);
   function "+" (From : Character ) return Integer renames convert;

   for identifier_Character use ('0' => +'0',
                                 '1' => +'1',
                                 '2' => +'2',
                                 '3' => +'3',
                                 '4' => +'4',
                                 '5' => +'5',
                                 '6' => +'6',
                                 '7' => +'7',
                                 '8' => +'8',
                                 '9' => +'9',

                                 'A' => +'A',
                                 'B' => +'B',
                                 'C' => +'C',
                                 'D' => +'D',
                                 'E' => +'E',
                                 'F' => +'F',
                                 'G' => +'G',
                                 'H' => +'H',
                                 'I' => +'I',
                                 'J' => +'J',
                                 'K' => +'K',
                                 'L' => +'L',
                                 'M' => +'M',
                                 'N' => +'N',
                                 'O' => +'O',
                                 'P' => +'P',
                                 'Q' => +'Q',
                                 'R' => +'R',
                                 'S' => +'S',
                                 'T' => +'T',
                                 'U' => +'U',
                                 'V' => +'V',
                                 'W' => +'W',
                                 'X' => +'X',
                                 'Y' => +'Y',
                                 'Z' => +'Z',

                                 '_' => +'_',

                                 'a' => +'a',
                                 'b' => +'b',
                                 'c' => +'c',
                                 'd' => +'d',
                                 'e' => +'e',
                                 'f' => +'f',
                                 'g' => +'g',
                                 'h' => +'h',
                                 'i' => +'i',
                                 'j' => +'j',
                                 'k' => +'k',
                                 'l' => +'l',
                                 'm' => +'m',
                                 'n' => +'n',
                                 'o' => +'o',
                                 'p' => +'p',
                                 'q' => +'q',
                                 'r' => +'r',
                                 's' => +'s',
                                 't' => +'t',
                                 'u' => +'u',
                                 'v' => +'v',
                                 'w' => +'w',
                                 'x' => +'x',
                                 'y' => +'y',
                                 'z' => +'z');




                                 --  others => +'0');
                                 --  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
                                 --  '_',
                                --  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');

end asl2ada.Model;
