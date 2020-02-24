!-- thRCmp3.f90
!-- 31 Jul 92, Richard Maine: Version 1.1.

module th_read_cmp3

  !-- Module for reading cmp3 format time history files.
  !-- Intended for calling from the th_read module.
  !-- We rely on th_read for much of the call validity testing.
  !-- 31 Jul 92, Richard Maine.

  use precision
  use sysdep_io
  use binary
  use string
  use th_read_gen

  implicit none
  private

  !-- Identifying string for automatic format determination.
  character*(*), public, parameter :: cmp3_format_string='cmp3'

  integer, parameter :: block_head_len = 4
  integer, parameter :: block_size = 2048, max_index = 255
  integer, parameter :: eod_flag = 0, full_frame_flag = 1, bit_map_flag = 2, &
       change_list_flag = 3

  type block_type
    type(byte_type) :: body(block_size)
  end type

  type cmp3_type
    integer :: lun
         !-- Fortran logical unit number.  More convenient here than in gen.
    integer :: first_index_block_num, first_data_block_num
    integer :: data_precision  !-- Number of bytes of data precision.
    real(r_kind) :: base_time, time_scale
    integer :: time_key_offset
    integer :: n_keys
    integer :: index_key(0:max_index)
    integer :: index_pos(0:max_index)
    type(block_type) :: block
    integer :: block_num  !-- Block number (numbered from 1).
    integer :: block_pos  !-- File position relative to block start.
    logical :: block_loaded  !-- Is a block currently loaded?
    real(r_kind), pointer :: prev_data(:)
  end type
  type cmp3_ptr_type
    type(cmp3_type), pointer :: cmp3
  end type

  type(cmp3_type), pointer :: cmp3  !-- for scratch use only.  Not saved.
  type(cmp3_ptr_type) :: cmp3_ptr   !-- for scratch use only.  Not saved.

  !-- Public procedures.
  public open_th_read_cmp3, close_th_read_cmp3, seek_th_cmp3, read_th_cmp3

  !-- Forward reference for private procedures.
  private get_header, get_cmp3, read_block

contains

  subroutine open_th_read_cmp3 (gen, file_name, n_signals, error)

    !-- Open a cmp3 file for reading.
    !-- 13 Aug 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Already allocated on entry.
    character*(*), intent(in) :: file_name
    integer, intent(out) :: n_signals       !-- Number of available signals.
    logical, intent(out) :: error

    !-------------------- local.
    character :: where*8, header_name*8, signal_name*16, eu_name*16
    integer :: open_size, iostat, i, rec_pos, header_data_len, title_len
    integer :: max_header_size
    integer, parameter :: small_size=28  !-- Big enough for blocks header.
    type(byte_type) :: small_header(small_size)
    type(byte_type), allocatable :: header_data(:)  !-- Must be contiguous.
    logical :: unclosed

    !-------------------- executable code.

    !-- Allocate the cmp3 record.
    where = 'allocate'
    nullify(cmp3)
    i = size(transfer(cmp3_ptr,gen%format_specific_data))
    allocate(gen%format_specific_data(i), stat=iostat)
    if (iostat /= 0) goto 8000
    allocate(cmp3, stat=iostat)
    if (iostat /= 0) goto 8000
    nullify(cmp3%prev_data)
    cmp3_ptr%cmp3 => cmp3
    gen%format_specific_data = transfer(cmp3_ptr, gen%format_specific_data)

    !-- Open the file.
    where = 'open'
    call assign_lun(cmp3%lun)
    inquire(iolength=open_size) cmp3%block
    open (cmp3%lun, file=file_name, form='unformatted', &
         access='direct', recl=open_size, &
         status='old', action='read', iostat=iostat)
    if (iostat /= 0) goto 8000

    cmp3%block_num = 1
    cmp3%block_pos = block_head_len
    cmp3%block_loaded = .false.

    !---------- Read required header records.
    !-- Note that we don't validate the header_data_lengths in cases
    !-- where they are supposed to be known.

    !-- format header.
    where = 'format'
    call get_header(small_header, small_size, header_data_len, error, &
         expect='format')
    if (error) goto 8000

    !-- blocks header.
    where = 'blocks'
    call get_header(small_header, small_size, header_data_len, error, &
         expect='blocks')
    if (error) goto 8000
    rec_pos = 12
    call get_i4(small_header, rec_pos, cmp3%first_index_block_num)
    rec_pos = 20
    call get_i4(small_header, rec_pos, cmp3%first_data_block_num)

    !-- nChans header.
    where = 'nChans'
    call get_header(small_header, small_size, header_data_len, error, &
         expect='nChans')
    if (error) goto 8000
    rec_pos = 0
    call get_i4(small_header, rec_pos, n_signals)
    cmp3%data_precision = n_signals/65536
    n_signals = mod(n_signals,65536)
    if (cmp3%data_precision == 0) cmp3%data_precision=3
    if ( (cmp3%data_precision /= 3) .and. (cmp3%data_precision /= 4) .and. &
         (cmp3%data_precision /= 8) ) goto 8000

    where = 'allocate'
    call all_th_read_gen(gen, n_signals, error)
    if (error) goto 8000
    max_header_size = max(16*n_signals, 80)
    allocate (header_data(max_header_size), cmp3%prev_data(0:n_signals), &
         stat=iostat)
    if (iostat /= 0) goto 8000

    !-- timeKey header.
    where = 'timeKey'
    call get_header(small_header, small_size, header_data_len, error, &
         expect='timeKey')
    if (error) goto 8000
    rec_pos = 0
    call get_r8(small_header, rec_pos, cmp3%base_time)
    call get_r8(small_header, rec_pos, cmp3%time_scale)
    call get_i4(small_header, rec_pos, cmp3%time_key_offset)

    !-- names header.
    where = 'names'
    call get_header(header_data, max_header_size, header_data_len, error, &
         expect='names')
    if (error) goto 8000
    rec_pos = 0
    do i = 1 , n_signals
      call get_char(header_data, rec_pos, signal_name)
      gen%signal_names(i) = signal_name
    end do

    !-- Fixup for files written without being closed.
    !-- Such files have 0 values in the blocks header and no endHead header.
    !-- They also have no index entries, which causes no fatal problems.
    !-- Finally, they likely end in the middle of a data record.
    unclosed = cmp3%first_index_block_num == 0
    if (unclosed) then
      call write_error_msg('Damaged cmp3 file: '//file_name)
      call write_error_msg('Most likely the job writing it aborted.')
      call write_error_msg('Recovery will be tried but could fail.')
      cmp3%first_index_block_num = cmp3%block_num + 1
      cmp3%first_data_block_num = cmp3%block_num + 2
    end if

    !---------- Read optional headers (but not if unclosed).
    if (.not. unclosed) then
      where = 'endHead'
      header_loop: do
        call get_header(header_data, max_header_size, header_data_len, error, &
             header_name)
        if (error) goto 8000
        if (string_eq(header_name, 'endHead')) exit header_loop
        if (string_eq(header_name, 'title')) then
          rec_pos = 0
          title_len = min(header_data_len, len(gen%file_title))
          call get_char(header_data, rec_pos, gen%file_title(:title_len))
        else if (string_eq(header_name, 'dt')) then
          rec_pos = 0
          call get_r4(header_data, rec_pos, gen%dt)
        else if (string_eq(header_name, 'units')) then
          rec_pos = 0
          do i = 1 , n_signals
            call get_char(header_data, rec_pos, eu_name)
            gen%eu_names(i) = eu_name
          end do
        end if
      end do header_loop
    end if

    !-- Read index.
    where = 'index'
    call read_block(cmp3%lun, cmp3%first_index_block_num, cmp3%block, error)
    if (error) goto 8000
    rec_pos = 4
    call get_i1(cmp3%block%body, rec_pos, cmp3%n_keys)
    cmp3%index_key(0) = 0
    cmp3%index_pos(0) = (cmp3%first_data_block_num-1)*block_size + &
         block_head_len
    rec_pos = 8
    do i = 1 , cmp3%n_keys
      call get_i4(cmp3%block%body, rec_pos, cmp3%index_key(i))
      call get_i4(cmp3%block%body, rec_pos, cmp3%index_pos(i))
    end do

    !-- Normal exit.
    gen%previous_time = -big_real
    cmp3%prev_data = 0.
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_read_cmp3 failed at: '//where)
    if (allocated(header_data)) deallocate(header_data)
    if (associated(cmp3)) call close_th_read_cmp3(gen)
    error = .true.
    return
  end subroutine open_th_read_cmp3

  subroutine close_th_read_cmp3 (gen)

    !-- Close an cmp3 file for reading.
    !-- 26 Jun 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Do not deallocate here.

    !-------------------- executable code.

    if (associated(gen%format_specific_data)) then

      cmp3_ptr = transfer(gen%format_specific_data, cmp3_ptr)
      cmp3 => cmp3_ptr%cmp3

      close (cmp3%lun)
      call release_lun(cmp3%lun)
      if (associated(cmp3%prev_data)) deallocate(cmp3%prev_data)
      deallocate(cmp3)
    end if
    return
  end subroutine close_th_read_cmp3

  subroutine seek_th_cmp3 (gen, start_time, error)

    !-- Seek to a time interval on an cmp3 file.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen          !-- Generic file descriptor.
    real(r_kind), intent(in) :: start_time  !-- Requested interval start time.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: key_seek, index_num, i
    real(r_kind) :: index_time

    !-------------------- executable code.

    cmp3_ptr = transfer(gen%format_specific_data, cmp3_ptr)
    cmp3 => cmp3_ptr%cmp3

    !-- Find the last index entry <= the sought time.
    key_seek = (start_time - cmp3%base_time)/cmp3%time_scale &
         + cmp3%time_key_offset
    index_num = 0
    do i = 1 , cmp3%n_keys
      if (cmp3%index_key(i) > key_seek) exit
      index_num = i
    end do
    index_time = (cmp3%index_key(index_num) - cmp3%time_key_offset) &
         * cmp3%time_scale + cmp3%base_time
    !-- Position to the index if better than current position.
    if (gen%previous_time >= start_time &
         .or. gen%previous_time < index_time) then
      cmp3%block_num = (cmp3%index_pos(index_num) - 1)/block_size + 1
      cmp3%block_pos = mod(cmp3%index_pos(index_num) - 1, block_size) + 1
      cmp3%block_loaded = .false.
      !-- The index time is not actually the previous time,
      !-- but it doesn't matter here.
      gen%previous_time = index_time
    end if

    !-- Normal exit.
    cmp3%prev_data = 0.
    error = .false.
    return
  end subroutine seek_th_cmp3

  subroutine read_th_cmp3 (gen, time, data, status)

    !-- Read a frame from an cmp3 file.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen        !-- Generic file descriptor.
    real(r_kind), intent(out) :: time     !-- Returned frame time.
    real(r_kind), intent(out) :: data(:)  !-- Returned frame data.
    integer, intent(out) :: status        !-- See read_th for codes.

    !-------------------- local.
    integer, parameter :: rec_header_len = 7
    type(byte_type) :: rec_header(rec_header_len)
    integer :: rec_pos, tot_len, time_key, data_len, i, n_changes, rec_flags
    type(byte_type) :: data_rec(gen%n_signals*8 + (gen%n_signals-1)/8 + 1)
    integer :: change_list(gen%n_signals)
    logical :: error
    real(r4_kind) :: temp_r4

    !-------------------- executable code.

    cmp3_ptr = transfer(gen%format_specific_data, cmp3_ptr)
    cmp3 => cmp3_ptr%cmp3

    status = thr_error
    !-- Read the record header.
    call get_cmp3(rec_header, rec_header_len, error)
    if (error) goto 8000
    rec_pos = 0
    call get_i2(rec_header, rec_pos, tot_len)
    call get_i4(rec_header, rec_pos, time_key)
    call get_i1(rec_header, rec_pos, rec_flags)

    !-- Read the record body.
    if (rec_flags == eod_flag) then
      status = thr_eod
      goto 8000
    end if
    data_len = tot_len - rec_header_len
    if (data_len < 0 .or. data_len > size(data_rec)) goto 8000
    call get_cmp3(data_rec, data_len, error)
    if (error) goto 8000

    !-- Compute time.
    time = (time_key - cmp3%time_key_offset)*cmp3%time_scale + cmp3%base_time

    !-- Create change_list
    rec_pos = 0
    !-- Full frame.
    if (rec_flags == full_frame_flag) then
      change_list = (/ (i, i = 1 , gen%n_signals) /)
      n_changes = gen%n_signals
    !-- Bit map.
    else if (rec_flags == bit_map_flag) then
      n_changes = 0
      do i = 1 , gen%n_signals
        if (test_bit(data_rec, i)) then
          n_changes = n_changes + 1
          change_list(n_changes) = i
        end if
      end do
      rec_pos = rec_pos + (gen%n_signals - 1)/8 + 1
    !-- change list
    else
      n_changes = 0
      do
        call get_i1(data_rec, rec_pos, i)
        if (i == 0) exit
        n_changes = n_changes + 1
        change_list(n_changes) = i
      end do
    end if

    !-- Unpack data and update current values table.
    do i = 1 , n_changes
      if (cmp3%data_precision == 3) then
        call get_r3(data_rec, rec_pos, temp_r4)
        cmp3%prev_data(change_list(i)) = temp_r4
      else if (cmp3%data_precision == 4) then
        call get_r4(data_rec, rec_pos, cmp3%prev_data(change_list(i)))
      else
        call get_r8(data_rec, rec_pos, cmp3%prev_data(change_list(i)))
      end if
    end do
    status = thr_ok

    !-- Select signals.
    data = cmp3%prev_data(gen%channel_map)

    !-- Normal exit.
    gen%previous_time = time
    return

    !---------- Error exit.
    8000 continue
    gen%previous_time = big_real
    return
  end subroutine read_th_cmp3

  subroutine get_header (data, max_data_len, data_len, error, &
       header_name, expect)

    !-- Read a cmp3 header.
    !-- Requires that the cmp3 pointer be defined by calling routine.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(byte_type), intent(out) :: data(*)
         !-- Must be contiguous.
    integer, intent(in) :: max_data_len
         !-- Size of the data buffer.
    integer, intent(out) :: data_len
         !-- Length of returned data vector.
    logical, intent(out) :: error
    character*(*), intent(out), optional :: header_name
         !-- Header name found.
    character*(*), intent(in), optional :: expect
         !-- Header name expected.  If not present, any header is accepted.

    !-------------------- local.
    integer, parameter :: rec_header_len = 11
    type(byte_type) :: rec_header(rec_header_len)
    integer :: rec_pos, tot_len, data_code
    character :: h_name*8

    !-------------------- executable code.

    call get_cmp3(rec_header, rec_header_len, error)
    if (error) return
    rec_pos = 0
    call get_i2(rec_header, rec_pos, tot_len)
    call get_i1(rec_header, rec_pos, data_code)
    call get_char(rec_header, rec_pos, h_name)
    if (present(header_name)) header_name = h_name
    if (present(expect)) error = .not. string_eq(h_name, expect)
    data_len = tot_len - rec_header_len
    error = error .or. data_len < 0  .or. data_len > max_data_len
    if (error) return
    call get_cmp3(data, data_len, error)
    return
  end subroutine get_header

  subroutine get_cmp3 (data, data_len, error)

    !-- Get bytes from a cmp3 file.
    !-- Requires that the cmp3 pointer be defined by calling routine.
    !-- Starts at current file position.
    !-- Concatenates data from multiple blocks as needed.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(byte_type), intent(out) :: data(*)  !-- Must be contiguous.
    integer, intent(in) :: data_len
         !-- Number of bytes to be read.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: done_len, part_len

    !-------------------- executable code.

    error = .true.

    !-- Load initial block if needed.
    if (.not. cmp3%block_loaded) then
      call read_block(cmp3%lun, cmp3%block_num, cmp3%block, error)
      cmp3%block_loaded = .not. error
      if (error) return
    end if

    done_len = 0
    block_loop: do

      !-- Get as much as can from current block.
      part_len = min(data_len-done_len, block_size-cmp3%block_pos)
      if (part_len /= 0) call copy_bytes &
        (cmp3%block%body, cmp3%block_pos, data, done_len, part_len)

      !-- Go to subsequent blocks as needed.
      if (done_len >= data_len) exit block_loop
      cmp3%block_pos = 1
      call get_i3(cmp3%block%body, cmp3%block_pos, cmp3%block_num)
      if (cmp3%block_num == 0) then
        call write_error_msg('End of block chain in cmp3 file.')
        error = .true.
        return
      end if
      call read_block(cmp3%lun, cmp3%block_num, cmp3%block, error)
      cmp3%block_loaded = .not. error
      if (error) return
      cmp3%block_pos = block_head_len
    end do block_loop
    error = .false.
    return
  end subroutine get_cmp3

  subroutine read_block (lun, block_num, block, error)

    !-- Read a block from a cmp3 file.
    !-- 3 Jul 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: lun  !-- Logical unit number.
    integer, intent(in) :: block_num
    type(block_type), intent(out) :: block
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat

    !-------------------- executable_code.

    read(lun, rec=block_num, iostat=iostat) block
    error = iostat /= 0
    if (error) then
      call write_sys_error(iostat)
      call write_error_msg('Error reading cmp3 file.')
    end if
    return
  end subroutine read_block

end module th_read_cmp3
