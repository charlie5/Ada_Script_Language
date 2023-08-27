with
     asl2ada.Translator,
     asl2ada.Parser,
     asl2ada.Token,
     asl2ada.Lexeme,
     asl2ada.Error,

     lace.Text.Forge,

     ada.Strings.fixed,
     ada.Strings.unbounded,
     ada.Directories,
     ada.command_Line;

with asl2ada.Lexer;


procedure Asl2Ada.launcher
--
-- Translates ASL source into Ada source.
--
is
   use ada.command_Line,
       ada.Strings.unbounded;



   function "+" (From : in String) return unbounded_String
                 renames to_unbounded_String;

   function "+" (From : in unbounded_String) return String
                    renames to_String;


   unit_Path      : constant String  := (if argument_Count >= 1 then Argument (1)
                                                                else "");
   output_Path    : constant String  := (if argument_Count  = 2 then Argument (2)
                                                                else ".");

   unit_Filename  : constant String  := ada.Directories.simple_Name (unit_Path);
   unit_Extension : unbounded_String;
   unit_Name      : unbounded_String;
   unit_Kind      : Parser.unit_Kind;

begin

   --  test_Lexer:
   --  declare
   --     use asl2ada.Lexer,
   --         lace.Text.forge;
   --
   --     Source : constant String := to_String (Filename' ("source.txt"));
   --  begin
   --     declare
   --        the_Tokens : constant Token.items := to_Tokens (Source);
   --     begin
   --        log;
   --        log;
   --        log;
   --        log ("Tokens:");
   --        log (the_Tokens'Image);
   --     end;
   --
   --     return;
   --  end test_Lexer;


   --  test_Parser:
   --  declare
   --     use asl2ada.Parser,
   --         lace.Text.forge;
   --
   --     --  Source : constant String := to_String (Filename' ("source.txt"));
   --     Source : constant String := to_String (Filename (unit_Path));
   --  begin
      --  declare
      --     use asl2ada.Lexer;
      --     Errors     :          asl2ada.Error.items;
      --     the_Tokens : constant Token.vector := to_Tokens (Source, Errors);
      --  begin
      --     log;
      --     log;
      --     log;
      --     log ("Token Tree:");
      --     log;
      --     parser.test_token_Tree (the_Tokens);
      --
      --     null;
      --  end;
      --
      --  --  raise program_Error;
      --  --  return;
   --  end test_Parser;


   parse_command_Line:
   declare
      use ada.Strings;

      procedure log_Usage
      is
      begin
         log;
         log ("Usage:");
         log;
         log ("   asl2ada   < unit_name.applet");
         log ("             | unit_Name.class");
         log ("             | unit_Name.module >   <output_Folder>");
         log;
      end log_Usage;

   begin
      if   argument_Count = 0
        or argument_Count > 2
      then
         log_Usage;
         return;
      end if;


      if not ada.Directories.exists (unit_Path)
      then
         log ("ASL source file '" & unit_Path & "' does not exist.");
         return;
      end if;


      declare
         use ada.Strings.fixed;

         dot_Index : constant Natural := Index (unit_Filename,
                                                Pattern => ".",
                                                from    => unit_Filename'Last,
                                                going   => Backward);
      begin
         unit_Name      := +unit_Filename (1             .. dot_Index - 1);
         unit_Extension := +unit_Filename (dot_Index + 1 .. unit_Filename'Last);
         unit_Kind      := Parser.unit_Kind'Value (to_String (unit_Extension));
      end;
   end parse_command_Line;



   translate_Unit_Source:
   begin
      case unit_Kind
      is
      when parser.Applet =>
         declare
            use lace.Text.Forge;
            asl_Source : constant String := comment_stripped_Source (From => to_String (Filename (unit_Path)));

         begin
            do_applet_spec_Source:
            declare
               ada_Source : constant String := asl2ada.Translator.to_applet_spec_Ada_Source (asl_Source,
                                                                                             unit_Name => +unit_Name);
            begin
               lace.Text.forge.store (Filename (output_Path & "/" & (+unit_Name) & "_applet.ads"),
                                      the_String => ada_Source);
            end do_applet_spec_Source;


            do_applet_body_Source:
            declare
               ada_Source : constant String := asl2ada.Translator.to_applet_body_Ada_Source (asl_Source,
                                                                                             unit_Name => +unit_Name);
            begin
               lace.Text.forge.store (Filename (output_Path & "/" & (+unit_Name) & "_applet.adb"),
                                      the_String => ada_Source);
            end do_applet_body_Source;


            do_applet_launch_Source:
            declare
               ada_Source : constant String := asl2ada.Translator.to_applet_launch_Ada_Source (asl_Source,
                                                                                               unit_Name => +unit_Name);
            begin
               lace.Text.forge.store (Filename (output_Path & "/" & (+unit_Name) & "_applet-launch.adb"),
                                      the_String => ada_Source);
            end do_applet_launch_Source;
         end;


      when parser.Class =>
         null;


      when parser.Module =>
         null;

      end case;
   end translate_Unit_Source;


   --  dlog ("Translation done.");
   --  dlog (3);
end Asl2Ada.launcher;
