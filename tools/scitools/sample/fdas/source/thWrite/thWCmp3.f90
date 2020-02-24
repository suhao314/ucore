!-- thWCmp3.f90
!-- 10 Dec 92, Richard Maine: Version 1.0.  Round time instead of truncate.

module th_write_cmp3

  !-- Module for writing cmp3 format time history files.
  !-- Intended for calling from the th_write module.
  !-- We rely on th_write for much of the call validity testing.
  !-- Possible system-dependencies in the open, read and write statements.
  !-- 10 Dec 92, Richard Maine.

  use precision
  use binary
  use sysdep_io

  implicit none
  private

  !-- Identifying string for format specification.
  character*(*), public, parameter :: cmp3_format_string='cmp3'

  integer, parameter :: block_size=2048, max_index=255

  integer, parameter :: header_block_code = 1, index_block_code = 2, &
       data_block_code=3
  integer, parameter :: block_head_len = 4
  integer, parameter :: eod_flag = 0, full_frame_flag = 1, bit_map_flag = 2, &
       change_list_flag = 3

  type :: block_type
    type(byte_type) :: body(block_size)
  end type

  type, private :: cmp3_type
    integer :: lun
    logical :: flush_on_close
    integer :: data_precision
    real(r_kind) :: base_time, time_scale
    integer :: time_key_offset, full_frame_interval
    integer :: n_blocks
    integer :: n_keys, index_count, index_div
    integer :: index_key(max_index), index_pos(max_index)
    integer :: first_index_block, n_index_blocks, first_data_block
    integer :: n_frames, prev_full_frame
    real(r_kind) :: first_time, last_time
    integer :: header_block_num, index_block_num, data_block_num
    integer :: header_block_len, index_block_len, data_block_len
    type(block_type) :: data_block, header_block
    real(r_kind), pointer :: last_value(:)
  end type

  type, private :: cmp3_ptr_type
    type(cmp3_type), pointer :: cmp3
  end type

  type(cmp3_type), pointer, private :: cmp3  !-- Scratch use only.  Not saved.
  type(cmp3_ptr_type), private :: cmp3_ptr   !-- Scratch use only.  Not saved.

  !-- Public procedures.
  public open_th_write_cmp3, close_th_write_cmp3, write_th_cmp3

  !-- Forward reference for private procedures.
  private put_header, put_frame, put_cmp3, write_block, read_block, add_key

contains

  subroutine open_th_write_cmp3 (gen, file_name, &
       signal_names, eu_names, dt, file_title, format_parameters, error)

    !-- Open a cmp3 file for writing.
    !-- 31 Jul 92, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)
         !-- Generic array for format-specific data.  Null on entry.
    character*(*), intent(in) :: file_name
    character*(*), intent(in) :: signal_names(:)
    character*(*), intent(in), optional :: eu_names(:)
    real(r_kind), intent(in), optional :: dt  !-- 0 or omitted means unknown.
    character*(*), intent(in), optional :: file_title  !-- Default is none.
    real(r_kind), intent(in), optional :: format_parameters(:)
         !-- Format-specific parameters.
         !-- For cmp3, first parameter is data precision (3, 4, or 8).
         !-- Zero or omitted data precision defaults to 3.
    logical, intent(out) :: error             !-- Returns true if open fails.

    !-------------------- local.
    integer :: iostat, open_size, rec_len, i, title_len
    integer :: n_signals
    character :: temp_char*16, where*8
    type(block_type), pointer :: index_block
    type(byte_type) :: header_data(80)  !-- Big enough for title.
    type(byte_type) :: names_header(size(signal_names)*16)

    !-------------------- executable code.

    !-- Allocate the gen array and cmp3 record.
    where = 'allocate'
    nullify(cmp3)
    i = size(transfer(cmp3_ptr, gen))
    allocate(gen(i), stat=iostat)
    if (iostat /= 0) goto 8000
    n_signals = size(signal_names)
    allocate(cmp3, stat=iostat)
    if (iostat /= 0) goto 8000
    cmp3_ptr%cmp3 => cmp3
    gen = transfer(cmp3_ptr, gen)
    cmp3%flush_on_close = .false.
    nullify(cmp3%last_value)
    allocate(cmp3%last_value(n_signals), stat=iostat)
    if (iostat /= 0) goto 8000

    !-- Open the file.
    where = 'open'
    call assign_lun(cmp3%lun)
    inquire(iolength=open_size) cmp3%data_block
    open(cmp3%lun, file=file_name, form='unformatted', iostat=iostat, &
         access='direct', recl=open_size, &
         status='replace', action='readwrite')
    if (iostat /= 0) goto 8000

    !-- Initialize various stuff.
    cmp3%base_time = 0.
    cmp3%time_scale = 1._r_kind/4096
    cmp3%time_key_offset = 2**20
    cmp3%full_frame_interval = 200
    cmp3%n_frames = 0
    cmp3%prev_full_frame = -cmp3%full_frame_interval - 1
    cmp3%first_time = 0.
    cmp3%last_time = 0.
    cmp3%last_value = 0.

    !-- Allocate and initialize the first header block.
    cmp3%n_blocks = 1
    cmp3%header_block%body = zero_byte
    cmp3%header_block_len = 0
    call put_i1(cmp3%header_block%body, cmp3%header_block_len, &
         header_block_code)
    cmp3%header_block_num = 1
    cmp3%header_block_len = block_head_len

    !-- Set data precision.
    where = 'precision'
    cmp3%data_precision = 3
    if (present(format_parameters)) then
      if (size(format_parameters)>=1) cmp3%data_precision=format_parameters(1)
    end if
    if (cmp3%data_precision == 0) cmp3%data_precision = 3
    if ( (cmp3%data_precision /= 3) .and. (cmp3%data_precision /= 4) .and. &
         (cmp3%data_precision /= 8)) goto 8000

    !---------- write header records.
    where = 'headers'

    !-- format header.
    rec_len = 0
    temp_char(1:8) = 'cmp 3'
    temp_char(9:16) = '.2'
    call put_char(header_data, rec_len, temp_char)
    call put_header(3, 'format', header_data, rec_len, error)
    if (error) goto 8000

    !-- blocks header.
    !-- Dummy for now.  Will be rewritten on close.
    header_data = zero_byte
    call put_header(0, 'blocks', header_data, 28, error)
    if (error) goto 8000

    !-- nChans header.
    rec_len = 0
    i = n_signals
    if (cmp3%data_precision /= 3) i = i + 65536*cmp3%data_precision
    call put_i4(header_data, rec_len, i)
    call put_header(1, 'nChans', header_data, rec_len, error)
    if (error) goto 8000

    !-- timeKey header.
    rec_len = 0
    call put_r8(header_data, rec_len, cmp3%base_time)
    call put_r8(header_data, rec_len, cmp3%time_scale)
    call put_i4(header_data, rec_len, cmp3%time_key_offset)
    call put_i4(header_data, rec_len, cmp3%full_frame_interval)
    call put_header(0, 'timeKey', header_data, rec_len, error)
    if (error) goto 8000

    !-- names header.
    !-- Note this is the first header without a hard-wired length.
    rec_len = 0
    do i = 1 , n_signals
      temp_char = signal_names(i)
      call put_char(names_header, rec_len, temp_char)
    end do
    call put_header(67, 'names', names_header, rec_len, error)
    if (error) goto 8000

    !-- optional title header.
    if (present(file_title)) then
      title_len = min(80,len_trim(file_title))
      if (title_len > 0) then
        rec_len = 0
        call put_char(header_data, rec_len, file_title(:title_len))
        call put_header(3, 'title', header_data, rec_len, error)
        if (error) goto 8000
      end if
    end if

    !-- optional dt header.
    if (present(dt)) then
      if (dt > 0.) then
        rec_len = 0
        call put_r4(header_data,rec_len,dt)
        call put_header(2, 'dt', header_data, rec_len, error)
        if (error) goto 8000
      end if
    end if

    !-- optional units header.
    if (present(eu_names)) then
      rec_len = 0
      do i = 1 , n_signals
        temp_char = eu_names(i)
        call put_char(names_header, rec_len, temp_char)
      end do
      call put_header(67, 'units', names_header, rec_len, error)
      if (error) goto 8000
    end if

    !-- Flush the last (so far) header block.
    call write_block(cmp3%lun, cmp3%header_block, cmp3%header_block_num, error)
    if (error) goto 8000

    !-- Initialize an empty index.
    cmp3%n_keys = 0
    cmp3%index_count = 0
    cmp3%index_div = 1

    !-- Allocate and write an empty index block.
    !-- Use the data_block array as it's not currently otherwise in use.
    index_block => cmp3%data_block
    cmp3%n_blocks = cmp3%n_blocks + 1
    cmp3%first_index_block = cmp3%n_blocks
    cmp3%n_index_blocks = 1
    index_block%body = zero_byte
    cmp3%index_block_len = 0
    call put_i1(index_block%body, cmp3%index_block_len, index_block_code)
    cmp3%index_block_num = cmp3%n_blocks
    cmp3%index_block_len = block_head_len
    call write_block(cmp3%lun, index_block, cmp3%index_block_num, error)
    if (error) goto 8000

    !-- Allocate and initialize the first data block.
    cmp3%n_blocks = cmp3%n_blocks + 1
    cmp3%first_data_block = cmp3%n_blocks
    cmp3%data_block%body = zero_byte
    cmp3%data_block_len = 0
    call put_i1(cmp3%data_block%body, cmp3%data_block_len, data_block_code)
    cmp3%data_block_num = cmp3%n_blocks
    cmp3%data_block_len = block_head_len

    !---------- Normal exit.
    cmp3%flush_on_close = .true.
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_write_cmp3 failed at: '//where)
    if (associated(cmp3)) call close_th_write_cmp3(gen, error)
    error = .true.
    return
  end subroutine open_th_write_cmp3

  subroutine close_th_write_cmp3 (gen, error)

    !-- Close an output cmp3 file.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    logical, intent(out) :: error

    !-------------------- local.
    integer, parameter :: eod_key = 2**30
    integer :: rec_flags, rec_len, i
    integer :: end_of_header, end_of_data
    type(block_type), pointer :: index_block
    type(byte_type) :: header_data(32)  !-- Big enough for blocks header.

    !-------------------- executable code.

    cmp3_ptr = transfer(gen, cmp3_ptr)
    cmp3 => cmp3_ptr%cmp3

    error = .false.
    if (.not. cmp3%flush_on_close) goto 8000

    !-- Write an end-of-data frame.
    rec_flags = eod_flag
    call put_frame(eod_key, rec_flags, error=error)
    if (error) goto 8000

    !-- Flush the last data block.
    call write_block(cmp3%lun, cmp3%data_block, cmp3%data_block_num, error)
    if (error) goto 8000
    end_of_data = (cmp3%data_block_num-1)*block_size + cmp3%data_block_len

    !-- Rewrite the index block.
    !-- Use the data_block array as it's not currently otherwise in use.
    index_block => cmp3%data_block
    index_block%body = zero_byte
    cmp3%index_block_len = 0
    call put_i1(index_block%body, cmp3%index_block_len, index_block_code)
    cmp3%index_block_num = cmp3%first_index_block
    cmp3%index_block_len = block_head_len
    call put_i1(index_block%body, cmp3%index_block_len, cmp3%n_keys)
    cmp3%index_block_len = 8
    do i = 1 , cmp3%n_keys
      call put_i4(index_block%body, cmp3%index_block_len, cmp3%index_key(i))
      call put_i4(index_block%body, cmp3%index_block_len, cmp3%index_pos(i))
    end do
    call write_block(cmp3%lun, index_block, cmp3%index_block_num, error)
    if (error) goto 8000

    !---------- Add final headers.
    !-- times header.
    rec_len = 0
    call put_r8(header_data, rec_len, cmp3%first_time)
    call put_r8(header_data, rec_len, cmp3%last_time)
    call put_i4(header_data, rec_len, cmp3%n_frames)
    call put_header(0, 'times', header_data, rec_len, error)
    if (error) goto 8000
    !-- endHead header.
    call put_header(0, 'endHead', error=error)
    if (error) goto 8000

    !-- Flush the last header block.
    call write_block(cmp3%lun, cmp3%header_block, cmp3%header_block_num, error)
    if (error) goto 8000

    !-- Update the blocks header.
    end_of_header = (cmp3%header_block_num-1)*block_size &
         + cmp3%header_block_len
    call read_block(cmp3%lun, 1, cmp3%header_block, error)
    if (error) goto 8000
    rec_len = 0
    call put_i4(header_data, rec_len, block_size)
    call put_i4(header_data, rec_len, cmp3%n_blocks)
    call put_i4(header_data, rec_len, end_of_header)
    call put_i4(header_data, rec_len, cmp3%first_index_block)
    call put_i4(header_data, rec_len, cmp3%n_index_blocks)
    call put_i4(header_data, rec_len, cmp3%first_data_block)
    call put_i4(header_data, rec_len, end_of_data)
    !-- Hard-wired location in first header block.
    !-- 31 = 4(block header) + 11 (format record header)
    !--      + 16 (format record body)
    cmp3%header_block_len = 31
    call put_header(0, 'blocks', header_data, rec_len, error)
    if (error) goto 8000
    call write_block(cmp3%lun, cmp3%header_block, 1, error)
    if (error) goto 8000

    !-- Close the file and release the lun and info area.
    8000 continue
    close(cmp3%lun)
    call release_lun(cmp3%lun)
    if (associated(cmp3%last_value)) deallocate(cmp3%last_value)
    deallocate(cmp3)
    return
  end subroutine close_th_write_cmp3

  subroutine write_th_cmp3 (gen, time, data, error)

    !-- Write a frame to a cmp3 file.
    !-- 10 Dec 92, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    real(r_kind), intent(in) :: time     !-- Frame time.
    real(r_kind), intent(in) :: data(:)  !-- Frame data.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: time_key, chan, data_len, data_pos
    integer :: n_signals, n_changes, bit_map_len
    type(byte_type) :: packed_data(8*size(data))
    type(byte_type) :: change_list(size(data)+1)
    type(byte_type) :: bit_map((size(data)-1)/8+1)
    real(r4_kind) :: temp_r4
    real(r_kind) :: new_value
    logical :: full_frame

    !-------------------- executable code.

    cmp3_ptr = transfer(gen, cmp3_ptr)
    cmp3 => cmp3_ptr%cmp3

    !-- Scale time.
    time_key = nint((time-cmp3%base_time)/cmp3%time_scale) &
         + cmp3%time_key_offset

    !-- Record frame counts and times.
    if (cmp3%n_frames == 0) cmp3%first_time = time
    cmp3%last_time = time
    cmp3%n_frames = cmp3%n_frames + 1

    n_signals = size(data)
    full_frame = cmp3%n_frames >= cmp3%prev_full_frame+cmp3%full_frame_interval

    !-- Pack data and generate bit map and change list.
    data_len = 0
    n_changes = 0
    bit_map = zero_byte
    bit_map_len = (n_signals-1)/8 + 1
    do chan = 1 , n_signals
      data_pos = data_len
      if (cmp3%data_precision == 3) then
        call put_r3(packed_data, data_len, real(data(chan),kind=r4_kind))
        call get_r3(packed_data, data_pos, temp_r4)
        new_value = real(temp_r4, kind=r_kind)
      else if (cmp3%data_precision == 4) then
        call put_r4(packed_data, data_len, data(chan))
        call get_r4(packed_data, data_pos, new_value)
      else
        call put_r8(packed_data, data_len, data(chan))
        new_value = data(chan)
      end if
      if (full_frame) then
        cmp3%last_value(chan) = new_value
      else if (new_value /= cmp3%last_value(chan)) then
        cmp3%last_value(chan) = new_value
        call put_i1(change_list, n_changes, chan)
        call set_bit(bit_map, chan)
      else
        data_len = data_len - cmp3%data_precision
      end if
    end do

    !---------- Write in appropriate format.
    !-- Full frame.
    if (full_frame) then
      cmp3%prev_full_frame = cmp3%n_frames
      call put_frame(time_key, full_frame_flag, packed_data, data_len, &
           error=error)
    !-- Change list.
    else if (n_signals<255 .and. n_changes<bit_map_len) then
      call put_i1(change_list, n_changes, 0)
      call put_frame(time_key, change_list_flag, packed_data, data_len, &
           change_list, n_changes, error)
    !-- Bit map.
    else
      call put_frame(time_key, bit_map_flag, packed_data, data_len, &
           bit_map, bit_map_len, error)
    end if
    return
  end subroutine write_th_cmp3

  subroutine put_header (data_code, header_name, header_data, data_len, &
       error)

    !-- Add a header record to a cmp3 file.
    !-- Requires that the cmp3 pointer be defined by calling routine.
    !-- 20 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: data_code
    character*(*), intent(in) :: header_name
    type(byte_type), intent(in), optional :: header_data(*)
         !-- Must be contiguous
    integer, optional, intent(in) :: data_len
         !-- Must be present if feader_data is.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: rec_len, data_len_temp
    integer, parameter :: rec_header_len = 11
    type(byte_type) :: rec_header(rec_header_len)
    character :: padded_header_name*8

    !-------------------- executable code.

    data_len_temp = 0
    if (present(header_data)) data_len_temp = data_len

    !-- Record header.
    rec_len = 0
    call put_i2(rec_header, rec_len, rec_header_len+data_len_temp)
    call put_i1(rec_header, rec_len, data_code)
    padded_header_name = header_name
    call put_char(rec_header, rec_len, padded_header_name)
    call put_cmp3(rec_header, rec_header_len, cmp3%header_block, &
         cmp3%header_block_num, cmp3%header_block_len, error)
    if (error) return

    !-- Record data body.
    if (data_len_temp > 0) call put_cmp3(header_data, data_len_temp, &
         cmp3%header_block, cmp3%header_block_num, cmp3%header_block_len, &
         error)
    return
  end subroutine put_header

  subroutine put_frame (time_key, rec_flags, data_vec, data_vec_len, &
       chan_vec, chan_vec_len, error)

    !-- Add a data frame to a cmp3 file.
    !-- Requires that the cmp3 pointer be defined by calling routine.
    !-- 20 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: time_key
    integer, intent(in) :: rec_flags
    type(byte_type), optional, intent(in) :: data_vec(*)
         !-- Must be contiguous
    integer, optional, intent(in) :: data_vec_len
         !-- Must be present if data_vec is.
    type(byte_type), optional, intent(in) :: chan_vec(*)
         !-- Must be contiguous
    integer, optional, intent(in) :: chan_vec_len
         !-- Must be present if chan_vec is.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: rec_len, data_pos, tot_len
    integer, parameter :: rec_header_len = 7
    type(byte_type) :: rec_header(rec_header_len)

    !-------------------- executable code.

    !-- Index full frames and end-of-data frame.
    if (rec_flags == full_frame_flag .or. rec_flags == eod_flag) then
      data_pos = (cmp3%data_block_num-1)*block_size + cmp3%data_block_len
      call add_key(time_key, data_pos, rec_flags/=eod_flag)
    end if

    !-- Record header.
    rec_len = 0
    tot_len = rec_header_len
    if (present(data_vec)) tot_len = tot_len + data_vec_len
    if (present(chan_vec)) tot_len = tot_len + chan_vec_len
    call put_i2(rec_header, rec_len, tot_len)
    call put_i4(rec_header, rec_len, time_key)
    call put_i1(rec_header, rec_len, rec_flags)
    call put_cmp3(rec_header, rec_header_len, cmp3%data_block, &
         cmp3%data_block_num, cmp3%data_block_len, error)
    if (error) return

    !-- Channel flags and data.
    if (present(chan_vec)) call put_cmp3(chan_vec, chan_vec_len, &
         cmp3%data_block, cmp3%data_block_num, cmp3%data_block_len, error)
    if (error) return
    if (present(data_vec)) call put_cmp3(data_vec, data_vec_len, &
         cmp3%data_block, cmp3%data_block_num, cmp3%data_block_len, error)
    return
  end subroutine put_frame

  subroutine add_key (time_key, data_pos, may_thin)

    !-- Add an index key to a cmp3 file.
    !-- Requires that the cmp3 pointer be defined by calling routine.
    !-- 20 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: time_key
    integer, intent(in) :: data_pos
    logical, intent(in) :: may_thin

    !-------------------- executable code.

    !-- Count and thin entries.
    cmp3%index_count = cmp3%index_count + 1
    if (mod(cmp3%index_count-1,cmp3%index_div) /= 0 .and. may_thin) return

    !-- Add this entry.
    cmp3%n_keys = cmp3%n_keys + 1
    cmp3%index_key(cmp3%n_keys) = time_key
    cmp3%index_pos(cmp3%n_keys) = data_pos

    !-- If all entries are used, thin them further.
    if (cmp3%n_keys >= max_index .and. may_thin) then
      cmp3%index_div = 2*cmp3%index_div
      cmp3%n_keys = max_index/2 + 1
      cmp3%index_key(1:cmp3%n_keys) = cmp3%index_key(::2)
      cmp3%index_pos(1:cmp3%n_keys) = cmp3%index_pos(::2)
      cmp3%index_key(cmp3%n_keys+1:) = 0
      cmp3%index_pos(cmp3%n_keys+1:) = 0
    end if
    return
  end subroutine add_key

  subroutine put_cmp3 (data, data_len, block, block_num, block_len, error)

    !-- Put bytes into a cmp3 header block or data block.
    !-- Flush full blocks and start new ones as needed.
    !-- Requires that the cmp3 pointer be defined by calling routine.
    !-- 20 Jun 90, Richard Maine.

    !-------------------- interface.
    type(byte_type), intent(in) :: data(*)  !-- Must be contiguous.
    integer, intent(in) :: data_len
    type(block_type), intent(inout) :: block
    integer, intent(inout) :: block_num
         !-- Current block number.
         !-- Updated on return if a new block is started.
    integer, intent(inout) :: block_len
         !-- Currently used length of the block.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: done_len, part_len

    !-------------------- executable code.

    error = .false.
    done_len = 0

    block_loop: do

      !-- Put as much as fits in current block.
      part_len = min(data_len-done_len,block_size-block_len)
      if (part_len /= 0) call copy_bytes &
           (data, done_len, block%body, block_len, part_len)

      !-- Exit loop if done.
      if (done_len >= data_len) exit block_loop

      !-- Allocate a new block and chain forward to it.
      cmp3%n_blocks = cmp3%n_blocks + 1
      block_len = 1
      call put_i3(block%body, block_len, cmp3%n_blocks)

      !-- Flush the old block.
      call write_block(cmp3%lun, block, block_num, error)
      if (error) return

      !-- Clear the new block.
      block%body(2:) = zero_byte  !-- Don't wipe block code in the first byte.
      block_num = cmp3%n_blocks
      block_len = block_head_len
    end do block_loop
    return
  end subroutine put_cmp3

  subroutine write_block (lun, block, block_num, error)

    !-- Write a block to a cmp3 file.
    !-- 21 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: lun  !-- Logical unit number
    type(block_type), intent(inout) :: block
    integer, intent(in) :: block_num
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat

    !-------------------- executable code.

    !-- Write to the file.
    write(lun, rec=block_num, iostat=iostat) block
    error = iostat /= 0
    if (error) then
      call write_sys_error(iostat)
      call write_error_msg('Error writing cmp3 file.')
    end if
    return
  end subroutine write_block

  subroutine read_block (lun, block_num, block, error)

    !-- Read a block from a cmp3 file.
    !-- This is identical to the one in the th_read_cmp3 module,
    !-- but we want to keep the read and write modules independent.
    !-- 21 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: lun  !-- Logical unit number
    integer, intent(in) :: block_num
    type(block_type), intent(out) :: block
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat

    !-------------------- executable code.

    !-- Read from the file.
    read(lun, rec=block_num, iostat=iostat) block
    error = iostat /= 0
    if (error) then
      call write_sys_error(iostat)
      call write_error_msg('Error rewriting cmp3 file.')
      return
    end if
    return
  end subroutine read_block

end module th_write_cmp3
