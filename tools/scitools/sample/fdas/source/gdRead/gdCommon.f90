!-- gdCommon.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module gd_common

  !-- Utility module for use in gd_read.
  !-- Provides functionality common to several gd_read submodules.
  !-- Routines, data, and types to manage the list of signals
  !-- and data sources.
  !-- 19 Oct 91, Richard Maine.

  use precision
  use sysdep_io
  use string
  use gd_tree

  implicit none
  private

  integer, public, parameter :: signal_name_len = 16

  integer, public, parameter :: no_source_code = 0
  integer, public, parameter :: file_source_code = 1
  integer, public, parameter :: filter_source_code = 2
  integer, public, parameter :: calc_source_code = 3

  !-- gd_source_type has generic information about a data source.
  !-- This is accessible outside of gd_read.
  type, public :: gd_source_type
    integer :: source_code
         !-- An integer code for the source type.
    integer :: source_number
         !-- The source number.  A single numbering sequence is
         !-- currently shared by all source codes.
    character*(file_name_len) :: source_name
         !-- Source name.  Often a file name.
    character*80 :: source_description
         !-- One-line description of the source.
    real(r_kind) :: source_dt
         !-- Nominal source sample interval.  0 if unknown or undefined.
         !-- Value for files reflects any file thinning.
    integer :: n_source_signals
         !-- Number of signals available from this source.
         !-- Note there may be more signals defined than are available.
         !-- This total includes only the available signals.
    integer :: source_signal_offset
         !-- Offset in the gd signal list of the signals from this source.
  end type

  !-- gd_signal_type has information about a get_data signal.
  type, public :: gd_signal_type
    integer :: signal_number  !-- Signal number in the get_data list.
    character*(signal_name_len) :: signal_name
         !-- Unique signal name.
    integer :: source_number
         !-- The source number for this signal.
         !-- For filter signals, this is the number of the associated file,
         !-- because that's what we always seem to need.
         !-- If we ever need the filter source number as distinct from
         !-- the file source number, we'll need a change.
    integer :: source_code
         !-- An integer code for the source type.
    integer :: source_signal_number
         !-- Index in the list of signals from this source.
         !-- For filter signals, refers to the associated file signal list,
         !-- rather than the filter signal list.
    real(r_kind) :: skew, adjusted_skew
         !-- Time skew for this signal.  Irrelevant for calc signals.
         !-- For hold-last-value signals, the adjusted skew includes
         !-- both the given skew plus an allowance for the time tolerance;
         !-- for other signals it is the same as the skew.
    logical :: interpolate
         !-- False means hold last value.  Irrelevant for calc signals.
    logical :: used
         !-- Is this signal used?
    logical :: synced
         !-- Does this signal need to be synced?
         !-- A filter input may be used without needing to be synced.
    real(r_kind) :: data
         !-- Signal data value.
  end type

  type signal_ptr_type
    type(gd_signal_type), pointer :: gd_signal
  end type

  type signal_list_node_type
    type(gd_signal_type) :: signal
    type(signal_list_node_type), pointer :: prev_node
  end type

  type, public :: gd_signal_list_type
    private
    integer :: n_signals
    type(tree_type) :: tree
    type(signal_list_node_type), pointer :: last_node
  end type

  type gd_source_list_node_type
    type(gd_source_type) :: source
    type(gd_source_list_node_type), pointer :: prev_node
  end type

  type, public :: gd_source_list_type
    private
    integer :: n_sources
    type(gd_source_list_node_type), pointer :: last_node
  end type

  !-- This dummy entry is returned when searches fail.
  type(gd_signal_type), target, save :: no_signal

  !-- Public procedures.
  public init_signal_list, release_signal_list, add_gd_signal
  public find_gd_signal, get_signal_array, get_signal_names, signal_list_size
  public init_source_list, release_source_list
  public add_gd_source, get_source_array, source_list_size

contains

  subroutine init_signal_list (signal_list)

    !-- Initialize an empty signal list.
    !-- 19 Oct 91, Richard Maine.

    !-------------------- interface.
    type(gd_signal_list_type), intent(out) :: signal_list

    !-------------------- executable code.

    no_signal%signal_number = 0
    no_signal%signal_name = ''
    no_signal%source_number = 0
    no_signal%source_code = no_source_code
    no_signal%source_signal_number = 0
    no_signal%skew = 0.
    no_signal%adjusted_skew = 0.
    no_signal%interpolate = .false.
    no_signal%used = .false.
    no_signal%synced = .false.
    no_signal%data = 0.

    signal_list%n_signals = 0
    call initialize_tree(signal_list%tree)
    nullify(signal_list%last_node)
    return
  end subroutine init_signal_list

  subroutine release_signal_list (signal_list)

    !-- Release space in the signal list.
    !-- 19 Oct 91, Richard Maine.

    !-------------------- interface.
    type(gd_signal_list_type), intent(inout) :: signal_list

    !-------------------- local.
    type(signal_list_node_type), pointer :: node

    !-------------------- executable code.

    do while(associated(signal_list%last_node))
      node => signal_list%last_node
      signal_list%last_node => node%prev_node
      deallocate(node)
    end do
    call deallocate_tree(signal_list%tree)
    return
  end subroutine release_signal_list

  function signal_list_size (signal_list)

    !-- Return the number of signals in a list.
    !-- 1 Sep 92, Richard Maine.

    !-------------------- interface.
    type(gd_signal_list_type), intent(in) :: signal_list
         !-- The list of get_data signal records.
    integer :: signal_list_size  !-- Number of signals in the list.

    !-------------------- executable code.

    signal_list_size = signal_list%n_signals
    return
  end function signal_list_size

  subroutine add_gd_signal (signal_list, signal_name, source, gd_signal, &
    source_name, error)

    !-- Add a new name to the get_data signal list.
    !-- Modify the name to be unique if needed.
    !-- If this routine fails (presumably by running out of memory)
    !-- then the signal list will likely be left with spurious
    !-- nodes for the preceding signals of the same source.
    !-- We probably ought to either figure out how to delete the
    !-- spurious nodes or declare the gd_read connection unuseable.
    !-- However, odds are that things will bomb later in any case
    !-- if we are that short on memory.
    !-- 19 Oct 91, Richard Maine.

    !-------------------- interface.
    type(gd_signal_list_type), intent(inout) :: signal_list
         !-- The list of get_data signal records.
    character*(*), intent(in) :: signal_name
         !-- Name of the new signal to be added.
    type(gd_source_type), intent(inout) :: source
         !-- Source record for the source of this signal.
    type(gd_signal_type), pointer :: gd_signal
         !-- Record of information about the signal.  Intent(out)
         !-- Default values will be filled in on exit.
    character*(*), intent(in) :: source_name
         !-- Name of the source.  Used in messages.
    logical, intent(out) :: error

    !-------------------- local.
    logical :: dup
    integer :: number, iostat
    character, parameter :: sharp = '#'
    character :: new_name*(signal_name_len)
    integer, pointer :: int_array(:)
    type(signal_ptr_type) :: signal_ptr
    type(signal_list_node_type), pointer :: signal_list_node

    !-------------------- executable code.

    nullify(signal_list_node)
    allocate(signal_list_node, stat=iostat)
    if (iostat /= 0) goto 8000

    gd_signal => signal_list_node%signal
    signal_ptr%gd_signal => gd_signal

    !-- Try to add the name as is (unless it is blank).
    dup = signal_name == ''
    if (.not. dup) then
      call add_tree_data(signal_name, transfer(signal_ptr,int_array), &
           signal_list%tree, dup, error)
      if (error) goto 8000
    end if

    !-- Generate a new name to avoid duplication.
    new_name = signal_name
    number = 1
    loop: do while(dup)
      number = number + 1
      new_name = sharp // trim(adjustl(int_string(number))) // sharp // &
           signal_name
      call add_tree_data(new_name, transfer(signal_ptr,int_array), &
           signal_list%tree, dup, error)
      if (error) goto 8000
      if (.not. dup) call write_error_msg('Duplicate name ' // signal_name // &
         ' from ' // source_name // ' changed to ' // new_name)
    end do loop

    !-- Add to linked list of signals and to source signal count.
    if (source%n_source_signals == 0) &
         source%source_signal_offset = signal_list%n_signals
    source%n_source_signals = source%n_source_signals + 1
    signal_list%n_signals = signal_list%n_signals + 1
    signal_list_node%prev_node => signal_list%last_node
    signal_list%last_node => signal_list_node

    gd_signal%signal_name = new_name
    gd_signal%signal_number = signal_list%n_signals
    gd_signal%source_number = source%source_number
    gd_signal%source_code = source%source_code
    gd_signal%source_signal_number = source%n_source_signals
    gd_signal%skew = 0.
    gd_signal%adjusted_skew = 0.
    gd_signal%interpolate = .false.
    gd_signal%used = .false.
    gd_signal%synced = .false.
    gd_signal%data = 0.
    error = .false.
    return

    !-- Error exit.
    8000 continue
    if (associated(signal_list_node)) deallocate(signal_list_node)
    error = .true.
    return
  end subroutine add_gd_signal

  subroutine find_gd_signal (signal_name, signal_list, gd_signal)

    !-- Find a get_data signal record by name.
    !-- 22 Oct 91, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: signal_name  !-- name of the signal sought.
    type(gd_signal_list_type), intent(in) :: signal_list
         !-- List of signal records to search.
    type(gd_signal_type), pointer :: gd_signal
         !-- Record of data about the specified signal.
         !-- If not found, returns pointer to dummy no_signal record.

    !-------------------- local.
    integer, pointer :: int_array(:)
    type(signal_ptr_type) :: signal_ptr

    !-------------------- executable code.

    call get_tree_data(signal_name, signal_list%tree, int_array)
    if (associated(int_array)) then
      signal_ptr = transfer(int_array, signal_ptr)
      gd_signal => signal_ptr%gd_signal
    else
      gd_signal => no_signal
    end if
    return
  end subroutine find_gd_signal

  subroutine get_signal_array (signal_list, signal)

    !-- Get the get_data signal records in an array.
    !-- 22 Oct 91, Richard Maine.

    !-------------------- interface.
    type(gd_signal_list_type), intent(in) :: signal_list
         !-- List of get_data signal records.
    type(gd_signal_type), intent(out) :: signal(0:)

    !-------------------- local.
    type(signal_list_node_type), pointer :: node

    !-------------------- executable code.

    node => signal_list%last_node
    do while (associated(node))
      signal(node%signal%signal_number) = node%signal
      node => node%prev_node
    end do
    signal(0) = no_signal
    return
  end subroutine get_signal_array

  subroutine get_signal_names (signal_list, signal_names)

    !-- Get the get_data signal names in a vector.
    !-- 22 Oct 91, Richard Maine.

    !-------------------- interface.
    type(gd_signal_list_type), intent(in) :: signal_list
         !-- List of get_data signal records.
    character*(*), intent(out) :: signal_names(:)

    !-------------------- local.
    type(signal_list_node_type), pointer :: node

    !-------------------- executable code.

    node => signal_list%last_node
    do while (associated(node))
      signal_names(node%signal%signal_number) = node%signal%signal_name
      node => node%prev_node
    end do
    return
  end subroutine get_signal_names

  subroutine init_source_list (source_list)

    !-- Initialize an empty source list.
    !-- 17 Sept 92, Richard Maine.

    !-------------------- interface.
    type(gd_source_list_type), intent(out) :: source_list

    !-------------------- executable code.

    source_list%n_sources = 0
    nullify(source_list%last_node)
    return
  end subroutine init_source_list

  subroutine release_source_list (source_list)

    !-- Release space in the source list.
    !-- 17 Sept 92, Richard Maine.

    !-------------------- interface.
    type(gd_source_list_type), intent(inout) :: source_list

    !-------------------- local.
    type(gd_source_list_node_type), pointer :: node

    !-------------------- executable code.

    do while(associated(source_list%last_node))
      node => source_list%last_node
      source_list%last_node => node%prev_node
      deallocate(node)
    end do
    return
  end subroutine release_source_list

  function source_list_size (source_list)

    !-- Return the number of sources in a list.
    !-- 1 Sep 92, Richard Maine.

    !-------------------- interface.
    type(gd_source_list_type), intent(in) :: source_list
         !-- The list of get_data source records.
    integer :: source_list_size  !-- Number of sources in the list.

    !-------------------- executable code.

    source_list_size = source_list%n_sources
    return
  end function source_list_size

  subroutine add_gd_source (source_list, source_code, source_name, &
       source_description, source_dt, source, error)

    !-- Add a new entry to the get_data source list.
    !-- 17 Sept 92, Richard Maine.

    !-------------------- interface.
    type(gd_source_list_type), intent(inout) :: source_list
         !-- The list of get_data sources.
    integer, intent(in) :: source_code
         !-- Source code value for this source.
    character*(*), intent(in) :: source_name
         !-- Name of the source.
    character*(*), intent(in) :: source_description
         !-- One-line description of the source.
    real(r_kind), intent(in) :: source_dt
         !-- Nominal sample interval of the source.  (0 if not applicable).
    type(gd_source_type), pointer :: source
         !-- Record of information about the source.  Intent(out)
         !-- Default values will be filled in on exit.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat
    type(gd_source_list_node_type), pointer :: source_list_node

    !-------------------- executable code.

    nullify(source_list_node)
    allocate(source_list_node, stat=iostat)
    if (iostat /= 0) goto 8000

    source => source_list_node%source

    !-- Add to linked list.
    source_list_node%prev_node => source_list%last_node
    source_list%last_node => source_list_node

    source_list%n_sources = source_list%n_sources + 1

    source%source_code = source_code
    source%source_number = source_list%n_sources
    source%source_name = source_name
    source%source_description = source_description
    source%source_dt = source_dt
    source%n_source_signals = 0
    source%source_signal_offset = 0

    error = .false.
    return

    !-- Error exit.
    8000 continue
    if (associated(source_list_node)) deallocate(source_list_node)
    error = .true.
    return
  end subroutine add_gd_source

  subroutine get_source_array (source_list, source)

    !-- Get the get_data source records in an array.
    !-- 22 Oct 91, Richard Maine.

    !-------------------- interface.
    type(gd_source_list_type), intent(in) :: source_list
         !-- List of get_data source records.
    type(gd_source_type), intent(out) :: source(:)

    !-------------------- local.
    type(gd_source_list_node_type), pointer :: node

    !-------------------- executable code.

    node => source_list%last_node
    do while (associated(node))
      source(node%source%source_number) = node%source
      node => node%prev_node
    end do
    return
  end subroutine get_source_array

end module gd_common
