with
     asl2ada.parser_Model.Declaration.of_exception;


package asl2ada.parser_Model.DB
is

   function  fetch_Exceptions                  return Declaration.of_exception.vector;
   function  fetch (Name :          in String) return Declaration.of_exception.view;
   procedure add   (the_Exception : in                Declaration.of_exception.view);

   function contains_Exception (Named : in String) return Boolean;




end asl2ada.parser_Model.DB;
