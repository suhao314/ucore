!-- thRUnc2.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_read_unc2

  !-- Module for reading unc2 format time history files.
  !-- Intended for calling from the th_read module.
  !-- We rely on th_read for much of the call validity testing.
  !-- 13 Aug 90, Richard Maine.

  use precision
  use sysdep_io
  use string
  use th_read_gen

  implicit none
  private

  !-- Identifying string for automatic format determination.
  character*(*), public, parameter :: unc2_format_string='unc2'

  !-- Public procedures.
  public open_th_read_unc2, close_th_read_unc2, seek_th_unc2, read_th_unc2

contains

  subroutine open_th_read_unc2 (gen, file_name, n_signals, error)

    !-- Open an unc2 file for reading.
    !-- 13 Aug 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Already allocated on entry.
    character*(*), intent(in) :: file_name
    integer, intent(out) :: n_signals       !-- Number of available signals.
    logical, intent(out) :: error

    !-------------------- local.
    character :: rec_label*8, where*8
    integer :: iostat

    !-------------------- executable code.

    !-- Open the file.
    !-- Note that we can't determine the max record length until after
    !-- reading the nChans record; thus we can't specify it in the open.
    !-- This could cause problems for files with records longer than the
    !-- system defaults, though I haven't actually seen such a problem.
    where = 'open'
    call assign_lun(gen%lun)
    open (gen%lun, file=file_name, form='unformatted', &
         status='old', action='read', position='rewind', iostat=iostat)
    if (iostat /= 0) goto 8000

    !-- Skip the format record data.
    where = 'format'
    read (gen%lun, iostat=iostat)
    if (iostat /= 0) goto 8000

    !-- Read nChans record and check its plausibility.
    where = 'nChans'
    read (gen%lun, iostat=iostat) rec_label, n_signals
    if (iostat /= 0) goto 8000
    if (.not. string_eq(rec_label,'nChans')) goto 8000

    !-- Allocate signal vector and default to all signals.
    where = 'allocate'
    call all_th_read_gen(gen, n_signals, error)
    if (error) goto 8000

    !-- Ignore the actual file title, due to complications of reading
    !-- a variable length string.
    where = 'title'
    read (gen%lun, iostat=iostat)
    if (iostat /= 0) goto 8000

    !-- Read signal names.
    where = 'names'
    read (gen%lun, iostat=iostat) rec_label, gen%signal_names(:)(1:4)
    if (iostat /= 0) goto 8000
    if (.not. string_eq(rec_label,'names')) goto 8000
    read (gen%lun, iostat=iostat) rec_label, gen%signal_names(:)(5:8)
    if (iostat /= 0) goto 8000
    read (gen%lun, iostat=iostat) rec_label, gen%signal_names(:)(9:12)
    if (iostat /= 0) goto 8000
    read (gen%lun, iostat=iostat) rec_label, gen%signal_names(:)(13:16)
    if (iostat /= 0) goto 8000
    if (.not. string_eq(rec_label,'names')) goto 8000

    !-- This format doesn't support dt and eu_names.

    !-- Normal exit.
    gen%previous_time = big_real
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_read_unc2 failed at: '//where)
    call close_th_read_unc2(gen)
    error = .true.
    return
  end subroutine open_th_read_unc2

  subroutine close_th_read_unc2 (gen)

    !-- Close an unc2 file for reading.
    !-- 26 Jun 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Do not deallocate here.

    !-------------------- executable code.

    close (gen%lun)
    call release_lun(gen%lun)
    return
  end subroutine close_th_read_unc2

  subroutine seek_th_unc2 (gen, start_time, error)

    !-- Seek to a time interval on an unc2 file.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen          !-- Generic file descriptor.
    real(r_kind), intent(in) :: start_time  !-- Requested interval start time.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat
    character :: rec_label*8

    !-------------------- executable code.

    !-- Rewind if seeking backwards.
    if (start_time <= gen%previous_time) then
      rewind (gen%lun)
      do
        read(gen%lun,iostat=iostat) rec_label
        if (iostat /= 0) goto 8000
        if (string_eq(rec_label,'data001')) exit
      end do
      gen%previous_time = -big_real
    end if

    !-- Normal exit.
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    gen%previous_time = big_real
    if (iostat > 0) then
      call write_sys_error(iostat)
      call write_error_msg('Error in seek_th_unc2.')
    end if
    error = .true.
    return
  end subroutine seek_th_unc2

  subroutine read_th_unc2 (gen, time, data, status)

    !-- Read a frame from an unc2 file.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen        !-- Generic file descriptor.
    real(r_kind), intent(out) :: time     !-- Returned frame time.
    real(r_kind), intent(out) :: data(:)  !-- Returned frame data.
    integer, intent(out) :: status        !-- See read_th for codes.

    !-------------------- local.
    integer :: iostat
    real(rs_kind) :: all_data(0:gen%n_signals)

    !-------------------- executable code.

    !-- Read a frame.
    read(gen%lun, iostat=iostat) time, all_data(1:gen%n_signals)
    if (iostat /= 0) goto 8000

    !-- Select signals.
    all_data(0) = 0.
    data = real(all_data(gen%channel_map), kind=r_kind)

    !-- Normal exit.
    gen%previous_time = time
    status = thr_ok
    return

    !---------- Error exit.
    8000 continue
    gen%previous_time = big_real
    if (iostat > 0) then
      call write_sys_error(iostat)
      call write_error_msg('Error in read_th_unc2.')
      status = thr_error
    else
      status = thr_eod
    end if
    return
  end subroutine read_th_unc2
end module th_read_unc2
