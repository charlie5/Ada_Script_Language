with
     lace.Environ.Paths,
     lace.Environ.Users,
     ASL,
     ada.Strings.Fixed;


procedure ASL_Applet
is
   use lace.Environ.Paths,
       lace.Environ.Users;

   BashRC : constant File := home_Folder + to_File (".bashrc");
begin
   ensure_Folder (home_Folder + to_Folder (".asl/bin"));

   declare
      use ada.Strings.fixed;

      export_PATH    : constant String  := "export PATH=" & to_String (home_Folder) & "/.asl/bin:$PATH     # Added by ASL.";
      BashRC_Content : constant String  := load (BashRC);
      Idx            : constant Natural := Index (BashRC_Content, export_PATH);
   begin
      if Idx = 0
      then
         append (BashRC, " ");
         append (BashRC, " ");
         append (BashRC, export_PATH);
      end if;
   end;

end ASL_Applet;
