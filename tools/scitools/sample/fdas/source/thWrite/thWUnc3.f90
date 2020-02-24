!-- thWUnc3.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_write_unc3

  !-- Module for writing unc3 format time history files.
  !-- Intended for calling from the th_write module.
  !-- We rely on th_write for much of the call validity testing.
  !-- Possible system-dependencies in the open and write statements.
  !-- 13 Aug 90, Richard Maine.

  use precision
  use binary
  use sysdep_io

  implicit none
  private

  !-- Identifying string for format specification.
  character*(*), public, parameter :: unc3_format_string='unc3'

  integer, parameter, private :: block_size=2048

  type block_type
    type(byte_type) :: body(block_size)
  end type

  type unc3_type
    integer :: lun
    logical :: flush_on_close
    real(r_kind) :: time_scale
    integer :: n_blocks
    type(block_type) :: block
    integer :: block_len
  end type

  type unc3_ptr_type
    type(unc3_type), pointer :: unc3
  end type

  type(unc3_type), pointer :: unc3  !-- Scratch use only.  Not saved.
  type(unc3_ptr_type) :: unc3_ptr   !-- Scratch use only.  Not saved.

  !-- Public procedures.
  public open_th_write_unc3, close_th_write_unc3, write_th_unc3

  !-- Forward reference for private procedures.
  private put_header, put_unc3, write_block

contains

  subroutine open_th_write_unc3 (gen, file_name, &
       signal_names, eu_names, dt, file_title, error)

    !-- Open an unc3 file for writing.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)
         !-- Generic array for format-specific data.  Null on entry.
    character*(*), intent(in) :: file_name
    character*(*), intent(in) :: signal_names(:)
    character*(*), intent(in), optional :: eu_names(:)
    real(r_kind), intent(in), optional :: dt  !-- 0 or omitted means unknown.
    character*(*), intent(in), optional :: file_title  !-- Default is none.
    logical, intent(out) :: error             !-- Returns true if open fails.

    !-------------------- local.
    integer :: iostat, open_size, rec_len, i
    integer :: n_signals, micro_time_scale
    character :: temp_char*16, padded_title*80, where*8
    type(byte_type) :: header_data(80)  !-- Big enough for title.
    type(byte_type) :: names_header(size(signal_names)*16)

    !-------------------- executable code.

    !-- Allocate the gen array and unc3 record.
    where = 'allocate'
    nullify(unc3)
    i = size(transfer(unc3_ptr, gen))
    allocate(gen(i), stat=iostat)
    if (iostat /= 0) goto 8000
    n_signals = size(signal_names)
    allocate(unc3, stat=iostat)
    if (iostat /= 0) goto 8000
    unc3_ptr%unc3 => unc3
    gen = transfer(unc3_ptr, gen)

    !-- Open the file.
    where = 'open'
    unc3%flush_on_close = .false.
    call assign_lun(unc3%lun)
    inquire(iolength=open_size) unc3%block
    open(unc3%lun, file=file_name, form='unformatted', iostat=iostat, &
         access='direct', recl=open_size, &
         status='replace', action='write')
    if (iostat /= 0) goto 8000

    !-- Initialize various stuff.
    unc3%time_scale = 1._r_kind/10000

    !-- Allocate and initialize the first block.
    unc3%n_blocks = 1
    unc3%block%body = zero_byte
    unc3%block_len = 0

    !---------- write header records.
    where = 'headers'

    !-- format header.
    rec_len = 0
    temp_char(1:8) = 'unc 3'
    temp_char(9:16) = '.1'
    call put_char(header_data, rec_len, temp_char)
    call put_header('format', header_data, rec_len, error)
    if (error) goto 8000

    !-- nChans header.
    rec_len = 0
    call put_i4(header_data, rec_len, n_signals)
    call put_header('nChans', header_data, rec_len, error)
    if (error) goto 8000

    !-- timeKey header.
    rec_len = 0
    micro_time_scale = nint(unc3%time_scale*1000000)
    call put_i4(header_data, rec_len, micro_time_scale)
    call put_header('timeKey', header_data, rec_len, error)
    if (error) goto 8000

    !-- title header.
    padded_title = ' '
    if (present(file_title)) then
      padded_title = file_title
    end if
    rec_len = 0
    call put_char(header_data, rec_len, padded_title)
    call put_header('title', header_data, rec_len, error)
    if (error) goto 8000

    !-- names header.
    !-- Note this is the first header without a hard-wired length.
    rec_len = 0
    do i = 1 , n_signals
      temp_char = signal_names(i)
      call put_char(names_header, rec_len, temp_char)
    end do
    call put_header('names', names_header, rec_len, error)
    if (error) goto 8000

    !-- optional dt header.
    if (present(dt)) then
      if (dt > 0.) then
        rec_len = 0
        call put_r4(header_data, rec_len, dt)
        call put_header('dt', header_data, rec_len, error)
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
      call put_header('units', names_header, rec_len, error)
      if (error) goto 8000
    end if

    !-- endHead header.
    call put_header('endHead', error=error)
    if (error) goto 8000

    !---------- Normal exit.
    unc3%flush_on_close = .true.
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_write_unc3 failed at: '//where)
    if (associated(unc3)) call close_th_write_unc3(gen, error)
    error = .true.
    return
  end subroutine open_th_write_unc3

  subroutine close_th_write_unc3 (gen, error)

    !-- Close an output unc3 file.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    logical, intent(out) :: error

    !-------------------- local.
    integer, parameter :: eod_key = -1
    integer :: rec_len
    type(byte_type) :: eod_data(4)

    !-------------------- executable code.

    unc3_ptr = transfer(gen, unc3_ptr)
    unc3 => unc3_ptr%unc3

    error = .false.
    if (.not. unc3%flush_on_close) goto 8000

    !-- Write an end-of-data frame.
    rec_len = 0
    call put_i4(eod_data, rec_len, eod_key)
    call put_unc3(eod_data, rec_len, error)
    if (error) goto 8000

    !-- Flush the last block.
    call write_block(unc3%lun, unc3%block, unc3%n_blocks, error)
    if (error) goto 8000

    !-- Close the file and release the lun and info area.
    8000 continue
    close(unc3%lun)
    call release_lun(unc3%lun)
    deallocate(unc3)
    return
  end subroutine close_th_write_unc3

  subroutine write_th_unc3 (gen, time, data, error)

    !-- Write a frame to an unc3 file.
    !-- 15 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, pointer  :: gen(:)  !-- Generic array for format-specific data.
    real(r_kind), intent(in) :: time     !-- Frame time.
    real(r_kind), intent(in) :: data(:)  !-- Frame data.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: time_key, chan, data_len
    type(byte_type) :: packed_data(4+4*size(data))

    !-------------------- executable code.

    unc3_ptr = transfer(gen, unc3_ptr)
    unc3 => unc3_ptr%unc3

    data_len = 0
    !-- Scale time.
    time_key = nint(time/unc3%time_scale)
    call put_i4(packed_data, data_len, time_key)

    !-- Pack data.
    do chan = 1 , size(data)
      call put_r4(packed_data, data_len, data(chan))
    end do

    !---------- Write it.
    call put_unc3(packed_data, data_len, error)
    return
  end subroutine write_th_unc3

  subroutine put_header (header_name, header_data, data_len, error)

    !-- Add a header record to an unc3 file.
    !-- Requires that the unc3 pointer be defined by calling routine.
    !-- 20 Jun 90, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: header_name
    type(byte_type), intent(in), optional :: header_data(*)
         !-- Must be contiguous
    integer, optional, intent(in) :: data_len
         !-- Must be present if feader_data is.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: rec_len, data_len_temp
    integer, parameter :: rec_header_len = 10
    type(byte_type) :: rec_header(rec_header_len)
    character :: padded_header_name*8

    !-------------------- executable code.

    data_len_temp = 0
    if (present(header_data)) data_len_temp = data_len

    !-- Record header.
    rec_len = 0
    call put_i2(rec_header, rec_len, rec_header_len+data_len_temp)
    padded_header_name = header_name
    call put_char(rec_header, rec_len, padded_header_name)
    call put_unc3(rec_header, rec_header_len, error)
    if (error) return

    !-- Record data body.
    if (data_len_temp > 0) call put_unc3(header_data, data_len_temp, error)
    return
  end subroutine put_header

  subroutine put_unc3 (data, data_len, error)

    !-- Put bytes to an unc3 file.
    !-- Flush full blocks and start new ones as needed.
    !-- Requires that the unc3 pointer be defined by calling routine.
    !-- 20 Jun 90, Richard Maine.

    !-------------------- interface.
    type(byte_type), intent(in) :: data(*)  !-- Must be contiguous
    integer, intent(in) :: data_len
    logical, intent(out) :: error

    !-------------------- local.
    integer :: done_len, part_len

    !-------------------- executable code.

    done_len = 0
    error = .false.

    block_loop: do

      !-- Put as much as fits in current block.
      part_len = min(data_len-done_len, block_size-unc3%block_len)
      if (part_len /= 0) call copy_bytes &
           (data, done_len, unc3%block%body, unc3%block_len, part_len)

      !-- Exit loop if done.
      if (done_len >= data_len) exit block_loop

      !-- Flush the old block.
      call write_block(unc3%lun, unc3%block, unc3%n_blocks, error)
      if (error) return

      !-- Allocate a new block.
      unc3%n_blocks = unc3%n_blocks + 1

      !-- Clear the new block.
      unc3%block%body = zero_byte
      unc3%block_len = 0
    end do block_loop
    return
  end subroutine put_unc3

  subroutine write_block (lun, block, block_num, error)

    !-- Write a block to an unc3 file.
    !-- 21 Jun 90, Richard Maine.

    !-------------------- interface.
    integer, intent(in) :: lun  !-- Logical unit number
    type(block_type), intent(in) :: block
    integer, intent(in) :: block_num
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat

    !-------------------- executable code.

    write(lun, rec=block_num, iostat=iostat) block
    error = iostat /= 0
    if (error) then
      call write_sys_error(iostat)
      call write_error_msg('Error writing unc3 file.')
    end if
    return
  end subroutine write_block

end module th_write_unc3
