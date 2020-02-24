program gdTest

  !-- Stub main program to test gd_read module.

  use precision
  use sysdep_io
  use gd_read
  use th_write

  implicit none

  type(gd_handle_type) :: handle
  type(th_write_handle_type) :: w_handle
  character :: file_name*128
  logical :: error
  integer :: n_sources, n_signals, i_src, offset, n_req, status
  type(gd_source_type), pointer :: sources(:)
  character, pointer :: signal_names(:)*16, requested_signals(:)*16
  integer, parameter :: n_filt=2
  character*16 :: filtered_signals(n_filt), filter_inputs(n_filt)
  real(r_kind) :: time
  real(r_kind), pointer :: data(:)

  call system_init

  write (*,*) 'Hello, world.'
  call open_gd(handle)
  write (*,*) 'gd_read opened.'

  !-- Open an input file and define a filter.

  file_name = 'input.data'
  call file_gd(handle, file_name, file_dt=.04_r_kind, &
       file_interpolate=.true., error=error)
  write (*,*) 'file opened ok.', .not. error

  filtered_signals(1) = 'alpha-f'
  filtered_signals(2) = 'mach-f'
  filter_inputs(1) = 'alpha'
  filter_inputs(2) = 'mach'
  call filter_gd (handle, 'low3filt', filter_parameters=(/ 2._r_kind /), &
       signal_names=filter_inputs, output_names=filtered_signals, &
       print_warning=.true., error=error)
  call sync_gd (handle, filtered_signals, &
       skew=spread(-.5_r_kind,1,size(filtered_signals)))
  write (*,*) 'filter opened ok.', .not. error

  !-- Inquire about what we opened.

  call inquire_gd(handle, n_sources=n_sources, n_signals=n_signals)
  write (*,*) 'n_sources = ', n_sources,' n_signals = ',n_signals
  allocate(sources(n_sources), signal_names(n_signals))
  call inquire_gd(handle, sources=sources, signal_names=signal_names)
  do i_src = 1 , n_sources
    write (*,*) 'Source ', i_src, ' code ',sources(i_src)%source_code
    write (*,*) 'source name: ',sources(i_src)%source_name
    write (*,*) 'source dt = ',sources(i_src)%source_dt
    offset = sources(i_src)%source_signal_offset
    write (*,*) 'source n_signals, offset = ', &
         sources(i_src)%n_source_signals, offset
    write (*,*) signal_names(offset+1:offset+sources(i_src)%n_source_signals)
  end do

  !-- Process and write the filtered signals to an output file.

  n_req = 2
  allocate(requested_signals(n_req), data(n_req))
  requested_signals(1) = 'alpha-f'
  requested_signals(2) = 'mach-f'
  write (*,*) 'Requesting signals: ', requested_signals
  call request_gd_signals(handle, requested_signals)

  write (*,*) 'Seeking.'
  call seek_gd(handle, dt=.1_r_kind)
  write (*,*) 'Seek ok.'
  !--- To test cmp3 format, change the asc2 in the following line to cmp3.
  call open_th_write(w_handle, 'output.data', 'asc2', requested_signals)
  do
    call read_gd(handle, time, data, status)
    if (status /= 0) exit
    call write_th(w_handle, time, data)
  end do
  write (*,*) 'read_gd exit status = ',status
  call close_th_write(w_handle)

  !-- Open the file just written as a second input file.
  call file_gd(handle, 'output.data', file_dt=.1_r_kind, &
       file_interpolate=.true., error=error)
  write (*,*) 'file opened ok.', .not. error
  call sync_gd (handle, (/'#2#alpha-f'/), skew=(/.5_r_kind/))

  !-- Request some signals and write them to std_out.

  n_req = 5
  deallocate(requested_signals, data)
  allocate(requested_signals(n_req), data(n_req))
  requested_signals(1) = 'alpha'
  requested_signals(2) = 'alpha-f'
  requested_signals(3) = '#2#alpha-f'
  requested_signals(4) = 'mach'
  requested_signals(5) = 'mach-f'
  write (*,*) 'Requesting signals: ', requested_signals
  call request_gd_signals(handle, requested_signals)

  write (*,*) 'Seeking.'
  call seek_gd(handle, dt=0.5_r_kind)
  write (*,*) 'Seek ok.'
  call open_th_write(w_handle, '$stdout', 'lis1', requested_signals)
  do
    call read_gd(handle, time, data, status)
    if (status /= 0) exit
    call write_th(w_handle, time, data)
  end do
  write (*,*) 'read_gd exit status = ',status
  call close_th_write(w_handle)

  call close_gd(handle)

  write (*,*) 'Bye.'
  call system_stop
end program
