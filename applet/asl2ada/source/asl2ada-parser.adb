with
     asl2ada.parser_Model.Unit.asl_Applet,
     asl2ada.parser_Model.Call,
     asl2ada.parser_Model.Expression,
     asl2ada.parser_Model.Declaration.of_variable,
     asl2ada.parser_Model.Statement.call,
     asl2ada.parser_Model.Statement.for_loop,
     asl2ada.parser_Model.Statement.a_null,
     asl2ada.parser_Model.Statement.a_raise,

     asl2ada.Lexer,
     asl2ada.Token,
     asl2ada.Error,

     ada.Characters.handling,
     ada.Strings.unbounded;


package body asl2ada.Parser
is
   use ada.Strings.unbounded;
       --  ada.Strings.fixed;


   --  function "+" (From : in String) return unbounded_String
   --                renames to_unbounded_String;
   --
   function "+" (From : in unbounded_String) return String
                 renames to_String;





   function parse_Context (From         : in     Token.vector;
                           i            : in out Positive;
                           Errors_found : in out Boolean) return parser_Model.Unit.context_Clauses
   is
      use Token;
      Tokens : Token.vector renames From;
      Result : parser_Model.Unit.context_Clauses;
   begin
      Outer:
      loop
         if Tokens (i).Kind = identifier_Token
         then
            declare
               withed_unit_Name : unbounded_String;
            begin
               loop
                  append (withed_unit_Name, Tokens (i).Identifier);
                  i := i + 1;

                  if Tokens (i).Kind = dot_Token
                  then
                     append (withed_unit_Name, ".");
                     i := i + 1;

                  elsif Tokens (i).Kind = comma_Token
                  then
                     i := i + 1;
                     exit;

                  elsif Tokens (i).Kind = semicolon_Token
                  then
                     Result.Withs.append (to_String (withed_unit_Name));
                     i := i + 1;
                     exit Outer;
                  end if;

               end loop;

               Result.Withs.append (to_String (withed_unit_Name));
            end;

         else
            Errors_found := True;
            exit Outer;
         end if;
      end loop Outer;


      return Result;
   end parse_Context;





   function parse_Expression (From : in Token.vector;   i : in out Positive) return parser_Model.Expression.view
   is
      Tokens :          Token.vector     renames From;
      Result : constant parser_Model.Expression.view := new parser_Model.Expression.item;

      use asl2ada.Token;


      function Current return Token.item
      is
      begin
         return Tokens (i);
      end Current;


   begin
      while i <= Integer (Tokens.Length)
      loop
         exit when    Current.Kind = comma_Token
                   or Current.Kind = right_parenthesis_Token;

         Result.add (Token => Current);
         i := i + 1;
      end loop;

      return Result;
   end parse_Expression;





   function parse_Declarations (From : in Token.vector;   i : in out Positive) return parser_Model.Declaration.vector
   is
      Tokens : Token.vector renames From;
      Result : parser_Model.Declaration.vector;

   begin
      while i <= Integer (Tokens.Length)
      loop
         dlog ("parse_Declarations ~ " & Tokens (i).Kind'Image);

         declare
            use asl2ada.Token;


            function Current return Token.item
            is
            begin
               return Tokens (i);
            end Current;


            function Next (Offset : in Positive := 1) return Token.item
            is
               next_Token : Token.item;
            begin
               if i + Offset <= Integer (Tokens.Length)
               then
                  next_Token := Tokens (i + Offset);
               end if;

               return next_Token;
            end Next;


         begin
            if Current.Kind = identifier_Token
            then
               declare
                  use parser_Model.Declaration.of_variable.Forge;
                  Variable : constant parser_Model.Declaration.of_variable.view := new_variable_Declaration (Identifier => +Current.Identifier);
               begin
                  i := i + 1;     -- Move to next token.
                  i := i + 1;     -- Skip colon token.
                  dlog (Current'Image);
                  Variable.Type_is (+Current.Identifier);

                  Result.append (parser_Model.Declaration.view (Variable));
               end;

               i := i + 1;        -- Skip semicolon.
            end if;

         end;

         i := i + 1;              -- Move to next token.
         dlog ("parse_Declarations ~ i:" & i'Image);
      end loop;


      return Result;
   end parse_Declarations;



   function parse_Statements (From : in Token.vector;   i : in out Positive) return parser_Model.Statement.vector
   is
      Tokens : Token.vector renames From;
      Result : parser_Model.Statement.vector;

   begin
      while i <= Integer (Tokens.Length)
      loop
         dlog ("parse_Statements ~ " & Tokens (i).Kind'Image);

         declare
            use asl2ada.Token;


            function Current return Token.item
            is
            begin
               return Tokens (i);
            end Current;


            function Next (Offset : in Positive := 1) return Token.item
            is
               Result : Token.item;
            begin
               if i + Offset <= Integer (Tokens.Length)
               then
                  Result := Tokens (i + Offset);
               end if;

               return Result;
            end Next;


         begin
            if Current.Kind = identifier_Token
            then
               declare
                  use parser_Model.Statement.Call.Forge;
                  Call : parser_Model.Statement.Call.view := new_Call_Statement (Name => +Current.Identifier);
               begin
                  i := i + 1;

                  if Current.Kind = left_parenthesis_Token
                  then               -- Parse arguments.
                     i := i + 1;     -- Skip left parenthesis.

                     loop
                        if Current.Kind /= comma_Token
                        then
                           --  dlog ("add arg");

                           Call.add_Argument (parse_Expression (From => Tokens, i => i));

                           --  if Current.Kind = string_literal_Token
                           --  then
                           --     Call.add_Argument ('"' & (+Current.string_Value) & '"');
                           --
                           --  else
                           --     Call.add_Argument (+Current.Lexeme.Text);
                           --  end if;
                        end if;

                        --  i := i + 1;
                        exit when Current.Kind = right_parenthesis_Token;
                        i := i + 1;     -- Skip ';' token.
                     end loop;
                  end if;

                  i := i + 1;     -- Skip right parenthesis.
                  i := i + 1;     -- Skip semicolon.

                  --  dlog ("Adding 'call' statement.");
                  --  dlog (Call.all'Image);
                  Result.append (parser_Model.Statement.view (Call));
               end;


            elsif Current.Kind = for_Token
            then
               declare
                  use parser_Model.Statement.for_loop.Forge;
                  for_Statement   : parser_Model.Statement.for_loop.view := new_for_loop_Statement (Variable => +Next.Identifier);
                  loop_Statements : parser_Model.Statement.vector;
               begin
                  i := i + 3;     -- Skip 'for', 'identifier' and 'in' tokens.
                  --  dlog ("159:" & Current.Kind'Image);
                  for_Statement.Lower_is (+Current.Lexeme.Text);

                  i := i + 2;     -- Skip 'lower' and '..' tokens.
                  for_Statement.Upper_is (+Current.Lexeme.Text);

                  i := i + 2;     -- Skip 'loop' token.

                  loop_Statements := parse_Statements (Tokens, i);     -- Recurse.
                  for_Statement.Statements_are (loop_Statements);

                  --  dlog ("my Adding 'for_loop' statement.");
                  Result.append (parser_Model.Statement.view (for_Statement));

                  -- i := i + 1;     -- Skip 'end', 'loop' and ';' tokens.
               end;


            elsif Current.Kind = null_Token
            then
               dlog ("Null token ~ i:" & i'Image);
               declare
                  use parser_Model.Statement.a_null.Forge;
                  null_Statement : parser_Model.Statement.a_null.view := new_null_Statement;
               begin
                  i := i + 2;     -- Skip 'null' and ';' tokens.
                  Result.append (parser_Model.Statement.view (null_Statement));
               end;


            elsif Current.Kind = end_Token
            then
               --  dlog ("END KKK");
               declare
               begin
                  i := i + 3;     -- Skip 'null' and ';' tokens.
                  exit;
               end;


            elsif Current.Kind = raise_Token
            then
               log (+Next.Identifier);

               declare
                  use parser_Model,
                      parser_Model.Statement.a_raise.Forge;
                  raise_Statement : parser_Model.Statement.a_raise.view := new_raise_Statement (Raises => +Next.Identifier);
               begin
                  i := i + 3;     -- Skip Identifier and ';' tokens.
                  Result.append (parser_Model.Statement.view (raise_Statement));
               end;


            else
               log ("KKKKKKKKKKKKKKKK " & Current'Image);
               declare
                  Statement : parser_Model.Statement.view := new parser_Model.Statement.item;
               begin
                  while Current.Kind /= semicolon_Token
                  loop
                     Statement.add (Current.Lexeme);
                     i := i + 1;
                  end loop;

                  Result.append (Statement);
                  i := i + 1;
               end;
            end if;
         end;

         --  i := i + 1;
         dlog ("i:" & i'Image);
      end loop;


      return Result;
   end parse_Statements;





   function parse_Applet (Source : in String;   unit_Name : in String) return asl2ada.parser_Model.Unit.view
   is
      use asl2ada.Token,
          asl2ada.Lexer,
          ada.Characters.handling;

      use type ada.Containers.Count_type;

      Errors        :          asl2ada.Error.items;
      Errors_found  :          Boolean                            := False;
      Tokens        :          Token.vector                       := Lexer.to_Tokens (Source, Errors);
      applet_Tokens :          Lexer.applet_Tokens                := Lexer.to_applet_Tokens (Tokens, unit_Name);
      Result        : constant asl2ada.parser_Model.Unit.asl_Applet.view := new asl2ada.parser_Model.Unit.asl_Applet.item;

   begin
      dlog (applet_Tokens'Image);


      -- log;
      -- log ("Source:");
      -- log;
      -- log (Source);
      -- log;

      --  log;
      --  log ("Tokens:");
      --  log;
      --  log (Tokens'Image);
      --  log; log;

      --  log;
      --  log ("Token tree:");
      --  log;
      --  log (Tree'Image);
      --  log; log;



      --  log ("Top level kids");
      --  log;
      --
      --  for Each of Tree.Root.Children
      --  loop
      --     log (Each.Value'Image);
      --  end loop;
      --
      --
      --  log; log; log;
      --  log ("Top level kids 2");
      --  log;
      --
      --  for Each of Tree.Root.Children
      --  loop
      --     for Child of Each.Children
      --     loop
      --        log (Child.Value'Image);
      --     end loop;
      --  end loop;


      parse_the_Context:
      declare
         Tokens : Token.vector renames applet_Tokens.Context;
         i      : Positive          := 1;

      begin
         if not Tokens.is_Empty
         then
            i := i + 1;     -- Skip 'with' token.

            add_Context:
            declare
               the_Context : constant parser_Model.Unit.context_Clauses := parse_Context (Tokens, i, Errors_found);
            begin
               if Errors_found
               then
                  log ("Errors found!");
                  return null;
               else
                  Result.Context_is (the_Context);
               end if;
            end add_Context;
         end if;
      end parse_the_Context;


      parse_the_Applet_Name:
      begin
         --  if Tokens (1).Kind = applet_Token
         --  then
         --     Tokens.delete_First;
         --
         --     if Tokens (1).Kind = identifier_Token
         --     then
         --        if   to_Lower (+Tokens (1).Identifier)
         --          /= to_Lower ( unit_Name)
         --        then
         --           log ("Error: Applet name does not match unit name. Should be " & unit_Name & ".");
         --           return null;
         --        end if;

               Result.Name_is (unit_Name);    -- to_String (Tokens (1).Identifier));
               --  Tokens.delete_First;

            --  else
            --     log ("Error: Missing applet name. Should be " & unit_Name & ".");
            --     return null;
            --  end if;
         --  end if;
      end parse_the_Applet_Name;


      --  if Tokens (1).Kind = is_Token
      --  then
      --     Tokens.delete_First;
      --  else
      --     log ("Error: Missing 'is' token.");
      --     return null;
      --  end if;


      --  add_Declarations:
      --  declare
      --     --  Declarations : String := source_Cursor.next_Token (Delimiter  => "do:",
      --     --                                                     match_Case => False,
      --     --                                                     Trim       => True);
      --  begin
      --     null;
      --  end add_Declarations;


      parse_global_Declarations:
      declare
         Tokens     :   Token.vector renames applet_Tokens.Declarations;
         i            : Positive          := 1;
         Declarations : parser_Model.Declaration.vector;
      begin
         Declarations := parse_Declarations (Tokens, i);
         Result.Declarations_are (Declarations);
      end parse_global_Declarations;


      --  if Tokens (1).Kind = asl_do_Token
      --  then
      --     Tokens.delete_First;
      --  else
      --     log ("Error: Missing 'do:' token.");
      --     return null;
      --  end if;


      --  declare
      --     do_Tree : token_Tree := to_token_Tree (applet_Tokens.do_Block);
      --  begin
      --     --  log (5);
      --     log ("do Tree");
      --     log (do_Tree'Image);
      --     log (1);
      --  end;


      parse_do_Block:
      declare
         Tokens     : Token.vector renames applet_Tokens.do_Block;
         i          : Positive          := 1;
         Statements : parser_Model.Statement.vector;
      begin
         --  i := 1;
         --  log (Tokens.Length'Image);

         i := i + 1;     -- Skip the 'is'    token.
         i := i + 1;     -- Skip the 'begin' token.

         Statements := parse_Statements (Tokens, i);
         Result.do_Block.Statements_are (Statements);
      end parse_do_Block;


      --  if         Tokens.Length   > 0
      --    and then Tokens (1).Kind = end_Token
      --  then
      --     Tokens.delete_First;
      --  else
      --     log ("Error: Missing 'end' token.");
      --     return null;
      --  end if;


      --  if Tokens (1).Kind = identifier_Token
      --  then
      --     if   to_Lower (+Tokens (1).Identifier)
      --       /= to_Lower ( unit_Name)
      --     then
      --        log ("Error: Applet name does not match unit name. Should be 'end " & unit_Name & "'.");
      --        return null;
      --     end if;
      --
      --     Tokens.delete_First;
      --
      --  else
      --     log ("Error: Missing applet name at end. Should be 'end " & unit_Name & "'.");
      --     return null;
      --  end if;


      --  if        Tokens.Length    = 0
      --    or else Tokens (1).Kind /= semicolon_Token
      --  then
      --     log ("Error: Missing final semicolon at end. Should be 'end " & unit_Name & ";'.");
      --     return null;
      --  else
      --     Tokens.delete_First;
      --  end if;


      --  if Tokens.Length /= 0
      --  then
      --     log ("Error: No statements allowed after final 'end' statement. Found '" & (+Tokens (1).Lexeme.Text) & "'.");
      --     return null;
      --  end if;



      --  log; log; log;
      --  log ("Parsed applet:");
      --  log;
      --  log (Result.all'Image);
      --  log;

      return parser_Model.Unit.view (Result);
   end parse_Applet;




   function parse_Class (Source : in String;   unit_Name : in String) return asl2ada.parser_Model.Unit.view
   is
   begin
      return null;
   end parse_Class;




   function parse_Module (Source : in String;   unit_Name : in String) return asl2ada.parser_Model.Unit.view
   is
   begin
      return null;
   end parse_Module;




   function to_Unit (Source : in String;   unit_Name : in String;
                                           of_Kind   : in unit_Kind) return asl2ada.parser_Model.Unit.view
   is
      Result : asl2ada.parser_Model.Unit.view;
   begin
      case of_Kind
      is
         when Applet => return parse_Applet (Source, unit_Name);
         when Class  => return parse_Class  (Source, unit_Name);
         when Module => return parse_Module (Source, unit_Name);
      end case;
   end to_Unit;


end asl2ada.Parser;
