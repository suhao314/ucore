!-- thWrite.f90
!-- 31 Jul 92, Richard Maine: Version 1.0.

module th_write

  !-- Module for write access to time history files.
  !-- Does not support cmp2(elxsi) or enc1(sel) formats.
  !-- 31 Jul 92, Richard Maine.

  use precision
  use sysdep_io
  use string
  use th_write_asc12
  use th_write_unc2
  use th_write_unc3
  use th_write_cmp3
  use th_write_lis1

  implicit none
  private

  logical, save :: th_write_initialized = .false.

  integer, parameter :: n_formats = 7
  integer, parameter :: usr1_code = 1, asc1_code = 2, asc2_code = 3, &
       unc2_code = 4, unc3_code = 5, cmp3_code = 6, lis1_code = 7
  character, save :: format_names(n_formats)*8 = ' none '
  
  type fd_type  !-- fd is short for file_descriptor
    integer :: format_code
    integer :: n_signals
    real(r_kind) :: prev_time
    integer, pointer :: gen(:)
         !-- Generic array for format-specific data.
         !-- The format-specific modules may allocate it to the size needed.
         !-- Some modules may find a simple array of integers adequate.
         !-- Other modules may need a more complex structure, in which
         !-- case they can use the transfer intrinsic.
  end type

  !-- Handles are public with private components.
  type, public :: th_write_handle_type
    private
    type(fd_type), pointer :: fd
  end type

  type(fd_type), pointer :: fd  !-- Scratch use only.  Not saved.

  !-- Public procedures.
  public open_th_write, close_th_write, write_th

contains

  subroutine init_th_write

    !-- Initialize the th_write module.
    !-- Will automatically be called when needed.
    !-- 14 Jun 90, Richard Maine.

    !-------------------- executable code.

    if (th_write_initialized) return
    th_write_initialized = .true.

    format_names(asc1_code) = asc1_format_string
    format_names(asc2_code) = asc2_format_string
    format_names(unc2_code) = unc2_format_string
    format_names(unc3_code) = unc3_format_string
    format_names(cmp3_code) = cmp3_format_string
    format_names(lis1_code) = lis1_format_string
    return
  end subroutine init_th_write

  subroutine open_th_write (file_handle, file_name, file_format, &
       signal_names, eu_names, dt, file_title, format_parameters, error)

    !-- Open a time history file for write access.
    !-- 31 Jul 92, Richard Maine.

    !-------------------- interface.
    type(th_write_handle_type), intent(out) :: file_handle
         !-- Identifies the file for subsequent reference.
         !-- Returns a null handle if open fails.
    character*(*), intent(in) :: file_name
    character*(*), intent(in), optional :: file_format  !-- Default is cmp3.
    character*(*), intent(in) :: signal_names(:)
         !-- Defines the number and names of the signals to be written.
    character*(*), intent(in), optional :: eu_names(:)
         !-- Engineering units names corresponding to signal_names.
         !-- If present, must be the same size as signal_names.
    real(r_kind), intent(in), optional :: dt
         !-- Nominal sample interval.  Default is 0, which implies unknown.
    character*(*), intent(in), optional :: file_title   !-- Default is none.
    real(r_kind), intent(in), optional :: format_parameters(:)
         !-- Format-specific parameters.
    logical, intent(out), optional :: error
         !-- Abort if open fails and this is not present.

    !-------------------- local.
    integer :: iostat, format_code
    logical :: sub_error
    character :: format_name*8, where*32

    !-------------------- executable code.

    if (.not. th_write_initialized) call init_th_write

    !-- Allocate a file handle.
    nullify(fd)
    allocate(fd, stat=iostat)
    file_handle%fd => fd
    if (iostat /= 0) then
      where = 'allocate'; goto 8000; endif
    nullify(fd%gen)
    fd%format_code = 0

    !-- Validate arguments.
    if (present(eu_names)) then
      if (size(eu_names) /= size(signal_names)) then
        where = 'eu_names size'; goto 8000; endif
    end if

    !-- Set file format code.
    format_name = ''
    if (present(file_format)) format_name = file_format
    format_code = cmp3_code
    if (format_name .ne. '') &
      format_code = string_index(string=format_name, list=format_names)
    if (format_code==0) then
      where = 'format: ' // format_name; goto 8000; endif

    !-- Open the file according to the format.
    select case(format_code)
    case (asc1_code)
      call open_th_write_asc12(1,fd%gen, file_name, signal_names, &
           eu_names, dt, file_title, error=sub_error)
    case (asc2_code)
      call open_th_write_asc12(2,fd%gen, file_name, signal_names, &
           eu_names, dt, file_title, error=sub_error)
    case (unc2_code)
      call open_th_write_unc2(fd%gen, file_name, signal_names, &
           eu_names, dt, file_title, error=sub_error)
    case (unc3_code)
      call open_th_write_unc3(fd%gen, file_name, signal_names, &
           eu_names, dt, file_title, error=sub_error)
    case (cmp3_code)
      call open_th_write_cmp3(fd%gen, file_name, signal_names, &
           eu_names, dt, file_title, format_parameters, error=sub_error)
    case (lis1_code)
      call open_th_write_lis1(fd%gen, file_name, signal_names, &
           eu_names, dt, file_title, error=sub_error)
    case default
      sub_error = .true.
    end select
    if (sub_error) then
      where = 'open format: ' // format_name; goto 8000; endif

    !-- Normal return.
    fd%format_code = format_code
    fd%n_signals = size(signal_names)
    fd%prev_time = -big_real
    if (present(error)) error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_write failed at ' // where)
    call write_error_msg('File: ' // file_name)
    if (associated(fd)) call close_th_write(file_handle, sub_error)
    if (.not.present(error)) call error_halt
    error = .true.
    return
  end subroutine open_th_write

  subroutine close_th_write (file_handle, error)

    !-- Close a file opened by open_th_write.
    !-- 16 Jun 90, Richard Maine.

    !-------------------- interface.
    type(th_write_handle_type), intent(inout) :: file_handle
         !-- Set to a null handle on exit.
    logical, intent(out), optional :: error
         !-- Abort if close fails and this is not present.

    !-------------------- local.
    logical :: sub_error

    !-------------------- executable code.

    if (present(error)) error = .false.

    !-- Quietly return if the handle is null; otherwise validate it.
    !-- Ideally, we should not be called with a null handle,
    !-- but we will allow it.
    fd => file_handle%fd
    if (.not. associated(fd)) return

    !-- Close according to the format.
    sub_error = .false.
    select case (fd%format_code)
    case (asc1_code,asc2_code)
      call close_th_write_asc12(fd%gen, sub_error)
    case (unc2_code)
      call close_th_write_unc2(fd%gen, sub_error)
    case (unc3_code)
      call close_th_write_unc3(fd%gen, sub_error)
    case (cmp3_code)
      call close_th_write_cmp3(fd%gen, sub_error)
    case (lis1_code)
      call close_th_write_lis1(fd%gen, sub_error)
    case (0)  !-- This may happen if called from open_th_write.
      sub_error = .false.
    case default
      sub_error = .true.
    end select

    !-- Free the handle.
    if (associated(fd%gen)) deallocate(fd%gen)
    deallocate(fd)
    if (sub_error) then
      call write_error_msg('Close_th_write failed.')
      if (.not. present(error)) call error_halt
      error = .true.
    end if
    return
  end subroutine close_th_write

  subroutine write_th (file_handle, time, data, error)

    !-- Write a frame to a time history file.
    !-- 16 Jun 90, Richard Maine.

    !-------------------- interface.
    type(th_write_handle_type), intent(in) :: file_handle
    real(r_kind), intent(in) :: time     !-- Frame time in seconds.
    real(r_kind), intent(in) :: data(:)  !-- Frame data.
    logical, intent(out), optional :: error
         !-- Abort if write fails and this is not present.

    !-------------------- local.
    logical :: sub_error
    character :: msg*80

    !-------------------- executable code.

    fd => file_handle%fd
    if (.not. associated(fd)) call error_halt('Closed th_write file_handle')

    if (size(data) < fd%n_signals) &
         call error_halt('Wrong data length in write_th')

    !-- Check for times out of order.
    if (time <= fd%prev_time) then
      msg = 'Times out of order in write_th'; goto 8000; endif

    !-- Write according to the format.
    sub_error = .true.
    select case (fd%format_code)
    case (asc1_code,asc2_code)
      call write_th_asc12(fd%gen, time, data(:fd%n_signals), sub_error)
    case (unc2_code)
      call write_th_unc2(fd%gen, time, data(:fd%n_signals), sub_error)
    case (unc3_code)
      call write_th_unc3(fd%gen, time, data(:fd%n_signals), sub_error)
    case (cmp3_code)
      call write_th_cmp3(fd%gen, time, data(:fd%n_signals), sub_error)
    case (lis1_code)
      call write_th_lis1(fd%gen, time, data(:fd%n_signals), sub_error)
    end select
    fd%prev_time = time
    if (sub_error) then
      msg = 'Write failed in write_th.'; goto 8000; endif

    !-- Normal return
    if (present(error)) error = .false.
    return

    !-- Error exit.
    8000 continue
    call write_error_msg(msg)
    if (.not. present(error)) call error_halt
    error = .true.
    return
  end subroutine write_th

end module th_write
