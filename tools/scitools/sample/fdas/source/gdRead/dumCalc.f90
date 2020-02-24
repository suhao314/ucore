!-- dumCalc.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module dummy_gd_calc

  !-- Dummy getData calculated function module.
  !-- 15 Mar 91, Richard Maine.

  use precision
  use sysdep_io
  use gd_list

  implicit none
  private

  !-- Name used to identify this calculated function.
  character, public :: calc_name*(16)='dummyCalc'

  !-- Public procedures.
  public open_calc, close_calc, request_calc_signals, do_calc

contains

  subroutine open_calc (calc_handle, calc_parameters, calc_string, &
       input_list, output_list, calc_description, error)

    !-- Open the calculated function connection.
    !-- Dummy version always returns failure.
    !-- 14 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: calc_handle(:)
         !-- A handle used to distinguish multiple opens.
         !-- May be ignored if this calc does not support multiple opens.
         !-- Otherwise, may be allocated to any required size and used
         !-- to save data between calls.  Initialized to null on entry.
    real(r_kind), intent(in) :: calc_parameters(:)
         !-- Interpretation of these parameters depends on the calc routines.
         !-- Many calc routines ignore them.
    character*(*), intent(in) :: calc_string
         !-- Interpretation of this parameter depends on the calc routines.
         !-- Many calc routines ignore it.
    type(gd_list_type), pointer :: input_list, output_list
         !-- Linked lists of input and output signal names.  Null on entry.
    character*(*), intent(out) :: calc_description
         !-- Description (typically up to 80 characters) of this calc.
    logical, intent(out) :: error  !-- True if an error occurs.

    !-------------------- executable code.

    nullify(input_list, output_list)  !-- Suppress compiler warning.
    call write_error_msg('Attempt to open dummy calc.')
    error = .true.
    return
  end subroutine open_calc

  subroutine close_calc (calc_handle)

    !-- Close the calculated function connection.
    !-- Dummy version should never be called.
    !-- 14 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: calc_handle(:)  !-- See open_calc.

    !-------------------- executable code.

    call error_halt('Stub close_calc routine called.')
  end subroutine close_calc

  subroutine request_calc_signals (calc_handle, output_used, input_used)

    !-- Request signals from a calculated function.
    !-- Dummy version should never be called.
    !-- 15 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: calc_handle(:)  !-- See open_calc.
    logical, intent(inout) :: output_used(:)
         !-- Flags which output signals should be calculated.
    logical, intent(inout) :: input_used(:)
         !-- Flags which input signals are required for the calculations.
         !-- Initialized to false on entry.

    !-------------------- executable code.

    call error_halt('Stub request_calc_signals routine called.')
  end subroutine request_calc_signals

  subroutine do_calc (calc_handle, reset, time, input_data, output_data, error)

    !-- Compute calculated functions for one time frame.
    !-- Dummy version should never be called.
    !-- 15 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: calc_handle(:)  !-- See open_calc.
    logical, intent(in) :: reset
         !-- True on the first frame of a time interval or after a time jump.
    real(r_kind), intent(in) :: time  !-- frame time.
    real(r_kind), intent(in) :: input_data(:)
         !-- Signals not flagged as used might be 0.
    real(r_kind), intent(out) :: output_data(:)
         !-- Signals not flagged as used need not be computed.
    logical, intent(inout) :: error
         !-- True if an error occurs.  Initialized to false on entry.

    !-------------------- executable code.

    call error_halt('Stub do_calc routine called.')
  end subroutine do_calc

end module dummy_gd_calc

module gd_calc2

  !-- Wrapper module to use dummy_gd_calc for gd_calc2
  !-- 14 Mar 91, Richard Maine.

  use dummy_gd_calc

end module gd_calc2
