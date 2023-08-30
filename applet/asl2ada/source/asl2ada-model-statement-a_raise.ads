with
     asl2ada.Model.an_Exception,
     ada.Containers.Vectors;


package asl2ada.Model.Statement.a_raise
is
   type Item is new Statement.item with private;
   type View is access all Item'Class;


   package Forge
   is
      --  function new_raise_Statement (Raises : in an_Exception.view) return View;
      function new_raise_Statement (Raises : in Identifier) return View;
   end Forge;


   package Vectors is new ada.Containers.Vectors (Positive, View);
   subtype Vector  is Vectors.Vector;


   --  function Raises (Self : in Item) return an_Exception.view;
   function Raises (Self : in Item) return Identifier;



private

   type Item is new Statement.item with
      record
         --  Raises : an_Exception.view;
         Raises : uString;
      end record;


end asl2ada.Model.Statement.a_raise;
