package body Asl_Ada.Job.Scheduler
is

   procedure add (Self : in out Item;   new_Job : in Job.view)
   is
   begin
      Self.Pending.append (new_Job);
   end add;



   procedure evolve (Self : in out Item)
   is
   begin
      --- Sort the pending queue into 'Due' time order.
      --
      declare
         function "<" (Left, Right : in Job.view) return Boolean
         is
         begin
            return Left.Due < Right.Due;
         end "<";

         package Sorter is new Job_lists.generic_Sorting;
      begin
         Sorter.sort (Self.Pending);
      end;


      --- Move the pending jobs into 'Queue', in time order.
      --
      declare
         use Job_lists;
         queue_Cursor   : Job_lists.Cursor := Self.Queue  .First;
         pending_Cursor : Job_lists.Cursor := Self.Pending.First;
      begin
         while has_Element (pending_Cursor)
         loop
            if not has_Element (queue_Cursor)
            then
               Self.Queue.append (Element (pending_Cursor));
               Self.Pending.delete_First;
               pending_Cursor := Self.Pending.First;
               queue_Cursor   := Self.Queue.First;

            elsif Element (pending_Cursor).Due < Element (queue_Cursor).Due
            then
               Self.Queue.insert (before   => queue_Cursor,
                                  new_Item => Element (pending_Cursor));
               Self.Pending.delete_First;
               pending_Cursor := Self.Pending.First;

            else
               next (queue_Cursor);
            end if;
         end loop;
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
                  Self.Queue.delete (Cursor);

                  if the_Job.Due /= Never
                  then
                     Self.add (the_Job);
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
