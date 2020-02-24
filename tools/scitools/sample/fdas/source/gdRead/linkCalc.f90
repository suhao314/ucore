!-- linkCalc.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module link_calc

  !-- Calculated function interface for gd_read.
  !-- This module links calculated functions to gd_read.
  !-- This version supports only pre-linked subroutines.
  !-- 15 Mar 91, Richard Maine.

  use precision
  use sysdep_io
  use string
  use gd_list

  use gd_calc1, calc1_name => calc_name, &
       open_calc1 => open_calc, close_calc1 => close_calc, &
       request_calc1_signals => request_calc_signals, do_calc1 => do_calc
  use gd_calc2, calc2_name => calc_name, &
       open_calc2 => open_calc, close_calc2 => close_calc, &
       request_calc2_signals => request_calc_signals, do_calc2 => do_calc

  implicit none
  private

  !-- link_calc_type has information about a calculation.
  type, private :: link_calc_type
    integer :: subroutine_number
         !-- Index of the linked subroutine set for this calc.
    integer, pointer :: sub_handle(:)
         !-- handle used by the subroutine set for this calc.
  end type

  !-- Handles are public with private components.
  type, public :: calc_handle_type
    private
    type(link_calc_type), pointer :: calc
  end type

  !-- Public procedures.
  public open_gd_calc, close_gd_calc, request_gd_calc_signals, do_gd_calc

contains

  subroutine open_gd_calc (calc_handle, calc_name, calc_linker, &
       calc_parameters, calc_string, input_list, output_list, &
       calc_description, error)

    !-- Initialize a calculated function and link it to a handle.
    !-- 31 Dec 90, Richard Maine.

    !-------------------- interface.
    type(calc_handle_type), intent(out) :: calc_handle
           !-- Identifies the calculation for subsequent reference.
           !-- Returns a null handle if the open fails.
    character*(*), intent(in) :: calc_name
    character*(*), intent(in), optional :: calc_linker
           !-- The calc_linker and calc_name, taken together, define
           !-- which set of calculated function routines is referenced.
           !-- The specific interpretation of the linker and name is not
           !-- defined by the interface and may vary from implementation
           !-- to implementation.  Some implementations may even ignore
           !-- them entirely.  The calc_linker argument is intended for
           !-- implementations where calculated functions can be
           !-- dynamically accessed at run time without being
           !-- pre-linked into the executable program.
           !-- This version ignores calc_linker and recognizes names
           !-- that match the calc_name values from the calc routines.
    real(r_kind), intent(in) :: calc_parameters(:)
           !-- Interpretation of these parameters depends on the calc routines.
           !-- Many calc routines ignore them.
    character*(*), intent(in) :: calc_string
           !-- Interpretation of this parameter depends on the calc routines.
           !-- Many calc routines ignore it.
    type(gd_list_type), pointer :: input_list, output_list
           !-- Linked lists of the input and output names.
           !-- These are null on entry.
    character*(*), intent(out) :: calc_description
           !-- A one-line description of the calculated function set.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat
    character :: calc_names(2)*16
    type(link_calc_type), pointer :: calc

    !-------------------- executable code.

    error = .true.

    !-- Allocate a calc descriptor.
    nullify(calc)
    allocate(calc, stat=iostat)
    calc_handle%calc => calc
    if (iostat /= 0) goto 8000

    !-- Determine which subroutine set is to be used.
    calc_names(1) = calc1_name
    calc_names(2) = calc2_name
    calc%subroutine_number = string_index(string=calc_name, list=calc_names)

    !-- Open the calc.
    gd_list_error = .false.
    nullify(calc%sub_handle)
    select case (calc%subroutine_number)
    case (1)
       call open_calc1(calc%sub_handle, calc_parameters, calc_string, &
            input_list, output_list, calc_description, &
            error)
    case (2)
       call open_calc2(calc%sub_handle, calc_parameters, calc_string, &
            input_list, output_list, calc_description, &
            error)
    case default
       call write_error_msg('No such calc name: ' // calc_name)
       error = .true.
    end select
    if (error) then
       calc%subroutine_number = 0
       goto 8000
    end if

    !-- Check whether any gd_list errors occurred.  This frees the
    !-- user routines from the necessity of checking after each call.
    if (gd_list_error) goto 8000

    !-- normal exit.
    error = .false.
    return

    !---------- error exit.
    8000 continue
    call close_gd_calc(calc_handle)
    error = .true.
    return
  end subroutine open_gd_calc

  subroutine close_gd_calc (calc_handle)

    !-- Close a calculated function opened with open_gd_calc.
    !-- 14 Mar 91, Richard Maine.

    !-------------------- interface.
    type(calc_handle_type), intent(inout) :: calc_handle
           !-- Returns a null handle on exit.

    !-------------------- local.
    type(link_calc_type), pointer :: calc

    !-------------------- executable code.

    !-- Quietly return if the handle is null.
    calc => calc_handle%calc
    if (.not. associated(calc)) return

    !-- Close the connection.
    select case (calc%subroutine_number)
    case (1)
       call close_calc1(calc%sub_handle)
    case (2)
       call close_calc2(calc%sub_handle)
    case (0)  !-- This may happen if called from open_gd_calc
       continue
    end select

    if (associated(calc%sub_handle)) deallocate(calc%sub_handle)
    deallocate(calc_handle%calc)
    return
  end subroutine close_gd_calc

  subroutine request_gd_calc_signals (calc_handle, output_used, input_used)

    !-- Request the signals to be calculated in a calculated function.
    !-- 15 Mar 91, Richard Maine.

    !-------------------- interface.
    type(calc_handle_type), intent(in) :: calc_handle
    logical, intent(in) :: output_used(:)
         !-- Flags which output signals are used.
         !-- Size of this vector isn't currently checked.
    logical, intent(out) :: input_used(:)
         !-- Flags which input signals are needed for the specified outputs.
         !-- Size of this vector isn't currently checked.

    !-------------------- local.
    type(link_calc_type), pointer :: calc
    logical :: out_used(size(output_used))  !-- Modifiable local copy.

    !-------------------- executable code.

    calc => calc_handle%calc

    !-- Initialize input_used for convenience of user routines.
    input_used = .false.
    out_used = output_used

    !-- Call the specific request routine.
    select case (calc%subroutine_number)
    case (1)
       call request_calc1_signals(calc%sub_handle, out_used, input_used)
    case (2)
       call request_calc2_signals(calc%sub_handle, out_used, input_used)
    end select
    return
  end subroutine request_gd_calc_signals

  subroutine do_gd_calc (calc_handle, reset, time, input_data, output_data, &
       error)

    !-- Do a calculated function for one time frame.
    !-- 15 Mar 91, Richard Maine.

    !-------------------- interface.
    type(calc_handle_type), intent(in) :: calc_handle
    logical, intent(in) :: reset
         !-- True on the first frame of a time interval or after a time jump.
    real(r_kind), intent(in) :: time  !-- frame time.
    real(r_kind), intent(in) :: input_data(:)
         !-- Signals not flagged as used might be 0.
         !-- Size of this vector isn't currently checked.
    real(r_kind), intent(out) :: output_data(:)
         !-- Signals not flagged as used need not be computed.
         !-- Size of this vector isn't currently checked.
    logical, intent(out) :: error  !-- True if an error occurs.

    !-------------------- local.
    type(link_calc_type), pointer :: calc

    !-------------------- executable code.

    !-- Currently no error checking on the handle or on array sizes.
    calc => calc_handle%calc

    !-- Initialize error for convenience of user routines.
    error = .false.

    !-- Call the calc routine.
    select case (calc%subroutine_number)
    case (1)
       call do_calc1(calc%sub_handle, reset, time, input_data, output_data, &
            error)
    case (2)
       call do_calc2(calc%sub_handle, reset, time, input_data, output_data, &
            error)
    end select
    return
  end subroutine do_gd_calc

end module link_calc
