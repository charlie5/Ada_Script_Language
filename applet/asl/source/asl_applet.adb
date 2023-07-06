with
     lace.Environ.Paths,
     lace.Environ.Users,
     ASL,
     ada.Strings.Fixed,
     ada.Strings.unbounded,
     ada.command_Line,
     ada.Text_IO;


procedure ASL_Applet
is
   use lace.Environ.Paths,
       lace.Environ.Users,
       ada.Strings.unbounded;


   procedure log (Message : in String := "")
                  renames ada.Text_IO.put_Line;


   type command_Kind is (Create, List, Move);
   type project_Kind is (Applet, Library);

   type Command (Kind : command_Kind := Create) is
      record
         project_Kind : ASL_Applet.project_Kind;

         case Kind
         is
            when Create =>
               project_Name : unbounded_String;

            when List =>
               Both : Boolean := False;

            when Move =>
               new_Location : Folder;
         end case;

      end record;


   the_Command : Command;

begin
   ensure_Folder (home_Folder + to_Folder (".asl/bin"));


   add_asl_bin_Path_to_BashRC:
   declare
      use ada.Strings.fixed;

      export_PATH    : constant String  := "export PATH=" & to_String (home_Folder) & "/.asl/bin:$PATH     # Added by ASL.";
      BashRC         : constant File    := home_Folder + to_File (".bashrc");
      BashRC_Content : constant String  := load (BashRC);
      Idx            : constant Natural := Index (BashRC_Content, export_PATH);
   begin
      if Idx = 0
      then
         append (BashRC, " ");
         append (BashRC, " ");
         append (BashRC, export_PATH);
      end if;
   end add_asl_bin_Path_to_BashRC;


   parse_command_Line:
   declare
      use ada.command_Line;

      procedure log_Usage
      is
      begin
         log;
         log ("asl <command> <options>");
         log;
         log ("Command: (create | list | move)");
         log;
         log ("Options:");
         log ("   - create: (applet | library) & 'project_name'");
         log ("   - list:   (all | applets | libraries)");
         log ("   - move:   '/absolute/path/to/new/location'");
         log ("              'relative/path/to/new/location'");
         log;
         log ("'app' can be used in place of 'applet'  and 'applets'.");
         log ("'lib' can be used in place of 'library' and 'libraries'.");
         log;
      end log_Usage;


   begin
      if argument_Count = 0
      then
         log_Usage;
         return;
      end if;


      if Argument (1) = "create"
      then
         the_Command := (Kind   => Create,
                         others => <>);

         if    argument_Count < 3
         then
            log ("Too few options given for 'create'.");
            return;

         elsif argument_Count > 3
         then
            log ("Too many options given for 'create'.");
            return;
         end if;

         if   Argument (2) = "applet"
           or Argument (2) = "app"
         then
            the_Command.project_Kind := Applet;
            the_Command.project_Name := to_unbounded_String (Argument (3));

         elsif Argument (2) = "library"
           or  Argument (2) = "lib"
         then
            the_Command.project_Kind := Library;
            the_Command.project_Name := to_unbounded_String (Argument (3));

         else
            log ("'create' project kind must be (app | applet | lib | library)");
            return;
         end if;
      end if;


      if Argument (1) = "list"
      then
         the_Command := (Kind   => List,
                         others => <>);

         if argument_Count < 2
         then
            log ("Too few options given for 'list'.");
            return;

         elsif argument_Count > 2
         then
            log ("Too many options given for 'list'.");
            return;
         end if;

         if    Argument (2) = "all"
         then
            the_Command.Both := True;

         elsif Argument (2) = "applet"
           or  Argument (2) = "app"
         then
            the_Command.project_Kind := Applet;

         elsif Argument (2) = "library"
           or  Argument (2) = "lib"
         then
            the_Command.project_Kind := Library;

         else
            log ("'list' project kind must be (all | app | applets | lib | libraries)");
            return;
         end if;

         log ("'list' is yet to be implemented.");
         return;
      end if;


      if Argument (1) = "move"
      then
         the_Command := (Kind   => Move,
                         others => <>);

         if argument_Count < 2
         then
            log ("Too few options given for 'move'.");
            return;

         elsif argument_Count > 2
         then
            log ("Too many options given for 'move'.");
            return;
         end if;

         if exists (to_Folder (Argument (2)))
         then
            log ("Moving project to folder '" & Argument (2) & "'.");
            the_Command.new_Location := to_Folder (Argument (2));
         else
            log ("New location folder '" & Argument (2) & "' does not exist.");
            return;
         end if;

         log ("'move' is yet to be implemented.");
         return;
      end if;

   end parse_command_Line;


   log ("Done.");
end ASL_Applet;
