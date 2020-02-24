   --------------------------------------------------------------------
--|  Package  :  Queue_Package                 Version : 2.0
   --------------------------------------------------------------------
--|  Abstract :  Specification of a classic queue.
   --------------------------------------------------------------------
--|  File            : Spec_Queue.ada
--|  Compiler/System : Alsys Ada - IBM AIX/370                         
--|  Author          : Dan Stubbs/Neil Webre   Date : 2/27/92
--|  References      : Stubbs & Webre, Data Structures with Abstract
--|     Data Types and Ada, Brooks/Cole, 1993, Chapter 3.
   --------------------------------------------------------------------
--   Version  History: Add a new operation: TAIL  10/19/93 jd 
generic

   type object_type is private;

package queue_package is
   
   type queue (max_size : positive) is limited private;

   queue_empty : exception;
   queue_full  : exception;

   procedure enqueue (the_queue : in out queue; the_object : object_type);
   --
   -- Results : Adds the_object to the_queue.
   --
   -- Exceptions : queue_full is raised if the queue contains
   --    max_size objects.
   --

   procedure dequeue (the_queue : in out queue);
   --
   -- Results : Deletes the object that has been in the_queue
   --    the longest.
   --
   -- Exceptions : queue_empty is raised if the queue is empty.
   --

   function head (the_queue : queue) return object_type;
   --
   -- Results : Returns the object that has been in the_queue
   --    the longest.
   --
   -- Exceptions : queue_empty is raised if the_queue is empty.
   --

   function tail (the_queue : queue) return object_type;
   --
   -- Results : Returns the object that was most recently added
   --
   -- Exceptions : queue_empty is raised if the_queue is empty.
   --

   procedure clear (the_queue : in out queue);
   --
   -- Results : Sets the number of objects in the_queue to zero.
   --

   function number_of_objects (the_queue : queue) return natural;
   --
   -- Results : Returns the number of objects in the_queue.
   --

   procedure copy (the_queue : queue; the_copy : in out queue);
   --
   -- Results : the_copy is a duplicate of the_queue.
   --

   generic
       with procedure process (the_object : object_type);
   procedure iterate (the_queue : queue);
   --
   -- Results : Procedure process is applied to each object in the_queue
   --    until all objects have been processed.
   --

private
   type array_of_objects is array (positive range <>) of object_type;

   type queue (max_size : positive) is record
      size    : natural  := 0;
      first   : positive := 1;
      last    : positive := max_size;
      objects : array_of_objects (1 .. max_size);
   end record;

end queue_package;

package body queue_package is
    
    procedure enqueue (the_queue : in out queue; the_object : object_type) is
    --
    --    Length 6   Complexity 2    Performance   O(1)
    --
    begin
       if the_queue.size = the_queue.max_size then 
			 raise queue_full;
       end if;
       the_queue.last := (the_queue.last mod the_queue.max_size) + 1;
       the_queue.objects(the_queue.last) := the_object;
       the_queue.size := the_queue.size + 1;
    end enqueue;

    procedure dequeue (the_queue : in out queue) is
    --
    --    Length 3   Complexity 2    Performance   O(1)
    --
    begin
       the_queue.size := the_queue.size - 1;
       the_queue.first := (the_queue.first mod the_queue.max_size) + 1;
	 exception
		 when constraint_error | numeric_error => raise queue_empty;
    end dequeue;

    function head (the_queue : queue) return object_type is
    --
    --    Length 2   Complexity 2    Performance   O(1)
    --
    begin
       return the_queue.objects(the_queue.first);
	 exception
		 when constraint_error | numeric_error => raise queue_empty;
    end head;

    function tail (the_queue : queue) return object_type is
    --
    --    Length 2   Complexity 2    Performance   O(1)
    --
    begin
       return the_queue.objects(the_queue.last);
	 exception
		 when constraint_error | numeric_error => raise queue_empty;
    end tail;

    procedure clear (the_queue : in out queue) is
    --
    --    Length 3   Complexity 1    Performance   O(1);
    --
    begin
       the_queue.size := 0;
       the_queue.first := 1;
       the_queue.last := the_queue.max_size;
    end clear;

    function number_of_objects (the_queue : queue) return natural is
    --
    --    Length 1   Complexity 1    Performance   O(1)
    --
    begin
       return the_queue.size;
    end number_of_objects;

    procedure copy (the_queue : queue; the_copy : in out queue) is
    --
    --    Length 9   Complexity 4  Performance O(n)
    --       All objects in the_queue are copied.
    --
       index : positive := the_queue.first;
    begin
       if the_queue.size > the_copy.max_size then
          raise queue_full;
       elsif the_queue.size > 0 then
          clear (the_copy);
          loop
             enqueue (the_copy, the_queue.objects(index));
             exit when index = the_queue.last;
             index := (index mod the_queue.max_size) + 1;
          end loop;
       end if;
    end copy;

    procedure iterate (the_queue : queue) is
    --
    --    Length 6   Complexity 3    Performance O(n)
    --       Each of the n objects in the_queue is processed.
    --
       index : natural := the_queue.first;
    begin
       if the_queue.size > 0 then
          loop
             process (the_queue.objects(index));
             exit when index = the_queue.last;
             index := (index mod the_queue.max_size) + 1;
          end loop;
       end if;
    end iterate;

end queue_package;

