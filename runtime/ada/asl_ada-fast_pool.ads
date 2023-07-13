generic
   type Item is private;
   type View is access all Item;

   Name              : String;
   initial_pool_Size : Positive := 5_000;

   with procedure define  (Self :    out Item) is null;
   with procedure destroy (Self : in out Item) is null;


package asl_Ada.fast_Pool
is

   function  new_Item     return View;
   procedure free (Self : in out View);

end asl_Ada.fast_Pool;
