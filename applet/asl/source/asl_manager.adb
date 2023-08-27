with
     lace.Environ.Paths,
     lace.Environ.Users,

     ada.Strings.Fixed,
     ada.Strings.unbounded,
     ada.command_Line,
     ada.Characters.latin_1,
     ada.Text_IO;


procedure ASL_Manager
is
   use lace.Environ.Paths,
       lace.Environ.Users,
       ada.Strings.unbounded;


   procedure log (Message : in String := "")
                  renames ada.Text_IO.put_Line;

   NL : constant String := [1 => ada.Characters.latin_1.LF];


   type command_Kind is (Create, List, Move);
   type project_Kind is (Applet, Library);

   type Command (Kind : command_Kind := Create) is
      record
         project_Kind : ASL_Manager.project_Kind;

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

   asl_Home          : constant Folder := home_Folder  + to_Folder (".asl");
   asl_Home_Bin      : constant Folder := asl_Home     + to_Folder ("bin");
   asl_Home_Bin_Exec : constant Folder := asl_Home_Bin + to_Folder ("exec");
   asl_Home_Projects : constant Folder := asl_Home     + to_Folder ("projects");

begin
   ensure_Folder (asl_Home_Bin_Exec);
   ensure_Folder (asl_Home_Projects);


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


   add_default_GPRs_to_asl_Home_Library:
   declare
      asl_intallation_Root                 : constant Folder := to_Folder ("/eden/forge/applet/tool/Ada_Script_Language/applet/asl");    -- TODO: Generalise this.
      asl_installation_default_GPRs_Folder : constant Folder := asl_intallation_Root + to_Folder ("default_GPRs");
   begin
      copy_Folder (asl_installation_default_GPRs_Folder, to => asl_Home_Projects);
   end add_default_GPRs_to_asl_Home_Library;


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



   process_Command:
   declare

   begin
      case the_Command.Kind
      is
         when Create =>
            create_Project:
            declare
               project_Name                   : constant String := to_String (the_Command.project_Name);
               project_Folder                 : constant Folder := to_Folder (project_Name);
               asl_Home_project_Folder        : constant Folder := asl_Home_Projects + project_Folder;
               asl_Home_project_source_Folder : constant Folder := asl_Home_Projects + project_Folder + to_Folder ("source");
               asl_source_File                : constant File   := to_File (project_Name) + "applet";
            begin
               log ("Creating project.");

               ensure_Folder (project_Folder);
               go_to_Folder  (project_Folder);

               add_applet_Source:
               declare
                  applet_Source : unbounded_String;
               begin
                  append (applet_Source, "applet " & project_Name & NL);
                  append (applet_Source, "is"                     & NL);
                  append (applet_Source, "begin"                  & NL);
                  append (applet_Source, "   do"                  & NL);
                  append (applet_Source, "   is"                  & NL);
                  append (applet_Source, "   begin"               & NL);
                  append (applet_Source, "      null;"            & NL);
                  append (applet_Source, "   end do;"             & NL);
                  append (applet_Source, "end " & project_Name & ";");

                  asl_source_File.save (to_String (applet_Source));
               end add_applet_Source;


               add_applet_Launcher:
               declare
                  launcher_File   : constant File   := asl_Home_Bin + to_File (project_Name);
                  launcher_Source : unbounded_String;

                  procedure add (Line : in String := "")
                  is
                  begin
                     append (launcher_Source, Line & NL);
                  end add;

               begin
                  add ("#!/bin/bash");
                  add;
                  add;
                  add ("SOURCE_ORIGIN=" & to_String (current_Folder));
                  add;
                  add ("pushd " & to_String (asl_Home_project_Folder)     & " > /dev/null");
                  add;
                  add ("asl2ada $SOURCE_ORIGIN/" & project_Name & ".applet source");
                  add;
                  add;
                  add ("gprbuild -v -m -p -P " & project_Name & "  > gprbuild.log  2> gprbuild-error.log");
                  add;
                  add ("Status=$?");
                  add;
                  add ("if [ $Status != 0 ];");
                  add ("then");
                  add ("   cat gprbuild-error.log");
                  add ("   exit");
                  add ("fi");
                  add;
                  add;
                  add ("popd > /dev/null");
                  add;
                  add;
                  add (to_String (  asl_Home_Bin
                                  + to_Folder ("exec")
                                  + to_File   (project_Name & ".exec")));

                  launcher_File.save (to_String (launcher_Source));
                  launcher_File.change_Mode ("a+x");     -- TODO: Needed ?
               end add_applet_Launcher;


               add_asl_Home_project_Folder:
               begin
                  ensure_Folder (asl_Home_project_Folder);
                  ensure_Folder (asl_Home_project_source_Folder);

                  create_project_GPR:
                  declare
                     gpr_File   : constant File   := asl_Home_project_Folder + to_File (project_Name) + "gpr";
                     gpr_Source : unbounded_String;

                     procedure add (Line : in String := "")
                     is
                     begin
                        append (gpr_Source, Line & NL);
                     end add;

                  begin
                     add ("with");
                     add ("     ""../default_GPRs/asl_applet_default"";");
                     add;
                     add;
                     add ("project " & project_Name);
                     add ("is");
                     add ("   for source_Dirs     use (""source"",");
                     add ("                            ""../../runtime/ada/**"");");
                     add ("   for object_Dir      use ""build"";");
                     add ("   for exec_Dir        use ""../../bin/exec"";");
                     add ("   for Main            use (""" & project_Name & "_applet-launch"");");
                     add;
                     add ("   package Builder is");
                     add ("      for default_Switches (""Ada"")     use asl_Applet_default.Builder'default_Switches (""Ada"");");
                     add ("      for global_configuration_Pragmas   use asl_Applet_default.Builder'global_configuration_Pragmas;");
                     add ("      for Executable       (""" & project_Name & "_applet-launch.adb"") use """ & project_Name & ".exec"";");
                     add ("   end Builder;");
                     add;
                     add ("end " & project_Name & ";");

                     gpr_File.save (to_String (gpr_Source));
                  end create_project_GPR;
               end add_asl_Home_project_Folder;

            end create_Project;


         when List =>
            log ("Listing projects.");


         when Move =>
            log ("Moving project.");
      end case;
   end process_Command;


   log ("Done.");
end ASL_Manager;
