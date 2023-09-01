with
     --  asl2ada.Model,
     asl2ada.parser_Model.Unit,
     --  asl2ada.Token,
     --  asl2ada.Lexer,

     ada.Containers.vectors;
     --  ada.Containers.indefinite_Vectors,
     --  ada.Strings.text_Buffers,
     --  ada.Strings.unbounded;


package asl2ada.Resolver
is
   type unit_Kind is (Applet, Class, Module);     -- Kind of compilation unit.


   function to_Unit (Source : in String;   unit_Name : in String;
                                           of_Kind   : in unit_Kind) return asl2ada.parser_Model.Unit.view;



   type Declaration      is tagged private;
   type Declaration_view is access all Declaration'Class;

   package Declaration_Vectors is new ada.Containers.Vectors (Positive, Declaration_view);
   subtype Declaration_Vector  is Declaration_Vectors.Vector;




   --  type Statement      is tagged private;
   --  type Statement_view is access all Statement'Class;
   --
   --  --  package Statement_vectors is new ada.Containers.Vectors (Positive, Statement_view);
   --  type Statements is new Statement with private;



   type Handler      is tagged private;
   type Handler_view is access all Handler'Class;

   package Handler_Vectors is new ada.Containers.Vectors (Positive, Handler_view);
   subtype Handler_Vector  is Handler_Vectors.Vector;



   --  type Block is
   --     record
   --        Declarations : Parser.Declaration_Vector;
   --        Statements   : Parser.Statements;
   --        Handlers     : Parser.Handler_Vector;
   --     end record;



private

   ----------------
   -- Declarations.
   --

   type Declaration is tagged
      record
         null; --Tokens : Token.Items;
      end record;




   ---------------
   --- Statements.
   --

   --  type Statement_view is access Statement'Class;

   --  package Statement_vectors is new ada.Containers.Vectors (Positive, Statement);


   --  type Statement is tagged
   --     record
   --        null; --Tokens : Token.Items;
   --     end record;


   --  type subprogram_Call is new Statement with
   --     record
   --        Name      : ada.Strings.unbounded.unbounded_String;
   --        Arguments : Strings;
   --     end record;


   --  package Statement_vectors is new ada.Containers.Vectors (Positive, Statement_view);
   --  package Statement_vectors is new ada.Containers.indefinite_Vectors (Positive, Statement);
   --  subtype Statement_vector  is Statement_vectors.Vector;
   --
   --  type Statements is new Statement with
   --     record
   --        Values : Statement_vector;
   --     end record;
   --


   ------------
   -- Handlers.
   --

   type Handler is tagged
      record
         null; --Tokens : Token.Items;
      end record;


end asl2ada.Resolver;
