with
     asl_Ada.Text.Pools;


package body asl_Ada.Text
is

   function to_Text (From : in wide_String := "") return Item
   is
      Result : constant Item := Pools.to_Text (Capacity => From'Length);
   begin
      lace_Text.String_is (Result.Data.all, now => From);

      return Result;
   end to_Text;




   procedure destroy (Self : in out Item)
   is
   begin
      Pools.free (Self);
   end destroy;


end asl_Ada.Text;
