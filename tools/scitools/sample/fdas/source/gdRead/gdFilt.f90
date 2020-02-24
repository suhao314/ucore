!-- gdFilt.f90
!-- 22 Sept 92, Richard Maine: Version 1.0.

module gd_filter

  !-- Filter module for gd_read.
  !-- The main function of this module is managing the lists of
  !-- available and used signals relevant to the filters.
  !-- 21 Oct 91, Richard Maine

  use precision
  use sysdep_io
  use gd_common
  use link_filter

  implicit none
  private

  !-- filter_signal_type has data about a filtered signal.
  type filter_signal_type
    integer :: input_number, output_number
         !-- Get_data signal numbers for the input and output signals.
    logical :: used
  end type

  !-- used_filter_signal_type has data about a used filter signal.
  type used_filter_signal_type
    integer :: input_map, output_map
         !-- maps to the compressed file frame buffers
    real(r_kind) :: input_data, output_data
  end type

  !-- filter_type has data about a filter.
  type filter_type
    logical :: opened  !-- Has the filter connection been opened?
    logical :: filter_used  !-- Is this filter used?
    type(filter_handle_type) :: filter_handle  !-- handle from open_gd_filter.
    type(gd_source_type), pointer :: source
         !-- Generic information about the data source.
    character :: filter_linker*128
    type(filter_signal_type), pointer :: signal(:)
    type(used_filter_signal_type), pointer :: used_signal(:)
    type(filter_type), pointer :: next_filter, prev_filter
         !-- Doubly linked list of filters for a file.
  end type

  type, public :: filter_list_type
    private
    integer :: input_source_number
         !-- Source number of the associated input file.
    type(filter_type), pointer :: first_filter, last_filter
  end type

  !-- Public procedures.
  public init_gd_filter_list, add_gd_filter, close_gd_filters
  public activate_gd_filters, do_gd_filters

  !-- Forward reference for private procedures.
  private release_gd_filter

contains

  subroutine init_gd_filter_list (filter_list, input_source_number)

    !-- Initialize an empty filter_list for gd_read.
    !-- 19 Oct 91, Richard Maine.

    !-------------------- interface.
    type(filter_list_type), intent(out) :: filter_list
    integer, intent(in) :: input_source_number
         !-- Source number of the associated input file.

    !-------------------- executable code.

    nullify(filter_list%first_filter, filter_list%last_filter)
    filter_list%input_source_number = input_source_number
    return
  end subroutine init_gd_filter_list

  subroutine add_gd_filter (filter_list, filter_name, filter_linker, &
       filter_dt, filter_parameters, signal_names, input_signal_numbers, &
       output_offset, interpolate, source_list, signal_list, error)

    !-- Add a filter to the list for a file.
    !-- 21 Oct 91, Richard Maine.

    !-------------------- interface.
    type(filter_list_type), intent(inout) :: filter_list
    character*(*), intent(in) :: filter_name
    character*(*), intent(in), optional :: filter_linker
    real(r_kind), intent(in) :: filter_dt
    real(r_kind), intent(in) :: filter_parameters(:)
         !-- Interpretation of these depends on the filter routines.
         !-- The most common parameter will probably be a break frequency.
    character*(*), intent(in) :: signal_names(:)
         !-- Names of the filter output signals.
    integer, intent(in) :: input_signal_numbers(:)
         !-- Get_data signal numbers for the filter inputs.
         !-- Should not be size 0.
    integer, intent(in) :: output_offset
         !-- Offset in the file signal vector for outputs from this filter.
    logical, intent(in) :: interpolate
         !-- True if signals should default to sync by interpolation.
         !-- False for hold-last-value.
    type(gd_source_list_type) :: source_list
         !-- List of source records for gd_read.
    type(gd_signal_list_type) :: signal_list
         !-- List of signal records for gd_read.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: i, iostat, n_signals
    character :: where*8, description*80
    type(filter_type), pointer :: filter
    type(gd_signal_type), pointer :: gd_signal

    !-------------------- executable code.

    !-- Allocate a new filter record.
    where = 'allocate'
    nullify(filter)
    allocate(filter, stat=iostat)
    if (iostat /= 0) goto 8000
    filter%opened = .false.
    filter%filter_used = .false.

    !-- Allocate and define the signal record.
    n_signals = size(signal_names)
    nullify(filter%signal, filter%used_signal)
    allocate(filter%signal(n_signals), stat=iostat)
    if (iostat /= 0) goto 8000
    filter%signal%input_number = input_signal_numbers

    !-- Open the filter.
    where = 'open'
    filter%filter_linker = ''
    if (present(filter_linker)) filter%filter_linker = filter_linker
    call open_gd_filter(filter%filter_handle, filter_name, &
         filter%filter_linker, filter_dt, filter_parameters, &
         n_signals, description, error)
    if (error) goto 8000
    filter%opened = .true.

    !-- Add source to the get_data list.
    call add_gd_source(source_list, filter_source_code, filter_name, &
         description, filter_dt, filter%source, error)
    if (error) goto 8000

    !-- Add the new signals to the get_data list.
    !-- Tag them with the file source number and signal number,
    !-- because that seems to be what we always need.
    !-- Code in sync_gd and filter_gd currently depends on this.
    where = 'avail'
    signal_loop: do i = 1 , n_signals
      call add_gd_signal(signal_list, signal_names(i), filter%source, &
           gd_signal, 'filter', error)
      if (error) goto 8000
      gd_signal%source_number = filter_list%input_source_number
      gd_signal%source_signal_number = output_offset + i
      gd_signal%interpolate = interpolate
      filter%signal(i)%output_number = gd_signal%signal_number
    end do signal_loop

    !-- Append filter to doubly linked list of filters for this file.
    nullify(filter%next_filter)
    filter%prev_filter => filter_list%last_filter
    if (.not.associated(filter_list%first_filter)) &
         filter_list%first_filter => filter
    if (associated(filter_list%last_filter)) &
         filter_list%last_filter%next_filter => filter
    filter_list%last_filter => filter

    !-- Normal exit.
    error = .false.
    return

    !-- Error exit.
    8000 continue
    call write_error_msg('Add_gd_filter failed at ' // where)
    call release_gd_filter(filter)
    error = .true.
    return
  end subroutine add_gd_filter

  subroutine close_gd_filters (filter_list)

    !-- Close all filters for a file.
    !-- 19 Oct 91, Richard Maine.

    !-------------------- interface.
    type(filter_list_type), intent(inout) :: filter_list

    !-------------------- local.
    type(filter_type), pointer :: filter

    !-------------------- executable code.

    do while (associated(filter_list%last_filter))
      filter => filter_list%last_filter%prev_filter
      call release_gd_filter(filter_list%last_filter)
      filter_list%last_filter => filter
    end do
    nullify(filter_list%first_filter)
    return
  end subroutine close_gd_filters

  subroutine release_gd_filter (filter)

    !-- Close a filter and deallocate space.
    !-- 9 Jan 91, Richard Maine.

    !-------------------- interface.
    type(filter_type), pointer :: filter  !-- intent(inout)

    !-------------------- executable code.

    if (associated(filter)) then
      if (associated(filter%used_signal)) deallocate(filter%used_signal)
      if (associated(filter%signal)) deallocate(filter%signal)
      if (filter%opened) call close_gd_filter(filter%filter_handle)
      deallocate(filter)
    end if
    return
  end subroutine release_gd_filter

  subroutine activate_gd_filters (filter_list, signal, error)

    !-- Activate the used filtered signals for a file.
    !-- Flag their needed inputs as used in turn.
    !-- 22 Sept 92, Richard Maine.

    !-------------------- interface.
    type(filter_list_type), intent(inout) :: filter_list
    type(gd_signal_type), intent(inout) :: signal(0:)
         !-- Array of get_data signal information.
         !-- Use the entry values to determine which filters to activate.
         !-- Set used any needed inputs of activated filters on return.
    logical, intent(out) :: error

    !-------------------- local.
    type(filter_type), pointer :: filter
    integer :: iostat, i, j, n_used
    integer :: buffer_map(0:ubound(signal,1))
    integer, pointer :: output_number(:), input_number(:)

    !-------------------- executable code.

    error = .true.

    !-- Activate the input signals needed for used filter output signals.
    !-- Note we must do this in reverse order to catch dependencies.
    filter => filter_list%last_filter
    do while (associated(filter))
      signal(0)%used = .false.
      output_number => filter%signal%output_number
      input_number => filter%signal%input_number
      do i = 1 , filter%source%n_source_signals
        if (signal(output_number(i))%used) &
             signal(input_number(i))%used = .true.
      end do
      filter => filter%prev_filter
    end do

    !-- Make map from get_data signal numbers to the compressed frame buffer.
    !-- Cannot be done until after all used signals in the file are flagged.
    signal(0)%used = .false.
    buffer_map = 0
    j = 0
    do i = 1 , ubound(signal,1)
      if (signal(i)%used .and. &
           (signal(i)%source_number==filter_list%input_source_number)) then
        j = j + 1
        buffer_map(i) = j
      end if
    end do

    !-- Make the used signal maps for each filter in the list.
    filter => filter_list%first_filter
    do while (associated(filter))
      output_number => filter%signal%output_number
      input_number => filter%signal%input_number
      filter%signal%used = signal(output_number)%used
      n_used = count(filter%signal%used)
      filter%filter_used = n_used > 0
      if (associated(filter%used_signal)) deallocate(filter%used_signal)
      if (filter%filter_used) then
        allocate(filter%used_signal(n_used), stat=iostat)
        if (iostat /= 0) return
        j = 0
        do i = 1 , filter%source%n_source_signals
          if (signal(output_number(i))%used) then
            j = j + 1
            filter%used_signal(j)%output_map = buffer_map(output_number(i))
            filter%used_signal(j)%input_map = buffer_map(input_number(i))
          end if
        end do
      end if
      filter => filter%next_filter
    end do
    error = .false.
    return
  end subroutine activate_gd_filters

  subroutine do_gd_filters(filter_list, reset, time, data, error)

    !-- Apply the activated filters for a file.
    !-- 21 Mar 91, Richard Maine.

    !-------------------- interface.
    type(filter_list_type), intent(in) :: filter_list
    logical, intent(in) :: reset
         !-- Should filters be reset?
         !-- True on first frame of a time interval.
    real(r_kind), intent(in) :: time
         !-- Frame time.
    real(r_kind), intent(inout) :: data(:)
         !-- Compressed data frame.
         !-- Includes only used signals for the file and associated filters.
    logical, intent(out) :: error

    !-------------------- local.
    type(filter_type), pointer :: filter
    type(used_filter_signal_type), pointer :: used_signal(:)

    !-------------------- executable code.

    filter => filter_list%first_filter
    do while (associated(filter))
      if (filter%filter_used) then
        used_signal => filter%used_signal
        used_signal%input_data = data(used_signal%input_map)
        call do_gd_filter(filter%filter_handle, reset, time, &
             used_signal%input_data, used_signal%output_data, error)
        if (error) return
        data(used_signal%output_map) = used_signal%output_data
      end if
      filter => filter%next_filter
    end do
    error = .false.
    return
  end subroutine do_gd_filters

end module gd_filter
