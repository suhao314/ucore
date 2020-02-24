!-- gdList.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module gd_list

  !-- Linked list module for get_data.
  !-- Maintain lists of names.
  !-- Specific to 16-character names as used throughout getData/fdas.
  !-- Does not handle lists of arbitrary type.
  !-- 14 Mar 91, Richard Maine.

  use sysdep_io

  implicit none
  private

  !-- The gd_list_error flag is set whenever an error occurs.
  !-- Calling routines can check whether any gd_list errors occurred
  !-- in a section of code by clearing the flag at the start and
  !-- testing it at the end of the section.  This may be more
  !-- convenient than testing the result of each individual call.
  logical, save, public :: gd_list_error = .false.

  !-- Nodes are public with private components.
  type, public :: gd_list_type
    private
    character :: name*16
    integer :: number
    type(gd_list_type), pointer :: prev
  end type

  !-- Public procedures.
  public add_list_node, get_list_array, deallocate_list, list_length

contains

  subroutine add_list_node (name, list, number)

    !-- Add a new node to a linked list.
    !-- 14 Mar 91, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: name
         !-- name to be entered into the list.
    type(gd_list_type), pointer :: list
         !-- End of the linked list.  Null for an empty list.
         !-- May be allocated on return if was null on entry.
    integer, intent(out) :: number
         !-- The list position for this name.
         !-- Returns 0 if the add fails.

    !-------------------- local.
    integer :: iostat
    type(gd_list_type), pointer :: new_node

    !-------------------- executable code.

    !-- Allocate a new node.
    allocate(new_node, stat=iostat)
    if (iostat /= 0) then
      number = 0
      gd_list_error = .true.
      return
    end if

    number = 1
    new_node%name = name

    !-- Append to existing list if any.
    if (associated(list)) number = list%number + 1
    new_node%number = number
    new_node%prev => list
    list => new_node
    return
  end subroutine add_list_node

  function list_length (list)

    !-- Return the length of a linked list.
    !-- 14 Mar 91, Richard Maine.

    !-------------------- interface.
    type(gd_list_type), pointer :: list
         !-- Intent(in). End of the linked list.  Null for an empty list.
    integer :: list_length  !-- Number of names in the list.

    !-------------------- executable code.

    list_length = 0
    if (associated(list)) list_length = list%number
    return
  end function list_length

  subroutine get_list_array (list, array)

    !-- Retrieve the list into an array.
    !-- Aborts on errors.
    !-- 14 Mar 91, Richard Maine.

    !-------------------- interface.
    type(gd_list_type), pointer :: list
         !-- Intent(in). End of the linked list.  Null for an empty list.
    character*(*), intent(out) :: array(:)
         !-- Names from the list.

    !-------------------- local.
    integer :: i
    type(gd_list_type), pointer :: node

    !-------------------- executable code.

    !-- Fill the array down from the top.
    node => list
    do i = size(array) , 1 , -1
      if (.not. associated(node)) call error_halt('Missing list node.')
      if (node%number /= i) call error_halt('Wrong list node.')
      array(i) = node%name
      node => node%prev
    end do
    if (associated(node)) call error_halt('Extra list node.')
    return
  end subroutine get_list_array

  subroutine deallocate_list (list)

    !-- Deallocate a linked list.
    !-- 14 Mar 91, Richard Maine.

    !-------------------- interface.
    type(gd_list_type), pointer :: list
         !-- Intent(inout).  End of the linked list.  Null on return.

    !-------------------- local.
    type(gd_list_type), pointer :: node

    !-------------------- executable code.

    do while (associated(list))
      node => list%prev
      deallocate(list)
      list => node
    end do
    return
  end subroutine deallocate_list

end module gd_list
