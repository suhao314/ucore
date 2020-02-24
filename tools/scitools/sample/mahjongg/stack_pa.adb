   --------------------------------------------------------------------
--|  Package  :  Stack_Package                 Version : 2.0
   --------------------------------------------------------------------
--|  Abstract :  Specification of a classic stack.
   --------------------------------------------------------------------
--|  File            : Spec_Stack.ada
--|  Compiler/System : Alsys Ada - IBM AIX/370
--|  Author          : Dan Stubbs/Neil Webre   Date : 2/27/92
--|  References      : Stubbs & Webre, Data Structures with Abstract
--|     Data Types and Ada, Brooks/Cole, 1993, Chapter 3.
   --------------------------------------------------------------------

generic

   type object_type is private;

package stack_package is

   type stack (max_size : positive) is limited private;

   stack_empty : exception;
   stack_full  : exception;

   procedure push (the_stack : in out stack; the_object : object_type);
   --
   -- Results : Pushes the_object onto the_stack.
   --
   -- Exceptions : stack_empty is raised if the stack contains
   --    max_size objects.
   --

   procedure pop (the_stack : in out stack);
   --
   -- Results : Returns, and removes from the_stack, the_object
   --    most recently pushed onto the_stack.
   --
   -- Exceptions : stack_empty is raised if the_stack is empty.
   --

   function top (the_stack : stack) return object_type;
   --
   -- Results : Returns the object most recently pushed onto
   --    the_stack.
   --
   -- Exceptions : stack_empty is raised if the_stack is empty.
   --

   procedure clear (the_stack : in out stack);
   --
   -- Results : Sets the number of objects in the_stack to zero.
   --

   function number_of_objects (the_stack : stack) return natural;
   --
   -- Results : Returns the number of objects in the_stack.
   --

   generic
       with procedure process (the_object : object_type);
   procedure iterate (the_stack : stack);
   --
   -- Results : Procedure process is applied to each object
   --    in the_stack. The order in which the objects are
   --    processed is NOT specified.
   --

   procedure copy (the_stack : stack; the_copy : in out stack);
   --
   -- Results : the_copy is a duplicate of the_stack.
   --
   -- note    : Consider using an instantiation of iterate to
   --    construct the copy. Can it be done?

   generic
       with function delete_this_object (the_object : object_type)
	       return boolean;
   procedure prune_stack (the_stack : in out stack);
   --
   -- Results : Delete from the_stack all objects for which
   --    delete_this_object is true.
   --

private

   type array_of_objects is array (positive range <>) of object_type;

   type stack (max_size : positive) is record
      latest  : natural := 0;
      objects : array_of_objects (1 .. max_size);
   end record;

end stack_package;

package body stack_package is
    
    procedure push (the_stack : in out stack; the_object : object_type) is
    --
    --    Length 4   Complexity 2   Performance O(1)
    --
    begin
       the_stack.objects(the_stack.latest + 1) := the_object;
       the_stack.latest := the_stack.latest + 1;
    exception
       when constraint_error => raise stack_full;
    end push;

    procedure pop (the_stack : in out stack) is
    --
    --    Length 2   Complexity 2   Performance O(1)
    --
    begin
       the_stack.latest := the_stack.latest - 1;
    exception
       when constraint_error | numeric_error => raise stack_empty;
    end pop;

    function top (the_stack : stack) return object_type is
    --
    --    Length 2   Complexity 2   Performance O(1)
    --
    begin
       return the_stack.objects(the_stack.latest);
    exception
       when constraint_error => raise stack_empty;
    end top;

    procedure clear (the_stack : in out stack) is
    --
    --    Length 1   Complexity 1   Performance O(1);
    --
    begin
       the_stack.latest := 0;
    end Clear;

    function number_of_objects (the_stack : stack) return natural is
    --
    --    Length 1   Complexity 1   Performance O(1)
    --
    begin
       return the_stack.latest;
    end number_of_objects;

    procedure iterate (the_stack : stack) is
    --
    --    Length 2    Complexity 2   Performance O(n)
    --
    begin
       for index in 1 .. the_stack.latest loop
          process (the_stack.objects(index));
       end loop;
    end iterate;

    procedure copy (the_stack : stack; the_copy : in out stack) is
    --
    --    Length 5    Complexity 2   Performance O(n)
    --
    begin
       if the_copy.max_size < the_stack.latest then
          raise stack_full;
       else
          the_copy.objects(1 .. the_stack.latest) :=
             the_stack.objects(1 .. the_stack.latest);
          the_copy.latest := the_stack.latest;
       end if;
    end copy;

    procedure prune_stack (the_stack : in out stack) is
    --
    --    Length 6    Complexity 3   Performance O(n)
    --
       destination : natural := 0;
    begin
       for k in 1 .. the_stack.latest loop
          if not delete_this_object(the_stack.objects(k)) then
             destination := destination + 1;
             the_stack.objects(destination) := the_stack.objects(k);
          end if;
       end loop;
       the_stack.latest := destination;
    end prune_stack;

end stack_package;

