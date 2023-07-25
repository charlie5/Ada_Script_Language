with
     lace.Text.all_Lines,
     ada.Strings.unbounded,
     ada.Characters.handling;


package body asl2ada.Lexer
is

   function to_Lexemes (Source : in String) return Lexeme.items
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
               if Column >= the_Line'Last
               then
                  return False;
               else
                  return the_Line (Column) = Token;
               end if;
            end next_is;


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

                  if next_is ('"')
                  then
                     if                   Column + 1  <= the_Line'Last
                       and then the_Line (Column + 1) /= '"'
                     then   -- Is a null string literal.
                        add_Symbol ("""");

                     else
                        declare
                           Literal : unbounded_String;
                        begin
                           loop

                              if the_Line (Column) = '"'
                                and then (                   Column + 1  <= the_Line'Last
                                          and then the_Line (Column + 1) /= '"')
                              then   -- At the end of the string literal.
                                 add_Symbol (to_String (Literal));
                                 add_Symbol ("""");
                                 exit;

                              else   -- Add a character to the literal.
                                 append (Literal, the_Line (Column));
                                 Column := Column + 1;

                                 if Column = the_Line'Last
                                 then   -- At end of line and no terminating quote is present.
                                    append (Literal, the_Line (Column));
                                    exit;
                                 end if;
                              end if;

                           end loop;
                        end;
                     end if;
                  end if;

               elsif next_is (" ")
               then
                  if Length (Word) > 0
                  then
                     add_Word;
                  end if;

                  Column := Column + 1;

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




   function to_Tokens (Source : in String) return Token.items
   is
      Lexemes : constant Lexeme.items := to_Lexemes (Source);
      Length  : constant Natural      := Natural (Lexemes.Length);

      Result  : Token.items (1 .. Length);
      Count   : Natural := 0;
   begin
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

            if    Lexeme.Text = "abort"        then   Result (Count) := (Kind =>        abort_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "abs"          then   Result (Count) := (Kind =>          abs_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "abstract"     then   Result (Count) := (Kind =>     abstract_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "accept"       then   Result (Count) := (Kind =>       accept_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "access"       then   Result (Count) := (Kind =>       access_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "aliased"      then   Result (Count) := (Kind =>      aliased_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "and"          then   Result (Count) := (Kind =>          and_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "applet"       then   Result (Count) := (Kind =>       applet_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "array"        then   Result (Count) := (Kind =>        array_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "at"           then   Result (Count) := (Kind =>           at_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "begin"        then   Result (Count) := (Kind =>        begin_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "body"         then   Result (Count) := (Kind =>         body_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "case"         then   Result (Count) := (Kind =>         case_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "class"        then   Result (Count) := (Kind =>        class_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "close"        then   Result (Count) := (Kind =>        close_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "constant"     then   Result (Count) := (Kind =>     constant_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "declare"      then   Result (Count) := (Kind =>      declare_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "delay"        then   Result (Count) := (Kind =>        delay_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "delta"        then   Result (Count) := (Kind =>        delta_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "digits"       then   Result (Count) := (Kind =>       digits_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "ada_do"       then   Result (Count) := (Kind =>       ada_do_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "asl_do"       then   Result (Count) := (Kind =>       asl_do_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "else"         then   Result (Count) := (Kind =>         else_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "elsif"        then   Result (Count) := (Kind =>        elsif_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "end"          then   Result (Count) := (Kind =>          end_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "entry"        then   Result (Count) := (Kind =>        entry_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "exception"    then   Result (Count) := (Kind =>    exception_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "exit"         then   Result (Count) := (Kind =>         exit_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "for"          then   Result (Count) := (Kind =>          for_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "function"     then   Result (Count) := (Kind =>     function_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "generic"      then   Result (Count) := (Kind =>      generic_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "goto"         then   Result (Count) := (Kind =>         goto_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "if"           then   Result (Count) := (Kind =>           if_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "in"           then   Result (Count) := (Kind =>           in_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "interface"    then   Result (Count) := (Kind =>    interface_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "is"           then   Result (Count) := (Kind =>           is_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "limited"      then   Result (Count) := (Kind =>      limited_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "loop"         then   Result (Count) := (Kind =>         loop_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "mod"          then   Result (Count) := (Kind =>          mod_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "module"       then   Result (Count) := (Kind =>       module_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "new"          then   Result (Count) := (Kind =>          new_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "not"          then   Result (Count) := (Kind =>          not_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "null"         then   Result (Count) := (Kind =>         null_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "null"         then   Result (Count) := (Kind =>         null_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "open"         then   Result (Count) := (Kind =>         open_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "or"           then   Result (Count) := (Kind =>           or_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "others"       then   Result (Count) := (Kind =>       others_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "out"          then   Result (Count) := (Kind =>          out_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "overriding"   then   Result (Count) := (Kind =>   overriding_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "package"      then   Result (Count) := (Kind =>      package_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "pragma"       then   Result (Count) := (Kind =>       pragma_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "private"      then   Result (Count) := (Kind =>      private_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "procedure"    then   Result (Count) := (Kind =>    procedure_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "protected"    then   Result (Count) := (Kind =>    protected_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "raise"        then   Result (Count) := (Kind =>        raise_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "range"        then   Result (Count) := (Kind =>        range_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "record"       then   Result (Count) := (Kind =>       record_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "rem"          then   Result (Count) := (Kind =>          rem_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "renames"      then   Result (Count) := (Kind =>      renames_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "requeue"      then   Result (Count) := (Kind =>      requeue_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "return"       then   Result (Count) := (Kind =>       return_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "reverse"      then   Result (Count) := (Kind =>      reverse_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "select"       then   Result (Count) := (Kind =>       select_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "separate"     then   Result (Count) := (Kind =>     separate_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "subtype"      then   Result (Count) := (Kind =>      subtype_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "synchronized" then   Result (Count) := (Kind => synchronized_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "tagged"       then   Result (Count) := (Kind =>       tagged_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "task"         then   Result (Count) := (Kind =>         task_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "terminate"    then   Result (Count) := (Kind =>    terminate_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "then"         then   Result (Count) := (Kind =>         then_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "type"         then   Result (Count) := (Kind =>         type_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "until"        then   Result (Count) := (Kind =>        until_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "use"          then   Result (Count) := (Kind =>          use_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "when"         then   Result (Count) := (Kind =>         when_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "while"        then   Result (Count) := (Kind =>        while_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "with"         then   Result (Count) := (Kind =>         with_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "xor"          then   Result (Count) := (Kind =>          xor_Token,   Lexeme => Lexeme);

            elsif Lexeme.Text = "/="           then   Result (Count) := (Kind =>             not_equals_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "<="           then   Result (Count) := (Kind =>    less_than_or_equals_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = ">="           then   Result (Count) := (Kind => greater_than_or_equals_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "**"           then   Result (Count) := (Kind =>            exponential_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = ":="           then   Result (Count) := (Kind =>             assignment_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "=>"           then   Result (Count) := (Kind =>                  arrow_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = ".."           then   Result (Count) := (Kind =>             double_dot_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "="            then   Result (Count) := (Kind =>                 equals_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "<"            then   Result (Count) := (Kind =>              less_than_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = ">"            then   Result (Count) := (Kind =>           greater_than_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "+"            then   Result (Count) := (Kind =>                   plus_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "-"            then   Result (Count) := (Kind =>                  minus_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "&"            then   Result (Count) := (Kind =>              ampersand_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "*"            then   Result (Count) := (Kind =>               multiply_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "/"            then   Result (Count) := (Kind =>                 divide_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "("            then   Result (Count) := (Kind =>       left_parenthesis_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = ")"            then   Result (Count) := (Kind =>      right_parenthesis_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "["            then   Result (Count) := (Kind =>           left_bracket_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "]"            then   Result (Count) := (Kind =>          right_bracket_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "@"            then   Result (Count) := (Kind =>              at_symbol_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "|"            then   Result (Count) := (Kind =>                    bar_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "#"            then   Result (Count) := (Kind =>                   hash_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = ":"            then   Result (Count) := (Kind =>                  colon_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = ";"            then   Result (Count) := (Kind =>              semicolon_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = ","            then   Result (Count) := (Kind =>                  comma_Token,   Lexeme => Lexeme);
            elsif Lexeme.Text = "."            then   Result (Count) := (Kind =>                    dot_Token,   Lexeme => Lexeme);

            elsif Lexeme.Text = "--"
            then
               i              := i + 1;
               Result (Count) := (Kind    => comment_Token,
                                  Lexeme  => Lexeme,
                                  Comment => Lexemes (i).Text);

            elsif Lexeme.Text = """"
            then
               Result (Count) := (Kind         => string_literal_Token,
                                  Lexeme       => Lexeme,
                                  string_Value => to_unbounded_String (next_Lexeme_Text));     -- TODO: Need to check for final '"' ?
               i := i + 2;

            elsif Lexeme.Text = "'"
            then
               if next_Lexeme_Text (skip => 1) = "'"
               then   -- Is a character literal.
                  Result (Count) := (Kind            => character_literal_Token,
                                     Lexeme          => Lexeme,
                                     character_Value => next_Lexeme_Text (1));     -- TODO: Need to check for final "'" ?
                  i := i + 2;

               else   -- Is an attribute apostrophe.
                  Result (Count) := (Kind   => apostrophe_Token,
                                     Lexeme => Lexeme);
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
                              Result (Count) := (Kind        => float_literal_Token,
                                                 Lexeme      => Lexeme,
                                                 float_Value => Value);
                              i := i + 2;
                           end;

                        else   -- Is an integer.
                           declare
                              is_Based : constant Boolean := next_Lexeme_Text = "#";     -- TODO: Need to check for final '#' ?
                           begin
                              if is_Based
                              then
                                 Result (Count) := (Kind                => based_integer_literal_Token,
                                                    Lexeme              => Lexeme,
                                                    Base                => Integer'Value (to_String (Lexeme.Text)),
                                                    based_integer_Value => long_long_long_Integer'Value (next_Lexeme_Text (skip => 1)));
                                 i := i + 3;
                              else
                                 Result (Count) := (Kind          => integer_literal_Token,
                                                    Lexeme        => Lexeme,
                                                    integer_Value => long_long_long_Integer'Value (to_String (Lexeme.Text)));
                              end if;
                           end;
                        end if;
                     end;

                  else   -- Is an identifier.
                     Result (Count) := (Kind       => identifier_Token,
                                        Lexeme     => Lexeme,
                                        Identifier => Lexeme.Text);
                  end if;
               end;
            end if;

            i := i + 1;
         end loop;
      end;


      return Result (1 .. Count);
   end to_Tokens;



end asl2ada.Lexer;
