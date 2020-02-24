!-- string.f90
!-- 29 Apr 92, Richard Maine: Version 1.0.

module string

  !-- String handling routines.
  !-- System-dependent. Generic version.
  !-- All character case stuff applies only to U.S. characters.
  !-- National ASCII characters are treated as non-alphabetic.
  !-- 13 Mar 91, Richard Maine.

  use precision
  use sysdep_io

  implicit none
  private

  integer :: i_do
  integer, parameter :: down_map_ascii(0:127) = &
       (/ (i_do, i_do=0,64), (i_do+32, i_do=65,90), (i_do, i_do=91,127) /)
  integer, parameter :: up_map_ascii(0:127) = &
       (/ (i_do, i_do=0,96), (i_do-32, i_do=97,122), (i_do, i_do=123,127) /)

  !-- Public procedures.
  public string_index, string_eq, string_comp, upper_case, lower_case
  public int_string, real_string, string_to_int, string_to_real, find_field

contains

  subroutine find_field (string, field, position, delims, delim, found)

    !-- Find a delimitted field in a string.
    !-- 15 Nov 90, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string   !-- The string input.
    character*(*), intent(out) :: field
         !-- The returned field.  Blank if no field found.
    integer, optional, intent(inout) :: position
         !-- On entry, the starting position for searching for the field.
         !-- Default is 1 if the argument is not present.
         !-- On exit, the starting position of the next field or
         !-- len(string)+1 if there is no following field.
    character*(*), optional, intent(in) :: delims
         !-- String containing the characters to be accepted as delimitters.
         !-- If this includes a blank character, then leading blanks are
         !-- removed from the returned field and the end delimitter may
         !-- optionally be preceeded by blanks.  If this argument is
         !-- not present, the default delimitter set is a blank.
    character*(*), optional, intent(out) :: delim
         !-- Returns the actual delimitter that terminated the field.
         !-- Returns char(0) if the field was terminated by the end of
         !-- the string or if no field was found.
         !-- If blank is in delimitters and the field was terminated
         !-- by one or more blanks, followed by a non-blank delimitter,
         !-- the non-blank delimitter is returned.
    logical, optional, intent(out) :: found
         !-- True if a field was found.

    !-------------------- local.
    character :: delimitter*1
    integer :: pos, field_start, field_end, i
    logical :: trim_blanks

    !-------------------- executable code.

    field = ''
    delimitter = char(0)
    pos = 1
    if (present(found)) found = .false.
    if (present(position)) pos = position
    if (pos > len(string)) goto 9000
    if (pos < 1) call error_halt('Illegal position in find_field')

    !-- Skip leading blanks if blank is a delimitter.
    field_start = pos
    trim_blanks = .true.
    if (present(delims)) trim_blanks = index(delims,' ') /= 0
    if (trim_blanks) then
      i = verify(string(pos:),' ')
      if (i == 0) then
        pos = len(string) + 1
        goto 9000
      end if
      field_start = pos + i - 1
    end if
    if (present(found)) found = .true.

    !-- Find the end of the field.
    if (present(delims)) then
      i = scan(string(field_start:), delims)
    else
      i = scan(string(field_start:), ' ')
    end if
    if (i == 0) then
      field_end = len(string)
      delimitter = char(0)
      pos = field_end + 1
    else
      field_end = field_start + i - 2
      delimitter = string(field_end+1:field_end+1)
      pos = field_end + 2
    end if

    !-- Return the field.
    field = string(field_start:field_end)

    !-- Skip trailing blanks if blank is a delimitter.
    if (trim_blanks) then
      i = verify(string(field_end+1:), ' ')
      if (i == 0) then
        pos = len(string) + 1
        goto 9000
      end if
      pos = field_end + i

      !-- If the first non-blank character is a delimitter,
      !-- skip blanks after it.
      i = 0
      if (present(delims)) i = index(delims, string(pos:pos))
      if (i /= 0) then
        delimitter = string(pos:pos)
        pos = pos + 1
        i = verify(string(pos:), ' ')
        if (i == 0) then
          pos = len(string) + 1
        else
          pos = pos + i - 1
        end if
      end if
    end if

    !---------- Normal exit.
    9000 continue
    if (present(delim)) delim = delimitter
    if (present(position)) position = pos
    return
  end subroutine find_field

  function string_eq (string1, string2)

    !-- Test if 2 strings are equal, ignoring case and trailing blanks.
    !-- generic version.
    !-- System-dependent versions might be more efficient.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string1, string2  !-- Strings to test.
    logical :: string_eq                           !-- true if match.

    !-------------------- local.
    integer :: i, min_len

    !-------------------- executable code.

    string_eq = .false.

    !-- Compare the common portion.
    min_len = min(len(string1), len(string2))
    do i = 1 , min_len
      if (down_map_ascii(iachar(string1(i:i))) /= &
          down_map_ascii(iachar(string2(i:i)))) return
    end do

    !-- Then check the remainders, one of which is empty.
    string_eq = string1(min_len+1:) == string2(min_len+1:)
    return
  end function string_eq

  function string_index (string, list)

    !-- Find index of a string in a list of strings.
    !-- Comparison is case-insensitive.
    !-- The list need not be ordered.
    !-- We may later want to add an option to allow abbreviations.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string   !-- The string input.
    character*(*), intent(in) :: list(:)  !-- List to compare against.
    integer :: string_index  !-- Index of string in list. 0 if no match.

    !-------------------- local.
    integer :: i

    !-------------------- executable code.

    do i = 1 , size(list)
      if (string_eq(string,list(i))) exit
    end do
    if (i > size(list)) i = 0
    string_index = i
    return
  end function string_index

  function string_comp (string1, string2)

    !-- Compare 2 strings, ignoring case and trailing blanks.
    !-- generic version.
    !-- System-dependent versions might be more efficient.
    !-- 29 Apr 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string1, string2  !-- Strings to test.
    integer :: string_comp
         !-- Returns 0 if strings equal,
         !-- -1 if string1 < string2, +1 if string1 > string2.

    !-------------------- local.
    integer :: i, min_len, ichar1, ichar2

    !-------------------- executable code.

    !-- Compare the common portion.
    min_len = min(len(string1), len(string2))
    do i = 1 , min_len
      ichar1 = down_map_ascii(iachar(string1(i:i)))
      ichar2 = down_map_ascii(iachar(string2(i:i)))

      if (ichar1 == ichar2) cycle
      if (ichar1 < ichar2) then
        string_comp = -1
      else
        string_comp = 1
      end if
      return
    end do

    !-- Then check the remainders, one of which is empty.
    if (string1(min_len+1:) == string2(min_len+1:)) then
      string_comp = 0
    else if (len(string1) > min_len) then
      string_comp = 1
    else
      string_comp = -1
    end if
    return
  end function string_comp

  function upper_case (string) result(result)

    !-- Change all lower case characters in a string to upper case.
    !-- generic version.
    !-- System-dependent versions might be more efficient.
    !-- 29 Apr 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string  !-- An arbitrary string.
    character*(len(string)) :: result  !-- The converted string.

    !-------------------- local.
    integer :: i

    !-------------------- executable code.

    do i = 1 , len(string)
      result(i:i) = achar(up_map_ascii(iachar(string(i:i))))
    end do
    return
  end function upper_case

  function lower_case (string) result(result)

    !-- Change all upper case characters in a string to lower case.
    !-- generic version.
    !-- System-dependent versions might be more efficient.
    !-- 29 Apr 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string  !-- An arbitrary string.
    character*(len(string)) :: result  !-- The converted string.

    !-------------------- local.
    integer :: i

    !-------------------- executable code.

    do i = 1 , len(string)
      result(i:i) = achar(down_map_ascii(iachar(string(i:i))))
    end do
    return
  end function lower_case

  function int_string(int) result(string)

    !-- Convert an integer to a string.
    !-- Current implementation gives a fixed-length blank-padded string.
    !-- 18 Oct 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: int  !-- Integer value.
    character :: string*12      !-- Converted value.

    !-------------------- executable code.

    write (string, *) int
    return
  end function int_string

  function real_string(val) result(string)

    !-- Convert a real to a string.
    !-- Current implementation gives a fixed-length blank-padded string.
    !-- 18 Oct 90, Richard Maine.

    !-------------------- interface.
    real(r_kind), intent(in) :: val  !-- Real value.
    character :: string*12           !-- Converted value.

    !-------------------- executable code.

    write (string, '(g12.5)') val
    return
  end function real_string

  subroutine string_to_int (string, int, min_val, max_val, name, error)

    !-- Convert a string to an integer, with error and range testing.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string
    integer, intent(inout) :: int
         !-- Input value left unchanged on errors.
    integer, intent(in), optional :: min_val, max_val
         !-- For compatability with old Fortran 77 codes,
         !-- these are ignored if min_val>max_val.
    character*(*), intent(in), optional :: name
         !-- Used in error message.  No error message if not present.
    logical, intent(out), optional :: error
         !-- Abort if there is an error and this is missing.

    !-------------------- local.
    character, save :: fmt*7 = '(i   1)'
    integer :: temp_i, min_i, max_i
    integer :: iostat

    !-------------------- executable code.

    !-- Convert string.
    write (unit=fmt(3:6), fmt='(i4)') len(string)
    read (unit=string, fmt=fmt, iostat=iostat) temp_i
    if (iostat /= 0) then
      if (present(name)) &
           call write_error_msg('bad integer syntax for '//name//': '//string)
      goto 8000
    end if

    !-- Test limits.
    min_i = -big_int
    if (present(min_val)) min_i = min_val
    max_i = big_int
    if (present(max_val)) max_i = max_val

    if (max_i >= min_i) then
      if (temp_i < min_i) then
        if (present(name)) call write_error_msg( &
             name//' value of '//int_string(temp_i)// &
             ' less than limit '//int_string(min_i))
        goto 8000
      end if

      if (temp_i > max_i) then
        if (present(name)) call write_error_msg( &
             name//' value of '//int_string(temp_i)// &
             ' greater than limit '//int_string(max_i))
        goto 8000
      end if
    end if

    !-- Normal exit.
    int = temp_i
    if (present(error)) error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (.not.present(error)) call error_halt('error in string_to_int')
    error = .true.
    return
  end subroutine string_to_int

  subroutine string_to_real (string, val, min_val, max_val, name, error)

    !-- Convert a string to a real, with error and range testing.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: string
    real(r_kind), intent(inout) :: val
         !-- Input value left unchanged on errors.
    real(r_kind), intent(in), optional :: min_val, max_val
         !-- For compatability with old Fortran 77 codes,
         !-- these are ignored if min_val>max_val.
    character*(*), intent(in), optional :: name
         !-- Used in error message.  No error message if not present.
    logical, intent(out), optional :: error
         !-- Abort if there is an error and this is missing.

    !-------------------- local.
    character, save :: fmt*9 = '(f  10.0)'
    real(r_kind) :: temp_r, min_r, max_r
    integer :: iostat

    !-------------------- executable code.

    !-- Convert string.
    write (unit=fmt(3:6), fmt='(i4)') len(string)
    read (unit=string, fmt=fmt, iostat=iostat) temp_r
    if (iostat /= 0) then
      if (present(name)) &
           call write_error_msg('bad real syntax for '//name//': '//string)
      goto 8000
    end if

    !-- Test limits.
    min_r = -big_real
    if (present(min_val)) min_r = min_val
    max_r = big_real
    if (present(max_val)) max_r = max_val

    if (max_r >= min_r) then
      if (temp_r < min_r) then
        if (present(name)) call write_error_msg( &
             name//' value of '//real_string(temp_r)// &
             ' less than limit '//real_string(min_r))
        goto 8000
      end if

      if (temp_r > max_r) then
        if (present(name)) call write_error_msg( &
             name//' value of '//real_string(temp_r)// &
             ' greater than limit '//real_string(max_r))
        goto 8000
      end if
    end if

    !-- Normal exit.
    val = temp_r
    if (present(error)) error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (.not.present(error)) call error_halt('error in string_to_real')
    error = .true.
    return
  end subroutine string_to_real

end module string
