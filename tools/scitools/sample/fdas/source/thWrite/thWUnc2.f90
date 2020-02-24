!-- thWUnc2.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_write_unc2

  !-- Module for writing unc2 format time history files.
  !-- Intended for calling from the th_write module.
  !-- We rely on th_write for much of the call validity testing.
  !-- 13 Aug 90, Richard Maine.

  use precision
  use sysdep_io

  implicit none
  private

  !-- Identifying string for format specification.
  character*(*), public, parameter :: unc2_format_string='unc2'

  !-- Generic array locations.
  integer, parameter, private :: gen_lun = 1

  !-- Public procedures.
  public open_th_write_unc2, close_th_write_unc2, write_th_unc2

contains

  subroutine open_th_write_unc2 (gen, file_name, &
       signal_names, eu_names, dt, file_title, error)

    !-- Open an unc2 file for writing.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)
         !-- Generic array for format-specific data.  Null on entry.
    character*(*), intent(in) :: file_name
    character*(*), intent(in) :: signal_names(:)
    character, intent(in), optional :: eu_names(:)
    real(r_kind), intent(in), optional :: dt
    character*(*), intent(in), optional :: file_title  !-- Default is none.
    logical, intent(out) :: error           !-- Returns true if open fails.

    !-------------------- local.
    integer :: iostat, lun
    character :: where*8
    character :: padded_names(size(signal_names))*16

    !-------------------- executable code.

    !-- Allocate generic data array.
    where = 'allocate'
    allocate(gen(1), stat=iostat)  !-- This format uses 1 element of gen.
    if (iostat /= 0) goto 8000

    !-- Open the file.
    !-- Files with large nChans might exceed default system record length
    !-- limits, necessitating an explicit recl in the open.
    !-- For now, we don't bother.
    where = 'open'
    call assign_lun(lun)
    gen(gen_lun) = lun
    open(lun, file=file_name, form='unformatted', iostat=iostat, &
         status='replace', action='write')
    if (iostat /= 0) goto 8000

    !-- Write header data.
    where = 'headers'
    write(lun, iostat=iostat) 'format  ', 'unc 2   ', '.1      '
    if (iostat /= 0) goto 8000

    write(lun, iostat=iostat) 'nChans  ', size(signal_names)
    if (iostat /= 0) goto 8000

    !-- The actual title is ignored due to possible complications in
    !-- reading it with an unknown length.
    write(lun, iostat=iostat) 'title   ', 'file title'  !-- dummy
    if (iostat /= 0) goto 8000

    padded_names = signal_names
    write(lun, iostat=iostat) 'names   ', padded_names(:)(1:4)
    if (iostat /= 0) goto 8000
    write(lun, iostat=iostat) 'names   ', padded_names(:)(5:8)
    if (iostat /= 0) goto 8000
    write(lun, iostat=iostat) 'names   ', padded_names(:)(9:12)
    if (iostat /= 0) goto 8000
    write(lun, iostat=iostat) 'names   ', padded_names(:)(13:16)
    if (iostat /= 0) goto 8000

    !-- This format doesn't support dt or units.

    write(lun, iostat=iostat) 'times001', r_zero, r_zero, 0
    if (iostat /= 0) goto 8000

    write(lun, iostat=iostat) 'data001 ','interval 1'
    if (iostat /= 0) goto 8000

    !---------- Normal exit.
    error = .false.

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_write_unc2 failed at: '//where)
    if (associated(gen)) call close_th_write_unc2(gen, error)
    error = .true.
    return
  end subroutine open_th_write_unc2

  subroutine close_th_write_unc2 (gen, error)

    !-- Close an output unc2 file.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    logical, intent(out) :: error

    !-------------------- executable code.

    error = .false.
    close(gen(gen_lun))
    call release_lun(gen(gen_lun))
    return
  end subroutine close_th_write_unc2

  subroutine write_th_unc2 (gen, time, data, error)

    !-- Write a frame to an unc2 file.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    real(r_kind), intent(in) :: time     !-- Frame time.
    real(r_kind), intent(in) :: data(:)  !-- Frame data.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat

    !-------------------- executable code.

    write(gen(gen_lun), iostat=iostat) time, real(data, kind=rs_kind)
    error = iostat /= 0
    if (error) then
      call write_sys_error(iostat)
      call write_error_msg('Error writing unc2 file.')
    end if
    return
  end subroutine write_th_unc2

end module th_write_unc2
