!-- sampleCalc.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module sample_calc

  !-- Sample getData calculated function module.
  !-- Illustrates aileron, elevator, and keas calculation.
  !-- This version does not support multiple simultaneous opens.
  !-- 15 Mar 90, Richard Maine.

  use precision
  use gd_list

  implicit none
  private

  !-- Name used to identify this calculated function.
  character, public :: calc_name*(16)='sampleCalc'

  logical, save :: calc_open = .false.

  !-- Signal numbers.
  integer, save :: i_del, i_der, i_qbar
  integer, save :: o_de, o_da, o_keas
  logical, save :: use_de, use_da, use_keas

  !-- Public procedures.
  public open_calc, close_calc, request_calc_signals, do_calc

contains

  subroutine open_calc (calc_handle, calc_parameters, calc_string, &
       input_list, output_list, calc_description, error)

    !-- Open the calculated function connection.
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

    !-- Refuse to open multiple copies.
    error = calc_open
    if (error) return
    calc_open = .true.

    calc_description = 'Sample calculated function.  Version 4.0, 14 Mar 91.'

    !-- Define input signal list.
    call add_list_node('der', input_list, i_der)
    call add_list_node('del', input_list, i_del)
    call add_list_node('qbar', input_list, i_qbar)

    !-- Define output signal list.
    call add_list_node('de', output_list, o_de)
    call add_list_node('da', output_list, o_da)
    call add_list_node('keas', output_list, o_keas)
    return
  end subroutine open_calc

  subroutine close_calc (calc_handle)

    !-- Close the calculated function connection.
    !-- 14 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: calc_handle(:)  !-- See open_calc.

    !-------------------- executable code.

    calc_open = .false.
    return
  end subroutine close_calc

  subroutine request_calc_signals (calc_handle, output_used, input_used)

    !-- Request signals from a calculated function.
    !-- 15 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: calc_handle(:)  !-- See open_calc.
    logical, intent(inout) :: output_used(:)
         !-- Flags which output signals should be calculated.
    logical, intent(inout) :: input_used(:)
         !-- Flags which input signals are required for the calculations.
         !-- Initialized to false on entry.

    !-------------------- executable code.

    !-- de and da calculations.
    use_de = output_used(o_de)
    use_da = output_used(o_da)
    if (use_de .or. use_da) then
      input_used(i_del) = .true.
      input_used(i_der) = .true.
    end if

    !-- keas calculation.
    use_keas = output_used(o_keas)
    if (use_keas) input_used(i_qbar) = .true.

    return
  end subroutine request_calc_signals

  subroutine do_calc (calc_handle, reset, time, input_data, output_data, error)

    !-- Compute calculated functions for one time frame.
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

    !-- de is the average of the left and right surfaces.
    if (use_de) output_data(o_de) = .5*(input_data(i_del) + input_data(i_der))

    !-- da is (left-right)/2.
    if (use_da) output_data(o_da) = .5*(input_data(i_del) - input_data(i_der))

    !-- keas.
    if (use_keas) then
      output_data(o_keas) = 0.
      if (input_data(i_qbar) > 0.) &
           output_data(o_keas) = 17.17*sqrt(input_data(i_qbar))
    end if

    return
  end subroutine do_calc

end module sample_calc

module gd_calc1

  !-- Wrapper module to use sample_calc for gd_calc1
  !-- 14 Mar 91, Richard Maine.

  use sample_calc

end module gd_calc1
