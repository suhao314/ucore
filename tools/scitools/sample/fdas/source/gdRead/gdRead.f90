!-- gdRead.f90
!-- 19 Oct 92, Richard Maine: Version 1.0.

module gd_read

  !-- Module for read access to get_data objects.
  !-- A get_data object is an abstraction of a time history data file.
  !-- It may involve, merging, skewing, interpolating, and calculating.
  !-- 21 Mar 91, Richard Maine.

  use precision
  use sysdep_io
  use string
  use time
  use gd_common
  use gd_filter
  use gd_calc
  use gd_file
  use th_read, only: thr_ok, thr_eod, thr_eoi, thr_error

  implicit none
  private

  public gd_source_type
  public thr_ok, thr_eod, thr_eoi, thr_error

  !-- input_frame_type has the data from a single input data frame.
  !-- It is compressed by elimination of unused signals.
  type, public :: input_frame_type
    integer :: status      !-- Code from read_th.
    real(r_kind) :: time
    real(r_kind), pointer :: data(:)
    type(input_frame_type), pointer :: next_frame, prev_frame
         !-- linked list of frames for an input source.
  end type

  type gd_input_type
    logical :: input_used  !-- Is anything from this input_source used?
    logical :: first_read  !-- First input frame in an interval?
    type(gd_source_type), pointer :: source
         !-- Generic information about the data source.
    integer :: n_used
         !-- Number of signals in use from this input source.
         !-- Includes those from read_th plus those from filters.
         !-- Compressed frame buffers are this size.
    integer :: n_aug_signals
         !-- Number of augmented signals associated with this input.
         !-- Includes those from read_th plus those from filters.
    logical :: file_interpolate  !-- Default to interpolate(T) or hold(F).
    real(r_kind) :: stale_time
         !-- Controls release of old data frames.
         !-- The last frame <= this time must be retained.
    real(r_kind) :: min_signal_skew, max_signal_skew
         !-- Min and max are over the synced signals only.
    integer, pointer :: used_signal_map(:)
         !-- Map from the compressed frame buffer to get_data signal number.
         !-- Special array for efficiency in sync_to_time
    type(input_frame_type), pointer :: first_frame, last_frame
         !-- Ends of doubly-linked list of frame buffers for this input source.
    type(input_frame_type), pointer :: current_frame
         !-- Points to last input frame with time <= output frame time.
    type(filter_list_type) :: filter_list
         !-- List of filters synced to this input source.
    type(file_list_type) :: file_list
         !-- Data about the input file(s) for this source.
    type(gd_input_type), pointer :: next_input
  end type

  type gd_type
    character :: access_id*16, password*16  !-- Access security control.
    real(r_kind) :: start_time, stop_time   !-- Requested time interval.
    real(r_kind) :: dt    !-- Requested sample interval.
    real(r_kind) :: jump_tolerance  !-- Time dropout tolerance.
    real(r_kind) :: time_tolerance  !-- Time tolerance for hold-last-value.
    real(r_kind) :: prev_time  !-- Previous output frame time.
    integer :: sync_thin  !-- Thinning factor for frame time sync.
    type(gd_input_type), pointer :: sync_input  !-- Input file for frame sync.
    logical :: maps_built !-- Are the maps of used signals built and current?
    logical :: ok_to_read !-- Is there an active time interval?
    logical :: first_read !-- Is the first read of a time interval pending?
    type(gd_input_type), pointer :: first_input, last_input
         !-- First and last input sources.
    type(gd_signal_type), pointer :: signal(:)
         !-- Array of signal information.
    type(gd_signal_list_type) :: signal_list
         !-- List of signal records.
    type(gd_source_list_type) :: source_list
         !-- List of source records.
    integer, pointer :: output_map(:)
         !-- Map of output signals to the get_data signal list.
    type(calc_list_type) :: calc_list
         !-- List of calculated functions.
  end type

  !-- Handles are public with private components.
  type, public :: gd_handle_type
    private
    type(gd_type), pointer :: gd
  end type

  type(gd_type), pointer :: gd  !-- for scratch use only.  Not saved.

  !-- Public procedures.
  public open_gd, close_gd, file_gd, calc_gd, filter_gd
  public inquire_gd, request_gd_signals, sync_gd, seek_gd, read_gd

  !-- Forward reference for private procedures.
  private check_gd_handle, activate_requested_signals, release_input_frames
  private set_output_time, sync_to_time, read_to_time, get_next_frame

contains

  subroutine open_gd (gd_handle, access_id, password, error)

    !-- Open a get_data object for read access.
    !-- Still need to have an option to use a server.
    !-- 3 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(out) :: gd_handle
         !-- Identifies the get_data object for subsequent reference.
         !-- Returns a null handle if the open fails.
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
    integer :: iostat

    !-------------------- executable code.

    !-- Allocate a gd descriptor.
    nullify(gd)
    allocate(gd, stat=iostat)
    gd_handle%gd => gd
    if (iostat /= 0) goto 8000

    gd%maps_built = .false.
    gd%ok_to_read = .false.
    gd%access_id = ''
    gd%password = ''
    if (present(access_id)) gd%access_id = access_id
    if (present(password)) gd%password = password
    nullify(gd%first_input, gd%last_input, gd%sync_input)
    nullify(gd%output_map, gd%signal)
    call init_signal_list(gd%signal_list)
    call init_source_list(gd%source_list)
    call init_gd_calc_list(gd%calc_list)
    allocate(gd%output_map(0), stat=iostat)
    if (iostat /= 0) goto 8000
    if (present(error)) error = .false.
    return

    !---------- error exit.
    8000 continue
    call write_error_msg('Open_gd failed.')
    call close_gd(gd_handle)
    if (.not.present(error)) call error_halt
    error = .true.
    return
  end subroutine open_gd

  subroutine close_gd (gd_handle)

    !-- Close an object opened by open_gd.
    !-- All errors are currently fatal.
    !-- 3 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(inout) :: gd_handle
         !-- Returns a null handle on exit.

    !-------------------- local.
    type(gd_input_type), pointer :: input

    !-------------------- executable code.

    !-- Quietly return if the handle is null; otherwise validate it.
    !-- Ideally, we should not be called with a null handle.
    !-- but we will allow it.
    gd => gd_handle%gd
    if (.not. associated(gd)) return

    call close_gd_calcs(gd%calc_list)

    do while (associated(gd%first_input))
      input => gd%first_input
      gd%first_input => input%next_input
      call release_input_frames(input)
      call close_gd_filters(input%filter_list)
      call release_gd_file(input%file_list)
      if (associated(input%used_signal_map)) deallocate(input%used_signal_map)
      deallocate(input)
    end do
    nullify(gd%last_input)

    if (associated(gd%signal))  deallocate(gd%signal)
    if (associated(gd%output_map))  deallocate(gd%output_map)
    call release_signal_list(gd%signal_list)
    call release_source_list(gd%source_list)
    deallocate(gd_handle%gd)
    return
  end subroutine close_gd

  subroutine file_gd (gd_handle, file_name, file_format, file_dt, file_thin, &
       file_skew, file_interpolate, source_number, error)

    !-- Connect an input file to a get_data object.
    !-- To merge data from multiple files, this routine is
    !-- called multiple times.
    !-- 19 Oct 92, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(in) :: gd_handle
    character*(*), intent(in) :: file_name
    character*(*), intent(in), optional :: file_format
         !-- Blank or missing means try automatic determination.
    real(r_kind), intent(in), optional :: file_dt
         !-- Nominal file sample interval.
         !-- Need not be exactly correct unless filters are used.
         !-- Substantially wrong values may effect efficiency of skewing.
         !-- Values less than the actual sample interval may cause loss
         !-- of the first and last frames in each interval.
         !-- Will be obtained from the file if omitted or zero.
         !-- Irrelevent for spliced files.
    integer, intent(in), optional :: file_thin
         !-- File thinning factor.  Default is 1.
    real(r_kind), intent(in), optional :: file_skew
         !-- File time skew.  Default is 0.
    logical, intent(in), optional :: file_interpolate
         !-- True means default to linear interpolation on this file.
         !-- False means default to hold-last-value.
         !-- Irrelevent for spliced files.
    integer, optional :: source_number
         !-- Source number assigned by gd_read module.
         !-- If input value is 0, newly assigned value will be returned.
         !-- If input value is non-zero, it is left unaltered and
         !-- this file is spliced to the specified source.
    logical, intent(out) :: error

    !-------------------- local.
    type(gd_input_type), pointer :: input
    integer :: iostat, source_number_tmp

    !-------------------- executable code.

    call check_gd_handle(gd_handle,gd)

    gd%maps_built = .false.
    gd%ok_to_read = .false.

    source_number_tmp = 0
    if (present(source_number)) source_number_tmp = source_number

    !---------- New input source.
    if (source_number_tmp == 0) then

      !-- Allocate space for a new input in the object.
      allocate(input, stat=iostat)
      if (iostat /= 0) then
        call write_sys_error(iostat)
        call write_error_msg('file_gd failed at allocate.')
        error = .true.
        return
      end if
      nullify(input%first_frame, input%last_frame, input%current_frame)
      nullify(input%used_signal_map)

      input%file_interpolate = .false.
      if (present(file_interpolate)) input%file_interpolate = file_interpolate

      call add_gd_file(input%file_list, file_name, file_format, &
           gd%access_id, gd%password, &
           file_dt, file_thin, file_skew, input%file_interpolate, &
           gd%source_list, gd%signal_list, input%source, error)
      if (error) then
        deallocate(input)
        return
      end if
      input%n_aug_signals = input%source%n_source_signals
      call init_gd_filter_list(input%filter_list, input%source%source_number)

      !-- Add to the linked list of inputs for this get_data object.
      nullify(input%next_input)
      if (.not. associated(gd%first_input)) gd%first_input => input
      if (associated(gd%last_input)) gd%last_input%next_input => input
      gd%last_input => input

      if (present(source_number)) source_number = input%source%source_number

    !---------- Splice to existing input source.
    else

      !-- Find the specified input source.
      input => gd%first_input
      input_loop: do while(associated(input))
        if (input%source%source_number == source_number) exit input_loop
        input => input%next_input
      end do input_loop
      if (.not.associated(input)) then
        call write_error_msg('No such input source_number in file_gd.')
        error = .true.
        return
      end if

      call splice_gd_file(input%file_list, file_name, file_format, &
           file_thin, file_skew, error)
      if (error) return
    end if

    error = .false.
    return
  end subroutine file_gd

  subroutine inquire_gd (gd_handle, n_sources, n_signals, n_requested, &
       sources, signal_names)

    !-- Inquire about a get_data object.
    !-- 7 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(in) :: gd_handle  !-- handle from open_gd.
    integer, intent(out), optional :: n_sources
         !-- Number of data sources.
    integer, intent(out), optional :: n_signals
         !-- Number of signals.
    integer, intent(out), optional :: n_requested
         !-- Number of requested signals.
    type(gd_source_type), intent(out), optional :: sources(:)
         !-- Generic information about the data sources.
    character*(*), intent(out), optional :: signal_names(:)
         !-- Names of all signals.

    !-------------------- local.
    integer :: n_signals_local, n_sources_local

    !-------------------- executable code.

    call check_gd_handle(gd_handle,gd)

    n_signals_local = signal_list_size(gd%signal_list)
    n_sources_local = source_list_size(gd%source_list)

    !-- Scalars.
    if (present(n_sources)) n_sources = n_sources_local
    if (present(n_signals)) n_signals = n_signals_local
    if (present(n_requested)) n_requested = size(gd%output_map)

    !---------- Source vector.
    if (present(sources)) then
      if (size(sources) < n_sources_local) &
           call error_halt('Sources size bad in inquire_gd,')
      call get_source_array(gd%source_list, sources(:n_sources_local))
    end if

    !-- Signal vectors.
    if (present(signal_names)) then
      if (size(signal_names) < n_signals_local) &
           call error_halt('Signal_names size bad in inquire_gd,')
      call get_signal_names(gd%signal_list, &
           signal_names(:n_signals_local))
    end if
    return
  end subroutine inquire_gd

  subroutine sync_gd (gd_handle, signal_names, skew, interpolate, &
       print_warning, all_found)

    !-- Specify signal time skews and syncronization methods.
    !-- 3 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(in) :: gd_handle  !-- handle from open_gd
    character*(*), intent(in) :: signal_names(:)
         !-- names of the signals referenced.
    real(r_kind), intent(in), optional :: skew(:)
         !-- Skew values corresponding to names.
         !-- If present, must be the same size as names.
         !-- If omitted, skews are left unchanged.
    logical, intent(in), optional :: interpolate(:)
         !-- Interpolation methods corresponding to names.
         !-- If present, must be the same size as names.
         !-- If omitted, interpolation methods are left unchanged.
    logical, intent(in), optional :: print_warning
         !-- Should missing signal messages be printed?  Default is true.
    logical, intent(out), optional :: all_found
         !-- True if all non-blank signal names were found.

    !-------------------- local.
    integer :: i
    logical :: warn
    type(gd_signal_type), pointer :: gd_signal

    !-------------------- executable code.

    call check_gd_handle(gd_handle,gd)

    !-- Check argument sizes.
    if (present(interpolate)) then
      if (size(interpolate) /= size(signal_names)) &
           call error_halt('Size of interpolate bad in sync_gd')
    end if
    if (present(skew)) then
      if (size(skew) /= size(signal_names)) &
           call error_halt('Size of skew bad in sync_gd')
    end if
    warn = .true.
    if (present(print_warning)) warn = print_warning

    gd%ok_to_read = .false.
    if (present(all_found)) all_found = .true.
    !-- Find the specified signals and save the data.
    signal_loop: do i = 1 , size(signal_names)
      if (signal_names(i) == '') cycle signal_loop
      call find_gd_signal(signal_names(i), gd%signal_list, gd_signal)
      if (gd_signal%source_code == file_source_code .or. &
           gd_signal%source_code == filter_source_code) then
        if (present(skew)) gd_signal%skew = skew(i)
        if (present(interpolate)) gd_signal%interpolate = interpolate(i)
      else
        if (present(all_found)) all_found = .false.
        if (warn) call write_error_msg &
             ('Signal ' // signal_names(i) // ' missing in sync_gd.')
      end if
    end do signal_loop
    return
  end subroutine sync_gd

  subroutine request_gd_signals (gd_handle, requested_signals, &
       print_warning, signal_found, all_found, error)

    !-- Request signals to be retrieved from a get_data object.
    !-- 5 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(in) :: gd_handle  !-- handle from open_gd.
    character*(*), intent(in) :: requested_signals(:)
         !-- Names of the signals requested.  Replaces any prior list.
    logical, intent(in), optional :: print_warning
         !-- Should missing signal messages be printed?  Default is true.
    logical, intent(out), optional :: signal_found(:)
         !-- Indicates whether or not each individual signal was found.
         !-- If present, must be the same size as requested_signals.
    logical, intent(out), optional :: all_found
         !-- True if all non-blank signal names were found.
    logical, intent(out), optional :: error
         !-- True if an error occurs.
         !-- Missing signals are not considered errors.
         !-- If omitted, the subroutine will abort on errors.

    !-------------------- local.
    integer :: iostat, i
    logical :: all_good, warn
    integer, pointer :: new_output(:)
    logical :: found(size(requested_signals))
    type(gd_signal_type), pointer :: gd_signal

    !-------------------- executable code.

    call check_gd_handle(gd_handle,gd)

    !-- Check argument sizes.
    if (present(signal_found)) then
      if (size(signal_found) /= size(requested_signals)) &
           call error_halt('Size of signal_found bad in request_gd_signals')
    end if

    gd%ok_to_read = .false.
    gd%maps_built = .false.

    !-- Allocate space.
    allocate(new_output(size(requested_signals)), stat=iostat)
    if (iostat /= 0) then
      call write_error_msg('Out of memory in request_gd_signals.')
      if (.not.present(error)) call error_halt
      error = .true.
      return
    end if
    deallocate(gd%output_map)
    gd%output_map => new_output

    !-- Find the requested signals.
    find_loop: do i = 1 , size(requested_signals)
      call find_gd_signal(requested_signals(i), gd%signal_list, gd_signal)
      gd%output_map(i) = gd_signal%signal_number
    end do find_loop
    found = gd%output_map /= 0

    !-- Print optional error messages.
    all_good = all(found .or. (requested_signals==''))
    warn = .true.
    if (present(print_warning)) warn = print_warning
    if (warn .and. .not. all_good) then
      print_loop: do i = 1 , size(requested_signals)
        if ((.not.found(i)) .and. (requested_signals(i) /= '')) &
             call write_error_msg('Signal ' // requested_signals(i) // &
             ' not found.')
      end do print_loop
    end if

    !-- Return optional arguments.
    if (present(signal_found)) signal_found = found
    if (present(all_found)) all_found = all_good
    if (present(error)) error = .false.
    return
  end subroutine request_gd_signals

  subroutine seek_gd (gd_handle, start_time, stop_time, &
       dt, sync_source, thin, time_tolerance, error)

    !-- Seek to a specified time interval in a get_data object.
    !-- 20 Aug 92, Richard Maine.

    type(gd_handle_type), intent(in) :: gd_handle  !-- Handle from open_gd.
    real(r_kind), intent(in), optional :: start_time, stop_time
         !-- Requested time interval in seconds.
         !-- Defaults are 0 and 86400 (24 hours).
    real(r_kind), intent(in), optional :: dt
         !-- Sample interval.  Ignored if 0.
         !-- One and only one of dt and sync_source must be non-zero.
    integer, intent(in), optional :: sync_source
         !-- Source number used for syncronization.  Ignored if 0.
         !-- One and only one of dt and sync_source must be non-zero.
    integer, intent(in), optional :: thin
         !-- Thinning factor for synchronization.
         !-- Default is 1 if omitted or 0.
         !-- Irrelevant if sync_source is 0 or omitted.
    real(r_kind), intent(in), optional :: time_tolerance
         !-- Default is .0001 if omitted or 0.
    logical, intent(out), optional :: error

    !-------------------- local.
    integer :: sync_source_temp, n_files_used, iostat, status
    logical :: sub_error
    type(gd_input_type), pointer :: input
    type(input_frame_type), pointer :: frame
    real(r_kind) :: file_start, file_stop, file_tolerance, time_epsilon
    character :: msg*80

    !-------------------- executable code.

    call check_gd_handle(gd_handle,gd)

    gd%ok_to_read = .false.

    if (.not.associated(gd%first_input)) then
      msg = 'No files open'; goto 8000; endif

    !-- Determine how output times are specified.
    gd%dt = 0.
    if (present(dt)) gd%dt = abs(dt)
    sync_source_temp = 0
    if (present(sync_source)) sync_source_temp = sync_source
    gd%sync_thin = 1
    if (present(thin)) gd%sync_thin = max(1,thin)
    if (gd%dt /= 0. .eqv. sync_source_temp /= 0) then
      msg = 'One (only) of dt or sync_source must be given'; goto 8000; endif
    nullify(gd%sync_input)

    gd%start_time = 0.
    gd%stop_time = 86400.
    if (present(start_time)) gd%start_time = start_time
    if (present(stop_time)) gd%stop_time = stop_time
    gd%time_tolerance = .0001_r_kind
    if (present(time_tolerance)) then
      if (time_tolerance > 0.) gd%time_tolerance = time_tolerance
    end if
    gd%jump_tolerance = 1.
    !-- Might want to validate reasonability of time tolerance
    !-- and jump tolerance relative to dt (or nominal dt).

    !-- time_epsilon is negligible compared to start and end times.
    !-- Used to avoid round-off problems.
    time_epsilon = 16.*epsilon(time_epsilon)* &
         max(abs(gd%start_time), abs(gd%stop_time), 86400._r_kind)

    !-- Activate the requested signals and build maps as needed.
    call activate_requested_signals(gd, sub_error)
    if (sub_error) then
      msg = 'signal activation failed'; goto 8000; endif
    where (gd%signal%interpolate)
      gd%signal%adjusted_skew = gd%signal%skew
    elsewhere
      gd%signal%adjusted_skew = gd%signal%skew - gd%time_tolerance
    end where

    !-- Initialize used input files.
    n_files_used = 0
    input => gd%first_input
    file_loop: do while (associated(input))
      call release_input_frames(input)
      if (input%source%source_number==sync_source_temp) gd%sync_input => input
      input%input_used = input%n_used > 0 .or. associated(gd%sync_input,input)
      if (input%input_used) then
        n_files_used = n_files_used + 1

        !-- Determine skew ranges for the file.
        !-- Consider only synced signals.
        input%min_signal_skew = -time_epsilon + min(r_zero, &
             minval(gd%signal%adjusted_skew, mask=gd%signal%synced .and. &
             (gd%signal%source_number==input%source%source_number)))
        input%max_signal_skew = time_epsilon + max(r_zero, &
             maxval(gd%signal%adjusted_skew, mask=gd%signal%synced .and. &
             (gd%signal%source_number==input%source%source_number)))

        !-- Seek input file, allowing for skews.

        !-------------
        !-- The requested interval passed to seek_th is intended to
        !-- include bracketing time frames, but they may be
        !-- missed in some cases where the file dt is inaccurate.
        !-------------

        file_tolerance = 3.*(input%source%source_dt + gd%dt) + time_epsilon
        file_start = gd%start_time - input%max_signal_skew - file_tolerance
        file_stop = gd%stop_time - input%min_signal_skew + file_tolerance
        input%stale_time = gd%start_time - input%max_signal_skew
        call seek_gd_file(input%file_list, file_start, file_stop, sub_error)
        if (sub_error) then
          msg = 'File seek failed in seek_gd'; goto 8000; endif

        !-- Initialize input frame buffer list.
        allocate(frame, stat=iostat)
        if (iostat /= 0) then
          msg = 'Out of space'; goto 8000; endif
        nullify(frame%data, frame%next_frame, frame%prev_frame)
        input%first_frame => frame
        input%last_frame => frame
        input%current_frame => frame
        allocate(frame%data(input%n_used), stat=iostat)
        if (iostat /= 0) then
          msg = 'Out of space'; goto 8000; endif
        frame%status = thr_ok
        frame%time = file_start - 1.
        frame%data = 0.

        !-- Read the first frame and extrapolate it backwards
        !-- in case it doesn't bracket the start time.
        input%first_read = .true.
        call get_next_frame(input, frame, status)
        if (status >= thr_error) then
          msg = 'Read failed'; goto 8000; endif
        input%first_frame%data = frame%data
      end if
      input => input%next_input
    end do file_loop
    if (n_files_used == 0) then
      msg =' No files used'; goto 8000; endif
    if ((sync_source_temp /= 0) .and. .not.associated(gd%sync_input)) then
      msg = 'Bad sync_source'; goto 8000; endif

    gd%signal%data = 0.
    gd%first_read = .true.

    !---------- Normal exit.
    if (present(error)) error = .false.
    gd%ok_to_read = .true.
    return

    !---------- Error exit.
    8000 continue
    call write_error_msg(trim(msg) // ' in seek_gd.')
    if (.not.present(error)) call error_halt
    error = .true.
    return
  end subroutine seek_gd

  subroutine activate_requested_signals (gd, error)

    !-- Build maps linking the currently requested signals
    !-- with their sources.  Request the appropriate signals
    !-- from each source.
    !-- 4 Jan 91, Richard Maine.

    !-------------------- interface.
    type(gd_type), intent(inout) :: gd
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat, n_signals, source_number, i
    type(gd_input_type), pointer :: input

    !-------------------- executable code.

    !-- Return if the maps have been built and are still valid.
    error = .false.
    if (gd%maps_built) return

    !-- Flag requested output signals as used.
    n_signals = signal_list_size(gd%signal_list)
    if (associated(gd%signal))  deallocate(gd%signal)
    allocate(gd%signal(0:n_signals), stat=iostat)
    error = iostat /= 0
    if (error) return
    call get_signal_array(gd%signal_list, gd%signal)
    gd%signal%used = .false.
    do i = 1 , size(gd%output_map)
      gd%signal(gd%output_map(i))%used = .true.
    end do

    !-- Activate used calculated signals and flag their inputs as used.
    call activate_gd_calcs(gd%calc_list, gd%signal%used, error)
    if (error) return

    !-- Synced signals are those used before considering filter inputs.
    gd%signal%synced = gd%signal%used

    !-- Request the used input signals and build their maps.
    input => gd%first_input
    do while (associated(input))

      !-- Activate filters as required and flag their inputs as used.
      call activate_gd_filters(input%filter_list, gd%signal, error)
      if (error) return

      !-- Activate the input file.  Must follow the filter activation.
      call activate_gd_file(input%file_list, gd%signal, error)
      if (error) return

      !-- Generate used_signal_map for sync_to_time.
      source_number = input%source%source_number
      input%n_used = count(gd%signal%used .and. &
           (gd%signal%source_number==source_number))

      if (associated(input%used_signal_map)) deallocate(input%used_signal_map)
      allocate(input%used_signal_map(input%n_used), stat=iostat)
      error = (iostat /= 0)
      if (error) return
      input%used_signal_map = pack( (/(i,i=0,n_signals)/), &
           gd%signal%used .and. (gd%signal%source_number==source_number))

      input => input%next_input
    end do

    !-- Normal exit.
    gd%signal(0)%used = .false.
    gd%signal(0)%source_number = 0
    gd%signal(0)%skew = 0.
    gd%maps_built = .true.
    return
  end subroutine activate_requested_signals

  subroutine read_gd (gd_handle, time, data, status)

    !-- Read a frame from a get_data object.
    !-- 24 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(in) :: gd_handle  !-- Handle from open_gd
    real(r_kind), intent(out) :: time              !-- Frame time
    real(r_kind), intent(out) :: data(:)           !-- Frame data
    integer, intent(out) :: status
         !-- Returns 0 for valid data frame.
         !-- 1 = end of requested interval reached.
         !-- 2 = end of available data reached.
         !-- 3 = error.

    !-------------------- local.
    logical :: error, jump

    !-------------------- executable code.

    call check_gd_handle(gd_handle,gd)

    status = thr_error
    if (.not. gd%ok_to_read) return
    gd%ok_to_read = .false.

    if (size(data) < size(gd%output_map)) &
         call error_halt('data size wrong in read_gd')

    call set_output_time(gd, time, jump, status)
    if (status /= thr_ok) return
    if (time > gd%stop_time) then
      status = thr_eoi
      return
    end if

    call read_to_time(gd, time, status)
    if (status >= thr_error) return

    call sync_to_time(gd, time)

    call do_gd_calcs(gd%calc_list, time, jump, gd%signal%data, error)
    status = thr_error
    if (error) return

    data(1:size(gd%output_map)) = gd%signal(gd%output_map)%data

    gd%prev_time = time
    gd%first_read = .false.
    gd%ok_to_read = .true.
    status = thr_ok
    return
  end subroutine read_gd

  subroutine set_output_time (gd, time, jump, status)

    !-- Determine the next output frame time for a get_data object.
    !-- 26 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_type), intent(inout) :: gd
    real(r_kind), intent(out) :: time
    logical, intent(out) :: jump
         !-- True if there was a time jump.
         !-- Will always be true on the first frame of an interval.
    integer, intent(out) :: status     !-- See read_gd for codes.

    !-------------------- local.
    integer :: thin_count, min_status
    type(gd_input_type), pointer :: input
    type(input_frame_type), pointer :: frame
    real(r_kind) :: min_time, jump_time, dt_count

    !-------------------- executable code.

    jump = gd%first_read

    !-- Times syncronized with an input source.
    time_method: if (associated(gd%sync_input)) then
      input => gd%sync_input

      !-- Find first time >= requested start.
      first_read: if (gd%first_read) then
        frame => input%current_frame
        do
          call get_next_frame(input, frame, status)
          if (status /= thr_ok) return
          time = frame%time
          input%stale_time = time - input%max_signal_skew
          if (time >= gd%start_time) exit
        end do

      !-- Find thin'th time after current frame.
      else first_read
        frame => input%current_frame
        do thin_count = 1 , gd%sync_thin
          call get_next_frame(input, frame, status)
          if (status /= thr_ok) return
          input%stale_time = frame%time - input%max_signal_skew
        end do
        time = frame%time
        jump = time > gd%prev_time + gd%jump_tolerance
      end if first_read

    !-- Times defined by dt.
    else time_method

      !-- Define the candidate time and the jump time.
      if (gd%first_read) then
        time = gd%start_time
        jump_time = time
      else
        dt_count = anint((gd%prev_time - gd%start_time)/gd%dt) + 1.
        time = gd%start_time + gd%dt*dt_count
        jump_time = time + gd%jump_tolerance
      end if

      !-- Find the earliest file time after the current frame.
      min_time = big_real
      min_status = thr_error
      input => gd%first_input
      file_loop: do while (associated(input))
        input_used: if (input%input_used) then
          frame => input%current_frame
          call get_next_frame(input, frame, status)
          if (status >= thr_error) return
          min_time = min(min_time, frame%time)
          min_status = min(min_status, frame%status)
        end if input_used
        input => input%next_input
      end do file_loop
      status = min_status
      if (status /= thr_ok) return

      !-- Accept the candidate time.
      if (min_time <= jump_time) return

      !-- Time jump.  Message except at start and end of requested interval.
      !-- The ceiling intrinsic might get integer overflow, so avoid it.
      jump = .true.
      dt_count = (min_time - gd%start_time)/gd%dt
      if (aint(dt_count) /= dt_count) dt_count = aint(dt_count) + 1
      time = gd%start_time + gd%dt*dt_count
      if (time <= gd%stop_time .and. .not.gd%first_read) &
           call write_error_msg('Time jump from ' // &
           time_string(gd%prev_time) // ' to ' // time_string(time))
    end if time_method
    return
  end subroutine set_output_time

  subroutine read_to_time (gd, time, status)

    !-- Read input frames as needed for a specified output frame time.
    !-- Includes allowance for skews.
    !-- A sucessful return must absolutely guarantee that, even with
    !-- round-off error, we have a frame with time less than or equal
    !-- to the earliest skewed time and we have a frame with time strictly
    !-- greater than the latest skewed time.  These may be "dummy" frames.
    !-- Sync_to_time depends on this, but does not verify it.
    !-- The min and max skews do already have allowance for round-off.
    !-- 27 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_type), intent(inout) :: gd
    real(r_kind), intent(in) :: time   !-- output frame time.
    integer, intent(out) :: status
         !-- See read_gd for codes.
         !-- Currently, only codes thr_ok and thr_error are returned from here.

    !-------------------- local.
    real(r_kind) :: needed_time
    type(gd_input_type), pointer :: input
    type(input_frame_type), pointer :: frame

    !-------------------- executable code.

    input => gd%first_input
    file_loop: do while (associated(input))
      input_used: if (input%input_used) then
        input%stale_time = time - input%max_signal_skew
        needed_time = time - input%min_signal_skew
        frame => input%last_frame
        frame_loop: do
          if (frame%time > needed_time) exit frame_loop
          call get_next_frame(input, frame, status)
          if (status >= thr_error) return
        end do frame_loop
      end if input_used
      input => input%next_input
    end do file_loop
    status = thr_ok
    return
  end subroutine read_to_time

  subroutine sync_to_time (gd, time)

    !-- Syncronize input data frames to the specified output time.
    !-- Skew and interpolate the input data, putting results in
    !-- the gd%signal%data array.
    !-- All required input frames are supposed to be already read,
    !-- so this routine involves no i/o.
    !-- Speed of this routine is a substantial and non-trivial issue.
    !-- For now, we largely follow the version 3.2 algorithm,
    !-- with little attention to optimizing performance.
    !-- We may later consider experimenting with other algorithms to
    !-- get better speed.
    !-- 28 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_type), intent(inout) :: gd
    real(r_kind), intent(in) :: time   !-- output frame time.

    !-------------------- local.
    integer :: chan, used_chan
    real(r_kind) :: signal_time, fact
    type(gd_input_type), pointer :: input
    type(input_frame_type), pointer :: current_frame, frame

    !-------------------- executable code.

    input => gd%first_input
    file_loop: do while (associated(input))
      input_used: if (input%input_used) then

        !-- Update current frame pointer to the last input frame <= time.
        current_frame => input%current_frame
        move_current: do
          if (current_frame%next_frame%time > time) exit move_current
          current_frame => current_frame%next_frame
        end do move_current
        input%current_frame => current_frame

        !-- Naively loop through the used signals of the file.
        !-- This is the time-consuming one.
        signal_loop: do used_chan = 1 , input%n_used
          chan = input%used_signal_map(used_chan)
          if (.not. gd%signal(chan)%synced) cycle signal_loop
          signal_time = time - gd%signal(chan)%adjusted_skew

          !-- Bracket signal_time with frame and frame%next_frame
          frame => current_frame
          bracket_time: do
             if (signal_time < frame%time) then
               frame => frame%prev_frame
             else if (signal_time >= frame%next_frame%time) then
               frame => frame%next_frame
             else
               exit bracket_time
             end if
          end do bracket_time

          if (gd%signal(chan)%interpolate) then
            fact = (signal_time - frame%time)/ &
                 (frame%next_frame%time - frame%time)
            gd%signal(chan)%data = &
                 (1.-fact)*frame%data(used_chan) + &
                 fact*frame%next_frame%data(used_chan)
          else
            gd%signal(chan)%data = frame%data(used_chan)
          end if
        end do signal_loop
      end if input_used
      input => input%next_input
    end do file_loop
    return
  end subroutine sync_to_time

  subroutine get_next_frame (input, frame, status)

    !-- Get the next input frame, allocating buffer space and
    !-- reading as needed.
    !-- 21 Mar 91, Richard Maine.

    !-------------------- interface.
    type(gd_input_type), intent(inout) :: input
         !-- Input record for gd_read.
    type(input_frame_type), pointer :: frame
         !-- Points to a frame node on entry.
         !-- Points to the next frame node on successful return.
         !-- A dummy frame with large time is generated for eod or eoi status.
         !-- Undefined on error return (status >= thr_error).
    integer, intent(out) :: status  !-- see gd_read for codes.

    !-------------------- local.
    integer :: iostat
    logical :: stale, error
    type(input_frame_type), pointer :: new_frame

    !-------------------- executable code.

    status = thr_error

    !-- If the next frame is already available, return it.
    if (associated(frame%next_frame)) then
      frame => frame%next_frame
      status = frame%status

    !-- Otherwise try to read a new one if allowed.
    else if (frame%status == thr_ok) then

      !-- If first frame is stale, re-use it.
      stale = .false.
      if (associated(input%first_frame%next_frame)) &
           stale = input%first_frame%next_frame%time < input%stale_time
      re_use: if (stale) then
        new_frame => input%first_frame
        input%first_frame => new_frame%next_frame

        !-- Don't leave current_frame pointer dangling.
        if (associated(input%current_frame, new_frame)) &
             input%current_frame => input%first_frame

      !-- Otherwise, allocate a new frame.
      else re_use
        allocate(new_frame, stat=iostat)
        if (iostat /= 0) return
        allocate(new_frame%data(input%n_used), stat=iostat)
        if (iostat /= 0) then
          deallocate(new_frame)
          return
        end if
      end if re_use

      !-- Add the frame to the end of the doubly linked list.
      nullify(new_frame%next_frame)
      new_frame%prev_frame => input%last_frame
      input%last_frame%next_frame => new_frame
      input%last_frame => new_frame

      !-- Read from input into the new frame.
      frame => new_frame
      call read_gd_file(input%file_list, frame%time, frame%data, frame%status)

      !-- Apply filters if valid data was read.
      if (frame%status == thr_ok) then
        call do_gd_filters(input%filter_list, input%first_read, &
             frame%time, frame%data, error)
        if (error) frame%status = thr_error
      end if
      input%first_read = .false.

      !-- Generate a dummy frame with large time and held values if needed.
      if (frame%status /= thr_ok) then
        frame%time = big_real
        frame%data = frame%prev_frame%data
      end if
      status = frame%status
    end if

    return
  end subroutine get_next_frame

  subroutine release_input_frames (input)

    !-- Release data frames for an input source.
    !-- 26 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_input_type), intent(inout) :: input

    !-------------------- local.
    type(input_frame_type), pointer :: frame, next_frame

    !-------------------- executable code.

    frame => input%first_frame
    do while(associated(frame))
      if (associated(frame%data)) deallocate(frame%data)
      next_frame => frame%next_frame
      deallocate(frame)
      frame => next_frame
    end do
    nullify(input%first_frame, input%last_frame, input%current_frame)
    return
  end subroutine release_input_frames

  subroutine filter_gd (gd_handle, filter_name, filter_linker, &
       filter_parameters, signal_names, output_names, print_warning, &
       all_found, error)

    !-- Connect a filter to a get_data object.
    !-- Might want to consider optional argument signal_found
    !-- corresponding to that in request_gd_signals.
    !-- 2 Jan 91, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(in) :: gd_handle  !-- Handle from open_gd.
    character*(*), intent(in) :: filter_name
    character*(*), intent(in), optional :: filter_linker
    real(r_kind), intent(in) :: filter_parameters(:)
           !-- Interpretation of these depends on the filter routines.
           !-- The most common parameter will probably be a break frequency.
    character*(*), intent(in) :: signal_names(:)
           !-- Names of the signals to be filtered.
    character*(*), intent(in) :: output_names(:)
           !-- Names of the filtered output signals.
    logical, intent(in), optional :: print_warning
           !-- Should missing signal warnings be printed?  Default is false.
    logical, intent(out), optional :: all_found
           !-- True if all non-blank requested signals were found.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: source_numbers(size(signal_names))
    integer :: signal_numbers(size(signal_names))
    integer :: i, n_filtered, source_number
    logical :: warn
    type(gd_input_type), pointer :: input
    type(gd_signal_type), pointer :: gd_signal

    !-------------------- executable code.

    call check_gd_handle(gd_handle,gd)

    !-- Check argument sizes.
    if (size(output_names) /= size(signal_names)) &
         call error_halt('Output_names size bad in filter_gd.')

    !-- Find the source signals.
    warn = .false.
    if (present(print_warning)) warn = print_warning
    find_loop: do i = 1 , size(signal_names)
      call find_gd_signal(signal_names(i), gd%signal_list, gd_signal)
      if (gd_signal%source_code == file_source_code .or. &
           gd_signal%source_code == filter_source_code) then
        source_numbers(i) = gd_signal%source_number
        signal_numbers(i) = gd_signal%signal_number
      else
        source_numbers(i) = 0
        if (warn) call write_error_msg &
             ('Signal ' // signal_names(i) // ' missing in filter_gd.')
      end if
    end do find_loop
    if (present(all_found)) all_found = all(signal_numbers /= 0)
    gd%maps_built = .false.
    gd%ok_to_read = .false.

    !-- For each input with signals to be filtered...
    input => gd%first_input
    file_loop: do while (associated(input))
      source_number = input%source%source_number
      n_filtered = count(source_numbers == source_number)
      file_filtered: if (n_filtered /= 0) then

        !-- Open the filter.
        call add_gd_filter(input%filter_list, filter_name, filter_linker, &
             input%source%source_dt, filter_parameters, &
             pack(output_names, source_numbers==source_number), &
             pack(signal_numbers, source_numbers==source_number), &
             input%n_aug_signals, input%file_interpolate, &
             gd%source_list, gd%signal_list, error)
        if (error) return

        input%n_aug_signals = input%n_aug_signals + n_filtered
      end if file_filtered
      input => input%next_input
    end do file_loop

    !-- Normal exit.
    error = .false.
    return
  end subroutine filter_gd

  subroutine calc_gd (gd_handle, calc_name, calc_linker, &
       calc_parameters, calc_string, error)

    !-- Connect a calculated function set to a get_data object.
    !-- 14 Mar 91, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(in) :: gd_handle  !-- handle from open_gd.
    character*(*), intent(in) :: calc_name
         !-- calculated function set name.
    character*(*), intent(in), optional :: calc_linker
         !-- calculated function set linker.
    real(r_kind), intent(in), optional :: calc_parameters(:)
         !-- Interpretation of these parameters depends on the calc routines.
         !-- Many calc routines ignore them.
    character*(*), intent(in), optional :: calc_string
         !-- Interpretation of this parameter depends on the calc routines.
         !-- Many calc routines ignore it.
    logical, intent(out) :: error

    !-------------------- executable code.

    call check_gd_handle(gd_handle,gd)

    gd%maps_built = .false.
    gd%ok_to_read = .false.

    call add_gd_calc(gd%calc_list, calc_name, calc_linker, &
           calc_parameters, calc_string, gd%source_list, gd%signal_list, error)
    return
  end subroutine calc_gd

  subroutine check_gd_handle (gd_handle,gd)

    !-- Check that a gd_handle is for a legal, opened object.
    !-- If ok, return gd as a pointer into gd_table.
    !-- 3 Dec 90, Richard Maine.

    !-------------------- interface.
    type(gd_handle_type), intent(in) :: gd_handle
    type(gd_type), pointer :: gd  !-- intent(out)

    !-------------------- executable code.

    !-- Check for illegal handles.
    gd => gd_handle%gd
    if (.not. associated(gd)) call error_halt('Null gd_handle')

    return
  end subroutine check_gd_handle
end module gd_read
