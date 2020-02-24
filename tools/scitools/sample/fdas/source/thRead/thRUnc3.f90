!-- thRUnc3.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module th_read_unc3

  !-- Module for reading unc3 format time history files.
  !-- Intended for calling from the th_read module.
  !-- We rely on th_read for much of the call validity testing.
  !-- 13 Aug 90, Richard Maine.

  use precision
  use sysdep_io
  use binary
  use string
  use th_read_gen

  implicit none
  private

  !-- Identifying string for automatic format determination.
  character*(*), public, parameter :: unc3_format_string='unc3'

  integer, parameter :: eod_key = -1

  integer, parameter :: block_size = 2048

  type :: block_type
    type(byte_type) :: body(block_size)
  end type

  type :: unc3_type
    integer :: lun
         !-- Fortran logical unit number.  More convenient here than in gen.
    integer :: data_start_block_num, data_start_block_pos
    real(r_kind) :: time_scale
    type(block_type) :: block
    integer :: block_num  !-- Block number (numbered from 1).
    integer :: block_pos  !-- File position relative to block start.
    logical :: block_loaded  !-- Is a block currently loaded?
  end type

  type :: unc3_ptr_type
    type(unc3_type), pointer :: unc3
  end type

  type(unc3_type), pointer :: unc3  !-- Scratch use only.  Not saved.
  type(unc3_ptr_type) :: unc3_ptr   !-- Scratch use only.  Not saved.

  !-- Public procedures.
  public open_th_read_unc3, close_th_read_unc3, seek_th_unc3, read_th_unc3

  !-- Forward reference for private procedures.
  private get_header, get_unc3, read_block

contains

  subroutine open_th_read_unc3 (gen, file_name, n_signals, error)

    !-- Open an unc3 file for reading.
    !-- 13 Aug 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Already allocated on entry.
    character*(*), intent(in) :: file_name
    integer, intent(out) :: n_signals       !-- Number of available signals.
    logical, intent(out) :: error

    !-------------------- local.
    character :: where*8, header_name*8
    character :: signal_name*16, eu_name*16
    integer :: open_size, rec_pos, header_data_len, title_len, i_scale
    integer :: iostat, i, max_header_size
    integer, parameter :: small_size=16  !-- Big enough for format header.
    type(byte_type) :: small_header(small_size)
    type(byte_type), allocatable :: header_data(:)  !-- Must be contiguous

    !-------------------- executable code.

    !-- Allocate the unc3 record.
    where = 'allocate'
    nullify(unc3)
    i = size(transfer(unc3_ptr,gen%format_specific_data))
    allocate(gen%format_specific_data(i), stat=iostat)
    if (iostat /= 0) goto 8000
    allocate(unc3, stat=iostat)
    if (iostat /= 0) goto 8000
    unc3_ptr%unc3 => unc3
    gen%format_specific_data = transfer(unc3_ptr, gen%format_specific_data)

    !-- Open the file.
    where = 'open'
    call assign_lun(unc3%lun)
    inquire(iolength=open_size) unc3%block
    open (unc3%lun, file=file_name, form='unformatted', &
         access='direct', recl=open_size, &
         iostat=iostat, status='old', action='read')
    if (iostat /= 0) goto 8000

    unc3%block_num = 1
    unc3%block_pos = 0
    unc3%block_loaded = .false.

    !---------- Read required header records.
    !-- Note that we don't validate the header_data_lengths in cases
    !-- where they are supposed to be known.

    !-- format header.
    where = 'format'
    call get_header(small_header, small_size, header_data_len, error, &
         expect='format')
    if (error) goto 8000

    !-- nChans header.
    where = 'nChans'
    call get_header(small_header, small_size, header_data_len, error, &
         expect='nChans')
    if (error) goto 8000
    rec_pos = 0
    call get_i4(small_header, rec_pos, n_signals)

    where = 'allocate'
    call all_th_read_gen(gen, n_signals, error)
    if (error) goto 8000
    max_header_size = max(16*n_signals, 80)
    allocate (header_data(max_header_size), stat=iostat)
    if (iostat /= 0) goto 8000

    !-- timeKey header.
    where = 'timeKey'
    call get_header(header_data, max_header_size, header_data_len, error, &
         expect='timeKey')
    if (error) goto 8000
    rec_pos = 0
    call get_i4(header_data, rec_pos, i_scale)
    unc3%time_scale = i_scale/1000000._r_kind

    !-- title header.
    where = 'title'
    call get_header(header_data, max_header_size, header_data_len, error, &
         expect='title')
    if (error) goto 8000
    title_len = min(header_data_len,len(gen%file_title))
    rec_pos = 0
    call get_char(header_data, rec_pos,gen%file_title(:title_len))

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

    !---------- Read optional headers.
    where = 'endHead'
    header_loop: do
      call get_header(header_data, max_header_size, header_data_len, error, &
           header_name)
      if (error) goto 8000
      if (string_eq(header_name, 'endHead')) exit header_loop
      if (string_eq(header_name, 'dt')) then
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

    !-- Save file position for rewind.
    unc3%data_start_block_num = unc3%block_num
    unc3%data_start_block_pos = unc3%block_pos

    !-- Normal exit.
    deallocate (header_data)
    gen%previous_time = -big_real
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('Open_th_read_unc3 failed at: '//where)
    if (allocated(header_data)) deallocate(header_data)
    if (associated(unc3)) call close_th_read_unc3(gen)
    error = .true.
    return
  end subroutine open_th_read_unc3

  subroutine close_th_read_unc3 (gen)

    !-- Close an unc3 file for reading.
    !-- 6 Jul 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen
         !-- Generic file descriptor.  Do not deallocate here.

    !-------------------- executable code.

    if (associated(gen%format_specific_data)) then

      unc3_ptr = transfer(gen%format_specific_data, unc3_ptr)
      unc3 => unc3_ptr%unc3

      close (unc3%lun)
      call release_lun(unc3%lun)
      deallocate(unc3)
    end if
    return
  end subroutine close_th_read_unc3

  subroutine seek_th_unc3 (gen, start_time, error)

    !-- Seek to a time interval on an unc3 file.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen          !-- Generic file descriptor.
    real(r_kind), intent(in) :: start_time  !-- Requested interval start time.
    logical, intent(out) :: error

    !-------------------- executable code.

    unc3_ptr = transfer(gen%format_specific_data, unc3_ptr)
    unc3 => unc3_ptr%unc3

    !-- Rewind if seeking backwards.
    if (start_time <= gen%previous_time) then
      unc3%block_num = unc3%data_start_block_num
      unc3%block_pos = unc3%data_start_block_pos
      unc3%block_loaded = .false.
      gen%previous_time = -big_real
    end if

    !-- Normal exit.
    error = .false.
    return
  end subroutine seek_th_unc3

  subroutine read_th_unc3 (gen, time, data, status)

    !-- Read a frame from an unc3 file.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(gen_type), pointer :: gen        !-- Generic file descriptor.
    real(r_kind), intent(out) :: time     !-- Returned frame time.
    real(r_kind), intent(out) :: data(:)  !-- Returned frame data.
    integer, intent(out) :: status        !-- See read_th for codes.

    !-------------------- local.
    integer, parameter :: rec_header_len = 4
    type(byte_type) :: rec_header(rec_header_len)
    integer :: rec_pos, time_key, i
    type(byte_type) :: data_rec(gen%n_signals*4)
    real(r_kind) :: all_data(0:gen%n_signals)
    logical :: error

    !-------------------- executable code.

    unc3_ptr = transfer(gen%format_specific_data, unc3_ptr)
    unc3 => unc3_ptr%unc3

    status = thr_error
    !-- Read the record header.
    call get_unc3(rec_header, rec_header_len, error)
    if (error) goto 8000
    rec_pos = 0
    call get_i4(rec_header, rec_pos, time_key)

    !-- Read the record body.
    if (time_key == eod_key) then
      status = thr_eod
      goto 8000
    end if
    call get_unc3(data_rec, size(data_rec), error)
    if (error) goto 8000

    !-- Compute time.
    time = time_key*unc3%time_scale

    !-- Unpack data.
    rec_pos = 0
    do i = 1 , gen%n_signals
      call get_r4(data_rec, rec_pos, all_data(i))
    end do
    status = thr_ok

    !-- Select signals.
    all_data(0) = 0.
    data = all_data(gen%channel_map)

    !-- Normal exit.
    gen%previous_time = time
    return

    !---------- Error exit.
    8000 continue
    gen%previous_time = big_real
    return
  end subroutine read_th_unc3

  subroutine get_header (data, max_data_len, data_len, error, &
       header_name, expect)

    !-- Read an unc3 header.
    !-- unc3 pointer be must be defined by calling routine.
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
    integer, parameter :: rec_header_len = 10
    type(byte_type) :: rec_header(rec_header_len)
    integer :: rec_pos, tot_len
    character :: h_name*8

    !-------------------- executable code.

    call get_unc3(rec_header, rec_header_len, error)
    if (error) return
    rec_pos = 0
    call get_i2(rec_header, rec_pos, tot_len)
    call get_char(rec_header, rec_pos, h_name)
    if (present(header_name)) header_name = h_name
    if (present(expect)) error = .not. string_eq(h_name, expect)
    data_len = tot_len - rec_header_len
    error = error .or. data_len < 0  .or. data_len > max_data_len
    if (error) return
    call get_unc3(data, data_len, error)
    return
  end subroutine get_header

  subroutine get_unc3 (data, data_len, error)

    !-- Get bytes from a unc3 file.
    !-- unc3 pointer be must be defined by calling routine.
    !-- Starts at current file position.
    !-- Concatenates data from multiple blocks as needed.
    !-- 2 Jul 90, Richard Maine.

    !-------------------- interface.
    type(byte_type), intent(out) :: data(*)  !-- Must be contiguous
    integer, intent(in) :: data_len
         !-- Number of bytes to be read.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: done_len, part_len

    !-------------------- executable code.

    !-- Load initial block if needed.
    if (.not. unc3%block_loaded) then
      call read_block(unc3%lun, unc3%block_num, unc3%block, error)
      unc3%block_loaded = .not. error
      if (error) return
    end if

    done_len = 0
    block_loop: do

      !-- Get as much as can from current block.
      part_len = min(data_len-done_len, block_size-unc3%block_pos)
      if (part_len /= 0)  call copy_bytes &
           (unc3%block%body, unc3%block_pos, data, done_len, part_len)

      !-- Go to subsequent blocks as needed.
      if (done_len >= data_len) exit block_loop
      unc3%block_num = unc3%block_num + 1
      unc3%block_pos = 0
      call read_block(unc3%lun, unc3%block_num, unc3%block, error)
      unc3%block_loaded = .not. error
      if (error) return
    end do block_loop
    error = .false.
    return
  end subroutine get_unc3

  subroutine read_block (lun, block_num, block, error)

    !-- Read a block from a unc3 file.
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
      call write_error_msg('Error reading unc3 file.')
    end if
    return
  end subroutine read_block

end module th_read_unc3
