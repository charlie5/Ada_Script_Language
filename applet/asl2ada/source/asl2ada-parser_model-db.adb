with
     ada.Containers.indefinite_hashed_Maps,
     ada.Strings. Hash_case_insensitive,
     ada.Strings.Equal_case_insensitive;


package body asl2ada.parser_Model.DB
is

   --  function Hash (Name : in Identifier) return ada.Containers.Hash_type
   --  is
   --  begin
   --     return ada.Strings.Hash (+Name);
   --  end Hash;


   use type Declaration.of_exception.view;
   package name_Maps_of_exceptions is new ada.Containers.indefinite_hashed_Maps (Key_type        => String,
                                                                                 Element_type    => Declaration.of_exception.view,
                                                                                 Hash            => ada.Strings. Hash_case_insensitive,
                                                                                 equivalent_Keys => ada.Strings.Equal_case_insensitive);
   subtype name_Map_of_exceptions is name_Maps_of_exceptions.Map;

   all_Exceptions : name_Map_of_exceptions;



   function fetch_Exceptions return Declaration.of_exception.vector
   is
      Result : Declaration.of_exception.vector;
   begin
      for Each of all_Exceptions
      loop
         Result.append (Each);
      end loop;

      return Result;
   end fetch_Exceptions;



   function fetch (Name : in String) return Declaration.of_exception.view
   is
   begin
      return all_Exceptions.Element (Name);
   end fetch;



   procedure add (the_Exception : in Declaration.of_exception.view)
   is
   begin
      dlog ("************** '" & the_Exception.Name & "'");
      all_Exceptions.insert (the_Exception.Name,
                             the_Exception);
   end add;



   function contains_Exception (Named : in String) return Boolean
   is
   begin
      return all_Exceptions.contains (Named);
   end contains_Exception;



begin

   --- Add standard exceptions.
   --
   declare
      use Declaration.of_exception.Forge;

      constraint_error_Exception : constant Declaration.of_exception.view := new_exception_Declaration ("constraint_Error");
      program_error_Exception    : constant Declaration.of_exception.view := new_exception_Declaration (   "program_Error");
      storage_error_Exception    : constant Declaration.of_exception.view := new_exception_Declaration (   "storage_Error");
      tasking_error_Exception    : constant Declaration.of_exception.view := new_exception_Declaration (   "tasking_Error");
      numeric_error_Exception    : constant Declaration.of_exception.view := new_exception_Declaration (   "numeric_Error");
   begin
      all_Exceptions.insert (constraint_error_Exception.Name, constraint_error_Exception);
      all_Exceptions.insert (program_error_Exception.Name,       program_error_Exception);
      all_Exceptions.insert (storage_error_Exception.Name,       storage_error_Exception);
      all_Exceptions.insert (tasking_error_Exception.Name,       tasking_error_Exception);
      all_Exceptions.insert (numeric_error_Exception.Name,       numeric_error_Exception);
   end;

end asl2ada.parser_Model.DB;
