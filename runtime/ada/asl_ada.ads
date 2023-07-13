package Asl_Ada with Pure
is

   subtype Boolean  is     standard.Boolean;
   type    Glyph    is new standard.wide_Character;

   type    Integer  is new standard.long_Integer;
   subtype Natural  is     asl_Ada.Integer range 0 .. asl_Ada.Integer'Last;
   subtype Positive is     asl_Ada.Integer range 1 .. asl_Ada.Integer'Last;

   type    Real     is new standard.long_Float;

end Asl_Ada;
