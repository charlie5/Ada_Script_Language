with
     ada.Strings.unbounded,
     ada.Containers.Vectors;


package asl2ada.Lexeme
is
   use ada.Strings.unbounded;


   type Item is
      record
         Text   : unbounded_String;
         Line   : Positive;
         Column : Positive;
      end record;


   package Vectors is new ada.Containers.Vectors (Positive,
                                                  Item);
   subtype Items   is Vectors.Vector;

end asl2ada.Lexeme;
