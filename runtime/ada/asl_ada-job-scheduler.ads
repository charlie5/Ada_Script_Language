private
with
     ada.Containers.doubly_linked_Lists;


package Asl_Ada.Job.Scheduler
is
   type Item is tagged private;


   procedure add    (Self : in out Item;   new_Job : in Job.view);
   procedure evolve (Self : in out Item);



private

   package Job_lists is new ada.Containers.doubly_linked_Lists (Element_type => Job.view);
   subtype Job_list  is Job_lists.List;


   type Item is tagged
      record
         Queue : Job_list;
      end record;


end Asl_Ada.Job.Scheduler;
