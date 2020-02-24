!-- sampleFilt.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module gd_filter1

  !-- Sample getData 3rd order lowpass filter module.
  !-- 22 Mar 91, Richard Maine.

  use precision
  use sysdep_io

  implicit none
  private

  !-- Name used to identify this filter.
  character, public :: filter_name*(16)='low3Filt'

  type filter_type
    logical :: is_open   !-- Is this filter open or free?
    real(r_kind) :: eat, gain1     !-- Coefficients for 1st order lowpass.
    real(r_kind) :: c1, c2, gain2  !-- Coefficients for 2nd order lowpass.
    real(r_kind), pointer :: u1(:)         !-- Prev input.
    real(r_kind), pointer :: z1(:), z2(:)  !-- Prev and 2 prev output.
    real(r_kind), pointer :: y0(:), y1(:), y2(:)
         !-- Current, prev, and 2 prev intermediate state.
  end type
  type filter_ptr_type
    type(filter_type), pointer :: filter
  end type

  type(filter_ptr_type) :: filter_ptr  !-- Scratch use only.  Not saved.

  !-- Public procedures.
  public open_filter, close_filter, do_filter

contains

  subroutine open_filter (filter_handle, filter_dt, filter_parameters, &
       n_signals, filter_description, error)

    !-- Open the filter connection.
    !-- 22 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: filter_handle(:)
         !-- A handle used to distinguish multiple opens.
         !-- May be ignored if this filter does not support multiple opens.
         !-- Otherwise, may be allocated to any required size and used
         !-- to save data between calls.  Initialized to null on entry.
         !-- For this filter, it stores a pointer to the filter structure.
    real(r_kind), intent(in) :: filter_dt
         !-- Sample interval for the filter.
    real(r_kind), intent(in) :: filter_parameters(:)
         !-- Interpretation of the parameters depends on the
         !-- filter routines.  The most common parameter will
         !-- probably be filter break frequency.
         !-- This module expects 1 parameter, the break frequency in Hz.
    integer, intent(in) :: n_signals
         !-- Number of signals using this filter.
         !-- This count includes all signals defined to use the filter
         !-- regardless of whether the signals are activated or not.
         !-- The number of active signals using the filter may be
         !-- smaller, but will not exceed n_signals.
    character*(*), intent(out) :: filter_description
         !-- Description (typically up to 80 characters) of this filter.
    logical, intent(out) :: error  !-- True if an error occurs.

    !-------------------- local.
    integer :: iostat, handle_size
    type(filter_type), pointer :: f
    real(r_kind) :: freq, w_dt, eabt
    real(r_kind), parameter :: pi=3.14159265358979_r_kind

    !-------------------- executable code.

    !-- Allocate a filter.
    nullify(f)
    allocate(f, stat=iostat)
    if (iostat /= 0) goto 8000
    nullify(f%u1, f%y0, f%y1, f%y2, f%z1, f%z2)
    handle_size = size(transfer(filter_ptr,filter_handle))
    allocate(filter_handle(handle_size), stat=iostat)
    if (iostat /= 0)  goto 8000
    filter_ptr%filter => f
    filter_handle = transfer(filter_ptr,filter_handle)

    if (size(filter_parameters) < 1) then
       call write_error_msg('Too few filter parameters.')
       goto 8000
    end if

    filter_description = &
       'Sample 3rd order lowpass filter.  Version 4.0, 7 Nov 91.'

    !-- Compute filter coefficients.
    freq = filter_parameters(1)
    w_dt = filter_dt*freq*2.*pi
    f%eat = exp(-w_dt)
    f%gain1 =.5*(1. - f%eat)
    eabt = exp(-sqrt(.75_r_kind)*w_dt)
    f%c1 = 2.*eabt*cos(.5*w_dt)
    f%c2 = -(eabt**2)
    f%gain2 = .25*(1. - f%c1 - f%c2)

    !-- Normal return.
    error = .false.
    return

    !-- Error exit.
    8000 continue
    if (associated(f)) deallocate(f)
    error = .true.
    return
  end subroutine open_filter

  subroutine close_filter (filter_handle)

    !-- Close the filter connection.
    !-- 22 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: filter_handle(:)  !-- See open_filter.

    !-------------------- local.
    type(filter_type), pointer :: filter

    !-------------------- executable code.

    filter_ptr = transfer(filter_handle, filter_ptr)
    filter => filter_ptr%filter
    
    call release_filter_states(filter)
    return
  end subroutine close_filter

  subroutine release_filter_states (filter)

    !-- Deallocate the filter state buffers.
    !-- 22 Mar 90, Richard Maine.

    !-------------------- interface.
    type(filter_type), intent(inout) :: filter

    !-------------------- executable code.

    if (associated(filter%u1)) deallocate(filter%u1)
    if (associated(filter%z1)) deallocate(filter%z1)
    if (associated(filter%z2)) deallocate(filter%z2)
    if (associated(filter%y0)) deallocate(filter%y0)
    if (associated(filter%y1)) deallocate(filter%y1)
    if (associated(filter%y2)) deallocate(filter%y2)
    return
  end subroutine release_filter_states

  subroutine do_filter (filter_handle, reset, time, input_data, output_data, &
       error)

    !-- Compute filter for one time frame.
    !-- 22 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: filter_handle(:)  !-- See open_filter.
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
    logical, intent(inout) :: error
         !-- True if an error occurs.  Initialized to false on entry.

    !-------------------- local.
    type(filter_type), pointer :: f
    integer :: iostat, n

    !-------------------- executable code.

    filter_ptr = transfer(filter_handle, filter_ptr)
    f => filter_ptr%filter

    !-- Allocate and initialize filter state vectors.
    if (reset) then
      call release_filter_states(f)
      n = size(input_data)
      allocate(f%u1(n), f%y0(n), f%y1(n), f%y2(n), f%z1(n), f%z2(n), &
           stat=iostat)
      error = iostat /= 0
      if (error) return

      f%u1 = input_data
      f%y0 = input_data
      f%y1 = input_data
      f%y2 = input_data
      f%z1 = input_data
      f%z2 = input_data
      output_data = input_data

    !-- filter.
    !-- We currently ignore time and just assume that dt is constant.
    else
      !-- First order lowpass.
      f%y0 = f%eat*f%y1 + f%gain1*(input_data + f%u1)

      !-- Second order lowpass.
      output_data = f%c1*f%z1 + f%c2*f%z2 + f%gain2*(f%y0 + 2.*f%y1 + f%y2)

      !-- time-shift state vectors.
      f%u1 = input_data
      f%y2 = f%y1
      f%y1 = f%y0
      f%z2 = f%z1
      f%z1 = output_data
    end if
    return
  end subroutine do_filter

end module gd_filter1

module gd_filter2

  !-- Sample getData notch filter module.
  !-- 22 Mar 91, Richard Maine.

  use precision
  use sysdep_io

  implicit none
  private

  !-- Name used to identify this filter.
  character, public :: filter_name*(16)='notchFilt'

  type filter_type
    logical :: is_open   !-- Is this filter open or free?
    real(r_kind) :: c1, c2, b1, gain  !-- Filter coefficients.
    real(r_kind), pointer :: u1(:), u2(:)  !-- Prev and 2 prev input.
    real(r_kind), pointer :: z1(:), z2(:)  !-- Prev and 2 prev output.
  end type
  type filter_ptr_type
    type(filter_type), pointer :: filter
  end type

  type(filter_ptr_type) :: filter_ptr  !-- Scratch use only.  Not saved.

  !-- Public procedures.
  public open_filter, close_filter, do_filter

contains

  subroutine open_filter (filter_handle, filter_dt, filter_parameters, &
       n_signals, filter_description, error)

    !-- Open the filter connection.
    !-- 22 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: filter_handle(:)
         !-- A handle used to distinguish multiple opens.
         !-- May be ignored if this filter does not support multiple opens.
         !-- Otherwise, may be allocated to any required size and used
         !-- to save data between calls.  Initialized to null on entry.
         !-- For this filter, it stores a pointer to the filter structure.
    real(r_kind), intent(in) :: filter_dt
         !-- Sample interval for the filter.
    real(r_kind), intent(in) :: filter_parameters(:)
         !-- Interpretation of the parameters depends on the
         !-- filter routines.  The most common parameter will
         !-- probably be filter break frequency.
         !-- This module expects 1 parameter, the notch frequency in Hz.
    integer, intent(in) :: n_signals
         !-- Number of signals using this filter.
         !-- This count includes all signals defined to use the filter
         !-- regardless of whether the signals are activated or not.
         !-- The number of active signals using the filter may be
         !-- smaller, but will not exceed n_signals.
    character*(*), intent(out) :: filter_description
         !-- Description (typically up to 80 characters) of this filter.
    logical, intent(out) :: error  !-- True if an error occurs.

    !-------------------- local.
    integer :: iostat, handle_size
    type(filter_type), pointer :: f
    real(r_kind) :: freq, w_dt, w2_dt
    real(r_kind), parameter :: pi=3.14159265358979_r_kind

    !-------------------- executable code.

    !-- Allocate a filter.
    nullify(f)
    allocate(f, stat=iostat)
    if (iostat /= 0) goto 8000
    nullify(f%u1, f%u2, f%z1, f%z2)
    handle_size = size(transfer(filter_ptr,filter_handle))
    allocate(filter_handle(handle_size), stat=iostat)
    if (iostat /= 0)  goto 8000
    filter_ptr%filter => f
    filter_handle = transfer(filter_ptr,filter_handle)

    if (size(filter_parameters) < 1) then
       call write_error_msg('Too few filter parameters.')
       goto 8000
    end if

    filter_description = 'Sample notch filter.  Version 4.0, 22 Mar 91.'

    !-- Compute filter coefficients.
    freq = filter_parameters(1)
    w_dt = filter_dt*freq*2.*pi
    f%b1 = -2.*cos(w_dt)
    w2_dt = w_dt*sqrt(2._r_kind)
    f%c1 = 2.*exp(-w2_dt)*cos(w2_dt)
    f%c2 = -exp(-2.*w2_dt)
    f%gain = (1. - f%c1 - f%c2)/(2. + f%b1)

    !-- Normal return.
    error = .false.
    return

    !-- Error exit.
    8000 continue
    if (associated(f)) deallocate(f)
    error = .true.
    return
  end subroutine open_filter

  subroutine close_filter (filter_handle)

    !-- Close the filter connection.
    !-- 22 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: filter_handle(:)  !-- See open_filter.

    !-------------------- local.
    type(filter_type), pointer :: filter

    !-------------------- executable code.

    filter_ptr = transfer(filter_handle, filter_ptr)
    filter => filter_ptr%filter
    
    call release_filter_states(filter)
    return
  end subroutine close_filter

  subroutine release_filter_states (filter)

    !-- Deallocate the filter state buffers.
    !-- 22 Mar 90, Richard Maine.

    !-------------------- interface.
    type(filter_type), intent(inout) :: filter

    !-------------------- executable code.

    if (associated(filter%u1)) deallocate(filter%u1)
    if (associated(filter%u2)) deallocate(filter%u2)
    if (associated(filter%z1)) deallocate(filter%z1)
    if (associated(filter%z2)) deallocate(filter%z2)
    return
  end subroutine release_filter_states

  subroutine do_filter (filter_handle, reset, time, input_data, output_data, &
       error)

    !-- Compute filter for one time frame.
    !-- 22 Mar 90, Richard Maine.

    !-------------------- interface.
    integer, pointer :: filter_handle(:)  !-- See open_filter.
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
    logical, intent(inout) :: error
         !-- True if an error occurs.  Initialized to false on entry.

    !-------------------- local.
    type(filter_type), pointer :: f
    integer :: iostat, n

    !-------------------- executable code.

    filter_ptr = transfer(filter_handle, filter_ptr)
    f => filter_ptr%filter

    !-- Allocate and initialize filter state vectors.
    if (reset) then
      call release_filter_states(f)
      n = size(input_data)
      allocate(f%u1(n), f%u2(n), f%z1(n), f%z2(n), stat=iostat)
      error = iostat /= 0
      if (error) return

      f%u1 = input_data
      f%u2 = input_data
      f%z1 = input_data
      f%z2 = input_data
      output_data = input_data

    !-- filter.
    !-- We currently ignore time and just assume that dt is constant.
    else
      output_data = f%c1*f%z1 + f%c2*f%z2 + &
           f%gain*(input_data + f%b1*f%u1 + f%u2)

      !-- time-shift state vectors.
      f%u2 = f%u1
      f%u1 = input_data
      f%z2 = f%z1
      f%z1 = output_data
    end if
    return
  end subroutine do_filter

end module gd_filter2
