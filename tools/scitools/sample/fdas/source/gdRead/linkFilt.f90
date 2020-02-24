!-- linkFilt.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module link_filter

  !-- Filter interface for gd_read.
  !-- This module is called from gd_read to do filtering.
  !-- This version supports only linked in subroutines.
  !-- 21 Mar 91, Richard Maine.

  use precision
  use sysdep_io
  use string

  use gd_filter1, filter1_name => filter_name, &
       open_filter1 => open_filter, close_filter1 => close_filter, &
       do_filter1 => do_filter
  use gd_filter2, filter2_name => filter_name, &
       open_filter2 => open_filter, close_filter2 => close_filter, &
       do_filter2 => do_filter

  implicit none
  private

  !-- link_filter_type has information about a filter.
  type link_filter_type
    integer :: subroutine_number
         !-- Index of the linked subroutine set for this filter.
    integer, pointer :: sub_handle(:)
         !-- handle used by the subroutine set for this filter.
  end type

  !-- Handles are public with private components.
  type, public :: filter_handle_type
    private
    type(link_filter_type), pointer :: filter
  end type

  !-- Public procedures.
  public open_gd_filter, close_gd_filter, do_gd_filter

contains

  subroutine open_gd_filter (filter_handle, filter_name, filter_linker, &
       filter_dt, filter_parameters, n_signals, filter_description, error)

    !-- Initialize a filter and link it to a handle.
    !-- 21 Mar 91, Richard Maine.

    !-------------------- interface.
    type(filter_handle_type), intent(out) :: filter_handle
           !-- Identifies the filter for subsequent reference.
           !-- Returns a null handle if the open fails.
    character*(*), intent(in) :: filter_name
    character*(*), intent(in), optional :: filter_linker
           !-- The filter_linker and filter_name, taken together, define
           !-- which set of filter routines is referenced.
           !-- The specific interpretation of the linker and name is not
           !-- defined by the interface and may vary from implementation
           !-- to implementation.  Some implementations may even ignore
           !-- them entirely.  The filter_linker argument is intended for
           !-- implementations where filters can be
           !-- dynamically accessed at run time without being
           !-- pre-linked into the executable program.
           !-- This version ignores filter_linker and recognizes names
           !-- that match the filter_name values from the filter routines.
    real(r_kind), intent(in) :: filter_dt
           !-- Sample interval for the filter.
    real(r_kind), intent(in) :: filter_parameters(:)
           !-- Interpretation of the parameters depends on the
           !-- filter routines.  The most common parameter will
           !-- probably be filter break frequency.
    integer, intent(in) :: n_signals
           !-- Number of signals using this filter.
           !-- This count includes all signals defined to use the filter
           !-- regardless of whether the signals are activated or not.
           !-- The number of active signals using the filter may be
           !-- smaller, but will not exceed n_signals.
    character*(*), intent(out) :: filter_description
           !-- A one-line description of the filter set.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat
    character :: filter_names(2)*16
    type(link_filter_type), pointer :: filter

    !-------------------- executable code.

    error = .true.

    !-- Allocate a filter descriptor.
    nullify(filter)
    allocate(filter, stat=iostat)
    filter_handle%filter => filter
    if (iostat /= 0) goto 8000

    !-- Determine which subroutine set is to be used.
    filter_names(1) = filter1_name
    filter_names(2) = filter2_name
    filter%subroutine_number = &
         string_index(string=filter_name, list=filter_names)

    !-- Open the filter.
    nullify(filter%sub_handle)
    select case (filter%subroutine_number)
    case (1)
       call open_filter1(filter%sub_handle, filter_dt, filter_parameters, &
            n_signals, filter_description, error)
    case (2)
       call open_filter2(filter%sub_handle, filter_dt, filter_parameters, &
            n_signals, filter_description, error)
    case default
       call write_error_msg('No such filter name: ' // filter_name)
       error = .true.
    end select
    if (error) then
       filter%subroutine_number = 0
       goto 8000
    end if

    !-- normal exit.
    error = .false.
    return

    !---------- error exit.
    8000 continue
    call close_gd_filter(filter_handle)
    error = .true.
    return
  end subroutine open_gd_filter

  subroutine close_gd_filter (filter_handle)

    !-- Close a filter opened with open_gd_filter.
    !-- 21 Mar 91, Richard Maine.

    !-------------------- interface.
    type(filter_handle_type), intent(inout) :: filter_handle
           !-- Returns a null handle on exit.

    !-------------------- local.
    type(link_filter_type), pointer :: filter

    !-------------------- executable code.

    !-- Quietly return if the handle is null.
    filter => filter_handle%filter
    if (.not. associated(filter)) return

    !-- Close the connection.
    select case (filter%subroutine_number)
    case (1)
       call close_filter1(filter%sub_handle)
    case (2)
       call close_filter2(filter%sub_handle)
    case (0)  !-- This may happen if called from open_gd_filter
       continue
    end select

    if (associated(filter%sub_handle)) deallocate(filter%sub_handle)
    deallocate(filter_handle%filter)
    return
  end subroutine close_gd_filter

  subroutine do_gd_filter (filter_handle, reset, time, input_data, &
       output_data, error)

    !-- Do a filter for one time frame.
    !-- 21 Mar 91, Richard Maine.

    !-------------------- interface.
    type(filter_handle_type), intent(in) :: filter_handle
    logical, intent(in) :: reset
         !-- Should the filter be reset?
         !-- True on first frame of a time interval.
         !-- When this is true, internal buffers based on the size of
         !-- input_data and output_data are allocated or reallocated.
    real(r_kind), intent(in) :: time
    real(r_kind), intent(in) :: input_data(:)
    real(r_kind), intent(out) :: output_data(:)
         !-- Note that the size of input_data and output_data may be
         !-- less than the value of n_signals from open_gd_filter.
         !-- A new size is established whenever reset is true.
    logical, intent(out) :: error

    !-------------------- local.
    type(link_filter_type), pointer :: filter

    !-------------------- executable code.

    filter => filter_handle%filter

    !-- Initialize error for convenience of user routines.
    error = .false.

    !-- Call the filter routine.
    select case (filter%subroutine_number)
    case (1)
       call do_filter1(filter%sub_handle, reset, time, input_data, &
            output_data, error)
    case (2)
       call do_filter2(filter%sub_handle, reset, time, input_data, &
            output_data, error)
    end select
    return
  end subroutine do_gd_filter

end module link_filter
