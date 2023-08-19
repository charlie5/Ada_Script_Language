with
     asl2ada.Lexeme,
     lace.Text.all_Lines,
     ada.Strings.unbounded,
     ada.Strings.Equal_case_insensitive,
     ada.Characters.handling;


package body asl2ada.Lexer
is

   function to_Lexemes (Source : in String;   Errors : in out asl2ada.Error.items) return asl2ada.Lexeme.items
   is
      use lace.Text;

      Result : Lexeme.items;

      Line   : Positive := 1;
      Column : Positive := 1;

      Lines  : constant lace.Text.items_512 := all_Lines.Lines (to_Text (Source));
   begin
      if Source = ""
      then
         return Result;
      end if;

      for i in 1 .. Lines'Length
      loop
         declare
            use ada.Strings.unbounded;

            the_Line : constant String := to_String (Lines (i));

            First : Positive        := 1;
            Word  : unbounded_String;


            function next_is (Token : in String) return Boolean
            is
               Last : constant Positive := Column + Token'Length - 1;
            begin
               return     Last                     <= the_Line'Last
                 and then the_Line (Column .. Last) = Token;
            end next_is;


            function next_is (Token : in Character) return Boolean
            is
            begin
               if Column > the_Line'Last
               then
                  return False;
               else
                  return the_Line (Column) = Token;
               end if;
            end next_is;


            function next_next_is (Token : in Character) return Boolean
            is
            begin
               if Column + 1 > the_Line'Last
               then
                  return False;
               else
                  return the_Line (Column + 1) = Token;
               end if;
            end next_next_is;


            procedure add_Word
            is
            begin
               Result.append (Lexeme.item' (Text   => Word,
                                            Line   => Line,
                                            Column => First));
               Word := null_unbounded_String;
            end add_Word;


            procedure add_Symbol (Token : in String)
            is
            begin
               if Length (Word) > 0
               then
                  add_Word;
               end if;

               Result.append (Lexeme.item' (Text   => to_unbounded_String (Token),
                                            Line   => Line,
                                            Column => Column));
               Column := Column + Token'Length;
            end add_Symbol;


         begin
            loop
               if next_is ("--")
               then
                  add_Symbol ("--");
                  add_Symbol (the_Line (Column .. the_Line'Last));
                  exit;

               elsif next_is ("/=") then add_Symbol ("/=");
               elsif next_is ("<=") then add_Symbol ("<=");
               elsif next_is (">=") then add_Symbol (">=");

               elsif next_is ("**") then add_Symbol ("**");
               elsif next_is (":=") then add_Symbol (":=");
               elsif next_is ("=>") then add_Symbol ("=>");
               elsif next_is ("..") then add_Symbol ("..");

               elsif next_is ("=")  then add_Symbol ("=");
               elsif next_is ("<")  then add_Symbol ("<");
               elsif next_is (">")  then add_Symbol (">");

               elsif next_is ("+")  then add_Symbol ("+");
               elsif next_is ("-")  then add_Symbol ("-");

               elsif next_is ("&")  then add_Symbol ("&");
               elsif next_is ("*")  then add_Symbol ("*");
               elsif next_is ("/")  then add_Symbol ("/");

               elsif next_is ("(")  then add_Symbol ("(");
               elsif next_is (")")  then add_Symbol (")");
               elsif next_is ("[")  then add_Symbol ("[");
               elsif next_is ("]")  then add_Symbol ("]");

               elsif next_is ("@")  then add_Symbol ("@");
               elsif next_is ("|")  then add_Symbol ("|");
               elsif next_is ("#")  then add_Symbol ("#");

               elsif next_is (":")  then add_Symbol (":");
               elsif next_is (";")  then add_Symbol (";");

               elsif next_is ("'")  then add_Symbol ("'");
               elsif next_is (",")  then add_Symbol (",");
               elsif next_is (".")  then add_Symbol (".");


               elsif next_is ('"')
               then
                  add_Symbol ("""");

                  if             next_is ('"')
                    and not next_next_is ('"')
                  then   -- Is a null string literal.
                     add_Symbol ("""");

                  else
                     declare
                        Literal      :          unbounded_String;
                        start_Column : constant Positive        := Column;
                     begin
                        loop
                           if         next_is ('"')
                             and next_next_is ('"')
                           then   -- Is an inner quote.
                              append (Literal, '"');
                              Column := Column + 2;

                           elsif next_is ('"')
                           then   -- At final terminating quote.
                              Result.append (Lexeme.item' (Text   => Literal,
                                                           Line   => Line,
                                                           Column => start_Column));
                              add_Symbol ("""");
                              exit;

                           else   -- Add a character to the literal.
                              append (Literal, the_Line (Column));
                              Column := Column + 1;
                           end if;

                           if Column > the_Line'Last
                           then   -- No terminating quote.
                              Result.append (Lexeme.item' (Text   => Literal,
                                                           Line   => Line,
                                                           Column => start_Column));
                              log ("Error: No terminating quote.");
                              exit;
                           end if;

                        end loop;
                     end;
                  end if;


               elsif next_is (" ")
               then
                  if Length (Word) > 0
                  then
                     add_Word;
                  end if;

                  Column := Column + 1;

               elsif next_is ("open:")  then add_Symbol ("open:");
               elsif next_is ("do:")    then add_Symbol ("do:");
               elsif next_is ("close:") then add_Symbol ("close:");

               else
                  if Column = the_Line'Last + 1
                  then
                     if Length (Word) > 0
                     then
                        add_Word;
                     end if;

                     exit;
                  end if;

                  if Length (Word) = 0
                  then
                     First := Column;
                  end if;

                  append (Word, the_Line (Column));
                  Column := Column + 1;
               end if;

            end loop;
         end;


         Line   := Line + 1;
         Column := 1;
      end loop;


      return Result;
   end to_Lexemes;




   function to_Tokens (Source : in String;   Errors : in out asl2ada.Error.items) return Token.vector
   is
      Lexemes : constant Lexeme.items := to_Lexemes (Source, Errors);
      Length  : constant Natural      := Natural (Lexemes.Length);

      Result  : Token.vector;
      Count   : Natural := 0;
   begin
      --  log;
      --  log;
      --  log ("Lexemes:");
      --  log (Lexemes'Image);

      declare
         use Token,
             ada.Strings.unbounded;

         Lexeme : asl2ada.Lexeme.item;
         i      : Positive := 1;


         function next_Lexeme_Text (Skip : Natural := 0) return String
         is
            Index : constant Positive := i + 1 + Skip;
         begin
            if Index > Integer (Lexemes.Length)
            then
               return "";
            else
               return to_String (Lexemes (Index).Text);
            end if;
         end next_Lexeme_Text;


      begin
         while i <= Length
         loop
            Lexeme := Lexemes (i);
            Count  := Count + 1;

            if    Lexeme.Text = "abort"        then   Result.append  (Token.item' (Kind =>        abort_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "abs"          then   Result.append  (Token.item' (Kind =>          abs_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "abstract"     then   Result.append  (Token.item' (Kind =>     abstract_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "accept"       then   Result.append  (Token.item' (Kind =>       accept_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "access"       then   Result.append  (Token.item' (Kind =>       access_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "aliased"      then   Result.append  (Token.item' (Kind =>      aliased_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "and"          then   Result.append  (Token.item' (Kind =>          and_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "applet"       then   Result.append  (Token.item' (Kind =>       applet_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "array"        then   Result.append  (Token.item' (Kind =>        array_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "at"           then   Result.append  (Token.item' (Kind =>           at_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "begin"        then   Result.append  (Token.item' (Kind =>        begin_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "body"         then   Result.append  (Token.item' (Kind =>         body_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "case"         then   Result.append  (Token.item' (Kind =>         case_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "class"        then   Result.append  (Token.item' (Kind =>        class_Token,   Lexeme => Lexeme));
            --  elsif Lexeme.Text = "close:"       then   Result.append  (Token.item' (Kind =>    asl_close_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "constant"     then   Result.append  (Token.item' (Kind =>     constant_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "declare"      then   Result.append  (Token.item' (Kind =>      declare_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "delay"        then   Result.append  (Token.item' (Kind =>        delay_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "delta"        then   Result.append  (Token.item' (Kind =>        delta_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "digits"       then   Result.append  (Token.item' (Kind =>       digits_Token,   Lexeme => Lexeme));
            --  elsif Lexeme.Text = "do:"          then   Result.append  (Token.item' (Kind =>       asl_do_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "do"           then   Result.append  (Token.item' (Kind =>           do_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "else"         then   Result.append  (Token.item' (Kind =>         else_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "elsif"        then   Result.append  (Token.item' (Kind =>        elsif_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "end"          then   Result.append  (Token.item' (Kind =>          end_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "entry"        then   Result.append  (Token.item' (Kind =>        entry_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "exception"    then   Result.append  (Token.item' (Kind =>    exception_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "exit"         then   Result.append  (Token.item' (Kind =>         exit_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "for"          then   Result.append  (Token.item' (Kind =>          for_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "function"     then   Result.append  (Token.item' (Kind =>     function_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "generic"      then   Result.append  (Token.item' (Kind =>      generic_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "goto"         then   Result.append  (Token.item' (Kind =>         goto_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "if"           then   Result.append  (Token.item' (Kind =>           if_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "in"           then   Result.append  (Token.item' (Kind =>           in_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "interface"    then   Result.append  (Token.item' (Kind =>    interface_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "is"           then   Result.append  (Token.item' (Kind =>           is_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "limited"      then   Result.append  (Token.item' (Kind =>      limited_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "loop"         then   Result.append  (Token.item' (Kind =>         loop_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "mod"          then   Result.append  (Token.item' (Kind =>          mod_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "module"       then   Result.append  (Token.item' (Kind =>       module_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "new"          then   Result.append  (Token.item' (Kind =>          new_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "not"          then   Result.append  (Token.item' (Kind =>          not_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "null"         then   Result.append  (Token.item' (Kind =>         null_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "null"         then   Result.append  (Token.item' (Kind =>         null_Token,   Lexeme => Lexeme));
            --  elsif Lexeme.Text = "open:"        then   Result.append  (Token.item' (Kind =>     asl_open_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "or"           then   Result.append  (Token.item' (Kind =>           or_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "others"       then   Result.append  (Token.item' (Kind =>       others_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "out"          then   Result.append  (Token.item' (Kind =>          out_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "overriding"   then   Result.append  (Token.item' (Kind =>   overriding_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "package"      then   Result.append  (Token.item' (Kind =>      package_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "pragma"       then   Result.append  (Token.item' (Kind =>       pragma_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "private"      then   Result.append  (Token.item' (Kind =>      private_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "procedure"    then   Result.append  (Token.item' (Kind =>    procedure_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "protected"    then   Result.append  (Token.item' (Kind =>    protected_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "raise"        then   Result.append  (Token.item' (Kind =>        raise_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "range"        then   Result.append  (Token.item' (Kind =>        range_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "record"       then   Result.append  (Token.item' (Kind =>       record_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "rem"          then   Result.append  (Token.item' (Kind =>          rem_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "renames"      then   Result.append  (Token.item' (Kind =>      renames_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "requeue"      then   Result.append  (Token.item' (Kind =>      requeue_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "return"       then   Result.append  (Token.item' (Kind =>       return_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "reverse"      then   Result.append  (Token.item' (Kind =>      reverse_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "select"       then   Result.append  (Token.item' (Kind =>       select_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "separate"     then   Result.append  (Token.item' (Kind =>     separate_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "subtype"      then   Result.append  (Token.item' (Kind =>      subtype_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "synchronized" then   Result.append  (Token.item' (Kind => synchronized_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "tagged"       then   Result.append  (Token.item' (Kind =>       tagged_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "task"         then   Result.append  (Token.item' (Kind =>         task_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "terminate"    then   Result.append  (Token.item' (Kind =>    terminate_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "then"         then   Result.append  (Token.item' (Kind =>         then_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "type"         then   Result.append  (Token.item' (Kind =>         type_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "until"        then   Result.append  (Token.item' (Kind =>        until_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "use"          then   Result.append  (Token.item' (Kind =>          use_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "when"         then   Result.append  (Token.item' (Kind =>         when_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "while"        then   Result.append  (Token.item' (Kind =>        while_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "with"         then   Result.append  (Token.item' (Kind =>         with_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "xor"          then   Result.append  (Token.item' (Kind =>          xor_Token,   Lexeme => Lexeme));

            elsif Lexeme.Text = "/="           then   Result.append  (Token.item' (Kind =>             not_equals_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "<="           then   Result.append  (Token.item' (Kind =>    less_than_or_equals_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = ">="           then   Result.append  (Token.item' (Kind => greater_than_or_equals_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "**"           then   Result.append  (Token.item' (Kind =>            exponential_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = ":="           then   Result.append  (Token.item' (Kind =>             assignment_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "=>"           then   Result.append  (Token.item' (Kind =>                  arrow_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = ".."           then   Result.append  (Token.item' (Kind =>             double_dot_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "="            then   Result.append  (Token.item' (Kind =>                 equals_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "<"            then   Result.append  (Token.item' (Kind =>              less_than_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = ">"            then   Result.append  (Token.item' (Kind =>           greater_than_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "+"            then   Result.append  (Token.item' (Kind =>                   plus_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "-"            then   Result.append  (Token.item' (Kind =>                  minus_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "&"            then   Result.append  (Token.item' (Kind =>              ampersand_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "*"            then   Result.append  (Token.item' (Kind =>               multiply_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "/"            then   Result.append  (Token.item' (Kind =>                 divide_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "("            then   Result.append  (Token.item' (Kind =>       left_parenthesis_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = ")"            then   Result.append  (Token.item' (Kind =>      right_parenthesis_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "["            then   Result.append  (Token.item' (Kind =>           left_bracket_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "]"            then   Result.append  (Token.item' (Kind =>          right_bracket_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "@"            then   Result.append  (Token.item' (Kind =>              at_symbol_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "|"            then   Result.append  (Token.item' (Kind =>                    bar_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "#"            then   Result.append  (Token.item' (Kind =>                   hash_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = ":"            then   Result.append  (Token.item' (Kind =>                  colon_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = ";"            then   Result.append  (Token.item' (Kind =>              semicolon_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = ","            then   Result.append  (Token.item' (Kind =>                  comma_Token,   Lexeme => Lexeme));
            elsif Lexeme.Text = "."            then   Result.append  (Token.item' (Kind =>                    dot_Token,   Lexeme => Lexeme));

            elsif Lexeme.Text = "--"
            then
               i := i + 1;
               Result.append  (Token.item' (Kind    => comment_Token,
                                            Lexeme  => Lexeme,
                                            Comment => Lexemes (i).Text));

            elsif Lexeme.Text = """"
            then
               Result.append  (Token.item' (Kind         => string_literal_Token,
                                            Lexeme       => Lexeme,
                                            string_Value => to_unbounded_String (next_Lexeme_Text)));     -- TODO: Need to check for final '"' ?
               i := i + 2;

            elsif Lexeme.Text = "'"
            then
               if next_Lexeme_Text (skip => 1) = "'"
               then   -- Is a character literal.
                  Result.append  (Token.item' (Kind            => character_literal_Token,
                                               Lexeme          => Lexeme,
                                               character_Value => next_Lexeme_Text (1)));     -- TODO: Need to check for final "'" ?
                  i := i + 2;

               else   -- Is an attribute apostrophe.
                  Result.append  (Token.item' (Kind   => apostrophe_Token,
                                               Lexeme => Lexeme));
               end if;

            else
               declare
                  use ada.Characters.handling;
                  first_Character : constant Character := Element (Lexeme.Text, 1);
               begin
                  if is_Digit (first_Character)
                  then   -- Is a number.
                     declare
                        is_Float : constant Boolean  := next_Lexeme_Text = ".";
                     begin
                        if is_Float
                        then
                           declare
                              integer_Part : constant String          := to_String (Lexeme.Text);
                              decimal_Part : constant String          := next_Lexeme_Text (skip => 1);
                              Value        : constant long_long_Float := long_long_Float'Value (integer_Part & "." & decimal_Part);
                           begin
                              Result.append  (Token.item' (Kind        => float_literal_Token,
                                                           Lexeme      => Lexeme,
                                                           float_Value => Value));
                              i := i + 2;
                           end;

                        else   -- Is an integer.
                           declare
                              is_Based : constant Boolean := next_Lexeme_Text = "#";     -- TODO: Need to check for final '#' ?
                           begin
                              if is_Based
                              then
                                 Result.append  (Token.item' (Kind                => based_integer_literal_Token,
                                                              Lexeme              => Lexeme,
                                                              Base                => Integer'Value (to_String (Lexeme.Text)),
                                                              based_integer_Value => long_long_long_Integer'Value (next_Lexeme_Text (skip => 1))));
                                 i := i + 3;
                              else
                                 Result.append  (Token.item' (Kind          => integer_literal_Token,
                                                              Lexeme        => Lexeme,
                                                              integer_Value => long_long_long_Integer'Value (to_String (Lexeme.Text))));
                              end if;
                           end;
                        end if;
                     end;

                  else   -- Is an identifier.
                     Result.append  (Token.item' (Kind       => identifier_Token,
                                                  Lexeme     => Lexeme,
                                                  Identifier => Lexeme.Text));
                  end if;
               end;
            end if;

            i := i + 1;
         end loop;
      end;

      --  log (Result'Image);

      return Result;
   end to_Tokens;




   function to_applet_Tokens (From        : in Token.Vector;
                              applet_Name : in String) return applet_Tokens
   is
      use asl2ada.Token,
          ada.Strings.unbounded;

      Result : applet_Tokens;
      i      : Positive     := 1;


      function next_Token return Token.item
      is
      begin
         if i > Integer (From.Length)
         then
            return (Kind => no_Token,
                    others => <>);
         end if;

         return From (i);
      end next_Token;


      function next_next_Token return Token.item
      is
      begin
         if i + 1 > Integer (From.Length)
         then
            return (Kind => no_Token,
                    others => <>);
         end if;

         return From (i + 1);
      end next_next_Token;


      function next_next_next_Token return Token.item
      is
      begin
         if i + 2 > Integer (From.Length)
         then
            return (Kind => no_Token,
                    others => <>);
         end if;

         return From (i + 2);
      end next_next_next_Token;


      function prior_is_not_a_Subprogram return Boolean
      is
      begin
         return i > 1
           and then (    From (i - 1).Kind /= function_Token
                     and From (i - 1).Kind /= procedure_Token);
      end prior_is_not_a_Subprogram;


   begin
      -- Context tokens.
      --
      while next_Token.Kind /= applet_Token
      loop
         Result.Context.append (From (i));
         i := i + 1;
      end loop;


      i := i + 3;     -- Skip 'applet', 'XYZ' and 'is' tokens.


      -- Declarations tokens.
      --
      loop
         exit when next_Token.Kind = begin_Token
           and    ((         next_next_Token.Kind       = identifier_Token
                    and then next_next_Token.Identifier = "open")
                   or        next_next_Token.Kind       = do_Token)
           and          next_next_next_Token.Kind       = is_Token;

         Result.Declarations.append (From (i));
         i := i + 1;
      end loop;


      i := i + 1;     -- Skip 'begin' token.


      -- Open tokens.
      --
      if (         next_Token.Kind       = identifier_Token
          and then next_Token.Identifier = "open")
        and        next_next_Token.Kind  = is_Token
      then
         i := i + 2;     -- Skip the 'open' and 'is' tokens.

         while i <= Integer (From.Length)
         loop
            exit when            next_Token.Kind       = end_Token
              and (         next_next_Token.Kind       = identifier_Token
                   and then next_next_Token.Identifier = "open")
              and      next_next_next_Token.Kind       = semicolon_Token;

            Result.open_Block.append (From (i));
            i := i + 1;
         end loop;

         i := i + 3;     -- Skip 'end', 'open' and ';' tokens.
      end if;


      -- Do tokens.
      --
      begin
         i := i + 1;     -- Skip 'do' and 'is' tokens.

         while i <= Integer (From.Length)
         loop
            exit when       next_Token.Kind = end_Token
              and      next_next_Token.Kind = do_Token
              and next_next_next_Token.Kind = semicolon_Token;

            Result.do_Block.append (From (i));
            i := i + 1;
         end loop;
      end;


      i := i + 3;     -- Skip 'end', 'do' and ';' tokens.


      -- Close tokens.
      --
      if (         next_Token.Kind       = identifier_Token
          and then next_Token.Identifier = "close")
        and   next_next_Token.Kind       = is_Token
      then
         i := i + 2;     -- Skip 'close' and 'is' tokens.

         while i <= Integer (From.Length)
         loop
            exit when       next_Token.Kind            = end_Token
              and (         next_next_Token.Kind       = identifier_Token
                   and then next_next_Token.Identifier = "close")
              and      next_next_next_Token.Kind       = semicolon_Token;

            Result.close_Block.append (From (i));
            i := i + 1;
         end loop;

         i := i + 3;     -- Skip 'end', 'close' and ';' tokens.
      end if;


      -- Handler tokens.
      --
      declare
         function "=" (Left, Right : String) return Boolean renames ada.Strings.Equal_case_insensitive;
      begin
         while i <= Integer (From.Length)
         loop
            exit when        next_Token.Kind            = end_Token
              and (          next_next_Token.Kind       = identifier_Token
                   and then +next_next_Token.Identifier = applet_Name);         -- Note the case insensitive equality operator.

            Result.Handlers.append (From (i));
            i := i + 1;
         end loop;
      end;


      return Result;
   end to_applet_Tokens;


end asl2ada.Lexer;
