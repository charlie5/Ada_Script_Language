with
     asl2ada.Token,
     asl2ada.Lexeme,

     asl2ada.parser_Model.Unit.asl_Applet,
     asl2ada.parser_Model.Expression,
     asl2ada.parser_Model.Declaration.of_exception,
     asl2ada.parser_Model.Declaration.of_variable,
     asl2ada.parser_Model.Handler,
     asl2ada.parser_Model.Statement.call,
     asl2ada.parser_Model.Statement.block,
     asl2ada.parser_Model.Statement.for_loop,
     asl2ada.parser_Model.Statement.a_null,
     asl2ada.parser_Model.Statement.a_raise,
     asl2ada.parser_Model.DB,

     asl2ada.Generator,

     ada.Strings.unbounded;


package body asl2ada.Translator
is
   use ada.Strings.unbounded;


   function "+" (From : in unbounded_String) return String
                 renames to_String;



   procedure add_with_of_Asl_Ada_Core (to_Source : in out unbounded_String)
   is
   begin
      insert (to_Source,
              before   => 1,
              new_Item => "with Asl_Ada.core;   use Asl_Ada.core;" & NL);
   end add_with_of_Asl_Ada_Core;



   procedure add_with_of_Gnat_formatted_String (to_Source : in out unbounded_String)
   is
   begin
      insert (to_Source,
              before   => 1,
              new_Item => "with gnat.formatted_String;" & NL);
   end add_with_of_Gnat_formatted_String;



   procedure add_with_of_Ada_Text_IO (to_Source : in out unbounded_String)
   is
   begin
      insert (to_Source,
              before   => 1,
              new_Item => "with ada.Text_IO;" & NL);
   end add_with_of_Ada_Text_IO;



   procedure add_with_of_Ada_unchecked_Deallocation (to_Source : in out unbounded_String)
   is
   begin
      insert (to_Source,
              before   => 1,
              new_Item => "with ada.unchecked_Deallocation;" & NL);
   end add_with_of_Ada_unchecked_Deallocation;



   procedure add_with_of_Ada_Exceptions (to_Source : in out unbounded_String)
   is
   begin
      insert (to_Source,
              before   => 1,
              new_Item => "with ada.Exceptions;" & NL);
   end add_with_of_Ada_Exceptions;



   procedure translate_Declarations (the_Declarations : in     parser_Model.Declaration.vector;
                                     indent_Level     : in out Positive;
                                     ada_Source       : in out uString)
   is
      use Token;

      function  Indent      return String  is begin   return +indent_Level * "   ";    end Indent;
      procedure add (Fragment : in String) is begin   append (ada_Source, Fragment);   end add;
      procedure new_Line                   is begin   append (ada_Source, NL);         end new_Line;

   begin
      for Each of the_Declarations
      loop
         dlog ("Translating declaration: " & Each.all'Image);

         if Each.all in parser_Model.Declaration.of_variable.item'Class
         then
            declare
               Variable : constant parser_Model.Declaration.of_variable.view := parser_Model.Declaration.of_variable.view (Each);
            begin
               add (Indent);
               add (Variable.Identifier);
               add (" : ");
               add (Variable.my_Type);
               add (";");
               new_Line;
            end;

         elsif Each.all in parser_Model.Declaration.of_exception.item'Class
         then
            declare
               the_Exception : constant parser_Model.Declaration.of_exception.view := parser_Model.Declaration.of_exception.view (Each);
            begin
               add (Indent);
               add (the_Exception.Name);
               add (" : ");
               add ("exception");
               add (";");
               new_Line;

               if the_Exception.is_Extended
               then
                  new_Line;
                  add (Indent);
                  add ("type ");
                  add (the_Exception.Name);
                  add ("_Data is");
                  new_Line;
                  add (Indent);
                  add ("   record");

                  for Each of the_Exception.Components
                  loop
                     new_Line;
                     add (Indent);
                     add ("      ");
                     add (Each.Identifier);
                     add (" : ");
                     add (Each.my_Type);
                     add (";");
                  end loop;

                  new_Line;
                  add (Indent);
                  add ("   end record;");
               end if;


               new_Line;
               new_Line;
               add (Indent);
               add ("package ");
               add (the_Exception.Name);
               add ("_Conversions is new system.Address_to_Access_conversions (");
               add (the_Exception.Name);
               add ("_Data");
               add (");");

               new_Line;
               add (Indent);
               add ("subtype ");
               add (the_Exception.Name & "_Data_view");
               add ("   is ");
               add (the_Exception.Name & "_Conversions.Object_pointer;");
               new_Line;
            end;

         else
            dlog ("Unhandled declaration found:");
            dlog (Each.all'Image);
         end if;

      end loop;
   end translate_Declarations;




   procedure translate_Statements (the_Statements : in     parser_Model.Statement.vector;
                                   indent_Level   : in out Positive;
                                   ada_Source     : in out uString)
   is
      use Token;


      function  Indent      return String  is begin   return +indent_Level * "   ";    end Indent;
      procedure add (Fragment : in String) is begin   append (ada_Source, Fragment);   end add;
      procedure new_Line                   is begin   append (ada_Source, NL);         end new_Line;

   begin
      for Each of the_Statements
      loop
         dlog ("Translating statement: " & Each.all'Image);

         if Each.all in parser_Model.Statement.call.item'Class
         then
            declare
               Call : constant parser_Model.Statement.call.view    := parser_Model.Statement.Call.view (Each);
               Args :          parser_Model.Expression.vector renames Call.Arguments;
            begin
               if Call.Name = "log"
               then
                  indent_Level := indent_Level + 1;

                  declare
                     Format : constant String := '"' & Args (1).all.to_String & '"';
                  begin
                     add (Indent & "declare"                                                   & NL);
                     add (Indent & "   use gnat.formatted_String;"                             & NL);
                     add (Indent & "   Format : constant formatted_String := +" & Format & ';' & NL);
                     add (Indent & "begin"                                                     & NL);


                     add (Indent & "   ada.Text_IO.put_Line (-(Format");

                     for i in 2 .. Integer (Args.Length)
                     loop
                        declare
                           Arg : constant parser_Model.Expression.view := Args (i);
                        begin
                           add (" & ");

                           for t in 1 .. Integer (Arg.Tokens.Length)
                           loop
                              declare
                                 Token : asl2ada.Token.item renames Arg.Tokens.Element (t);
                              begin
                                 if Token.Kind = integer_literal_Token
                                 then
                                    if         t > 1
                                      and then Arg.Tokens.Element (t - 1).Kind = exponential_Token
                                    then
                                       add ("Natural' (" & (+Token.Lexeme.Text) & ")");     -- An exponent must be a 'Natural'.
                                    else
                                       add ("Integer' (" & (+Token.Lexeme.Text) & ")");
                                    end if;

                                 elsif Token.Kind = string_literal_Token
                                 then
                                    add ('"' & (+Token.string_Value) & '"');

                                 else
                                    add (+Token.Lexeme.Text);
                                 end if;
                              end;
                           end loop;
                        end;
                     end loop;

                     add ("));"           & NL);
                     add (Indent & "end;" & NL & NL);
                  end;

                  indent_Level := indent_Level - 1;


               else     -- A standard call.
                  add (Indent & Call.Name);

                  if not Call.Arguments.is_Empty
                  then
                     add (" (");

                     for i in 1 .. Integer (Args.Length)
                     loop
                        if i > 1
                        then
                           add (", ");
                        end if;

                        for i in 1 .. Integer (Args.Length)
                        loop
                           declare
                              Arg : constant parser_Model.Expression.view := Args (i);
                           begin
                              for Each of Arg.Tokens
                              loop
                                 add (" " & (+Each.Lexeme.Text));
                              end loop;
                           end;
                        end loop;
                     end loop;

                     add (");" & NL);
                  end if;
               end if;
            end;


         elsif Each.all in parser_Model.Statement.for_Loop.item'Class
         then
            declare
               for_Loop : constant parser_Model.Statement.for_loop.view := parser_Model.Statement.for_loop.view (Each);
            begin
               add (Indent & "for " & for_Loop.Variable & " in " & for_Loop.Lower & " .. " & for_Loop.Upper & NL);
               add (Indent & "loop" & NL);

               --  dlog ("Statement Count:" & for_Loop.Statements.Length'Image);
               translate_Statements (for_Loop.Statements, indent_Level, ada_Source);     -- Recurse.

               add (Indent & "end loop;" & NL);
            end;


         elsif Each.all in parser_Model.Statement.a_null.item'Class
         then
            indent_Level := indent_Level + 1;
            add (Indent & "null;" & NL);
            indent_Level := indent_Level - 1;


         elsif Each.all in parser_Model.Statement.a_raise.item'Class
         then
            declare
               use      asl2ada.parser_Model;
               use type asl2ada.parser_Model.Declaration.of_variable.view;

               the_Raise     : constant parser_Model.Statement.a_raise.view        := parser_Model.Statement.a_raise.view (Each);
               the_Exception : constant parser_Model.Declaration.of_exception.view := parser_Model.DB.fetch (+the_Raise.Raises);
            begin
               if the_Exception.is_Extended
               then
                  indent_Level := indent_Level + 1;

                  add (Indent);
                  add ("declare");
                  new_Line;

                  add (Indent);
                  add ("   the_");
                  add (the_Exception.Name & "_Data");
                  add ("         : constant ");
                  add (the_Exception.Name);
                  add ("_Data_view := new ");
                  add (the_Exception.Name & "_Data");

                  add ("' (");
                  declare
                     i : Natural := 0;
                  begin
                     for Component of the_Exception.Components
                     loop
                        i := i + 1;
                        add (Component.Identifier);
                        add (" => ");
                        add (the_Raise.Values.Element (i));

                        if Component /= the_Exception.Components.last_Element
                        then
                           add (",");
                           new_Line;
                           add (Indent);
                           add ("                                                                                  ");
                        end if;
                     end loop;
                  end;
                  add (");");

                  new_Line;
                  add (Indent);
                  add ("   the_" & the_Exception.Name & "_Data_address : constant system.Address     := the_" & the_Exception.Name & "_Data.all'Address;");

                  new_Line;
                  add (Indent);
                  add ("   the_" & the_Exception.Name & "_Data_string  : constant address_Buffer     := to_Buffer (the_" & the_Exception.Name & "_Data_address);");

                  new_Line;
                  add (Indent);
                  add ("begin");
                  new_Line;

                  add (Indent);
                  add ("   raise ");
                  add (the_Exception.Name);
                  add (" with ");
                  add ("the_" & the_Exception.Name & "_Data_string");
                  add (";");

                  new_Line;
                  add (Indent);
                  add ("end;");
                  new_Line;

                  indent_Level := indent_Level - 1;

               else
                  indent_Level := indent_Level + 1;
                  add (Indent);
                  add ("raise ");
                  add (+the_Raise.Raises);
                  add (";");
                  new_Line;
                  indent_Level := indent_Level - 1;
               end if;
            end;



            --  declare
            --     the_gl_Error_Data         : constant gl_Error_Data_view := new gl_Error_Data' (Code => 5,
            --                                                                                    Name => to_unbounded_String ("Invalid context."));
            --     the_gl_Error_Data_address : constant system.Address     := the_gl_Error_Data.all'Address;
            --     the_gl_Error_Data_string  : constant address_Buffer     := to_Buffer (the_gl_Error_Data_address);
            --  begin
            --     raise gl_Error with the_gl_Error_Data_string;
            --  end;





         else     -- Assume raw Ada.
            declare
               prior_L : Lexeme.item;
            begin
               for i in 1 .. Integer (Each.Lexemes.Length)
               loop
                  declare
                     L : Lexeme.item renames Each.Lexemes.Element (i);


                     function next_L return Lexeme.item
                     is
                        Result : Lexeme.item;
                     begin
                        if i < Integer (Each.Lexemes.Length)
                        then
                           Result := Each.Lexemes.Element (i + 1);
                        end if;

                        return Result;
                     end next_L;


                  begin
                     if i /= 1
                     then
                        add (" ");
                     end if;

                     prior_L := L;
                  end;
               end loop;
            end;
         end if;

      end loop;
   end translate_Statements;






   procedure translate_Handlers (the_Handlers : in     parser_Model.Handler.vector;
                                 indent_Level : in out Positive;
                                 ada_Source   : in out uString)
   is
      use Token;

      function  Indent      return String  is begin   return +indent_Level * "   ";    end Indent;
      procedure add (Fragment : in String) is begin   append (ada_Source, Fragment);   end add;
      procedure new_Line                   is begin   append (ada_Source, NL);         end new_Line;

   begin
      dlog (3);
      dlog ("translator.translate_Handlers:");

      if the_Handlers.is_Empty
      then
         dlog ("translator.translate_Handlers: NO Exceptions !!!");
         return;
      end if;

      new_Line;
      new_Line;
      add (Indent);
      add ("exception");
      new_Line;

      for Each of the_Handlers
      loop
         declare
            the_Exception : parser_Model.Declaration.of_exception.view := parser_Model.DB.fetch (Each.Name);
         begin
            dlog ("Translating handler: ");
            dlog (Each.all'Image);

            indent_Level := indent_Level + 1;

            if the_Exception.is_extended
            then
               add (Indent);
               add ("when E : " & Each.Name & " => ");
               new_Line;

               indent_Level := indent_Level + 1;

               add (Indent);
               add ("declare");
               new_Line;

               indent_Level := indent_Level + 1;

               add (Indent);
               add ("use Asl_Ada.core;");
               new_Line;

               add (Indent);
               add ("procedure deallocate is new ada.unchecked_Deallocation (");
               add (Each.Name & "_Data, " & Each.Name & "_Data_view);");
               new_Line;

               new_Line;

               add (Indent);
               add ("Buffer   : constant address_Buffer     := ada.Exceptions.exception_Message (E);");
               new_Line;

               add (Indent);
               add ("Address  : constant system.Address     := to_Address (Buffer);");
               new_Line;

               add (Indent);
               add (Each.Name & " :          " & Each.Name & "_Data_view := " & Each.Name & "_Conversions.to_Pointer (Address);");
               new_Line;
               --  add ("         Message  : constant String             := " & Each.Name & ".all'Image;");

               new_Line;

               indent_Level := indent_Level - 1;

               add (Indent);
               add ("begin");
               new_Line;

               translate_Statements (Each.Statements,
                                     indent_Level,
                                     ada_Source);

               indent_Level := indent_Level + 1;
               add (Indent);
               add ("deallocate (" & Each.Name & ");");
               new_Line;
               indent_Level := indent_Level - 1;

               --  add ("         raise " & applet_Package_Name & "." & Each.Name & " with Message;");
               --  new_Line;


               add (Indent);
               add ("end;");
               new_Line;
               new_Line;

               indent_Level := indent_Level - 1;

            else
               add (Indent);
               add ("when " & Each.Name & " =>");
               new_Line;

               translate_Statements (Each.Statements,
                                     indent_Level,
                                     ada_Source);
            end if;
         end;

         indent_Level := indent_Level - 1;


         declare
            --  Variable : constant parser_Model.Declaration.of_variable.view := parser_Model.Declaration.of_variable.view (Each);
         begin
            null;
            --  add (Indent);
            --  add (Variable.Identifier);
            --  add (" : ");
            --  add (Variable.my_Type);
            --  add (";");
            --  new_Line;
         end;

      end loop;
   end translate_Handlers;





   --  function translate_Applet (the_Applet : in parser_Model.Unit.asl_Applet.view) return String
   --  is
   --     use type ada.Containers.Count_type;
   --
   --     ada_Source   : unbounded_String;
   --     indent_Level : Natural := 0;
   --
   --
   --     function Indent return String
   --     is
   --     begin
   --        return +indent_Level * "   ";
   --     end Indent;
   --
   --
   --     procedure add (Fragment : in String)
   --     is
   --     begin
   --        append (ada_Source, Fragment);
   --     end add;
   --
   --
   --     procedure new_Line
   --     is
   --     begin
   --        append (ada_Source, NL);
   --     end new_Line;
   --
   --
   --  begin
   --     if the_Applet.Context.Withs.Length > 0
   --     then
   --        add ("with");
   --        new_Line;
   --
   --        for i in 1 .. Integer (the_Applet.Context.Withs.Length)
   --        loop
   --           declare
   --              Length    : constant Natural := Integer (the_Applet.Context.Withs.Length);
   --              unit_Name : constant String  := the_Applet.Context.Withs (i);
   --           begin
   --              if i = Length then add ("     " & unit_Name & ";" & NL);
   --                            else add ("     " & unit_Name & ",");
   --              end if;
   --           end;
   --        end loop;
   --     end if;
   --
   --
   --     new_Line;
   --     new_Line;
   --     add ("procedure " & the_Applet.Name & "_Applet.launch" & NL);
   --     add ("is"                                              & NL);
   --     add ("begin"                                           & NL);
   --
   --
   --     translate_do_Block:
   --     declare
   --        --  do_Block : model.Statement.Block.view;
   --     begin
   --        indent_Level := indent_Level + 1;
   --
   --        add (Indent & "do_Block:" & NL);
   --        add (Indent & "begin"     & NL);
   --
   --        indent_Level := indent_Level + 1;
   --        translate_Statements (the_Applet.do_Block.Statements, indent_Level, ada_Source);
   --        indent_Level := indent_Level - 1;
   --
   --        add (Indent & "end do_Block;" & NL);
   --     end translate_do_Block;
   --
   --
   --     indent_Level := indent_Level - 1;
   --     add (Indent & "end " & the_Applet.Name & "_Applet.launch;" & NL);
   --
   --     return +ada_Source;
   --  end translate_Applet;




   function translate_Class (the_Unit : in parser_Model.Unit.view) return String
   is
      ada_Source :   uString;


      procedure add (Fragment : in String)
      is
      begin
         append (ada_Source, Fragment);
      end add;

   begin
      return +ada_Source;
   end translate_Class;




   function translate_Module (the_Unit : in parser_Model.Unit.view) return String
   is
      ada_Source : uString;


      procedure add (Fragment : in String)
      is
      begin
         append (ada_Source, Fragment);
      end add;


   begin
      return +ada_Source;
   end translate_Module;




   --  function to_applet_spec_Ada_Source (Source : in String;   unit_Name : in String) return String
   function to_applet_spec_Ada_Source (the_Unit : in asl2ada.parser_Model.Unit.view;   unit_Name : in String) return String
   is
      --  the_Unit   : constant asl2ada.parser_Model.Unit.view    := asl2ada.Parser.to_Unit (Source, unit_Name, Parser.Applet);
      the_Applet : constant parser_Model.Unit.asl_Applet.view := parser_Model.Unit.asl_Applet.view (the_Unit);
      ada_Source :          unbounded_String;

      use type ada.Containers.Count_type;
      indent_Level : Natural := 0;

      function  Indent      return String  is begin   return +indent_Level * "   ";    end Indent;
      procedure add (Fragment : in String) is begin   append (ada_Source, Fragment);   end add;
      procedure new_Line                   is begin   append (ada_Source, NL);         end new_Line;

      applet_Package_Name : constant String := unit_Name & "_Applet";

   begin
      if the_Applet.Context.Withs.Length > 0
      then
         add ("with");
         new_Line;

         for i in 1 .. Integer (the_Applet.Context.Withs.Length)
         loop
            declare
               Length    : constant Natural := Integer (the_Applet.Context.Withs.Length);
               unit_Name : constant String  := the_Applet.Context.Withs (i);
            begin
               if i = Length then add ("     " & unit_Name & ";" & NL);
               else add ("     " & unit_Name & ",");
               end if;
            end;
         end loop;
      end if;

      new_Line;
      add ("with System.Address_to_Access_conversions;");


      new_Line;
      new_Line;
      add ("package " & applet_Package_Name   & NL);
      add ("is"                               & NL);

      indent_Level := indent_Level + 1;
      translate_Declarations (the_Applet.Declarations, indent_Level, ada_Source);
      indent_Level := indent_Level - 1;

      new_Line;
      new_Line;

      add ("   procedure open;"               & NL);
      add ("   procedure do_it;"              & NL);
      add ("   procedure close;"              & NL);
      add ("end " & applet_Package_Name & ";" & NL);

      return +ada_Source;
   end to_applet_spec_Ada_Source;




   --  function to_applet_body_Ada_Source (Source : in String;   unit_Name : in String) return String
   function to_applet_body_Ada_Source (the_Unit : in asl2ada.parser_Model.Unit.view;   unit_Name : in String) return String
   is
      --  the_Unit   : constant asl2ada.parser_Model.Unit.view    := asl2ada.Parser.to_Unit (Source, unit_Name, Parser.Applet);
      the_Applet : constant parser_Model.Unit.asl_Applet.view := parser_Model.Unit.asl_Applet.view (the_Unit);
      ada_Source :          unbounded_String;

      use type ada.Containers.Count_type;
      indent_Level : Natural := 0;

      function  Indent      return String  is begin   return +indent_Level * "   ";    end Indent;
      procedure add (Fragment : in String) is begin   append (ada_Source, Fragment);   end add;
      procedure new_Line                   is begin   append (ada_Source, NL);         end new_Line;

      applet_Package_Name : constant String := unit_Name & "_Applet";

   begin
      --  dlog ("Translating '" & unit_Name & "' " & to_Lower (of_Kind'Image) & ".");

      add_with_of_Asl_Ada_Core               (to_Source => ada_Source);
      add_with_of_Gnat_formatted_String      (to_Source => ada_Source);
      add_with_of_Ada_Text_IO                (to_Source => ada_Source);
      add_with_of_Ada_unchecked_Deallocation (to_Source => ada_Source);
      add_with_of_Ada_Exceptions             (to_Source => ada_Source);

      new_Line;
      new_Line;
      add ("package body " & applet_Package_Name   & NL);
      add ("is"                                    & NL);
      add ("   procedure open  is null;"           & NL);

      new_Line;
      new_Line;
      add ("   procedure close is null;"           & NL);


      new_Line;
      new_Line;
      add ("   procedure do_it"              & NL);
      add ("   is"                           & NL);
      add ("   begin"                        & NL);

      indent_Level := indent_Level + 1;
      translate_Statements (the_Applet.do_Block.Statements, indent_Level, ada_Source);
      indent_Level := indent_Level - 1;


      dlog (3);
      dlog ("the_Applet.do_Block.Handlers count: " & the_Applet.do_Block.Handlers.Length'Image);

      indent_Level := indent_Level + 1;
      translate_Handlers (the_Applet.do_Block.Handlers,
                          indent_Level,
                          ada_Source);
      indent_Level := indent_Level - 1;
      dlog (3);


      add ("   end do_it;"                   & NL);


      new_Line;
      new_Line;
      --  append (ada_Source, translate_Applet (model.Unit.asl_Applet.view (the_Unit)));

      new_Line;
      new_Line;
      add ("end " & applet_Package_Name & ";" & NL);

      return +ada_Source;
   end to_applet_body_Ada_Source;




   --  function to_applet_launch_Ada_Source (Source : in String;   unit_Name : in String) return String
   function to_applet_launch_Ada_Source (the_Unit : in asl2ada.parser_Model.Unit.view;   unit_Name : in String) return String
   is
      --  the_Unit   : constant asl2ada.parser_Model.Unit.view := asl2ada.Parser.to_Unit (Source, unit_Name, Parser.Applet);
      ada_Source :          unbounded_String;

      use type ada.Containers.Count_type;
      indent_Level : Natural := 0;

      function  Indent      return String  is begin   return +indent_Level * "   ";    end Indent;
      procedure add (Fragment : in String) is begin   append (ada_Source, Fragment);   end add;
      procedure new_Line                   is begin   append (ada_Source, NL);         end new_Line;

      applet_Package_Name : constant String := unit_Name & "_Applet";

   begin
      --  dlog ("Translating '" & unit_Name & "' " & to_Lower (of_Kind'Image) & ".");

      add ("with");
      add ("     ada.unchecked_Deallocation,");
      new_Line;
      add ("     ada.Exceptions,");
      new_Line;
      add ("     Asl_Ada.core;");
      new_Line;

      new_Line;
      add ("procedure " & applet_Package_Name & ".launch" & NL);
      add ("is"                                           & NL);
      add ("begin"                                        & NL);
      add ("   " & applet_Package_Name & ".open;"         & NL);
      add ("   " & applet_Package_Name & ".do_it;"        & NL);
      add ("   " & applet_Package_Name & ".close;"        & NL);
      new_line;
      add ("exception"                                    & NL);

      for Each of parser_Model.DB.fetch_Exceptions
      loop
         if Each.is_Extended
         then
            add ("   when E : " & Each.Name & " => ");
            new_Line;
            add ("      declare");
            new_Line;
            add ("         use Asl_Ada.core;");
            new_Line;

            add ("         procedure deallocate is new ada.unchecked_Deallocation (");
            add (Each.Name & "_Data, " & Each.Name & "_Data_view);");
            new_Line;
            new_Line;
            add ("         Buffer   : constant address_Buffer     := ada.Exceptions.exception_Message (E);");
            new_Line;
            add ("         Address  : constant system.Address     := to_Address (Buffer);");
            new_Line;
            add ("         " & Each.Name & " :          " & Each.Name & "_Data_view := " & Each.Name & "_Conversions.to_Pointer (Address);");
            new_Line;
            add ("         Message  : constant String             := " & Each.Name & ".all'Image;");

            new_Line;
            add ("      begin");
            new_Line;
            add ("         deallocate (" & Each.Name & ");");
            new_Line;
            add ("         raise " & applet_Package_Name & "." & Each.Name & " with Message;");
            new_Line;
            add ("      end;");
            new_Line;
            new_Line;
         end if;
      end loop;


      add ("   when others => "                           & NL);
      add ("      raise;"                                 & NL);
      add ("end " & applet_Package_Name & ".launch;"      & NL);

      return +ada_Source;
   end to_applet_launch_Ada_Source;



   --  function to_applet_launch_Ada_Source (Source : in String;   unit_Name : in String;
   --                                        of_Kind   : in Parser.unit_Kind) return String
   --  is
   --     ada_Source :          unbounded_String;
   --     the_Unit   : constant asl2ada.Model.Unit.view := asl2ada.Parser.to_Unit (Source, unit_Name, of_Kind);
   --  begin
   --     --  dlog ("Translating '" & unit_Name & "' " & to_Lower (of_Kind'Image) & ".");
   --
   --     add_with_of_Asl_Ada_Core          (to_Source => ada_Source);
   --     add_with_of_Gnat_formatted_String (to_Source => ada_Source);
   --     add_with_of_Ada_Text_IO           (to_Source => ada_Source);
   --
   --     case of_Kind
   --     is
   --        when Parser.Applet =>   append (ada_Source, translate_Applet (model.Unit.asl_Applet.view (the_Unit)));
   --        when Parser.Class  =>   return translate_Class  (the_Unit);
   --        when Parser.Module =>   return translate_Module (the_Unit);
   --     end case;
   --
   --     return +ada_Source;
   --  end to_applet_launch_Ada_Source;


end asl2ada.Translator;
