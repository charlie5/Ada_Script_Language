with
     asl2ada.parser_Model.Unit.asl_Applet,
     asl2ada.parser_Model.Call,
     asl2ada.parser_Model.Condition,
     asl2ada.parser_Model.Expression,
     asl2ada.parser_Model.Declaration.of_exception,
     asl2ada.parser_Model.Declaration.of_variable,
     asl2ada.parser_Model.Handler,
     asl2ada.parser_Model.Operator,
     asl2ada.parser_Model.Statement.assignment,
     asl2ada.parser_Model.Statement.block,
     asl2ada.parser_Model.Statement.call,
     asl2ada.parser_Model.Statement.end_when,
     asl2ada.parser_Model.Statement.for_loop,
     asl2ada.parser_Model.Statement.a_null,
     asl2ada.parser_Model.Statement.a_raise,
     asl2ada.parser_Model.DB,

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
                   or Current.Kind = right_parenthesis_Token
                   or Current.Kind = semicolon_Token;

         Result.add (Token => Current);
         i := i + 1;
      end loop;

      return Result;
   end parse_Expression;




   function parse_Operator (From : in Token.vector;   i : in out Positive) return parser_Model.Operator.view
   is
      Tokens :          Token.vector          renames From;
      Result : constant parser_Model.Operator.view := new parser_Model.Operator.item;
   begin
      --  i := i + 1;
      Result.Token_is (Tokens (i));
      --  i := i + 1;

      return Result;
   end parse_Operator;




   function parse_Condition (From : in     Token.vector;
                             i    : in out Positive) return parser_Model.Condition.view
   is
      Tokens   : Token.vector                    renames From;
      Result   : constant parser_Model.Condition.view := new parser_Model.Condition.item;

      Left     : constant parser_Model.Expression.view := parse_Expression (From => Tokens, i => i);
      Operator : constant parser_Model.Operator  .view := parse_Operator   (From => Tokens, i => i);
      Right    : constant parser_Model.Expression.view := parse_Expression (From => Tokens, i => i);

   begin
      Result.Left_is     (Left);
      Result.Operator_is (Operator);
      Result.Right_is    (Right);

      return Result;
   end parse_Condition;




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
               if Next (2).Kind = exception_Token
               then     -- Is an exception declaration.
                  declare
                     use parser_Model.Declaration.of_exception.Forge;
                     the_Exception : constant parser_Model.Declaration.of_exception.view := new_exception_Declaration (Name => +Current.Identifier);
                  begin
                     i := i + 1;     -- Skip colon token.
                     dlog (Current'Image);

                     if Next (2).Kind = is_Token
                     then     -- Extended exception.
                        i := i + 2;
                        dlog ("CURR:" & Current'Image);

                        i := i + 1;

                        while Current.Kind /= end_Token
                        loop
                           --  i := i + 1;

                           dlog ("CURR2:" & Current'Image);
                           declare
                              use parser_Model.Declaration.of_variable.Forge;
                              Component : constant parser_Model.Declaration.of_variable.view := new_variable_Declaration (Identifier => +Current.Identifier);
                           begin
                              --  i := i + 1;     -- Move to next token.
                              i := i + 2;     -- Skip colon token.
                              dlog ("Exception component:" & Current'Image);

                              Component.Type_is (+Current.Identifier);

                              the_Exception.add (Component);
                              i := i + 2;
                              dlog ("CURR3:" & Current'Image);
                           end;
                        end loop;
                     end if;

                     Result.append (parser_Model.Declaration.view (the_Exception));

                     if not parser_Model.DB.contains_Exception (Named => the_Exception.Name)     -- HACK !
                     then
                        dlog ("ADDING EXCEPTION: " & the_Exception.Name);
                        parser_Model.DB.add (the_Exception);
                     end if;
                  end;

               else     -- Is a variable.
                  declare
                     use parser_Model.Declaration.of_variable.Forge;
                     Variable : constant parser_Model.Declaration.of_variable.view := new_variable_Declaration (Identifier => +Current.Identifier);
                  begin
                     i := i + 1;     -- Move to next token.
                     i := i + 1;     -- Skip colon token.
                     dlog (Current'Image);

                     Variable.Type_is (+Current.Identifier);

                     i := i + 1;

                     if Current.Kind = assignment_Token
                     then
                        i := i + 1;
                        Variable.Initialiser_is (Current.integer_Value'Image);
                     end if;

                     Result.append (parser_Model.Declaration.view (Variable));
                  end;
               end if;

               i := i + 1;        -- Skip semicolon.
            end if;

         end;

         i := i + 1;              -- Move to next token.
         dlog ("parse_Declarations ~ i:" & i'Image);
      end loop;


      return Result;
   end parse_Declarations;





   function parse_Statements (From : in     Token.vector;
                              i    : in out Positive) return parser_Model.Statement.vector
   is
      Tokens : Token.vector renames From;
      Result : parser_Model.Statement.vector;

   begin
      dlog (2);
      dlog ("parser.Parsing statements");
      dlog;

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
            then                                        -- An assignment or a subprogram call.
               if Next.Kind = assignment_Token
               then     -- An assignment.
                  declare
                     use parser_Model.Statement.assignment.Forge;
                     Assignment : constant parser_Model.Statement.assignment.view := new_assignment_Statement (Variable => +Current.Identifier);
                  begin
                     i := i + 2;     -- Skip ':='.
                     Assignment.Expression_is (parse_Expression (From => Tokens,
                                                                 i    => i));
                     Result.append (parser_Model.Statement.view (Assignment));
                     i := i + 0;
                  end;

               else     -- A subprogram call.
                  declare
                     use parser_Model.Statement.Call.Forge;
                     Call : constant parser_Model.Statement.Call.view := new_call_Statement (Name => +Current.Identifier);
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
               end if;


            elsif Current.Kind = for_Token
            then     -- A for loop.
               declare
                  use parser_Model.Statement.for_loop.Forge;
                  for_Statement   : constant parser_Model.Statement.for_loop.view := new_for_loop_Statement (Variable => +Next.Identifier);
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
            then     -- A null statement.
               dlog ("Null token ~ i:" & i'Image);

               declare
                  use parser_Model.Statement.a_null.Forge;
                  null_Statement : constant parser_Model.Statement.a_null.view := new_null_Statement;
               begin
                  i := i + 2;     -- Skip 'null' and ';' tokens.
                  Result.append (parser_Model.Statement.view (null_Statement));
               end;


            elsif Current.Kind = end_Token
            then
               if Next.Kind = when_Token
               then     -- An 'end when' statement.
                  declare
                     use parser_Model.Statement.end_when.Forge;

                     end_when_Statement : constant parser_Model.Statement.end_when.view := new_end_when_Statement;
                     the_Condition      :          parser_Model.Condition .view         := new parser_Model.Condition .item;
                  begin
                     i := i + 2;
                     dlog ("END WHEN Current: " & (+Current.Identifier));


                     the_Condition := parse_Condition (From => Tokens,
                                                       i    => i);


                     --  end_when_Statement.Condition_is (+Current.Identifier);
                     end_when_Statement.Condition_is (the_Condition);

                     Result.append (parser_Model.Statement.view (end_when_Statement));

                     i := i + 1;
                  end;

               else     -- The end of statements.
                  i := i + 3;     -- Skip 'null' and ';' tokens.
                  exit;
               end if;


            elsif Current.Kind = raise_Token
            then     -- The raise of an exception.
               dlog;
               dlog ("Exception identifier: " & (+Next.Identifier));

               declare
                  use parser_Model,
                      parser_Model.Statement.a_raise.Forge;

                  raise_Statement : constant parser_Model.Statement.a_raise.view := new_raise_Statement (Raises => +Next.Identifier);
               begin
                  --  i := i + 3;     -- Skip Identifier and ';' tokens.
                  i := i + 2;     -- Skip Identifier token.
                  --  i := i + 1;

                  dlog (Current.Kind'Image);

                  if Current.Kind = semicolon_Token
                  then     -- Simple exception.
                     null;

                  else     -- Extended exception.
                     while Current.Kind /= right_parenthesis_Token
                     loop
                        i := i + 3;
                        --  i := i + 2;

                        if Current.Kind = integer_literal_Token
                        then
                           dlog ("Adding integer literal value.");
                           raise_Statement.add (Current.integer_Value'Image);
                           i := i + 1;

                        elsif Current.Kind = character_literal_Token
                        then
                           dlog ("Adding character literal value.");
                           raise_Statement.add (Current.character_Value'Image);
                           i := i + 1;

                        else
                           raise program_Error with "Unhandled token kind ~ '" & Current.Kind'Image & "'.";
                        end if;

                        dlog ("Current.Kind: " & Current.Kind'Image);
                     end loop;
                  end if;

                  --  if Current.Kind /= semicolon_Token
                  --  then   -- Extended exception.
                  --     i := i + 3;
                  --     raise_Statement.add (Current.integer_Value'Image);
                  --  end if;

                  i := i + 1;
                  Result.append (parser_Model.Statement.view (raise_Statement));
               end;


            else   -- Assume raw Ada.
               dlog ("Raw ada: " & Current'Image);

               declare
                  Statement : constant parser_Model.Statement.view := new parser_Model.Statement.item;
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





   function parse_Handlers (From : in     Token.vector;
                            i    : in out Positive) return parser_Model.Handler.vector
   is
      Tokens : Token.vector renames From;
      Result : parser_Model.Handler.vector;

   begin
      dlog (2);
      dlog ("parser.Parsing handlers");
      dlog;

      while i <= Integer (Tokens.Length)
      loop
         dlog ("parse_Handlers ~ " & Tokens (i).Kind'Image);

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
            then     -- The handled exception name.
               declare
                  use parser_Model.Handler.Forge;

                  Handler    : constant parser_Model.Handler  .view   := new_Handler (Name => +Current.Identifier);
                  Statements : parser_Model.Statement.vector;
               begin
                  dlog ("Adding handler for " & Handler.Name);

                  i := i + 2;     -- Skip '=>' token.
                  Statements := parse_Statements (From => Tokens,
                                                  i    => i);
                  dlog ("Handler statements:");
                  dlog (Statements'Image);

                  Handler.Statements_are (Statements);
                  Result.append (Handler);
               end;

            else
               dlog ("parser.parse_Handlers ~ Unhandled token: " & Current'Image);
            end if;
         end;

         i := i + 1;
         dlog ("i:" & i'Image);
         dlog;
      end loop;

      --  raise Program_Error;

      return Result;
   end parse_Handlers;




   function parse_Applet (Source : in String;   unit_Name : in String) return asl2ada.parser_Model.Unit.view
   is
      use asl2ada.Token,
          asl2ada.Lexer,
          ada.Characters.handling;

      use type ada.Containers.Count_type;

      Errors        :          asl2ada.Error.items;
      Errors_found  :          Boolean                           := False;
      Tokens        : constant Token.vector                      := Lexer.to_Tokens (Source, Errors);
      applet_Tokens : constant Lexer.applet_Tokens               := Lexer.to_applet_Tokens (Tokens, unit_Name);
      Result        : constant parser_Model.Unit.asl_Applet.view := new asl2ada.parser_Model.Unit.asl_Applet.item;

   begin
      dlog ("__________________________");
      dlog ("Entering the applet parser ~ Unit: " & unit_Name);
      dlog;

      dlog ("applet_Tokens:" & applet_Tokens'Image);


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
         dlog (2);
         dlog ("Parsing the context ...");

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
         dlog (2);
         dlog ("Parsing the global declarations ...");

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


      dlog (2);
      dlog ("Parsing the 'do' block ...");
      dlog (2);

      parse_do_Block:
      declare
         block_Tokens   : constant lexer.block_Tokens := to_block_Tokens (applet_Tokens.do_Block);
      begin
         find_End_When:
         declare
            Tokens : Token.vector renames block_Tokens.Statements;
            Found  : Boolean           := False;
         begin
            for i in 1 .. Natural (Tokens.Length - 1)
            loop
               if    Tokens (i)    .Kind = end_Token
                 and Tokens (i + 1).Kind = when_Token
               then
                  Found := True;
                  dlog ("find_End_When is found !!!!!!!!!!!!!!!!!!!!!");
                  exit;
               end if;
            end loop;

            if Found
            then
               Result.end_when_Found;
            end if;
         end find_End_When;



         parse_block_Declarations:
         declare
            Tokens     : Token.vector renames block_Tokens.Declarations;
            i          : Positive          := 1;
            Statements : parser_Model.Statement.vector;
         begin
            --  i := 1;
            log ("parse_do_block_Declarations length:" & Tokens.Length'Image);
            log ("parse_do_block_Declarations:       " & Tokens'Image);
            dlog (2);

            i := i + 1;     -- Skip the 'is'    token.
            i := i + 1;     -- Skip the 'begin' token.

            --  Statements := parse_Statements (Tokens, i);
            --  Result.do_Block.Statements_are (Statements);
         end parse_block_Declarations;


         parse_block_Statements:
         declare
            Tokens     : Token.vector renames block_Tokens.Statements;
            i          : Positive          := 1;
            Statements : parser_Model.Statement.vector;
         begin
            --  i := 1;
            --  log (Tokens.Length'Image);
            dlog (2);
            dlog ("parse_do_block_Statements length:" & Tokens.Length'Image);
            dlog ("parse_do_block_Statements:       " & Tokens'Image);
            dlog (2);

            --  i := i + 1;     -- Skip the 'is'    token.
            --  i := i + 1;     -- Skip the 'begin' token.

            Statements := parse_Statements (Tokens, i);
            Result.do_Block.Statements_are (Statements);
         end parse_block_Statements;


         parse_block_Handlers:
         declare
            Tokens   : Token.vector renames block_Tokens.Handlers;
            i        : Positive          := 1;
            Handlers : parser_Model.Handler.vector;
         begin
            --  i := 1;
            --  log (Tokens.Length'Image);
            dlog (2);
            dlog ("parse_do_block_Handlers length:" & Tokens.Length'Image);
            dlog ("parse_do_block_Handlers:       " & Tokens'Image);
            dlog (2);

            i := i + 1;     -- Skip the 'when' token.

            Handlers := parse_Handlers (Tokens, i);

            dlog ("parse_do_block_Handlers.Handlers" & Handlers'Image);

            Result.do_Block.Handlers_are (Handlers);

            dlog ("HANDLERS COUNT:" & Handlers.Length'Image);
            dlog ("HANDLERS COUNT:" & Result.do_Block.Handlers.Length'Image);
         end parse_block_Handlers;


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

      dlog (2);
      dlog ("End of parse_Applet.");
      dlog (2);

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
