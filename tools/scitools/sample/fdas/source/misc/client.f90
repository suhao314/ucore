!-- client.f90
!-- System-dependent.  Generic stub version always returns failure.
!-- 4 Mar 92, Richard Maine: Version 1.0.

module client

  !-- tcp client module.
  !-- 10 Oct 91, Richard Maine.

  use binary
  use sysdep_io

  implicit none
  private

  !-- Public procedures.
  public client_connect, client_close
  public client_write_line, client_write_rec, client_read_line, client_read_rec

contains

  subroutine client_connect (handle, host_name, host_port, error)

    !-- Connect to a server on the specified host and port.
    !-- 10 Oct 91, Richard Maine.

    !-------------------- interface.
    integer, intent(out) :: handle
         !-- Identifies the connection for future reference.
    character*(*), intent(in) :: host_name
         !-- Server host name, internet domain style.
    integer, intent(in) :: host_port
    logical, intent(out) :: error

    !-------------------- executable code.

    call write_error_msg('client_connect not implemented.')
    error = .true.
    return
  end subroutine client_connect

  subroutine client_close (handle)

    !-- Close a client's tcp connection.
    !-- 10 Oct 91, Richard Maine.

    !-------------------- interface.
    integer, intent(inout) :: handle  !-- Handle from client_connect.

    !-------------------- executable code.

    return
  end subroutine client_close

  subroutine client_write_line (handle, rec_code, line, error)

    !-- Write an ASCII line from a client to a server.
    !-- 10 Oct 91, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: handle  !-- Handle from client_connect.
    integer, intent(in) :: rec_code
         !-- Integer record type code defined by the application.
    character*(*), intent(in) :: line
    logical, intent(out) :: error

    !-------------------- executable code.

    call error_halt('Stub client_write_line called.')
  end subroutine client_write_line

  subroutine client_write_rec (handle, rec_code, rec_buffer, rec_len, error)

    !-- Write a record from a client to a server.
    !-- 10 Oct 91, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: handle  !-- Handle from client_connect.
    integer, intent(in) :: rec_code
         !-- Integer record type code defined by the application.
    type(byte_type), intent(in) :: rec_buffer(*)
         !-- Buffer containing the record body.
         !-- Note the use of assumed size instead of assumed shape.
         !-- Buffer must be contiguous.
    integer, intent(in) :: rec_len
         !-- Length of the record buffer in bytes.
    logical, intent(out) :: error

    !-------------------- executable code.

    call error_halt('Stub client_write_rec called.')
  end subroutine client_write_rec

  subroutine client_read_line (handle, rec_code, line)

    !-- Read an ASCII line to a client from a server.
    !-- 10 Oct 91, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: handle  !-- Handle from client_connect.
    integer, intent(out) :: rec_code
         !-- Integer record type code defined by the application.
         !-- 0 is a special code indicating an error.
    character*(*), intent(out) :: line

    !-------------------- executable code.

    call error_halt('Stub client_read_line called.')
  end subroutine client_read_line

  subroutine client_read_rec (handle, rec_code, rec_buffer, buffer_size, &
       rec_len)

    !-- Read a record to a client from a server.
    !-- 10 Oct 91, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: handle  !-- Handle from client_connect.
    integer, intent(out) :: rec_code
         !-- Integer record type code defined by the application.
         !-- 0 is a special code indicating an i/o error.
         !-- Negative codes are intercepted and interpreted
         !-- as error messages from the server.
    type(byte_type), intent(out) :: rec_buffer(*)
         !-- Buffer for the record body.
         !-- Note the use of assumed size instead of assumed shape.
         !-- Buffer must be contiguous.
    integer, intent(in) :: buffer_size
         !-- Max size of rec_buffer.
    integer, intent(out) :: rec_len
         !-- Length of the record body returned in rec_buffer.

    !-------------------- executable code.

    call error_halt('Stub client_read_rec called.')
  end subroutine client_read_rec

end module client
