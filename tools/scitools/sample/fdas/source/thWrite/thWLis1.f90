!-- thWLis1.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_write_lis1

  !-- Module for writing lis1 format time history files.
  !-- Intended for calling from the th_write module.
  !-- We rely on th_write for much of the call validity testing.
  !-- We special case the file name $stdout.
  !-- 13 Aug 90, Richard Maine.

  use precision
  use standard_files
  use sysdep_io
  use string
  use time

  implicit none
  private

  !-- Identifying string for format specification.
  character*(*), public, parameter :: lis1_format_string='lis1'

  !-- Generic array locations.
  integer, parameter, private :: gen_lun = 1
  integer, parameter, private :: gen_is_stdout = 2

  !-- Public procedures.
  public open_th_write_lis1, close_th_write_lis1, write_th_lis1

contains

  subroutine open_th_write_lis1 (gen, file_name, &
       signal_names, eu_names, dt, file_title, error)

    !-- Open a lis1 file for writing.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)
         !-- Generic array for format-specific data.  Null on entry.
    character*(*), intent(in) :: file_name
    character*(*), intent(in) :: signal_names(:)
    character*(*), intent(in), optional :: eu_names(:)
    real(r_kind), intent(in), optional :: dt  !-- Unused here.
    character*(*), intent(in), optional :: file_title  !-- Default is none.
    logical, intent(out) :: error             !-- Returns true if open fails.

    !-------------------- local.
    character :: where*8, padded_title*80
    integer :: iostat

    !-------------------- executable code.

    !-- Allocate generic data array.
    where = 'allocate'
    allocate(gen(2), stat=iostat)  !-- This format uses 2 elements of gen.
    if (iostat /= 0) goto 8000

    !-- Open the file, special casing the name '$stdout'
    !-- Leave position asis for this format as we might be writing to a device.
    where = 'open'
    if (string_eq(file_name,'$stdout')) then
      gen(gen_is_stdout) = 1
      gen(gen_lun) = std_out
    else
      gen(gen_is_stdout) = 0
      call assign_lun(gen(gen_lun))
      open(gen(gen_lun), file=file_name, form='formatted', iostat=iostat, &
         status='replace', action='write')
      if (iostat /= 0) goto 8000
    end if

    !-- Write header data.
    where = 'headers'
    if (present(file_title)) then
      padded_title = file_title
      write(gen(gen_lun), '(1x,a77)', iostat=iostat) padded_title
      if (iostat /= 0) goto 8000
    end if
    write(gen(gen_lun), '((13x,5(1x,a11:)))') signal_names

    !-- Ignore dt and units for this format.

    !---------- Normal exit.
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_write_lis1 failed at: '//where)
    if (associated(gen)) call close_th_write_lis1(gen, error)
    error = .true.
    return
  end subroutine open_th_write_lis1

  subroutine close_th_write_lis1 (gen, error)

    !-- Close an output lis1 file.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    logical, intent(out) :: error

    !-------------------- executable code.

    error = .false.
    if (gen(gen_is_stdout) == 0) then
      close(gen(gen_lun))
      call release_lun(gen(gen_lun))
    end if
    return
  end subroutine close_th_write_lis1

  subroutine write_th_lis1 (gen, time, data, error)

    !-- Write a frame to a lis1 file.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    real(r_kind), intent(in) :: time     !-- Frame time.
    real(r_kind), intent(in) :: data(:)  !-- Frame data.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat
    8001 format(1x,a12,5(1x,g11.5:)/(13x,5(1x,g11.5:)))

    !-------------------- executable code.

    write(gen(gen_lun), 8001, iostat=iostat) time_string(time), data
    if (iostat /= 0) call write_sys_error(iostat)
    error = iostat /= 0
    return
  end subroutine write_th_lis1

end module th_write_lis1
