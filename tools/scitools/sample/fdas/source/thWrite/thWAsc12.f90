!-- thWAsc12.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_write_asc12

  !-- Module for writing asc1 and asc2 format time history files.
  !-- Intended for calling from the th_write module.
  !-- We rely on th_write for much of the call validity testing.
  !-- 13 Aug 90, Richard Maine.

  use precision
  use sysdep_io

  implicit none
  private

  !-- Identifying strings for format specification.
  character*(*), public, parameter :: asc1_format_string='asc1'
  character*(*), public, parameter :: asc2_format_string='asc2'

  !-- Generic array locations.
  integer, parameter, private :: gen_lun = 1
  integer, parameter, private :: gen_format = 2

  !-- Public procedures.
  public open_th_write_asc12, close_th_write_asc12, write_th_asc12

contains

  subroutine open_th_write_asc12 (format_num, gen, file_name, &
       signal_names, eu_names, dt, file_title, error)

    !-- Open an asc1 or asc2 file for writing.
    !-- 13 Aug 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: format_num         !-- 1 or 2 for asc1 or asc2
    integer, pointer  :: gen(:)
         !-- Generic array for format-specific data.  Null on entry.
    character*(*), intent(in) :: file_name
    character*(*), intent(in) :: signal_names(:)
    character*(*), intent(in), optional :: eu_names(:)
    real(r_kind), intent(in), optional :: dt  !-- 0 or omitted means unknown.
    character*(*), intent(in), optional :: file_title  !-- Default is none.
    logical, intent(out) :: error             !-- Returns true if open fails.

    !-------------------- local.
    character :: where*8, padded_title*72
    character :: padded_names(size(signal_names))*16
    integer :: iostat, lun

    8001 format(a8,8x,4a16:/(5a16))        !-- names format for asc1
    8002 format(a8,5x,5a13,2x:/(6a13,2x))  !-- names format for asc2

    !-------------------- executable code.

    !-- Allocate generic data array.
    where = 'allocate'
    allocate(gen(2), stat=iostat)  !-- This format uses 2 elements of gen.
    if (iostat /= 0) goto 8000

    !-- Open the file.
    where = 'open'
    call assign_lun(lun)
    gen(gen_format) = format_num
    gen(gen_lun) = lun
    open(lun, file=file_name, form='formatted', iostat=iostat, &
         status='replace', action='write')
    if (iostat /= 0) goto 8000

    !-- Write header data.
    !-- Format header.
    where = 'headers'
    write(lun, '(a8,a4,i1,3x,a8)', iostat=iostat) &
         'format  ', 'asc ', format_num, '.1      '
    if (iostat /= 0) goto 8000

    !-- Write a title record only if the title is non-blank.
    !-- This allows compatability with old codes that can't read it.
    if (present(file_title)) then
      if (file_title /= '') then
        padded_title = file_title
        write(lun, '(a8,a72)', iostat=iostat) 'title   ', padded_title
        if (iostat /= 0) goto 8000
      end if
    end if

    !-- nChans and names headers.
    write(lun, '(a8,i8)', iostat=iostat) 'nChans  ', size(signal_names)
    if (iostat /= 0) goto 8000
    padded_names = signal_names
    if (format_num == 1) then
      write(lun, 8001, iostat=iostat) 'names   ', padded_names
    else
      write(lun, 8002, iostat=iostat) 'names   ', padded_names
    end if
    if (iostat /= 0) goto 8000

    !-- Optional units header.
    if (present(eu_names)) then
      padded_names = eu_names
      write(lun, '(a8,8x,4a16:/(16x,4a16))', iostat=iostat) &
           'units   ', padded_names
      if (iostat /= 0) goto 8000
    end if

    !-- dt header if dt is present and non-zero.
    if (present(dt)) then
      if (dt > 0.) then
        write(lun, '(a8,g12.6)', iostat=iostat) 'dt      ', dt
        if (iostat /= 0) goto 8000
      end if
    end if

    write(lun, '(a8)', iostat=iostat) 'data001 '
    if (iostat /= 0) goto 8000
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_write_asc12 failed at: '//where)
    if (associated(gen)) call close_th_write_asc12(gen, error)
    error = .true.
    return
  end subroutine open_th_write_asc12

  subroutine close_th_write_asc12 (gen, error)

    !-- Close an output asc1 or asc2 file.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    logical, intent(out) :: error

    !-------------------- executable code.

    error = .false.
    close(gen(gen_lun))
    call release_lun(gen(gen_lun))
    return
  end subroutine close_th_write_asc12

  subroutine write_th_asc12 (gen, time, data, error)

    !-- Write a frame to an asc1 or asc2 file.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    real(r_kind), intent(in) :: time     !-- Frame time.
    real(r_kind), intent(in) :: data(:)  !-- Frame data.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat

    8001 format(f10.3,10x,3g20.14:/(4g20.14))     !-- asc1
    8002 format(f10.3,3x,5g13.7,2x:/(6g13.7,2x))  !-- asc2

    !-------------------- executable code.

    if (gen(gen_format) == 1) then
      write(gen(gen_lun), 8001, iostat=iostat) time, data
    else
      write(gen(gen_lun), 8002, iostat=iostat) time, data
    end if
    if (iostat /= 0) call write_sys_error(iostat)
    error = iostat /= 0
    return
  end subroutine write_th_asc12

end module th_write_asc12
