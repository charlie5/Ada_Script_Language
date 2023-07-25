with
     asl2ada.Lexeme,
     ada.Strings.unbounded;


package asl2ada.Token
is
   use ada.Strings.unbounded;


   type Kind is (no_Token,

                 -- Reserved words.
                 --
                 abort_Token,
                 abs_Token,
                 abstract_Token,
                 accept_Token,
                 access_Token,
                 aliased_Token,
                 all_Token,
                 and_Token,
                 applet_Token,
                 array_Token,
                 at_Token,
                 based_integer_literal_Token,
                 begin_Token,
                 body_Token,
                 case_Token,
                 character_literal_Token,
                 class_Token,
                 close_Token,      -- 'close:'
                 comment_Token,
                 constant_Token,
                 declare_Token,
                 delay_Token,
                 delta_Token,
                 digits_Token,
                 ada_do_Token,
                 asl_do_Token,     -- 'do:'
                 else_Token,
                 elsif_Token,
                 end_Token,
                 entry_Token,
                 exception_Token,
                 exit_Token,
                 float_literal_Token,
                 for_Token,
                 function_Token,
                 generic_Token,
                 goto_Token,
                 identifier_Token,
                 if_Token,
                 in_Token,
                 integer_literal_Token,
                 interface_Token,
                 is_Token,
                 limited_Token,
                 loop_Token,
                 mod_Token,
                 module_Token,
                 new_Token,
                 not_Token,
                 null_Token,
                 of_Token,
                 open_Token,       -- 'open:'
                 or_Token,
                 others_Token,
                 out_Token,
                 overriding_Token,
                 package_Token,
                 pragma_Token,
                 private_Token,
                 procedure_Token,
                 protected_Token,
                 raise_Token,
                 range_Token,
                 record_Token,
                 rem_Token,
                 renames_Token,
                 requeue_Token,
                 return_Token,
                 reverse_Token,
                 select_Token,
                 separate_Token,
                 string_literal_Token,
                 subtype_Token,
                 synchronized_Token,
                 tagged_Token,
                 task_Token,
                 terminate_Token,
                 then_Token,
                 type_Token,
                 until_Token,
                 use_Token,
                 when_Token,
                 while_Token,
                 with_Token,
                 xor_Token,

                 -- Symbols
                 --
                 not_equals_Token,                 -- '/='
                 less_than_or_equals_Token,        -- '<='
                 greater_than_or_equals_Token,     -- '>='

                 exponential_Token,                -- '**'
                 assignment_Token,                 -- ':='
                 arrow_Token,                      -- '=>'
                 double_dot_Token,                 -- '..'

                 equals_Token,                     -- '='
                 less_than_Token,                  -- '<'
                 greater_than_Token,               -- '>'

                 plus_Token,                       -- '+'
                 minus_Token,                      -- '-'

                 ampersand_Token,                  -- '&'
                 multiply_Token,                   -- '*'
                 divide_Token,                     -- '/'

                 left_parenthesis_Token,           -- '('
                 right_parenthesis_Token,          -- ')'
                 left_bracket_Token,               -- '['
                 right_bracket_Token,              -- ']'

                 at_symbol_Token,                  -- '@'
                 bar_Token,                        -- '|'
                 hash_Token,                       -- '#'

                 colon_Token,                      -- ':'
                 semicolon_Token,                  -- ';'

                 apostrophe_Token,                 -- '''
                 comma_Token,                      -- ','
                 dot_Token);                       -- '.'


   type Item (Kind : Token.Kind := no_Token) is
      record
         Lexeme : asl2ada.Lexeme.item;

         case Kind
         is
            when based_integer_literal_Token =>
               Base                : Integer;
               based_integer_Value : long_long_long_Integer;

            when character_literal_Token =>
               character_Value     : Character;

            when comment_Token =>
               Comment             : unbounded_String;

            when float_literal_Token =>
               float_Value         : long_long_Float;

            when identifier_Token =>
               Identifier          : unbounded_String;

            when integer_literal_Token =>
               integer_Value       : long_long_long_Integer;

            when string_literal_Token =>
               string_Value        : unbounded_String;

            when others =>
               null;
         end case;
      end record;


   type Items is array (Positive range <>) of Item;


end asl2ada.Token;
