with
     asl2ada.Lexeme,
     ada.Strings.unbounded,
     ada.Containers.Vectors;


package asl2ada.Error
is
   use ada.Strings.unbounded;


   type Item is
      record
         Lexeme  : asl2ada.Lexeme.item;
         Message : unbounded_String;
      end record;


   package Vectors is new ada.Containers.Vectors (Positive, Item);
   subtype Items   is Vectors.Vector;

end asl2ada.Error;
