!-- thRGen.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_read_gen

  !-- Generic support module for input time history files.
  !-- This module has support data and routines generic to many of
  !-- the format-specific th_read_modules.
  !-- The format-specific modules must use this module to declare the
  !-- gen_type structure, which is passed to them.
  !-- They may may use the subroutines and data structures of this module,
  !-- they are not required to do so.
  !-- 4 Nov 91, Richard Maine.

  use precision
  use sysdep_io
  use string

  implicit none
  public

  integer, parameter :: max_signals = 2000
       !-- This is just for plausibility checks.
       !-- No dimensions are really limitted by it.

  !-- Status code return values.
  integer, parameter :: thr_ok = 0
  integer, parameter :: thr_eoi = 1
  integer, parameter :: thr_eod = 2
  integer, parameter :: thr_error = 3

  type gen_type
    integer :: version
         !-- An integer version code.
         !-- Not referenced in th_read_gen; just provides a place.
         !-- Use and interpretation are up to the format-specific modules.
    integer :: lun
         !-- Fortran logical unit number.
         !-- Not referenced in th_read_gen; just provides a place.
         !-- Use and interpretation are up to the format-specific modules.
    character :: file_title*80
         !-- The format-specific modules may define this to make it
         !-- available for inquiries.  It is initialized to blanks.
    real(r_kind) :: dt
         !-- Nominal file sample interval (before thinning).
         !-- The format-specific modules may define this to make it
         !-- available for inquiries.  It has no other use internal
         !-- to the th_read module.  It is initialized to 0., which
         !-- is interpreted by some codes as meaning unknown.
         !-- It is not checked against actual times on the file, so any
         !-- resemblance to reality depends on the format-specific modules.
    integer :: n_signals
         !-- Number of available signals.
    integer :: n_requested
         !-- Number of requested signals.
    character, pointer :: signal_names(:)*16
         !-- Names of all available signals on a file.
         !-- This is normally allocated and released by the
         !-- all_th_read_gen and free_th_read_gen routines.
    character*16, pointer :: eu_names(:)
         !-- Engineering units names of the signals on a file.
         !-- This is normally allocated and released by the
         !-- all_th_read_gen and free_th_read_gen routines.
    integer, pointer :: channel_map(:)
         !-- Map from the available signals to the requested signals.
         !-- Each element corresponds to a requested signal and gives
         !-- the index of that signal in the list of all available signals.
         !-- For requested signals that are unavailable, the index is 0.
         !-- This is normally initialized by all_th_read_gen, modified
         !-- by request_th_read_gen, and released by free_th_read_gen.
         !-- It is up to the format-specific routines to use the map.
    real(r_kind) :: previous_time
         !-- Time of the previous frame.
         !-- Not referenced in th_read_gen; just provides a place.
         !-- Use and interpretation are up to the format-specific modules.
    integer, pointer :: format_specific_data(:)
         !-- This provides a place for format specific data.
         !-- If the data is not a simple array of integers, the transfer
         !-- intrinsic must be used to recast the type for storage here.
         !-- This will often be used for a pointer to a format-specific
         !-- data structure.  Allocation of this vector as needed must
         !-- be done by the format-specific routines. The free_th_read_gen
         !-- routine will release this vector, but cannot release any
         !-- indirectly referenced storage based on recasting it.
  end type
  type gen_ptr_type
    type(gen_type), pointer :: gen
  end type

contains

  subroutine allocate_th_read_gen (gen, error)

    !-- Allocate a th_read_gen descriptor.
    !-- This routine is called from th_read module before the format-specific
    !-- open routine.  The format-specific routines should not call this.
    !-- 4 Nov 91, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen   !-- Intent(out).
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat

    !-------------------- executable code.

    nullify(gen)
    allocate(gen, stat=iostat)
    error = (iostat /= 0)
    if (error) return
    nullify(gen%signal_names, gen%eu_names, gen%channel_map)
    nullify(gen%format_specific_data)

    gen%file_title = ''
    gen%dt = 0.
    return
  end subroutine allocate_th_read_gen

  subroutine all_th_read_gen (gen, n_signals, error)

    !-- Allocates the signal list and initializes the channel map
    !-- for a th_read_gen file.
    !-- The format-specific routines may call this or not as desired.
    !-- 4 Nov 91, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen  !-- From allocate_th_read_gen.
    integer, intent(in) :: n_signals
    logical, intent(out) :: error

    !-------------------- local.
    integer iostat, i

    !-------------------- executable code.

    error = .true.

    !-- Plausibility check.
    if (n_signals < 0 .or. n_signals > max_signals) return

    !-- Allocate vectors.
    gen%n_signals = n_signals
    allocate(gen%signal_names(n_signals), gen%eu_names(n_signals), &
         gen%channel_map(n_signals), stat=iostat)
    if (iostat /= 0) return

    !-- Initialize channel map default to return all signals.
    gen%signal_names = ''
    gen%eu_names = ''
    gen%n_requested = n_signals
    gen%channel_map = (/ (i, i = 1 , n_signals) /)

    !-- Normal exit.
    error = .false.
    return
  end subroutine all_th_read_gen

  subroutine free_th_read_gen (gen)

    !-- Release space used for a file by the th_read_gen module.
    !-- This is called from the th_read module after the format-specific
    !-- close routine.  The format-specific routines should not call this.
    !-- 4 Nov 91, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Descriptor allocated by allocate_th_read_gen.
         !-- Null on return.  Intent(inout).

    !-------------------- executable code.

    if (.not. associated(gen)) return

    if (associated(gen%signal_names)) deallocate(gen%signal_names)
    if (associated(gen%eu_names)) deallocate(gen%eu_names)
    if (associated(gen%channel_map)) deallocate(gen%channel_map)
    if (associated(gen%format_specific_data)) &
         deallocate(gen%format_specific_data)
    deallocate(gen)
    return
  end subroutine free_th_read_gen

  subroutine inquire_th_gen (gen, signal_names, eu_names)

    !-- Return signal names available on a generic th_read file.
    !-- The format-specific routines may use this or have their own
    !-- customized equivalent; if they use a customized version,
    !-- the th_read module must be modified to call it.
    !-- 4 Oct 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen  !-- From allocate_th_read_gen.
    character*(*), intent(out), optional :: signal_names(:)
         !-- Names of the signals known to be available.
         !-- Size is not checked.
    character*(*), optional, intent(out) :: eu_names(:)
         !-- Engineering units names for the currently requested signals.
         !-- Note that this corresponds to signal_names only if all
         !-- the signals are currently requested.  Blank if unknown.
         !-- Size is not checked.

    !-------------------- executable code.

    if (present(signal_names)) signal_names(:gen%n_signals) = gen%signal_names
    if (present(eu_names)) &
          eu_names(:gen%n_requested) = gen%eu_names(gen%channel_map)
    return
  end subroutine inquire_th_gen

  subroutine request_th_gen (gen, requested_signals, found)

    !-- Specify signals to be read from a generic th_read file.
    !-- Aborts on errors.
    !-- Failure to find requested signals is not considered an error.
    !-- The format-specific routines may use this or have their own
    !-- customized equivalent; if they use a customized version,
    !-- the th_read module must be modified to call it.
    !-- This version uses a simple string_index call, which is fine
    !-- for small numbers of signals, but has speed quadratic in the
    !-- number of signals.  If performance becomes a problem, we
    !-- could use a binary tree implementation.
    !-- Time to request all signals from a list of 1000 is about 4.5 sec
    !-- on a Sun 690; this doesn't seem like a problem.
    !-- 4 Oct 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen  !-- From allocate_th_read_gen.
    character*(*), intent(in) :: requested_signals(:)
    logical, intent(out) :: found(:)
         !-- Indicates which requested signals were found.
         !-- Must be the same size as requested_signals.  (Not checked).

    !-------------------- local.
    integer :: chan
    logical :: error
    integer, pointer :: new_map(:)

    !-------------------- executable code.

    gen%n_requested = size(requested_signals)
    error = gen%n_requested < 0 .or. gen%n_requested > max_signals
    if (error) call error_halt('Too many signals requested in request_th')

    allocate(new_map(gen%n_requested))
    deallocate(gen%channel_map)
    gen%channel_map => new_map
    do chan = 1 , gen%n_requested
      gen%channel_map(chan) = string_index(string=requested_signals(chan), &
           list=gen%signal_names)
    end do
    found = gen%channel_map /= 0
    return
  end subroutine request_th_gen

end module th_read_gen
