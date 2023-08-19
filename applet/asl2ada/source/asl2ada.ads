with
     ada.Containers.indefinite_Vectors,
     ada.Strings.unbounded;

private
with
     ada.Text_IO,
     ada.Characters.latin_1;


package Asl2Ada
is

   package String_vectors is new ada.Containers.indefinite_Vectors (Positive, String);
   subtype Strings        is String_vectors.Vector;

   subtype uString is ada.Strings.unbounded.unbounded_String;
   function "+" (From : uString) return  String renames ada.Strings.unbounded.to_String;
   function "+" (From :  String) return uString renames ada.Strings.unbounded.to_unbounded_String;



private

   NL : constant Character := ada.Characters.latin_1.LF;


   procedure log  (Message   : in String);
   procedure log  (new_Lines : in ada.Text_IO.positive_Count := 1);


   debugging : constant Boolean := True;
   --  debugging : constant Boolean := False;

   procedure dlog (Message   : in String);
   procedure dlog (new_Lines : in ada.Text_IO.positive_Count := 1);

end Asl2Ada;
