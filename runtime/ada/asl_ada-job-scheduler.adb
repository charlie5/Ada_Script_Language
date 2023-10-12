package body Asl_Ada.Job.Scheduler
is

   procedure add (Self : in out Item;   new_Job : in Job.view)
   is
   begin
      Self.Queue.append (new_Job);
   end add;



   procedure evolve (Self : in out Item)
   is
   begin
      --- Sort the queue into 'Due' time order.
      --
      declare
         function "<" (Left, Right : in Job.view) return Boolean
         is
         begin
            return Left.Due < Right.Due;
         end "<";

         package Sorter is new Job_lists.generic_Sorting;
      begin
         Sorter.sort (Self.Queue);
      end;


      --- Perform all due jobs, in time order.
      --
      declare
         use Job_lists;

         Cursor : Job_lists.Cursor := Self.Queue.First;
      begin
         while has_Element (Cursor)
         loop
            declare
               the_Job : constant Job.view          := Element (Cursor);
               Now     : constant ada.Calendar.Time := Clock;
            begin
               if the_Job.Due <= Now
               then
                  the_Job.perform;

                  if the_Job.Due = Never
                  then
                     Self.Queue.delete (Cursor);
                  end if;

               else
                  exit;
               end if;
            end;

            next (Cursor);
         end loop;
      end;

   end evolve;


end Asl_Ada.Job.Scheduler;
