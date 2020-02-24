!-- thRAsc12.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_read_asc12

  !-- Module for reading asc1 and acs2 format time history files.
  !-- Intended for calling from the th_read module.
  !-- We rely on th_read for much of the call validity testing.
  !-- 13 Aug 90, Richard Maine.

  use precision
  use sysdep_io
  use string
  use th_read_gen

  implicit none
  private

  !-- Identifying strings for automatic format determination.
  character*(*), public, parameter :: asc1_format_string='asc1'
  character*(*), public, parameter :: asc2_format_string='asc2'

  !-- Public procedures.
  public open_th_read_asc12, close_th_read_asc12, seek_th_asc12, read_th_asc12

contains

  subroutine open_th_read_asc12 (gen, file_name, n_signals, error)

    !-- Open an asc1 or asc2 file for reading.
    !-- 13 Aug 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Already allocated on entry.
    character*(*), intent(in) :: file_name
    integer, intent(out) :: n_signals       !-- Number of available signals.
    logical, intent(out) :: error

    !-------------------- local.
    character :: rec_label*8, where*8, body*72, format*8
    integer :: iostat

    8001 format(a8,8x,4a16:/(5a16))  !-- names format for asc1
    8002 format(a8,5x,5a13:/(6a13))  !-- names format for asc2

    !-------------------- executable code.

    !-- Open the file.
    where = 'open'
    call assign_lun(gen%lun)
    open (gen%lun, file=file_name, form='formatted', iostat=iostat, &
         status='old', action='read', position='rewind')
    if (iostat /= 0) goto 8000

    !-- Read the format record.
    where = 'format'
    read (gen%lun, '(2a8)', iostat=iostat) rec_label, format
    if (iostat /= 0) goto 8000
    if (.not. string_eq(rec_label,'format')) goto 8000
    if (.not. string_eq(format(1:4),'asc ')) goto 8000
    call string_to_int(format(5:5), gen%version, min_val=1, max_val=2, &
         error=error)
    if (error) goto 8000

    !-- Optional title records.
    where = 'title'
    do
      read(gen%lun, '(a8,a72)', iostat=iostat) rec_label, body
      if (iostat /= 0) goto 8000
      if (.not. string_eq(rec_label,'title')) exit
      if (gen%file_title == '') gen%file_title = body
    end do

    !-- Read nChans record and check its plausibility.
    where = 'nChans'
    if (.not. string_eq(rec_label,'nChans')) goto 8000
    call string_to_int(body(:8), n_signals, min_val=0, max_val=max_signals, &
         name='nChans', error=error)
    if (error) goto 8000

    !-- Allocate signal vector and default to all signals.
    where = 'allocate'
    call all_th_read_gen(gen, n_signals, error)
    if (error) goto 8000

    !-- Read signal names.
    where = 'names'
    if (gen%version == 2) then
      read (gen%lun, 8002, iostat=iostat) rec_label, gen%signal_names
    else
      read (gen%lun, 8001, iostat=iostat) rec_label, gen%signal_names
    end if
    if (iostat /= 0) goto 8000
    if (.not. string_eq(rec_label,'names')) goto 8000

    !-- Read optional headers.
    where = 'endHead'
    end_head: do
      read (gen%lun, '(a8,a72)', iostat=iostat) rec_label, body
      if (iostat /= 0) goto 8000
      if (string_eq(rec_label,'data001')) exit end_head
      if (string_eq(rec_label,'dt')) then
        call string_to_real(body(:12), gen%dt, min_val=r_zero, name='dt', &
             error=error)
        if (error) goto 8000
      else if (string_eq(rec_label,'units')) then
        read (body, '(8x,4a16)') gen%eu_names(1:min(n_signals,4))
        if (n_signals > 4) then
          read (gen%lun, '(16x,4a16)', iostat=iostat) gen%eu_names(5:)
          if (iostat /= 0) goto 8000
        end if
      end if
    end do end_head

    !-- Normal exit.
    gen%previous_time = -big_real
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_read_asc12 failed at: '//where)
    call close_th_read_asc12(gen)
    error = .true.
    return
  end subroutine open_th_read_asc12

  subroutine close_th_read_asc12 (gen)

    !-- Close an asc1 or asc2 input file.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Do not deallocate here.

    !-------------------- executable code.

    close (gen%lun)
    call release_lun(gen%lun)
    return
  end subroutine close_th_read_asc12

  subroutine seek_th_asc12 (gen, start_time, error)

    !-- Seek to a time interval on an asc1 or asc2 file.
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
        read (gen%lun, '(a8)', iostat=iostat) rec_label
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
    if (iostat /= 0) then
      call write_sys_error(iostat)
      call write_error_msg('Error in seek_th_asc12.')
    end if
    gen%previous_time = big_real
    error = .true.
    return
  end subroutine seek_th_asc12

  subroutine read_th_asc12 (gen, time, data, status)

    !-- Read a frame from an asc1 or asc2 file.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen        !-- Generic file descriptor.
    real(r_kind), intent(out) :: time     !-- Returned frame time.
    real(r_kind), intent(out) :: data(:)  !-- Returned frame data.
    integer, intent(out) :: status        !-- See read_th for codes.

    !-------------------- local.
    integer :: iostat
    real(r_kind) :: all_data(0:gen%n_signals)

    8001 format(f10.3,10x,3g20.14:/(4g20.14))     !-- asc1
    8002 format(f10.3,3x,5g13.7:/(6g13.7))  !-- asc2

    !-------------------- executable code.

    !-- Read a frame.
    if (gen%version == 1) then
      read(gen%lun, 8001, iostat=iostat) time, all_data(1:)
    else
      read(gen%lun, 8002, iostat=iostat) time, all_data(1:)
    end if
    if (iostat /= 0) goto 8000

    !-- Select signals.
    all_data(0) = 0.
    data = all_data(gen%channel_map)

    !-- Normal exit.
    gen%previous_time = time
    status = thr_ok
    return

    !---------- Error exit.
    8000 continue
    gen%previous_time = big_real
    if (iostat > 0) then
      call write_sys_error(iostat)
      call write_error_msg('Error in read_th_asc12.')
      status = thr_error
    else
      status = thr_eod
    end if
    return
  end subroutine read_th_asc12
end module th_read_asc12
