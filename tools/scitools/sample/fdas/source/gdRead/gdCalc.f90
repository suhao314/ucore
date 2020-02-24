!-- gdCalc.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module gd_calc

  !-- Calculated function module for gd_read.
  !-- This main function of this module is managing the lists
  !-- of available and used signals relevant to the calculated functions.
  !-- 19 Oct 91, Richard Maine.

  use precision
  use sysdep_io
  use gd_list
  use link_calc
  use gd_common

  implicit none
  private

  !-- calc_signal_type has data about a calculated function signal.
  !-- It is used for both inputs and outputs to the cf.
  type calc_signal_type
    character :: name*(signal_name_len)
    logical :: used       !-- Is this signal used?
    integer :: signal_number  !-- map to the list of get_data signals.
    real(r_kind) :: data
  end type

  !-- calc_used_signal_type has data about a used calculated function signal.
  type :: calc_used_signal_type
    integer :: signal_number  !-- map to the list of get_data signals.
    integer :: full_map   !-- map to the full signal list for this calc.
  end type

  !-- calc_type has data about a calculated function set.
  type :: calc_type
    logical :: opened     !-- Is this calc opened or free?
    logical :: calc_used  !-- Is anything from this calc used?
    type(calc_handle_type) :: calc_handle  !-- handle from open_gd_calc.
    type(gd_source_type), pointer :: source
         !-- Generic information about the data source.
    character :: calc_linker*128  !-- Input for open_gd_calc.
    integer :: n_inputs, n_outputs
         !-- Total number of input and output signals for the calc.
    integer :: n_used_inputs, n_used_outputs
         !-- Number of used input and output signals for the calc.
    type(calc_signal_type), pointer :: output(:)
    type(calc_signal_type), pointer :: input(:)
    type(calc_used_signal_type), pointer :: used_input(:)
    type(calc_used_signal_type), pointer :: used_output(:)
    type(calc_type), pointer :: next_calc, prev_calc
         !-- Doubly-linked list of calcs for the get_data object.
  end type

  type, public :: calc_list_type
    private
    type(calc_type), pointer :: first_calc, last_calc
  end type

  !-- Public procedures.
  public init_gd_calc_list, add_gd_calc, close_gd_calcs, activate_gd_calcs
  public do_gd_calcs

  !-- Forward reference for private procedures.
  private release_gd_calc

contains

  subroutine init_gd_calc_list (calc_list)

    !-- Initialize an empty calc_list for gd_read.
    !-- 19 Oct 91, Richard Maine.

    !-------------------- interface.
    type(calc_list_type), intent(out) :: calc_list

    !-------------------- executable code.

    nullify(calc_list%first_calc, calc_list%last_calc)
    return
  end subroutine init_gd_calc_list

  subroutine add_gd_calc (calc_list, calc_name, calc_linker, &
       calc_parameters, calc_string, source_list, signal_list, error)

    !-- Add a calculated function set to the list for gd_read.
    !-- 19 Oct 91, Richard Maine.

    !-------------------- interface.
    type(calc_list_type), intent(inout) :: calc_list
    character*(*), intent(in) :: calc_name
         !-- calculated function set name.
    character*(*), intent(in), optional :: calc_linker
         !-- calculated function set linker.
    real(r_kind), intent(in), optional, target :: calc_parameters(:)
         !-- Interpretation of these parameters depends on the calc routines.
         !-- Many calc routines ignore them.
    character*(*), intent(in), optional :: calc_string
         !-- Interpretation of this parameter depends on the calc routines.
         !-- Many calc routines ignore it.
    type(gd_source_list_type), intent(inout) :: source_list
         !-- List of get_data source records.
    type(gd_signal_list_type), intent(inout) :: signal_list
         !-- List of get_data signal records.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat, i
    character :: where*8, descr*80
    type(calc_type), pointer :: calc
    type(calc_signal_type), pointer :: input(:), output(:)
    real(r_kind), target :: no_parameters(0)
    real(r_kind), pointer :: parameters(:)
    type(gd_list_type), pointer :: input_list, output_list
         !-- Linked lists of input and output signal names.
    type(gd_signal_type), pointer :: gd_signal

    !-------------------- executable code.

    !-- Allocate a new calculation record.
    where = 'allocate'
    nullify(calc, input_list, output_list)
    allocate(calc, stat=iostat)
    if (iostat /= 0) goto 8000
    calc%opened = .false.
    nullify(calc%output, calc%input, calc%used_input, calc%used_output)

    !-- Nothing in this calc is yet used.
    calc%calc_used = .false.

    !-- Save arguments.
    calc%calc_linker = ''
    if (present(calc_linker)) calc%calc_linker = calc_linker
    parameters => no_parameters
    if (present(calc_parameters)) parameters => calc_parameters

    !-- Open the calc.
    where = 'open'
    if (present(calc_string)) then
      call open_gd_calc(calc%calc_handle, calc_name, calc%calc_linker, &
           parameters, calc_string, input_list, output_list, descr, error)
    else
      call open_gd_calc(calc%calc_handle, calc_name, calc%calc_linker, &
           parameters, '', input_list, output_list, descr, error)
    end if
    if (error) goto 8000
    calc%opened = .true.

    !-- Get the signal lists.
    where = 'signals'
    calc%n_inputs = list_length(input_list)
    calc%n_outputs = list_length(output_list)
    allocate(calc%output(calc%n_outputs), calc%input(calc%n_inputs), &
         stat=iostat)
    if (iostat /= 0) goto 8000
    input => calc%input
    output => calc%output
    call get_list_array(input_list, input%name)
    call get_list_array(output_list, output%name)
    call deallocate_list(input_list)
    call deallocate_list(output_list)

    !-- Append to source and signal lists.
    where = 'avail'
    call add_gd_source(source_list, calc_source_code, calc_name, &
         descr, r_zero, calc%source, error)
    if (error) goto 8000

    !-- Determine which of the signals can be calculated from avail inputs.
    do i = 1 , calc%n_inputs
      call find_gd_signal(input(i)%name, signal_list, gd_signal)
      input(i)%signal_number = gd_signal%signal_number
    end do
    do i = 1 , calc%n_outputs
      output%used = .false.
      output(i)%used = .true.
      call request_gd_calc_signals(calc%calc_handle, output%used, input%used)
      if (all((input%signal_number /= 0) .or. .not. input%used)) then
        call add_gd_signal(signal_list, output(i)%name, calc%source, &
             gd_signal, 'calc', error)
        if (error) goto 8000
        output(i)%signal_number = gd_signal%signal_number
      else
        output(i)%signal_number = 0
      end if
    end do

    !-- Add to the doubly linked list of calcs for this get_data object.
    nullify(calc%next_calc)
    calc%prev_calc => calc_list%last_calc
    if (.not. associated(calc_list%first_calc)) calc_list%first_calc => calc
    if (associated(calc_list%last_calc)) calc_list%last_calc%next_calc => calc
    calc_list%last_calc => calc

    !-- Normal exit.
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    if (iostat /= 0) call write_sys_error(iostat)
    call write_error_msg('calc_gd failed at ' // where)
    call deallocate_list(input_list)
    call deallocate_list(output_list)
    call release_gd_calc(calc)
    error = .true.
    return
  end subroutine add_gd_calc

  subroutine close_gd_calcs (calc_list)

    !-- Close all calculated functions for gd_read.
    !-- 19 Oct 91, Richard Maine.

    !-------------------- interface.
    type(calc_list_type), intent(inout) :: calc_list

    !-------------------- local.
    type(calc_type), pointer :: calc

    !-------------------- executable code.

    do while (associated(calc_list%last_calc))
      calc => calc_list%last_calc%prev_calc
      call release_gd_calc(calc_list%last_calc)
      calc_list%last_calc => calc
    end do
    nullify(calc_list%first_calc)
    return
  end subroutine close_gd_calcs

  subroutine release_gd_calc (calc)

    !-- Close a calculated function set and deallocate space.
    !-- 2 Jan 91, Richard Maine.

    !-------------------- interface.
    type(calc_type), pointer :: calc  !-- intent(inout)

    !-------------------- executable code.

    if (associated(calc)) then
      if (associated(calc%output)) deallocate(calc%output)
      if (associated(calc%input)) deallocate(calc%input)
      if (associated(calc%used_output)) deallocate(calc%used_output)
      if (associated(calc%used_input)) deallocate(calc%used_input)
      if (calc%opened) call close_gd_calc(calc%calc_handle)
      deallocate(calc)
    end if
    return
  end subroutine release_gd_calc

  subroutine activate_gd_calcs (calc_list, used, error)

    !-- Request the used calculated signals and build their maps.
    !-- Flag their needed inputs as used in turn.
    !-- 8 Jan 91, Richard Maine.

    !-------------------- interface.
    type(calc_list_type), intent(in) :: calc_list
    logical, intent(inout) :: used(0:)
         !-- Flags which signals are used.
    logical, intent(out) :: error

    !-------------------- local.
    integer :: iostat, i
    type(calc_type), pointer :: calc
    type(calc_signal_type), pointer :: inputs(:), outputs(:)
    type(calc_used_signal_type), pointer :: used_inputs(:), used_outputs(:)

    !-------------------- executable code.

    error = .false.

    !-- Note we must activate calcs in reverse order to catch dependencies.
    calc => calc_list%last_calc
    do while (associated(calc))
      inputs => calc%input
      outputs => calc%output
      used(0) = .false.
      outputs%used = used(outputs%signal_number)
      calc%n_used_outputs = count(outputs%used)
      calc%calc_used = calc%n_used_outputs /= 0
      if (calc%calc_used) then
        if (associated(calc%used_output)) deallocate(calc%used_output)
        if (associated(calc%used_input)) deallocate(calc%used_input)
        call request_gd_calc_signals(calc%calc_handle, outputs%used, &
             inputs%used)
        calc%n_used_inputs = count(inputs%used)
        allocate(calc%used_output(calc%n_used_outputs), &
             calc%used_input(calc%n_used_inputs), stat=iostat)
        if (iostat /= 0) goto 8000
        used_inputs => calc%used_input
        used_inputs%full_map = pack((/(i,i=1,calc%n_inputs)/), inputs%used)
        used_inputs%signal_number = inputs(used_inputs%full_map)%signal_number
        used_outputs => calc%used_output
        used_outputs%full_map = pack((/(i,i=1,calc%n_outputs)/), outputs%used)
        used_outputs%signal_number = &
             outputs(used_outputs%full_map)%signal_number

        !-- Don't use array assignment.  Duplicate inputs may exist.
        do i = 1 , calc%n_used_inputs
          used(used_inputs(i)%signal_number) = .true.
        end do
        inputs%data = 0.
        outputs%data = 0.
      end if
      calc => calc%prev_calc
    end do
    error = .false.
    return

    !---------- Error exit.
    8000 continue
    error = .true.
    return
  end subroutine activate_gd_calcs

  subroutine do_gd_calcs (calc_list, time, jump, gd_data, error)

    !-- Do calculations for an output frame.
    !-- 8 Jan 91, Richard Maine.

    !-------------------- interface.
    type(calc_list_type), intent(in) :: calc_list
    real(r_kind), intent(in) :: time  !-- Frame time.
    logical, intent(in) :: jump
         !-- True on the first frame after a time jump or interval start.
    real(r_kind), intent(inout) :: gd_data(0:)
         !-- Vector of data for the frame.
    logical, intent(out) :: error

    !-------------------- local.
    type(calc_type), pointer :: calc

    !-------------------- executable code.

    calc => calc_list%first_calc
    do while (associated(calc))
      if (calc%calc_used) then
        calc%input(calc%used_input%full_map)%data = &
             gd_data(calc%used_input%signal_number)
        call do_gd_calc(calc%calc_handle, jump, time, &
             calc%input%data, calc%output%data, error)
        if (error) return
        gd_data(calc%used_output%signal_number) = &
             calc%output(calc%used_output%full_map)%data
      end if
      calc => calc%next_calc
    end do
    error = .false.
    return
  end subroutine do_gd_calcs

end module gd_calc
