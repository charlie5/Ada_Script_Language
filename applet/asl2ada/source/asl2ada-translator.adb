with
     asl2ada.Token,
     asl2ada.Lexeme,
     asl2ada.Model.Unit.asl_Applet,
     asl2ada.Model.Expression,
     asl2ada.Model.Statement.call,
     asl2ada.Model.Statement.block,
     asl2ada.Model.Statement.for_loop,
     asl2ada.Model.Statement.a_null,

     ada.Strings.unbounded;


package body asl2ada.Translator
is
   use ada.Strings.unbounded;


   function "+" (From : in unbounded_String) return String
                 renames to_String;



   procedure add_with_of_Asl_Ada_Core (to_Source : in out unbounded_String)
   is
   begin
      insert (to_Source, before   => 1,
                         new_Item => "with Asl_Ada.core;   use Asl_Ada.core;" & NL);
   end add_with_of_Asl_Ada_Core;



   procedure add_with_of_Gnat_formatted_String (to_Source : in out unbounded_String)
   is
   begin
      insert (to_Source, before   => 1,
                         new_Item => "with gnat.formatted_String;" & NL);
   end add_with_of_Gnat_formatted_String;



   procedure add_with_of_Ada_Text_IO (to_Source : in out unbounded_String)
   is
   begin
      insert (to_Source, before   => 1,
                         new_Item => "with ada.Text_IO;" & NL);
   end add_with_of_Ada_Text_IO;







   procedure translate_Statements (the_Statements : in     model.Statement.vector;
                                   indent_Level   : in out Positive;
                                   ada_Source     : in out uString)
   is
      use Token;


      function Indent return String
      is
      begin
         return +indent_Level * "   ";
      end Indent;


      procedure add (Fragment : in String)
      is
      begin
         append (ada_Source, Fragment);
      end add;


      procedure new_Line
      is
      begin
         append (ada_Source, NL);
      end new_Line;


   begin
      for Each of the_Statements
      loop
         dlog ("Translating statement: " & Each.all'Image);

         if Each.all in model.Statement.call.item'Class
         then
            declare
               Call : constant model.Statement.call.view    := Model.Statement.Call.view (Each);
               Args :          model.Expression.vector renames Call.Arguments;
            begin
               if Call.Name = "log"
               then
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
                           Arg : constant model.Expression.view := Args (i);
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
                              Arg : constant model.Expression.view := Args (i);
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


         elsif Each.all in model.Statement.for_Loop.item'Class
         then
            declare
               for_Loop : constant Model.Statement.for_loop.view := Model.Statement.for_loop.view (Each);
            begin
               add (Indent & "for " & for_Loop.Variable & " in " & for_Loop.Lower & " .. " & for_Loop.Upper & NL);
               add (Indent & "loop" & NL);

               --  dlog ("Statement Count:" & for_Loop.Statements.Length'Image);
               translate_Statements (for_Loop.Statements, indent_Level, ada_Source);     -- Recurse.

               add (Indent & "end loop;" & NL);
            end;


         elsif Each.all in model.Statement.a_null.item'Class
         then
            indent_Level := indent_Level + 1;
            add (Indent & "null;" & NL);
            indent_Level := indent_Level - 1;


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






   function translate_Applet (the_Applet : in Model.Unit.asl_Applet.view) return String
   is
      use type ada.Containers.Count_type;

      ada_Source   : unbounded_String;
      indent_Level : Natural := 0;


      function Indent return String
      is
      begin
         return +indent_Level * "   ";
      end Indent;


      procedure add (Fragment : in String)
      is
      begin
         append (ada_Source, Fragment);
      end add;


      procedure new_Line
      is
      begin
         append (ada_Source, NL);
      end new_Line;


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
      new_Line;
      add ("procedure " & the_Applet.Name & NL);
      add ("is"                           & NL);
      add ("begin"                        & NL);


      translate_do_Block:
      declare
         --  do_Block : model.Statement.Block.view;
      begin
         indent_Level := indent_Level + 1;

         add (Indent & "do_Block:" & NL);
         add (Indent & "begin"     & NL);

         indent_Level := indent_Level + 1;
         translate_Statements (the_Applet.do_Block.Statements, indent_Level, ada_Source);
         indent_Level := indent_Level - 1;

         add (Indent & "end do_Block;" & NL);
      end translate_do_Block;


      indent_Level := indent_Level - 1;
      add (Indent & "end " & the_Applet.Name & ";" & NL);

      return +ada_Source;
   end translate_Applet;




   function translate_Class (the_Unit : in Model.Unit.view) return String
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




   function translate_Module (the_Unit : in Model.Unit.view) return String
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




   function translate (Source : in String;   unit_Name : in String;
                                             of_Kind   : in Parser.unit_Kind) return String
   is

      function comment_stripped_Source return String
      is
         Result : String (Source'Range);
         Index  : Natural := 0;
         Skip   : Boolean := False;
      begin
         for i in Source'First .. Source'Last - 1
         loop
            if    Source (i)     = '-'
              and Source (i + 1) = '-'
            then
               Skip := True;
            end if;

            if Skip
            then
               if Source (i) = NL
               then
                  Skip           := False;
                  Index          := Index + 1;
                  Result (Index) := NL;
               end if;
            else
               Index          := Index + 1;
               Result (Index) := Source (i);
            end if;
         end loop;

         if    not Skip
           and Source (Source'Last) /= '-'
         then
            Index          := Index + 1;
            Result (Index) := Source (Source'Last);
         end if;

         return Result (1 .. Index);
      end comment_stripped_Source;


      ada_Source :          unbounded_String;
      the_Unit   : constant asl2ada.Model.Unit.view := asl2ada.Parser.to_Unit (comment_stripped_Source, unit_Name, of_Kind);
   begin
      --  dlog ("Translating '" & unit_Name & "' " & to_Lower (of_Kind'Image) & ".");

      add_with_of_Asl_Ada_Core          (to_Source => ada_Source);
      add_with_of_Gnat_formatted_String (to_Source => ada_Source);
      add_with_of_Ada_Text_IO (to_Source => ada_Source);

      case of_Kind
      is
         when Parser.Applet =>   append (ada_Source, translate_Applet (model.Unit.asl_Applet.view (the_Unit)));
         when Parser.Class  =>   return translate_Class  (the_Unit);
         when Parser.Module =>   return translate_Module (the_Unit);
      end case;

      return +ada_Source;
   end translate;


end asl2ada.Translator;