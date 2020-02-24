!-- thRNet1.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_read_net1_codes

  !-- Record codes for net1 protocol.
  !-- 30 Nov 90, Richard Maine.

  implicit none
  public

  !-- Command codes.
  integer, parameter :: hello_code=1100, auth_code=1110, &
       file_code=1200, list_code=1300, &
       sigs_code=1400, sigs_name_code=1410, sigs_done_code=1420, &
       seek_code=1500, go_code=1600, stop_code=1700, bye_code=1900

  !-- Reply codes.
  integer, parameter :: hello_ok_reply=1100000, auth_ok_reply=1110000, &
       file_ok_reply=1200000, &
       list_ok_reply=1300000, list_name_reply=1300100, &
       list_done_reply=1300200, sigs_ok_reply=1400000, &
       sigs_ready_reply=1400100, sigs_miss_reply=1400200, &
       miss_sig_reply=1400300, seek_ok_reply=1500000, go_ok_reply=1600000, &
       go_ack_reply=1600100, go_end_req_reply=1600200, &
       go_end_data_reply=1600300, stop_ok_reply=1700000, bye_ok_reply=1900000

end module th_read_net1_codes

module th_read_net1

  !-- Module for reading net1 format time history files.
  !-- Intended for calling from the th_read module.
  !-- We rely on th_read for much of the call validity testing.
  !-- 30 Nov 90, Richard Maine.

  use precision
  use binary
  use sysdep_io
  use string
  use th_read_gen
  use th_read_net1_codes
  use client

  implicit none
  private

  !-- Identifying string for automatic format determination.
  !-- Not really applicable to this format, but define it anyway.
  character*(*), public, parameter :: net1_format_string='net1'

  !-- Public procedures.
  public open_th_read_net1, close_th_read_net1
  public request_th_net1, seek_th_net1, read_th_net1

  !-- Forward reference for private procedures.
  private flush_th_read_net1

contains

  subroutine open_th_read_net1 (gen, file_name, access_id, password, &
       n_signals, error)

    !-- Open a net1 file for reading.
    !-- 30 Nov 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Already allocated on entry.
    character*(*), intent(in) :: file_name
    character*(*), intent(in) :: access_id, password
    integer, intent(out) :: n_signals       !-- Number of available signals.
    logical, intent(out) :: error

    !-------------------- local.
    character :: where*8, field*16, line*256, delim*1
    character :: server_name*128, service*16, media*16, server_file*128
    integer :: pos, port, chan, reply_code

    !-------------------- executable code.

    gen%lun = 0

    !-- Parse the "fileName" as server(port):media:fileName
    where = 'parse'
    pos = 1
    call find_field(file_name, server_name, pos, ':(', delim)
    if (server_name=='') server_name = 'fdas.dfrf.nasa.gov'
    if (delim=='(') then
      call find_field(file_name, service, pos, ')')
      call find_field(file_name, field, pos, ':')
      call string_to_int(service, port, 1024, 32767, error=error)
      if (error) goto 8000
    else
      port = 30001
    end if
    call find_field(file_name, media, pos, ':')
    if (media=='') media= 'path'
    server_file = file_name(pos:)
    if (server_file=='') goto 8000

    !-- Establish a connection.
    !-- gen%lun is used here for the tcp handle.
    where = 'connect'
    call client_connect(gen%lun, server_name, port, error)
    if (error) goto 8000

    !-- Request authorization.
    where = 'hello'
    call client_write_line(gen%lun, hello_code, 'hello thRead 1.0', error)
    if (error) goto 8000
    call client_read_line(gen%lun, reply_code, line)
    if (reply_code /= hello_ok_reply .or. &
         .not. string_eq(line(:13), 'hello thRead ')) goto 8000
    where = 'authoriz'
    line = 'auth read ' // access_id // ' ' // password
    call client_write_line(gen%lun, auth_code, trim(line), error)
    if (error) goto 8000
    call client_read_line(gen%lun, reply_code, line)
    if (reply_code /= auth_ok_reply) goto 8000

    !-- Open the file.
    where = 'open'
    call client_write_line(gen%lun, file_code, &
         'file ' // trim(media) // ' ' // trim(server_file), error)
    if (error) goto 8000
    call client_read_line(gen%lun, reply_code, line)
    if (reply_code /= file_ok_reply) goto 8000

    !-- Title, dt, and nChans.
    where = 'nChans'
    pos = 6
    call find_field(line, field, pos)
    call string_to_int(field, n_signals, min_val=0, name='nChans', error=error)
    if (error) goto 8000
    call find_field(line, field, pos)
    call string_to_real(field, gen%dt, min_val=r_zero, name='dt', error=error)
    if (error) goto 8000
    gen%file_title = line(pos:)

    where = 'allocate'
    call all_th_read_gen(gen, n_signals, error)
    if (error) goto 8000

    !-- Get signal names and engineering units.
    where = 'signals'
    call client_write_line(gen%lun, list_code, 'list signals', error)
    if (error) goto 8000
    call client_read_line(gen%lun, reply_code, line)
    if (reply_code /= list_ok_reply) goto 8000
    do chan = 1 , n_signals
      call client_read_line(gen%lun, reply_code, line)
      if (reply_code /= list_name_reply) goto 8000
      gen%signal_names(chan) = line(1:16)
      gen%eu_names(chan) = line(17:32)
    end do
    call client_read_line(gen%lun, reply_code, line)
    if (reply_code /= list_done_reply) goto 8000

    !-- Normal exit.
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    call write_error_msg('Open_th_read_net failed at: '//where)
    call close_th_read_net1(gen)
    error = .true.
    return
  end subroutine open_th_read_net1

  subroutine close_th_read_net1 (gen)

    !-- Close a net1 file for reading.
    !-- 30 Nov 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Do not deallocate here.

    !-------------------- local.
    integer :: reply_code
    logical :: error
    character :: line*16

    !-------------------- executable code.

    if (gen%lun /= 0) then
      !-- Send bye command, ignoring errors to the extent possible.
      call client_write_line(gen%lun, bye_code, 'bye', error)
      if (.not. error) call client_read_line(gen%lun, reply_code, line)
      call client_close(gen%lun)
    end if
    return
  end subroutine close_th_read_net1

  subroutine request_th_net1 (gen, requested_signals, found, error)

    !-- Specify signals to be read from a net1 th_read file.
    !-- 30 Nov 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen  !-- Generic file descriptor.
    character*(*), intent(in) :: requested_signals(:)
         !-- Requested signal names.
    logical, intent(out) :: found(:)
         !-- Indicates which requested signals were found.
         !-- Must be the same size as requested_signals.  (Not checked).
    logical, intent(out) :: error
         !-- True if an error occurs.
         !-- Failure to find requested signals is not considered an error.

    !-------------------- local.
    integer chan, miss, n_request, n_miss, reply_code
    character :: line*128

    !-------------------- executable code.

    !-- In case of errors.
    gen%n_requested = 0    

    !-- Flush any pending data.
    call flush_th_read_net1(gen, error)
    if (error) return

    !-- Send signal list to server.
    n_request = size(requested_signals)
    call client_write_line(gen%lun, sigs_code, &
         'signals ' // int_string(n_request), error)
    if (error) goto 8000
    call client_read_line(gen%lun, reply_code, line)
    if (reply_code /= sigs_ready_reply) goto 8000
    do chan = 1 , n_request
      call client_write_line(gen%lun, sigs_name_code, &
           trim(requested_signals(chan)), error)
      if (error) goto 8000
      found(chan) = .true.
    end do
    call client_write_line(gen%lun, sigs_done_code, 'done', error)
    if (error) goto 8000

    !-- Get server response.
    call client_read_line(gen%lun, reply_code, line)
    if (error) goto 8000

    !-- If some signals not found, get the list.
    if (reply_code == sigs_miss_reply) then
      call string_to_int(line(17:28), n_miss, 1, n_request, error=error)
      if (error) goto 8000
      do miss = 1 , n_miss
        call client_read_line(gen%lun, reply_code, line)
        if (reply_code /= miss_sig_reply) goto 8000
        call string_to_int(line(1:12), chan, 1, n_request, error=error)
        if (error) goto 8000
        found(chan) = .false.
      end do
      call client_read_line(gen%lun, reply_code, line)
    end if

    !-- Verify normal termination.
    if (reply_code /= sigs_ok_reply) goto 8000

    !---------- Normal exit.
    gen%n_requested = n_request
    return

    !---------- Error exit.
    8000 continue
    call flush_th_read_net1(gen, error)
    error = .true.
    return
  end subroutine request_th_net1

  subroutine seek_th_net1 (gen, start_time, stop_time, thin_factor, error)

    !-- Seek to a time interval on a net1 file.
    !-- 30 Nov 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen  !-- Generic file descriptor.
    real(r_kind), intent(in) :: start_time, stop_time
    integer, intent(inout) :: thin_factor
         !-- On exit, must be reset to 1 to indicate that the higher level
         !-- routines should not thin (to avoid double thinning).
    logical, intent(out) :: error

    !-------------------- local.
    integer :: reply_code
    character :: line*128

    !-------------------- executable code.

    !-- Flush any pending data.
    call flush_th_read_net1(gen, error)
    if (error) return

    write(line,'(a6,2e20.12,a6,i5)') &
         'times ', start_time, stop_time, ' thin=',thin_factor
    call client_write_line(gen%lun, seek_code, line(:57), error)
    if (error) return

    call client_read_line(gen%lun, reply_code, line)
    error = reply_code /= seek_ok_reply

    thin_factor = 1
    return
  end subroutine seek_th_net1

  subroutine read_th_net1 (gen, time, data, status)

    !-- Read a frame from a net1 file.
    !-- 30 Nov 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen        !-- Generic file descriptor.
    real(r_kind), intent(out) :: time     !-- Returned frame time.
    real(r_kind), intent(out) :: data(:)  !-- Returned frame data.
    integer, intent(out) :: status        !-- See read_th for codes.

    !-------------------- local.
    integer rec_len, buf_pos, rec_flags, chan, reply_code
    type(byte_type) :: frame_buffer(9+4*size(data))
    logical :: error

    !-------------------- executable code.

    status = thr_error

    !-- Read frame buffer from server.
    call client_read_rec(gen%lun, reply_code, frame_buffer, &
         size(frame_buffer), rec_len)

    !-- Check response code.
    !-- Send acknowledgement if requested.
    if (reply_code == go_ack_reply) then
      call client_write_line(gen%lun, go_code, 'go', error)
      if (error) return
    !-- Anything else other than go_ok terminates retrieval.
    else if (reply_code /= go_ok_reply) then
      if (reply_code == go_end_req_reply) status = thr_eoi
      if (reply_code == go_end_data_reply) status = thr_eod
    end if

    !-- Decode binary data in buffer.
    if (rec_len < 9 .or. rec_len > size(frame_buffer)) then
      call write_error_msg('Frame length error in read_th_net1.')
      return
    end if
    buf_pos = 0
    call get_i1(frame_buffer, buf_pos, rec_flags)
    call get_r8(frame_buffer, buf_pos, time)
    do chan = 1 , size(data)
      call get_r4(frame_buffer, buf_pos, data(chan))
    end do

    status = thr_ok
    return
  end subroutine read_th_net1

  subroutine flush_th_read_net1 (gen, error)

    !-- Flush data stream from a net1 input file.
    !-- 30 Nov 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen  !-- Generic file descriptor.
    logical, intent(out) :: error

    !-------------------- local.
    character :: line*16
    integer :: reply_code

    !-------------------- executable code.

    call client_write_line(gen%lun, stop_code, 'stop', error)
    if (error) return

    loop: do
      call client_read_line(gen%lun, reply_code, line)
      error = reply_code == 0
      if (error) return
      if (reply_code == stop_ok_reply) exit loop
    end do loop
    return
  end subroutine flush_th_read_net1

end module th_read_net1
