private
package asl_Ada.Text.Pools
is

   function  to_Text (Size : in     Natural := 0) return Text.item;
   procedure free    (Self : in out Text.item);

end asl_Ada.Text.Pools;
