with
     asl2ada.Unit.asl_Applet,
     lace.Text.Cursor,

     ada.Characters.handling,
     --  ada.Characters.latin_1,
     ada.Strings.fixed,
     ada.Strings.Maps
     --  ada.Strings.unbounded,
     --  ada.Text_IO
;


package body asl2ada.Parser
is
   --  use ada.Strings.unbounded,
       --  ada.Strings.fixed;


   --  function "+" (From : in String) return unbounded_String
   --                renames to_unbounded_String;
   --
   --  function "+" (From : in unbounded_String) return String
   --                renames to_String;


   function parse_Context (Source : in String;   Errors_found : in out Boolean) return Unit.context_Clauses
   is
      use ada.Strings.fixed;

      Result : Unit.context_Clauses;
   begin
      --  log ("'" & context_Source & "'" );

      if    Source'Length /= 0
        and Source        /= Source'Length * NL     -- Ignore if source is all new lines characters.
      then
         declare
            with_Index               : constant Natural := Index (Source, "with");
            semicolon_Index          : constant Natural := Index (Source, ";");

            with_Token_detected      : constant Boolean := with_Index      /= 0;
            semicolon_Token_detected : constant Boolean := semicolon_Index /= 0;
         begin
            if not with_Token_detected
            then
               log ("Token 'with' not found.");
               Errors_found := True;

            elsif not semicolon_Token_detected
            then
               log ("Token ';' not found in the context region.");
               Errors_found := True;

            else
               declare
                  use lace.Text.Cursor;

                  context_Text   : aliased lace.Text.item              := lace.Text.to_Text (Source (        with_Index + 5
                                                                                                     .. semicolon_Index - 1));
                  context_Cursor :         lace.Text.Cursor.item       := First (context_Text'Access);
               begin
                  while context_Cursor.has_Element
                  loop
                     declare
                        use ada.Strings.Maps;
                        withed_Unit : constant String := context_Cursor.next_Token (',', trim => True);     --TODO: 'trim' doesn't work.
                     begin
                        Result.Withs.append (trim (withed_Unit, Left  => to_Set (" " & NL),
                                                                Right => to_Set (" " & NL)));
                     end;
                  end loop;

                  --  log (Result'Image);
               end;
            end if;
         end;
      end if;


      return Result;
   end parse_Context;




   function parse_Applet (Source : in String;   unit_Name : in String) return asl2ada.Unit.view
   is
      use ada.Strings.fixed,
          ada.Characters.handling;

      applet_Token_detected : constant Boolean := Index (to_Lower (Source),  to_Lower ("applet " & unit_Name))       /= 0;
      do_Token_detected     : constant Boolean := Index (          Source,             "do:")                        /= 0;
      end_Token_detected    : constant Boolean := Index (to_Lower (Source),  to_Lower ("end "    & unit_Name & ";")) /= 0;

      Errors_found : Boolean := False;

   begin
      if not applet_Token_detected then   log ("Token 'applet " & unit_Name & "' not found.");      Errors_found := True;   end if;
      if not do_Token_detected     then   log ("Token 'do:' not found.");                           Errors_found := True;   end if;
      if not end_Token_detected    then   log ("Token 'end "    & unit_Name & ";' not found.");     Errors_found := True;   end if;

      if Errors_found
      then
         return null;
      end if;


      declare
         Result : constant asl2ada.Unit.view := new asl2ada.Unit.asl_Applet.item;
      begin
         Result.Name_is (unit_Name);

         declare
            use lace.Text.Cursor;

            source_Text   : aliased lace.Text.item        := lace.Text.to_Text (Source);
            source_Cursor :         lace.Text.Cursor.item := First (source_Text'Access);

         begin
            add_Context:
            declare
               context_Source : constant String               := source_Cursor.next_Token (Delimiter  => "applet " & unit_Name,
                                                                                           match_Case => False,
                                                                                           Trim       => True);
               the_Context    : constant Unit.context_Clauses := parse_Context (context_Source, Errors_found);
            begin
               if Errors_found
               then
                  return null;
               else
                  Result.Context_is (the_Context);
               end if;

               --  log (Result.all'Image);
            end add_Context;


            add_Declarations:
            declare
               Declarations : String := source_Cursor.next_Token (Delimiter  => "do:",
                                                                  match_Case => False,
                                                                  Trim       => True);
            begin
               null;
            end add_Declarations;


            add_Statements:
            declare
               Statements : String := source_Cursor.next_Token (Delimiter  => NL & "end " & unit_Name,
                                                                match_Case => False,
                                                                Trim       => True);
            begin
               null;
            end add_Statements;
         end;


         return Result;
      end;
   end parse_Applet;




   function parse_Class (Source : in String;   unit_Name : in String) return asl2ada.Unit.view
   is
   begin
      return null;
   end parse_Class;




   function parse_Module (Source : in String;   unit_Name : in String) return asl2ada.Unit.view
   is
   begin
      return null;
   end parse_Module;




   function to_Unit (Source : in String;   unit_Name : in String;
                                           of_Kind   : in unit_Kind) return asl2ada.Unit.view
   is
      Result : asl2ada.Unit.view;
   begin
      case of_Kind
      is
         when Applet => return parse_Applet (Source, unit_Name);
         when Class  => return parse_Class  (Source, unit_Name);
         when Module => return parse_Module (Source, unit_Name);
      end case;
   end to_Unit;


end asl2ada.Parser;
