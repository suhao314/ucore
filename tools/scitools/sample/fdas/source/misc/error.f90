!-- error.f90
!-- 1 May 92, Richard Maine: Version 1.0.

subroutine write_error_sub (message)

  !-- Write an error message.
  !-- This is the implementation for subroutine write_error_msg
  !-- in the sysdep_io module.
  !-- It is a separate external routine to facilitate overrides.
  !-- Generic version writes to std_err file.
  !-- 1 May 92, Richard Maine.

  use standard_files
  implicit none

  !-------------------- interface.
  character*(*), intent(in) :: message  !-- Error message.  Already trimmed.

  !-------------------- executable code.

  write (std_err, *) '** ', message
  return
end subroutine write_error_sub
