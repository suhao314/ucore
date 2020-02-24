!-- sysdepIo.f90
!-- System-dependent. Generic version.
!-- 9 Dec 92, Richard Maine: Version 1.0.

module standard_files

  !-- Unit numbers for standard files.
  !-- System-dependent. Generic version.
  !-- 13 Aug 90, Richard Maine.

  implicit none
  private

  !-- The initial values are intended to be for units pre-connected
  !-- to the system standard files.  These values are system dependent.
  !-- If no unit numbers are so pre-connected, we would need an
  !-- initialization routine to do the required opens.

  !-- Term_in and term_out should ideally be connected to the user terminal
  !-- for interactive jobs.  They should not be subject to redirection.
  !-- For jobs not associated with a terminal, they should be connected
  !-- to the batch input and output files.
  integer, public, parameter :: term_in=5, term_out=6

  !-- Std_in and std_out are variables, thus allowing the values to be
  !-- changed during a job.  This could be used, for instance, to
  !-- temporarily take input from or send output to alternative files.
  integer, save, public :: std_in = term_in    !-- standard input
  integer, save, public :: std_out = term_out  !-- standard output

  !-- Std_err is for error messages.  It may be altered during a job.
  integer, save, public :: std_err = term_out  !-- standard error

end module standard_files

module sysdep_io

  !-- General system-dependent support routines.
  !-- System-dependent. Generic version.
  !-- 9 Dec 92 92, Richard Maine.

  use precision
  use standard_files

  implicit none
  private

  external write_error_sub

  !-- Max length of a file name.
  integer, parameter, public :: file_name_len = 128

  !-- The list of legal logical unit numbers is system-dependent.
  !-- We avoid low-numbered luns to minimize likely system conflicts.
  integer, parameter :: min_lun=10, max_lun=99
  logical, save :: lun_is_free(min_lun:max_lun) = .true.

  !-- Public procedures.
  public system_init, system_stop, system_sleep, system_shell
  public error_halt, write_error_msg, write_sys_error
  public assign_lun, release_lun, reserve_lun
  public system_user_info, system_file_info

contains

  subroutine system_init

    !-- Do any special system initialization required.
    !-- For instance, may need to open standard files.
    !-- This version does nothing, assuming that the files are pre-connected.
    !-- This should be called very early in program initialization,
    !-- before anything that might produce error messages.
    !-- 13 Jun 90, Richard Maine.

    !-------------------- executable code.

    return
  end subroutine system_init

  subroutine system_stop

    !-- Do any special system shutdown required for clean termination.
    !-- Generic version just does a stop.

    !-------------------- executable code.

    stop
  end subroutine system_stop

  subroutine system_sleep (time)

    !-- Sleep (wait) for a specified time.
    !-- Time may be approximate, or may terminate early.
    !-- Check with system_clock if you care much.
    !-- Generic version just returns.
    !-- This subroutine isn't yet (20 Nov 92) documented because
    !-- I'm not sure I'll keep it.  Nothing currently uses it.
    !-- It was used for an abandoned experiment and I decided to
    !-- keep the code around for now rather than discard it.
    !-- 20 Nov 92, Richard Maine.

    !-------------------- interface.
    real(r_kind), intent(in) :: time  !-- Time to sleep (seconds).

    !-------------------- executable.

    return
  end subroutine system_sleep

  subroutine system_shell (command, error)

    !-- Execute a system shell command.
    !-- Generic version just writes an error message.
    !-- 21 Jul 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: command  !-- Shell command to execute.
    logical, intent(out), optional :: error
         !-- True if an error occurs.
         !-- Ignore errors if this is omitted.

    !-------------------- executable.

    call write_error_msg('system_shell not implemented.')
    if (present(error)) error = .true.
    return
  end subroutine system_shell

  subroutine error_halt (message)

    !-- Halt in an error state.
    !-- System-dependent. Generic version.
    !-- 13 Jun 90, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in), optional :: message  !-- Error message.

    !-------------------- executable code.

    if (present(message)) call write_error_msg('Error: ' // message)

    !-- Any system-dependent call traceback or other diagnostics go here.
    !-- For the generic version, just announce the error halt.
    call write_error_msg('Error halt.')

    !-- Return an error status to the system if possible.
    !-- For the generic version, we use a stop-code of 1.
    !-- This may or may not be interpreted as an error status by the system.
    stop 1
  end subroutine error_halt

  subroutine write_error_msg (message)

    !-- Write an error message.
    !-- This implementation calls a separate external routine
    !-- to facilitate overrides.
    !-- 1 May 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: message  !-- Error message.

    !-------------------- executable code.

    if (message == '') return
    call write_error_sub(trim(message))
    return
  end subroutine write_error_msg

  subroutine write_sys_error (error_num)

    !-- Write a system error message.
    !-- System-dependent.
    !-- Generic version just writes error number.
    !-- Some systems may be able to get error message text based
    !-- on the error number.  On other systems, however, the error
    !-- text may be readily available only for the most recent
    !-- system call.  To accomodate both cases, there should be
    !-- no i/o or other system calls executed between the statement
    !-- that caused the error and the call to this routine.
    !-- Specifically, if the program wants to print out both the
    !-- system error text plus some other error diagnostic data,
    !-- the system error text should be printed first.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: error_num
         !-- System error number, usually from an iostat specifier.
         !-- Zero if no error number is available.

    !-------------------- local.
    character :: num_str*12

    !-------------------- executable code.

    !-- can't use int_string here.
    write (num_str, '(i12)') error_num
    call write_error_msg('System error number ' // num_str)
    return
  end subroutine write_sys_error

  subroutine assign_lun (lun)

    !-- Assign an available Fortran logical unit number.
    !-- Aborts if no lun can be assigned; there are no error returns.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(out) :: lun  !-- Logical unit number.

    !-------------------- local.
    integer :: iostat
    logical :: used

    !-------------------- executable code.

    do lun = min_lun , max_lun
      if (lun_is_free(lun)) then
        inquire(unit=lun, opened=used, iostat=iostat)
        if (iostat /= 0) used = .true.
        lun_is_free(lun) = .false.
        if (.not.used) return
      end if
    end do
    call error_halt('No luns available in assign_lun')
    return
  end subroutine assign_lun

  subroutine reserve_lun (lun)

    !-- Reserve a specific Fortran logical unit number.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: lun
         !-- Logical unit number.  Illegal values are quietly ignored.

    !-------------------- executable code.

    if (lun>=min_lun .and. lun<=max_lun) lun_is_free(lun) = .false.
    return
  end subroutine reserve_lun

  subroutine release_lun (lun)

    !-- Release a Fortran logical unit number for reuse.
    !-- No checking is done to see that the lun is actually closed;
    !-- assign_lun will check that before re-assigning it.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: lun
         !-- Logical unit number.  Illegal values are quietly ignored.

    !-------------------- executable code.

    if (lun>=min_lun .and. lun<=max_lun) lun_is_free(lun) = .true.
  end subroutine release_lun

  subroutine system_user_info (user_id, user_name)

    !-- Get system information identifying the user.
    !-- This version returns blanks.
    !-- 4 Nov 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(out), optional :: user_id
      !-- System user identifier.
    character*(*), intent(out), optional :: user_name
      !-- User's actual name.

    !-------------------- executable code.

    if (present(user_id)) user_id = ''
    if (present(user_name)) user_name = ''
    return
  end subroutine system_user_info

  subroutine system_file_info (file_name, file_size)

    !-- Get system information about a file.
    !-- This version returns 0.
    !-- 9 Dec 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: file_name
      !-- Path name of the file.
    integer, intent(out), optional :: file_size
      !-- Size of the file in bytes.
      !-- 0 if unknown or if the file does not exist.

    !-------------------- executable code.

    if (present(file_size)) file_size = 0
    return
  end subroutine system_file_info

end module sysdep_io
