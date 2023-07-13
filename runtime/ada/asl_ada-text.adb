with
     asl_Ada.fast_Pool;


package body asl_Ada.Text
is

   type lace_Text_1_view is access all lace_Text.item_1;

   package Text_1 is new fast_Pool
     (Item              => lace_Text.item_1,
      View              => lace_Text_1_view,
      Name              => "Text_1",
      initial_pool_Size => 1);



   type lace_Text_2_view is access all lace_Text.item_2;

   package Text_2 is new fast_Pool
     (Item              => lace_Text.item_2,
      View              => lace_Text_2_view,
      Name              => "Text_2",
      initial_pool_Size => 1);



   type lace_Text_4_view is access all lace_Text.item_4;

   package Text_4 is new fast_Pool
     (Item              => lace_Text.item_4,
      View              => lace_Text_4_view,
      Name              => "Text_4",
      initial_pool_Size => 1);



   type lace_Text_8_view is access all lace_Text.item_8;

   package Text_8 is new fast_Pool
     (Item              => lace_Text.item_8,
      View              => lace_Text_8_view,
      Name              => "Text_8",
      initial_pool_Size => 1);



   type lace_Text_16_view is access all lace_Text.item_16;

   package Text_16 is new fast_Pool
     (Item              => lace_Text.item_16,
      View              => lace_Text_16_view,
      Name              => "Text_16",
      initial_pool_Size => 1);



   type lace_Text_32_view is access all lace_Text.item_32;

   package Text_32 is new fast_Pool
     (Item              => lace_Text.item_32,
      View              => lace_Text_32_view,
      Name              => "Text_32",
      initial_pool_Size => 1);



   type lace_Text_64_view is access all lace_Text.item_64;

   package Text_64 is new fast_Pool
     (Item              => lace_Text.item_64,
      View              => lace_Text_64_view,
      Name              => "Text_64",
      initial_pool_Size => 1);



   type lace_Text_128_view is access all lace_Text.item_128;

   package Text_128 is new fast_Pool
     (Item              => lace_Text.item_128,
      View              => lace_Text_128_view,
      Name              => "Text_128",
      initial_pool_Size => 1);



   type lace_Text_256_view is access all lace_Text.item_256;

   package Text_256 is new fast_Pool
     (Item              => lace_Text.item_256,
      View              => lace_Text_256_view,
      Name              => "Text_256",
      initial_pool_Size => 1);



   type lace_Text_512_view is access all lace_Text.item_512;

   package Text_512 is new fast_Pool
     (Item              => lace_Text.item_512,
      View              => lace_Text_512_view,
      Name              => "Text_512",
      initial_pool_Size => 1);



   type lace_Text_1k_view is access all lace_Text.item_1k;

   package Text_1k is new fast_Pool
     (Item              => lace_Text.item_1k,
      View              => lace_Text_1k_view,
      Name              => "Text_1k",
      initial_pool_Size => 1);



   type lace_Text_2k_view is access all lace_Text.item_2k;

   package Text_2k is new fast_Pool
     (Item              => lace_Text.item_2k,
      View              => lace_Text_2k_view,
      Name              => "Text_2k",
      initial_pool_Size => 1);



   type lace_Text_4k_view is access all lace_Text.item_4k;

   package Text_4k is new fast_Pool
     (Item              => lace_Text.item_4k,
      View              => lace_Text_4k_view,
      Name              => "Text_4k",
      initial_pool_Size => 1);



   type lace_Text_8k_view is access all lace_Text.item_8k;

   package Text_8k is new fast_Pool
     (Item              => lace_Text.item_8k,
      View              => lace_Text_8k_view,
      Name              => "Text_8k",
      initial_pool_Size => 1);



   type lace_Text_16k_view is access all lace_Text.item_16k;

   package Text_16k is new fast_Pool
     (Item              => lace_Text.item_16k,
      View              => lace_Text_16k_view,
      Name              => "Text_16k",
      initial_pool_Size => 1);



   type lace_Text_32k_view is access all lace_Text.item_32k;

   package Text_32k is new fast_Pool
     (Item              => lace_Text.item_32k,
      View              => lace_Text_32k_view,
      Name              => "Text_32k",
      initial_pool_Size => 1);



   type lace_Text_64k_view is access all lace_Text.item_64k;

   package Text_64k is new fast_Pool
     (Item              => lace_Text.item_64k,
      View              => lace_Text_64k_view,
      Name              => "Text_64k",
      initial_pool_Size => 1);



   type lace_Text_128k_view is access all lace_Text.item_128k;

   package Text_128k is new fast_Pool
     (Item              => lace_Text.item_128k,
      View              => lace_Text_128k_view,
      Name              => "Text_128k",
      initial_pool_Size => 1);



   type lace_Text_256k_view is access all lace_Text.item_256k;

   package Text_256k is new fast_Pool
     (Item              => lace_Text.item_256k,
      View              => lace_Text_256k_view,
      Name              => "Text_256k",
      initial_pool_Size => 1);



   type lace_Text_512k_view is access all lace_Text.item_512k;

   package Text_512k is new fast_Pool
     (Item              => lace_Text.item_512k,
      View              => lace_Text_512k_view,
      Name              => "Text_512k",
      initial_pool_Size => 1);



   type lace_Text_1m_view is access all lace_Text.item_1m;

   package Text_1m is new fast_Pool
     (Item              => lace_Text.item_1m,
      View              => lace_Text_1m_view,
      Name              => "Text_1m",
      initial_pool_Size => 1);



   type lace_Text_2m_view is access all lace_Text.item_2m;

   package Text_2m is new fast_Pool
     (Item              => lace_Text.item_2m,
      View              => lace_Text_2m_view,
      Name              => "Text_2m",
      initial_pool_Size => 1);



   type lace_Text_4m_view is access all lace_Text.item_4m;

   package Text_4m is new fast_Pool
     (Item              => lace_Text.item_4m,
      View              => lace_Text_4m_view,
      Name              => "Text_4m",
      initial_pool_Size => 1);



   type lace_Text_8m_view is access all lace_Text.item_8m;

   package Text_8m is new fast_Pool
     (Item              => lace_Text.item_8m,
      View              => lace_Text_8m_view,
      Name              => "Text_8m",
      initial_pool_Size => 1);



   type lace_Text_16m_view is access all lace_Text.item_16m;

   package Text_16m is new fast_Pool
     (Item              => lace_Text.item_16m,
      View              => lace_Text_16m_view,
      Name              => "Text_16m",
      initial_pool_Size => 1);



   type lace_Text_32m_view is access all lace_Text.item_32m;

   package Text_32m is new fast_Pool
     (Item              => lace_Text.item_32m,
      View              => lace_Text_32m_view,
      Name              => "Text_32m",
      initial_pool_Size => 1);



   type lace_Text_64m_view is access all lace_Text.item_64m;

   package Text_64m is new fast_Pool
     (Item              => lace_Text.item_64m,
      View              => lace_Text_64m_view,
      Name              => "Text_64m",
      initial_pool_Size => 1);



   type lace_Text_128m_view is access all lace_Text.item_128m;

   package Text_128m is new fast_Pool
     (Item              => lace_Text.item_128m,
      View              => lace_Text_128m_view,
      Name              => "Text_128m",
      initial_pool_Size => 1);



   type lace_Text_256m_view is access all lace_Text.item_256m;

   package Text_256m is new fast_Pool
     (Item              => lace_Text.item_256m,
      View              => lace_Text_256m_view,
      Name              => "Text_256m",
      initial_pool_Size => 1);



   type lace_Text_512m_view is access all lace_Text.item_512m;

   package Text_512m is new fast_Pool
     (Item              => lace_Text.item_512m,
      View              => lace_Text_512m_view,
      Name              => "Text_512m",
      initial_pool_Size => 1);





   null_Text : constant Item := (Data => null);


   function to_Text (From : in String := "") return Item
   is
   begin
      if From = ""
      then
         return null_Text;
      end if;

      return null_Text;
   end to_Text;




   b  : constant :=     1;
   kb : constant := 1_024;
   mb : constant := 1_024 * kb;


   function to_Text (Capacity : in Natural := 0) return Item
   is
      Result : Item;
   begin
      if    Capacity  =   0*b  then   return null_Text;
      elsif Capacity  =   1*b  then   Result := (Data => lace_Text_view (Text_1   .new_Item));
      elsif Capacity  =   2*b  then   Result := (Data => lace_Text_view (Text_2   .new_Item));
      elsif Capacity <=   4*b  then   Result := (Data => lace_Text_view (Text_4   .new_Item));
      elsif Capacity <=   8*b  then   Result := (Data => lace_Text_view (Text_8   .new_Item));
      elsif Capacity <=  16*b  then   Result := (Data => lace_Text_view (Text_16  .new_Item));
      elsif Capacity <=  32*b  then   Result := (Data => lace_Text_view (Text_32  .new_Item));
      elsif Capacity <=  64*b  then   Result := (Data => lace_Text_view (Text_64  .new_Item));
      elsif Capacity <= 128*b  then   Result := (Data => lace_Text_view (Text_128 .new_Item));
      elsif Capacity <= 256*b  then   Result := (Data => lace_Text_view (Text_256 .new_Item));
      elsif Capacity <= 512*b  then   Result := (Data => lace_Text_view (Text_512 .new_Item));
      elsif Capacity <=   1*kb then   Result := (Data => lace_Text_view (Text_1k  .new_Item));
      elsif Capacity <=   2*kb then   Result := (Data => lace_Text_view (Text_2k  .new_Item));
      elsif Capacity <=   4*kb then   Result := (Data => lace_Text_view (Text_4k  .new_Item));
      elsif Capacity <=   8*kb then   Result := (Data => lace_Text_view (Text_8k  .new_Item));
      elsif Capacity <=  16*kb then   Result := (Data => lace_Text_view (Text_16k .new_Item));
      elsif Capacity <=  32*kb then   Result := (Data => lace_Text_view (Text_32k .new_Item));
      elsif Capacity <=  64*kb then   Result := (Data => lace_Text_view (Text_64k .new_Item));
      elsif Capacity <= 128*kb then   Result := (Data => lace_Text_view (Text_128k.new_Item));
      elsif Capacity <= 256*kb then   Result := (Data => lace_Text_view (Text_256k.new_Item));
      elsif Capacity <= 512*kb then   Result := (Data => lace_Text_view (Text_512k.new_Item));
      elsif Capacity <=   1*mb then   Result := (Data => lace_Text_view (Text_1m  .new_Item));
      elsif Capacity <=   2*mb then   Result := (Data => lace_Text_view (Text_2m  .new_Item));
      elsif Capacity <=   4*mb then   Result := (Data => lace_Text_view (Text_4m  .new_Item));
      elsif Capacity <=   8*mb then   Result := (Data => lace_Text_view (Text_8m  .new_Item));
      elsif Capacity <=  16*mb then   Result := (Data => lace_Text_view (Text_16m .new_Item));
      elsif Capacity <=  32*mb then   Result := (Data => lace_Text_view (Text_32m .new_Item));
      elsif Capacity <=  64*mb then   Result := (Data => lace_Text_view (Text_64m .new_Item));
      elsif Capacity <= 128*mb then   Result := (Data => lace_Text_view (Text_128m.new_Item));
      elsif Capacity <= 256*mb then   Result := (Data => lace_Text_view (Text_256m.new_Item));
      elsif Capacity <= 512*mb then   Result := (Data => lace_Text_view (Text_512m.new_Item));
      end if;

      return Result;
   end to_Text;



   procedure free (Self : in out Item)
   is
   begin
      if    Self.Data.Capacity  =   1*b  then   Text_1   .free (lace_Text_1_view    (Self.Data));
      elsif Self.Data.Capacity  =   2*b  then   Text_2   .free (lace_Text_2_view    (Self.Data));
      elsif Self.Data.Capacity <=   4*b  then   Text_4   .free (lace_Text_4_view    (Self.Data));
      elsif Self.Data.Capacity <=   8*b  then   Text_8   .free (lace_Text_8_view    (Self.Data));
      elsif Self.Data.Capacity <=  16*b  then   Text_16  .free (lace_Text_16_view   (Self.Data));
      elsif Self.Data.Capacity <=  32*b  then   Text_32  .free (lace_Text_32_view   (Self.Data));
      elsif Self.Data.Capacity <=  64*b  then   Text_64  .free (lace_Text_64_view   (Self.Data));
      elsif Self.Data.Capacity <= 128*b  then   Text_128 .free (lace_Text_128_view  (Self.Data));
      elsif Self.Data.Capacity <= 256*b  then   Text_256 .free (lace_Text_256_view  (Self.Data));
      elsif Self.Data.Capacity <= 512*b  then   Text_512 .free (lace_Text_512_view  (Self.Data));
      elsif Self.Data.Capacity <=   1*kb then   Text_1k  .free (lace_Text_1k_view   (Self.Data));
      elsif Self.Data.Capacity <=   2*kb then   Text_2k  .free (lace_Text_2k_view   (Self.Data));
      elsif Self.Data.Capacity <=   4*kb then   Text_4k  .free (lace_Text_4k_view   (Self.Data));
      elsif Self.Data.Capacity <=   8*kb then   Text_8k  .free (lace_Text_8k_view   (Self.Data));
      elsif Self.Data.Capacity <=  16*kb then   Text_16k .free (lace_Text_16k_view  (Self.Data));
      elsif Self.Data.Capacity <=  32*kb then   Text_32k .free (lace_Text_32k_view  (Self.Data));
      elsif Self.Data.Capacity <=  64*kb then   Text_64k .free (lace_Text_64k_view  (Self.Data));
      elsif Self.Data.Capacity <= 128*kb then   Text_128k.free (lace_Text_128k_view (Self.Data));
      elsif Self.Data.Capacity <= 256*kb then   Text_256k.free (lace_Text_256k_view (Self.Data));
      elsif Self.Data.Capacity <= 512*kb then   Text_512k.free (lace_Text_512k_view (Self.Data));
      elsif Self.Data.Capacity <=   1*mb then   Text_1m  .free (lace_Text_1m_view   (Self.Data));
      elsif Self.Data.Capacity <=   2*mb then   Text_2m  .free (lace_Text_2m_view   (Self.Data));
      elsif Self.Data.Capacity <=   4*mb then   Text_4m  .free (lace_Text_4m_view   (Self.Data));
      elsif Self.Data.Capacity <=   8*mb then   Text_8m  .free (lace_Text_8m_view   (Self.Data));
      elsif Self.Data.Capacity <=  16*mb then   Text_16m .free (lace_Text_16m_view  (Self.Data));
      elsif Self.Data.Capacity <=  32*mb then   Text_32m .free (lace_Text_32m_view  (Self.Data));
      elsif Self.Data.Capacity <=  64*mb then   Text_64m .free (lace_Text_64m_view  (Self.Data));
      elsif Self.Data.Capacity <= 128*mb then   Text_128m.free (lace_Text_128m_view (Self.Data));
      elsif Self.Data.Capacity <= 256*mb then   Text_256m.free (lace_Text_256m_view (Self.Data));
      elsif Self.Data.Capacity <= 512*mb then   Text_512m.free (lace_Text_512m_view (Self.Data));
      end if;
   end free;


end asl_Ada.Text;
