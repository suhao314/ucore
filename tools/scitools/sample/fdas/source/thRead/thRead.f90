!-- thRead.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_read

  !-- Module for read access to time history files.
  !-- Does not support cmp2(elxsi) or enc1(sel) formats.
  !-- 19 Sep 90, Richard Maine.

  use precision
  use sysdep_io
  use string
  use th_read_gen
  use th_read_asc12
  use th_read_unc2
  use th_read_unc3
  use th_read_cmp3
  use th_read_net1

  implicit none
  private

  !-- Public parameters from th_read_gen
  public thr_ok, thr_eoi, thr_eod, thr_error

  logical, save :: th_read_initialized = .false.

  integer, parameter :: n_formats = 7
  integer, parameter :: usr1_code = 1, asc1_code = 2, asc2_code = 3, &
       unc2_code = 4, unc3_code = 5, cmp3_code = 6, net1_code = 7
  character, save :: format_names(n_formats)*8 = ' none '
  
  type fd_type  !-- fd is short for file_descriptor
    integer :: format_code
    logical :: ok_to_read
         !-- True when an attempt to read is allowed.
         !-- If false, the file must be repositioned before the next read.
    integer :: n_signals, n_requested
    real(r_kind) :: start_time, stop_time, prev_time
    integer :: thin_factor
    logical :: first_read
         !-- True on the first read of a time interval.
         !-- Used in thinning.
    type(gen_type), pointer :: gen
         !-- Generic data for the format-specific modules.
         !-- None of the internal structure should be referenced here.
  end type

  !-- Handles are public with private components.
  type, public :: th_read_handle_type
    private
    type(fd_type), pointer :: fd
  end type

  type(fd_type), pointer :: fd  !-- Scratch use only.  Not saved.

  !-- Public procedures.
  public open_th_read, close_th_read, inquire_th, request_th_signals
  public seek_th, read_th

  !-- Forward reference for private procedures.
  private read_th_format, read_raw_file

contains

  subroutine init_th_read

    !-- Initialize the th_read module.
    !-- Will automatically be called when needed.
    !-- 22 Jun 90, Richard Maine.

    !-------------------- executable code.

    !-- Return immediately if already done.
    if (th_read_initialized) return
    th_read_initialized = .true.

    format_names(asc1_code) = asc1_format_string
    format_names(asc2_code) = asc2_format_string
    format_names(unc2_code) = unc2_format_string
    format_names(unc3_code) = unc3_format_string
    format_names(cmp3_code) = cmp3_format_string
    format_names(net1_code) = net1_format_string
    return
  end subroutine init_th_read

  subroutine open_th_read (file_handle, file_name, file_format, &
       access_id, password, error)

    !-- Open a time history file for read access.
    !-- Note that, unlike in the old Fortran 77 routines,
    !-- this open does not establish a file position;
    !-- a call to seek_th is required before the first data access.
    !-- 19 Sept 90, Richard Maine.

    !-------------------- interface.
    type(th_read_handle_type), intent(out) :: file_handle
         !-- Identifies the file for subsequent reference.
         !-- Returns a null handle if the open fails.
    character*(*), intent(in) :: file_name
    character*(*), intent(in), optional :: file_format
         !-- Attempts automatic determination if this is blank or absent.
    character*(*), intent(in), optional :: access_id, password
         !-- Id and password for security authorization.
         !-- Some files may require specification of an acceptable
         !-- access_id and password to allow access.
         !-- Blank or omitted values imply that no special access
         !-- permissions are requested.
    logical, intent(out), optional :: error
         !-- Returns true if open fails.
         !-- Abort if open fails and this is not present.

    !-------------------- local.
    integer :: iostat, format_code
    character :: format_name*8, access_id_tmp*16, password_tmp*16, where*32
    logical :: sub_error

    !-------------------- executable code.

    if (.not. th_read_initialized) call init_th_read

    !-- Allocate a file handle.
    where = 'allocate'
    nullify(fd)
    allocate(fd, stat=iostat)
    file_handle%fd => fd
    if (iostat /= 0) goto 8000
    call allocate_th_read_gen(fd%gen, sub_error)
    if (sub_error) goto 8000

    !-- Determine the format.
    fd%format_code = 0
    format_name = ''
    if (present(file_format)) format_name = file_format
    if (format_name == '') call read_th_format(file_name, format_name)
    if (format_name == '') then
      where = 'format determination'; goto 8000; endif
    format_code = string_index(string=format_name, list=format_names)
    if (format_code==0) then
      where = 'unknown format: ' // format_name; goto 8000; endif

    !-- Handle defaults for security access.
    access_id_tmp = ''
    password_tmp = ''
    if (present(access_id)) access_id_tmp = access_id
    if (present(password)) password_tmp = password

    !-- Open the file according to the format.
    select case(format_code)
    case (asc1_code,asc2_code)
      call open_th_read_asc12(fd%gen, file_name, fd%n_signals, sub_error)
    case (unc2_code)
      call open_th_read_unc2(fd%gen, file_name, fd%n_signals, sub_error)
    case (unc3_code)
      call open_th_read_unc3(fd%gen, file_name, fd%n_signals, sub_error)
    case (cmp3_code)
      call open_th_read_cmp3(fd%gen, file_name, fd%n_signals, sub_error)
    case (net1_code)
      call open_th_read_net1(fd%gen, file_name, access_id_tmp, password_tmp, &
           fd%n_signals, sub_error)
    case default
      sub_error = .true.
    end select
    if (sub_error) then
      where = 'open format: ' // format_name; goto 8000; endif

    !-- Default to complete signal list.
    fd%n_requested = fd%n_signals

    !-- Normal return.
    fd%format_code = format_code
    fd%ok_to_read = .false.
    if (present(error)) error = .false.
    return

    !---------- error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_read failed at ' // where)
    call write_error_msg('File: ' // file_name)
    if (associated(fd)) call close_th_read(file_handle)
    if (.not.present(error)) call error_halt
    error = .true.
    return
  end subroutine open_th_read

  subroutine close_th_read (file_handle)

    !-- Close file opened by open_th_read.
    !-- All errors are currently fatal.
    !-- 13 Aug 90, Richard Maine.

    !-------------------- interface.
    type(th_read_handle_type), intent(inout) :: file_handle
         !-- Returns a null handle on exit.

    !-------------------- executable code.

    !-- Quietly return if the handle is null; otherwise validate it.
    !-- Ideally, we should not be called with a null handle.
    !-- but we will allow it.
    fd => file_handle%fd
    if (.not. associated(fd)) return

    if (associated(fd%gen)) then

      !-- Close according to the format.
      select case (fd%format_code)
      case (asc1_code,asc2_code)
        call close_th_read_asc12(fd%gen)
      case (unc2_code)
        call close_th_read_unc2(fd%gen)
      case (unc3_code)
        call close_th_read_unc3(fd%gen)
      case (cmp3_code)
        call close_th_read_cmp3(fd%gen)
      case (net1_code)
        call close_th_read_net1(fd%gen)
      case (0)  !-- This may happen if called from open_th_read.
        continue
      end select

      !-- Free the handle.
      call free_th_read_gen(fd%gen)
    end if
    deallocate(file_handle%fd)
    return
  end subroutine close_th_read

  subroutine inquire_th (file_handle, n_signals, dt, file_title, &
       signal_names, eu_names, error)

    !-- Return information about a th_read file.
    !-- 26 Jun 90, Richard Maine.

    !-------------------- interface.
    type(th_read_handle_type), intent(in) :: file_handle
    integer, intent(out), optional :: n_signals
         !-- Number of signals available on the file.
    real(r_kind), intent(out), optional :: dt
         !-- Nominal sample interval.  0 if unknown.
    character*(*), intent(out), optional :: file_title
         !-- File title.  Blank if none.
    character*(*), optional, intent(out) :: signal_names(:)
         !-- Names of the signals known to be available.
         !-- Note that this list may be incomplete in some cases
         !-- where the only way to find out if a signal is available
         !-- is to ask for it (sad, but true).
    character*(*), optional, intent(out) :: eu_names(:)
         !-- Engineering units names for the currently requested signals.
         !-- Note that this corresponds to signal_names only if all
         !-- the signals are currently requested.  Blank if unknown.
    logical, intent(out), optional :: error
         !-- Returns true if an error occurs.
         !-- Abort if there is an error and this is not present.

    !-------------------- executable code.

    fd => file_handle%fd
    if (.not. associated(fd)) call error_halt('Closed th_read file_handle')

    if (present(n_signals)) n_signals = fd%n_signals
    if (present(dt)) dt = fd%gen%dt
    if (present(file_title)) file_title = fd%gen%file_title

    !-- Check array sizes.
    if (present(signal_names)) then
      if (size(signal_names) < fd%n_signals) &
           call error_halt('Signal_names vector too small in inquire_th.')
    end if
    if (present(eu_names)) then
      if (size(eu_names) < fd%n_requested) &
           call error_halt('Eu_names vector too small in inquire_th.')
    end if

    !-- Obtain signal names and eu names according to format if required.
    if (present(signal_names) .or. present(eu_names)) then
      select case (fd%format_code)
      case (asc1_code,asc2_code,unc2_code,unc3_code,cmp3_code,net1_code)
        call inquire_th_gen(fd%gen, signal_names, eu_names)
      end select
    end if

    !-- Normal exit.
    if (present(error)) error = .false.
    return
  end subroutine inquire_th

  subroutine request_th_signals (file_handle, requested_signals, &
       print_warning, signal_found, all_found, error)

    !-- Specify signals to be read from a time history file.
    !-- Terminates the current seek interval.
    !-- 19 Sept 90, Richard Maine.

    !-------------------- interface.
    type(th_read_handle_type), intent(in) :: file_handle
    character*(*), intent(in) :: requested_signals(:)
         !-- Requested signal names.
    logical, intent(in), optional :: print_warning
         !-- Should warning messages be printed for missing signals?
         !-- Default is .true.
    logical, intent(out), optional :: signal_found(:)
         !-- Indicates which requested signals were found.
         !-- If present, must be the same size as requested_signals.
    logical, intent(out), optional :: all_found
         !-- True if all requested non-blank signals were found.
    logical, intent(out), optional :: error
         !-- True if an error occurs.
         !-- Abort if an error occurs and this is not present.
         !-- This indicates a serious error (usually i/o).
         !-- Failure to find requested signals is not considered an error.
         !-- The signal_found argument and the resulting signal list
         !-- are undefined if this returns true.

    !-------------------- local.
    integer :: i, n_requested
    logical :: all_good, sub_error, warn
    logical :: found(size(requested_signals))

    !-------------------- executable code.

    fd => file_handle%fd
    if (.not. associated(fd)) call error_halt('Closed th_read file_handle')

    n_requested = size(requested_signals)
    if (present(signal_found)) then
      if (size(signal_found) /= n_requested) &
           call error_halt('Inconsistent sizes in request_th_signals')
    end if

    fd%n_requested = -1
    fd%ok_to_read = .false.
    all_good = .false.

    !-- Request signals according to format.
    sub_error = .false.
    select case (fd%format_code)
    case (asc1_code,asc2_code,unc2_code,unc3_code,cmp3_code)
      call request_th_gen(fd%gen, requested_signals, found)
    case (net1_code)
      call request_th_net1(fd%gen, requested_signals, found, sub_error)
    end select
    if (sub_error) goto 8000

    !-- Print optional error messages.
    all_good = all(found .or. (requested_signals==''))
    warn = .true.
    if (present(print_warning)) warn = print_warning
    if (warn .and. .not. all_good) then
      do i = 1 , n_requested
        if ((.not. found(i)) .and. (requested_signals(i) /= '')) &
             call write_error_msg('Signal ' // requested_signals(i) // &
             ' not found.')
      end do
    end if

    !-- Return optional arguments.
    fd%n_requested = n_requested
    if (present(signal_found)) signal_found = found

    !-- Both normal and error exits return through here.
    8000 continue
    if (present(all_found)) all_found = all_good
    if (sub_error .and. .not.present(error)) &
         call error_halt('Error in request_th_signals.')
    if (present(error)) error = sub_error
    return
  end subroutine request_th_signals

  subroutine seek_th (file_handle, start_time, stop_time, thin, error)

    !-- Seek to a specified time interval on a time history file.
    !-- 19 Sept 90, Richard Maine.

    !-------------------- interface.
    type(th_read_handle_type), intent(in) :: file_handle
    real(r_kind), intent(in), optional :: start_time, stop_time
         !-- Default seek interval is 0-24 hours.
    integer, intent(in), optional :: thin
         !-- Thinning factor for data frames.  Default is 1.
         !-- Must be >=1.  Illegal values currently are ignored.
    logical, intent(out), optional :: error
         !-- True if an error occurs.  It is not considered an error
         !-- to seek to an interval that has no data frames.

    !-------------------- local.
    logical :: sub_error

    !-------------------- executable code.

    fd => file_handle%fd
    if (.not. associated(fd)) call error_halt('Closed th_read file_handle')

    !-- Don't seek if the signal list is undefined (from an error).
    sub_error = fd%n_requested < 0
    if (sub_error) goto 8000

    !-- Save time interval specifications.
    if (present(start_time)) then
      fd%start_time = start_time
    else
      fd%start_time = 0.
    end if
    if (present(stop_time)) then
      fd%stop_time = stop_time
    else
      fd%stop_time = 86400._r_kind
    end if
    if (present(thin)) then
      fd%thin_factor = max(thin,1)
    else
      fd%thin_factor = 1
    end if
    fd%prev_time = -big_real
    fd%first_read = .true.

    !-- Call lower level routines to do the seek.

    !-- Note that the low level routines are allowed to seek to
    !-- any earlier time (for instance to the first available frame).
    !-- The high level read will discard any data before the requested
    !-- start time.  The decision of how much to do in the low
    !-- level routine is purely one of efficiency.

    !-- If the lower level routine handles thinning, then we must
    !-- set fd%thin_factor to 1 afterwards to avoid double thinning.

    sub_error = .true.
    select case (fd%format_code)
    case (asc1_code,asc2_code)
      call seek_th_asc12(fd%gen, fd%start_time, sub_error)
    case (unc2_code)
      call seek_th_unc2(fd%gen, fd%start_time, sub_error)
    case (unc3_code)
      call seek_th_unc3(fd%gen, fd%start_time, sub_error)
    case (cmp3_code)
      call seek_th_cmp3(fd%gen, fd%start_time, sub_error)
    case (net1_code)
      call seek_th_net1(fd%gen, fd%start_time, fd%stop_time, fd%thin_factor, &
           sub_error)
    end select

    !-- Normal or error exit.
    8000 continue
    fd%ok_to_read = .not. sub_error
    if (sub_error .and. .not.present(error)) &
         call error_halt('Error in seek_th.')
    if (present(error)) error = sub_error
    return
  end subroutine seek_th

  subroutine read_th (file_handle, time, data, status)

    !-- Read a frame from a th file.
    !-- 19 Sept 90, Richard Maine.

    !-------------------- interface.
    type(th_read_handle_type), intent(in) :: file_handle
    real(r_kind), intent(out) :: time     !-- Frame time.
    real(r_kind), intent(out) :: data(:)  !-- Frame data.
    integer, intent(out) :: status
         !-- Returns 0 for valid data frame.
         !-- 1 = end of requested interval reached.
         !-- 2 = end of available data reached.
         !-- 3 = error.

    !-------------------- local.
    integer :: thin_count, thin_factor, n_req

    !-------------------- executable code.

    fd => file_handle%fd
    if (.not. associated(fd)) call error_halt('Closed th_read file_handle')

    status = 3
    if (.not. fd%ok_to_read) return
    fd%ok_to_read = .false.

    n_req = fd%n_requested
    if (size(data) < n_req) call error_halt('data size wrong in read_th')

    !-- Read a frame according to format.
    !-- Error message for frames out of time order.
    !-- Skip frames prior to the requested interval.
    !-- Stop on frames after the requested interval.
    thin_factor = fd%thin_factor
    if (fd%first_read) thin_factor = 1
    fd%first_read = .false.
    thin_loop: do thin_count = 1 , thin_factor
      seek_loop: do
        status = 3
        select case (fd%format_code)
        case (asc1_code,asc2_code)
          call read_th_asc12(fd%gen, time, data(1:n_req), status)
        case (unc2_code)
          call read_th_unc2(fd%gen, time, data(1:n_req), status)
        case (unc3_code)
          call read_th_unc3(fd%gen, time, data(1:n_req), status)
        case (cmp3_code)
          call read_th_cmp3(fd%gen, time, data(1:n_req), status)
        case (net1_code)
          call read_th_net1(fd%gen, time, data(1:n_req), status)
        end select
        if (status /= 0) return
        if (time < fd%prev_time) then
          call write_error_msg('Time out of order in read_th.')
          status = 3
          return
        end if
        fd%prev_time = time
        if (time >= fd%start_time) exit seek_loop
      end do seek_loop
      if (time > fd%stop_time) then
        status = 1
        return
      end if
    end do thin_loop

    !-- Normal exit.
    fd%ok_to_read = .true.
    status = 0
    return
  end subroutine read_th

  subroutine read_th_format (file_name, file_format)

    !-- Determine the format of a time history file for open_th_read.
    !-- 22 Jun 90, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: file_name
    character*(*), intent(out) :: file_format  !-- Returns blank on failure.

    !-------------------- local.
    character :: data*40, key_string*8
    logical :: error
    integer :: i, j

    !-------------------- executable code.

    file_format = ''
    call read_raw_file (file_name, data, error)
    if (error) return

    !-- Find the format field.
    !-- Explicitly down_casing protects against source code case changes.
    key_string = lower_case('format  ')
    data = lower_case(data)
    i = index(string=data, substring=key_string)

    !-- xtract field, stripping embedded blanks.
    if (i > 0) then
      j = 0
      do i = i+8 , min(i+15,len(data))
        if (data(i:i) /= ' ') then
          j = j + 1
          if (j > len(file_format)) exit
          file_format(j:j) = data(i:i)
        end if
      end do
    end if

    if (file_format == '') &
      call write_error_msg('No format field in th_read file.')
    return
  end subroutine read_th_format

  subroutine read_raw_file (file_name, data, error)

    !-- Read the first bytes from a file of unknown format.
    !-- System dependent.
    !-- This routine must open and read data from a file without first
    !-- knowing the file format, including such things as whether the
    !-- file is formatted, unformatted, sequential, or direct.
    !-- It is acceptable to include low-level system record-control
    !-- or block-control headers in the data returned; the calling code
    !-- will scan past such headers to find the desired data.
    !-- Generic version, insomuch as we can.
    !-- This version uses direct access formatted i/o.
    !-- Alternatives include non-advancing or direct access unformatted.
    !-- 22 Jun 90, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: file_name
    character*(*), intent(out) :: data
    logical, intent(out) :: error

    !-------------------- local.
    integer :: lun, iostat

    !-------------------- executable code.

    !-- Try to open the file.
    data = ''
    call assign_lun(lun)
    open(lun, file=file_name, status='old', action='read', iostat=iostat, &
         form='formatted', access='direct', recl=len(data))
    error = iostat /= 0
    if (iostat /= 0) then
      call write_sys_error(iostat)
      call write_error_msg('Open_th_read unable to open file.')
      call release_lun(lun)
      return
    end if

    read(lun, '(a)', rec=1, iostat=iostat) data

    !-- close file and exit.
    error = iostat /= 0
    if (iostat /= 0) then
      call write_sys_error(iostat)
      call write_error_msg('Empty or bad file in open_th_read.')
    end if
    close(lun)
    call release_lun(lun)
    return
  end subroutine read_raw_file

end module th_read
