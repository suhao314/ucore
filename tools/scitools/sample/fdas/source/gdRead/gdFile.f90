!-- gdFile.f90
!-- 19 Oct 92, Richard Maine: Version 1.0.

module gd_file

  !-- Time history file module for gd_read.
  !-- All the calls from gd_read to the th_read module go through here.
  !-- 19 Oct 92, Richard Maine.

  use precision
  use sysdep_io
  use gd_common
  use th_read

  implicit none
  private

  !-- file_signal_type has data about a signal from an input file.
  type file_signal_type
    character*(signal_name_len) :: name
    integer :: signal_number  !-- map to get_data signal list.
    logical :: used  !-- Is this signal used?
  end type

  !-- file_type has data about a single input file.
  type file_type
    logical :: opened  !-- Is this file open?
    type(th_read_handle_type) :: file_handle  !-- Handle from open_th_read.
    character*128 :: file_name  !-- File name for open_th_read.
    character*8 :: file_format  !-- Input for open_th_read.
    real(r_kind) :: file_skew  !-- Skew for file frame times.
    integer :: file_thin         !-- Thinning factor for read_th.
    real(r_kind) :: file_end  !-- Skewed end time of the file.
    type(file_type), pointer :: next_file
  end type

  !-- file_list_type has data about a list of spliced input files.
  type, public :: file_list_type
    private
    type(gd_source_type), pointer :: source
         !-- Generic information about the data source.
    type(file_signal_type), pointer :: signal(:)
         !-- Info about all the signals for this file.
    real(r_kind) :: start_time, stop_time  !-- requested time interval.
    real(r_kind) :: last_time  !-- Last time returned in the current interval.
    integer :: pending_status
         !-- Provisional status for next read_gd_file call.
         !--   0 (thr_ok) = ok.  Try the read.
         !--   1 (thr_eoi) = not used.
         !--   2 (thr_eod) = return end-of-data status.
         !--   3 (thr_error) = return error status.
    type(file_type), pointer :: first_file, last_file, file
  end type

  !-- Public procedures.
  public add_gd_file, splice_gd_file, release_gd_file, activate_gd_file
  public seek_gd_file, read_gd_file
  private open_and_seek

contains

  subroutine add_gd_file (file_list, file_name, file_format, &
       access_id, password, &
       file_dt, file_thin, file_skew, file_interpolate, &
       source_list, signal_list, source, error)

    !-- Open an input file for gd_read.
    !-- 18 Sept 92, Richard Maine.

    !-------------------- interface.
    type(file_list_type), intent(out) :: file_list
         !-- File record for gd_read.
    character*(*), intent(in) :: file_name
    character*(*), intent(in), optional :: file_format
         !-- Blank or missing means try automatic determination.
    character*(*), intent(in), optional :: access_id, password
         !-- Id and password for security authorization.
         !-- Blank or omitted values imply that no special access
         !-- permissions are requested.
    real(r_kind), intent(in), optional :: file_dt
         !-- Nominal file sample interval.
         !-- Need not be exactly correct unless filters are used.
         !-- Substantially wrong values may effect efficiency of skewing.
         !-- Values less than the actual sample interval may cause loss
         !-- of the first and last frames in each interval.
         !-- Will be obtained from the file if omitted or zero.
    integer, intent(in), optional :: file_thin
         !-- File thinning factor.  Default is 1.
    real(r_kind), intent(in), optional :: file_skew
         !-- File time skew.  Default is 0.
    logical, intent(in) :: file_interpolate
         !-- True means default to linear interpolation on this file.
         !-- False means default to hold-last-value.
    type(gd_source_list_type), intent(inout) :: source_list
         !-- List of get_data source records.
    type(gd_signal_list_type), intent(inout) :: signal_list
         !-- List of get_data signal records.
    type(gd_source_type), pointer :: source
         !-- Pointer to generic source data for the file.  Intent(out).
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat, i, n_signals
    character  :: where*8, description*80
    type(gd_signal_type), pointer :: gd_signal
    real(r_kind) :: dt
    type(file_type), pointer :: file

    !-------------------- executable code.

    where = 'allocate'
    nullify(file_list%signal)
    nullify(file_list%first_file, file_list%last_file, file_list%file)
    allocate(file, stat=iostat)
    if (iostat /= 0) goto 8000
    nullify(file%next_file)
    file_list%first_file => file
    file_list%last_file => file
    file_list%file => file

    !-- Save arguments.
    file%file_name = file_name
    file%file_format = ''
    if (present(file_format)) file%file_format = file_format
    file%file_skew = 0.
    if (present(file_skew)) file%file_skew = file_skew
    dt = 0.
    if (present(file_dt)) dt = max(file_dt, r_zero)
    file%file_thin = 1
    if (present(file_thin)) file%file_thin = max(file_thin,1)
    file%file_end = 0.

    !-- Open the file.
    where = 'open'
    call open_th_read(file%file_handle, file%file_name, file%file_format, &
         access_id, password, error)
    file%opened = .not. error
    if (error) goto 8000
    call inquire_th(file%file_handle, n_signals=n_signals, &
         file_title=description)
    if (dt == 0.) call inquire_th(file%file_handle, dt=dt)

    !-- Determine available signal names.
    where = 'signals'
    allocate(file_list%signal(n_signals), stat=iostat)
    if (iostat /= 0) goto 8000
    call inquire_th(file%file_handle, signal_names=file_list%signal%name)

    !-- Add to get_data source and signal lists.
    where = 'avail'
    call add_gd_source(source_list, file_source_code, file_name, &
         description, dt*file%file_thin, file_list%source, error)
    if (error) goto 8000
    do i = 1 , n_signals
      call add_gd_signal(signal_list, file_list%signal(i)%name, &
           file_list%source, gd_signal, 'file', error)
      if (error) goto 8000
      gd_signal%interpolate = file_interpolate
      file_list%signal(i)%signal_number = gd_signal%signal_number
    end do

    !-- Normal exit.
    file_list%pending_status = thr_error
    source => file_list%source
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('file_gd failed at ' // where)
    call release_gd_file(file_list)
    error = .true.
    return
  end subroutine add_gd_file

  subroutine splice_gd_file (file_list, file_name, file_format, &
       file_thin, file_skew, error)

    !-- Open an input file for gd_read.
    !-- 19 Oct 92, Richard Maine.

    !-------------------- interface.
    type(file_list_type), intent(out) :: file_list
         !-- File record for gd_read.
    character*(*), intent(in) :: file_name
    character*(*), intent(in), optional :: file_format
         !-- Blank or missing means try automatic determination.
    integer, intent(in), optional :: file_thin
         !-- File thinning factor.  Default is 1.
    real(r_kind), intent(in), optional :: file_skew
         !-- File time skew.  Default is 0.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat
    logical :: exists
    character  :: where*8
    type(file_type), pointer :: file

    !-------------------- executable code.

    where = 'allocate'
    allocate(file, stat=iostat)
    if (iostat /= 0) goto 8000
    nullify(file%next_file)

    !-- Save arguments.
    file%file_name = file_name
    file%file_format = ''
    if (present(file_format)) file%file_format = file_format
    file%file_skew = 0.
    if (present(file_skew)) file%file_skew = file_skew
    file%file_thin = 1
    if (present(file_thin)) file%file_thin = max(file_thin,1)
    file%file_end = 0.

    !-- Validate file existence.
    !-- This is invalid for net1 and maybe other as yet undefined file types.
    !-- We may have to restrict or eliminate the validation in the future.
    !-- At the moment, we are only using files that this applies to.
    where = 'inquire'
    inquire(file=file%file_name, exist=exists)
    if (.not. exists) goto 8000

    !-- Add to the file_list
    file_list%last_file%next_file => file
    file_list%last_file => file

    !-- Normal exit.
    file_list%pending_status = thr_error
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('file_gd failed at ' // where)
    if (associated(file)) deallocate(file)
    error = .true.
    return
  end subroutine splice_gd_file

  subroutine release_gd_file (file_list)

    !-- Close an input file list and deallocate space.
    !-- For internal use in gd_read module only.
    !-- 5 Dec 90, Richard Maine.

    !-------------------- interface.
    type(file_list_type), intent(inout) :: file_list
         !-- File record for gd_read.

    !-------------------- local.
    type(file_type), pointer :: file

    !-------------------- executable code.

    if (associated(file_list%signal)) deallocate(file_list%signal)
    do while(associated(file_list%first_file))
      file => file_list%first_file
      file_list%first_file => file%next_file
      if (file%opened) call close_th_read(file%file_handle)
      deallocate(file)
    end do
    nullify(file_list%last_file, file_list%file)
    return
  end subroutine release_gd_file

  subroutine activate_gd_file (file_list, signal, error)

    !-- Request the used signals from a file and build maps.
    !-- 18 Sept 92, Richard Maine.

    !-------------------- interface.
    type(file_list_type), intent(inout) :: file_list
         !-- File record for gd_read.
    type(gd_signal_type), intent(inout) :: signal(0:)
         !-- Array of get_data signal information.
    logical, intent(out) :: error
         !-- True if an error occurs.

    !-------------------- executable code.

    signal(0)%used = .false.
    file_list%signal%used = signal(file_list%signal%signal_number)%used
    error = .false.
    return
  end subroutine activate_gd_file

  subroutine seek_gd_file (file_list, start_time, stop_time, error)

    !-- Seek to a specified time interval in a get_data file list.
    !-- 18 Sept 92, Richard Maine.

    !-------------------- interface.
    type(file_list_type), intent(inout) :: file_list
         !-- File record for gd_read.
    real(r_kind), intent(in) :: start_time, stop_time
         !-- Start and stop times for the interval.
         !-- These include allowances for signal skews.
    logical, intent(out) :: error
         !-- True if an error occurs.

    !-------------------- local.
    type(file_type), pointer :: file

    !-------------------- executable code.

    file_list%start_time = start_time
    file_list%stop_time = stop_time
    file_list%last_time = 0.

    file => file_list%first_file
    do while(associated(file))
      if ((file%file_end==r_zero) .or. (file%file_end > start_time)) then
        call open_and_seek(file_list, file, error)
        return
      end if
      file => file%next_file
    end do
    file_list%pending_status = thr_eod
    error = .false.
    return
  end subroutine seek_gd_file

  subroutine read_gd_file (file_list, time, data, status)

    !-- Read a frame a get_data file.
    !-- 21 Sept 92, Richard Maine.

    !-------------------- interface.
    type(file_list_type), intent(inout) :: file_list
         !-- File record for gd_read.
    real(r_kind), intent(out) :: time  !-- Frame time.
    real(r_kind), intent(out) :: data(:)  !-- Frame data.
    integer, intent(out) :: status  !-- Same as gd_read codes.

    !-------------------- local.
    type(file_type), pointer :: file
    logical :: error

    !-------------------- executable code.

    loop: do
      status = file_list%pending_status
      if (status /= thr_ok) exit loop
      file => file_list%file
      call read_th(file%file_handle, time, data, status)
      if (status /= thr_eod) exit loop
      if (file_list%last_time > file%file_end) &
           file%file_end = file_list%last_time + file_list%source%source_dt
      call open_and_seek(file_list, file%next_file, error)
      if (error) then; status = thr_error; return; endif
    end do loop
    if (status == thr_ok) then
      time = time + file%file_skew
      file_list%last_time = time
      file_list%pending_status = thr_ok
    else
      file_list%pending_status = thr_error
    end if
    return
  end subroutine read_gd_file

  subroutine open_and_seek(file_list, file, error)

    !-- Open a file in file_list, and seek it.
    !-- 16 Oct 92, Richard Maine.

    !-------------------- interface.
    type(file_list_type), intent(inout) :: file_list
    type(file_type), pointer :: file
    logical, intent(out) :: error

    !-------------------- local.
    logical :: all_found
    character :: msg*80
    real(r_kind) :: start_time

    !-------------------- executable code.

    !-- Return end-of-data status on null file.  Leave the current file open.
    if (.not.associated(file)) then
      file_list%pending_status = thr_eod
      error = .false.
      return
    end if

    !-- If some different file is open, close it.
    if (associated(file_list%file) &
         .and. .not.associated(file_list%file,file)) then
      if (file_list%file%opened) then
        call close_th_read(file_list%file%file_handle)
        file_list%file%opened = .false.
      end if
    end if

    !-- Set the current file and open it if needed.
    file_list%file => file
    if (.not. file%opened) then
      call open_th_read(file%file_handle, file%file_name, file%file_format, &
         error=error)
      file%opened = .not. error
      if (error) then
        msg = 'File open failed.'; goto 8000; endif
    end if

    !-- request signals.
    call request_th_signals(file%file_handle, &
         pack(file_list%signal%name, file_list%signal%used), &
         all_found=all_found, error=error)
    if (error) then
      msg = 'Error in request_th_signals.'; goto 8000; endif
    if (.not. all_found) then
      msg = 'Expected signals not on file.'; goto 8000; endif

    !-- If some data for the interval has already been returned,
    !-- then seek starting at the predicted next time.
    !-- Otherwise seek the full requested interval.
    if (file_list%last_time /= 0.) then
      start_time = file_list%last_time + file_list%source%source_dt
    else
      start_time = file_list%start_time
    end if
    call seek_th(file%file_handle, &
         start_time - file%file_skew, file_list%stop_time - file%file_skew, &
         file%file_thin, error)
    if (error) then
      msg = 'Error in seek_th.'; goto 8000; endif

    !-- Normal exit.
    file_list%pending_status = thr_ok
    return

    !-- Error exit.
    8000 continue
    call write_error_msg(msg)
    file_list%pending_status = thr_error
    error = .true.
    return
  end subroutine open_and_seek
end module gd_file
