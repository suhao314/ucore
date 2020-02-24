!-- time.f90
!-- 1 Dec 92, Richard Maine: Version 1.0.

module time

  !-- Routines for time conversion.
  !-- 1 Dec 92, Richard Maine.

  use precision
  use sysdep_io
  use string

  implicit none
  private

  character*3, parameter, public :: month_abbrevs(1:12) = &
       (/ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', &
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' /)

  !-- Public procedures.
  public time_to_hmsms, time_string, get_system_time, parse_times
  public parse_date

contains

  subroutine time_to_hmsms (time, hmsms)

    !-- Convert time to hours,minutes,seconds,milliseconds format
    !-- 22 Jun 90, Richard Maine.

    !-------------------- interface.
    real(r_kind), intent(in) :: time
    integer, intent(out) :: hmsms(4)

    !-------------------- local.
    integer :: i_time

    !-------------------- executable code.

    i_time = time + .0004_r_kind
    hmsms(1) = i_time/3600
    hmsms(2) = mod(i_time/60, 60)
    hmsms(3) = mod(i_time, 60)
    hmsms(4) = min(999,nint(1000.*(time-i_time)))
    return
  end subroutine time_to_hmsms

  function time_string (time)

    !-- Convert time to a string format for printing.
    !-- 22 Jun 90, Richard Maine.

    !-------------------- interface.
    real(r_kind), intent(in) :: time
    character :: time_string*12

    !-------------------- local.
    integer :: hmsms(4), i, j, divide, i_digit
    character, parameter :: digits(0:9) = &
         (/ '0','1','2','3','4','5','6','7','8','9'/)
    character :: hmsms_strings(4)*3

    !-------------------- executable code.

    call time_to_hmsms(time, hmsms)

    !-- The rest of this subroutine is a long-winded equivalent of the
    !-- following commented-out internal write.  The long way is
    !-- used so that this function can be referenced in an output
    !-- iolist without violating the ansi restriction on the use of
    !-- io statements in such functions.
    !--     write (time_string,'(2(i2.2,1h.),i2.2,1h.,i3.3)') hmsms

    do i = 1 , 4
      divide = 1000
      do j = 1 , 3
        i_digit = abs(mod(hmsms(i),divide))
        divide = divide/10
        hmsms_strings(i)(j:j) = digits(i_digit/divide)
      end do
    end do
    if (hmsms(1) > 99 .or. hmsms(1) < 0) hmsms_strings(1)='***'
    time_string = hmsms_strings(1)(2:3) // '.' // hmsms_strings(2)(2:3) &
         // '.' // hmsms_strings(3)(2:3) // '.' // hmsms_strings(4)
    return
  end function time_string

  subroutine get_system_time (date, time)

    !-- Get system date and time in "nice" formats.
    !-- Just reformats the output from the standard date_and_time intrinsic.
    !-- 18 Mar 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(out), optional :: date
         !-- Returns date in the form dd-mmm-yyyy as in 18-Mar-1992.
         !-- Should be at least 11 chars long to hold full string.
    character*(*), intent(out), optional :: time
         !-- Returns time in the form hh:mm:ss
         !-- Should be at least 8 chars long to hold full string.

    !-------------------- local.
    character :: sys_date*8, sys_time*10, month*3
    integer :: values(8)

    !-------------------- executable code.

    call date_and_time(sys_date, sys_time, values=values)

    if (present(date)) then
      month = '   '
      if (values(2) > 0) month = month_abbrevs(values(2))
      date = sys_date(7:8) // '-' // month // '-' // sys_date(1:4)
    end if

    if (present(time)) then
      time = sys_time(1:2) // ':' // sys_time(3:4) // ':' // sys_time(5:6)
    end if
    return
  end subroutine get_system_time

  subroutine parse_times (string, start_time, stop_time, position, error)

    !-- Parse start and end times from a string.
    !-- 20 Apr 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string  !-- String to be parsed.
    real(r_kind), intent(out) :: start_time  !-- Start time in seconds.
    real(r_kind), intent(out) :: stop_time  !-- Stop time in seconds.
    integer, intent(inout) :: position
         !-- On entry, the starting position for parse.
         !-- On exit, the starting position of the next field or
         !-- len(string)+1 if there is no following field.
    logical, intent(out) :: error  !-- True if an error occurs.

    !-------------------- local.
    integer :: i, start_pos, values(8)
    logical :: found, sub_error
    character :: field*10

    !-------------------- executable code.

    error = .true.

    !-- Parse 8 fields from source string.

    start_pos = position
    do i = 1 , 8
      call find_field(string, field, position, ' -:.,', found=found)
      if (.not. found) then
        call write_error_msg &
             ('Too few fields for times: ' // string(start_pos:))
        return
      end if
      call string_to_int(field, values(i), 0, 1000, 'time field', sub_error)
      if (sub_error) return
    end do

    start_time = values(1)*3600._r_kind + values(2)*60._r_kind + values(3) + &
         values(4)*.001_r_kind
    stop_time =  values(5)*3600._r_kind + values(6)*60._r_kind + values(7) + &
         values(8)*.001_r_kind
    if (stop_time < start_time) then
      call write_error_msg('Stop time ' // time_string(stop_time) // &
           ' preceeds start ' // time_string(start_time))
      return
    end if

    error = .false.
    return
  end subroutine parse_times

  subroutine parse_date (string, dmy, position, error)

    !-- Parse a date from a string.
    !-- Accepts syntax like 12-Nov-92.
    !-- Does not currently check the number of days in the month.
    !-- Month may be spelled out or abbreviated.
    !-- Year must be between 1901 and 2099,
    !-- century may be omitted for years from 1950 to 2049.
    !-- 1 Dec 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string  !-- String to be parsed.
    integer, intent(out) :: dmy(3)
         !-- Integer day, month and year.
         !-- Year is always all 4 digits.
    integer, intent(inout), optional :: position
         !-- On entry, the starting position for parse. (1 if omitted).
         !-- On exit, the starting position of the next field or
         !-- len(string)+1 if there is no following field.
    logical, intent(out) :: error  !-- True if an error occurs.

    !-------------------- local.
    integer :: pos
    character :: field*12

    !-------------------- executable code.

    pos = 1
    if (present(position)) pos = position

    !-- day
    call find_field(string, field, pos, ' -')
    call string_to_int(field, dmy(1), 1, 31, 'day', error)
    if (error) goto 8000

    !-- month
    call find_field(string, field, pos, ' -')
    dmy(2) = string_index(field(1:3), month_abbrevs)
    if (dmy(2) == 0) then
         call write_error_msg(trim(field) // ' is not a month name.')
         error = .true.
         goto 8000
    end if

    !-- year.
    call find_field(string, field, pos, ' -')
    call string_to_int(field, dmy(3), 0, 2099, 'year', error)
    if (error) goto 8000
    if (dmy(3) < 50) dmy(3) = dmy(3) + 2000
    if (dmy(3) < 100) dmy(3) = dmy(3) + 1900
    error = (dmy(3) < 1901)
    if (error) call write_error_msg('Year is less than 1901.')

    !-- Both normal and error exits come here.
    8000 continue
    if (present(position)) position = pos
    return
  end subroutine parse_date

end module time
