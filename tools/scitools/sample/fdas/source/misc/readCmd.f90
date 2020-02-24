!-- readCmd.f90
!-- 14 Oct 92, Richard Maine: Version 1.0.

module command

  use standard_files
  use sysdep_io

  implicit none
  private

  integer, save :: do_level = 0
  integer, parameter :: max_do_level = 3
  integer, save :: do_lun(0:max_do_level) = 0

  !-- Public procedures.
  public read_command, do_do
  private read_command_file

contains

  subroutine read_command (prompt, command, command_len, status)

    !-- Read a command, handling end-of-file for do-files.
    !-- 14 Oct 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: prompt    !-- Prompt string.
    character*(*), intent(out) :: command  !-- Concatenated command.
    integer, intent(out) :: command_len    !-- Length of trimmed command.
    integer, intent(out) :: status
         !-- Result status code.
         !--   0 = successful. 
         !--   1 = end-of-file
         !--   2 = error

    !-------------------- executable code.

    !-- Set standard input to the appropriate do-file.
    !-- This is in case some other code was also changing standard input.
    !-- We might want discrepancies here to be errors,
    !-- but for now we quietly override them.

    if (do_level > 0) std_in = do_lun(do_level)

    1000 continue
    call read_command_file(prompt, command, command_len, status)

    !-- On end of a do file, close it, go up a level, and try again.
    if ((status == 1) .and. (do_level > 0)) then
      close(do_lun(do_level))
      do_level = do_level - 1
      std_in = do_lun(do_level)
      goto 1000
    end if
    return
  end subroutine read_command

  subroutine read_command_file (prompt, command, command_len, status)

    !-- Read a command from standard input.
    !-- Concatenate continuations and discard comments.
    !-- 17 Apr 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: prompt    !-- Prompt string.
    character*(*), intent(out) :: command  !-- Concatenated command.
    integer, intent(out) :: command_len    !-- Length of trimmed command.
    integer, intent(out) :: status
         !-- Result status code.
         !--   0 = successful. 
         !--   1 = end-of-file (except when expecting continuation)
         !--   2 = error

    !-------------------- local.
    logical :: do_prompt, do_echo, is_continued
    integer :: iostat, line_len
    character :: line*256

    !-------------------- executable code.

    !-- Determine whether to prompt and/or echo.
    !-- For non-interactive jobs, we want to never prompt and always echo,
    !-- but we have no good way of determining whether this is interactive.
    !-- If non-interactive jobs redirect std_in away from term_in,
    !-- they will get the desired behavior.

    do_prompt = (std_in == term_in) .and. (prompt /= '')
    do_echo = (std_in /= term_in) .or. (std_out /= term_out)

    if (do_prompt) write(term_out, '(1x)')

    !-- Loop until we get a complete command.
    status = 2
    command = ''
    command_len = 0
    loop: do

      !-- Prompt for initial or continuation line.
      if (do_prompt) then
        if (command_len == 0) then
          write (term_out, '(1x,a)', advance='no') prompt
        else
          write (term_out, '(1x,a)', advance='no') 'more: '
        end if
      end if

      !-- Read a line, returning on errors.
      read(std_in, '(a)', iostat=iostat) line
      if (iostat /= 0) then
        if (iostat > 0) then
          call write_sys_error(iostat)
          call write_error_msg('Error in read_command')
        else if (command_len > 0) then
          call write_error_msg('Continuation missing in read_command')
        else
          status = 1
        end if
        return
      end if

      !-- Echo input.
      if (do_echo) write(std_out, '(1x,a,a)') prompt, trim(line)

      !-- Ignore comment line.
      line = adjustl(line)
      if (line(1:2) == '--') cycle loop

      !-- Remove continuation character.
      line_len = max(1,len_trim(line))
      is_continued = (line(line_len:line_len) == '&')
      if (is_continued) then
        line(line_len:line_len) = ' '
        line_len = len_trim(line) + 1
      end if

      !-- Concatenate command.
      if (command_len + line_len > len(command)) then
        call write_error_msg('Command too long.  Discarded.')
        return
      end if
      command(command_len+1:command_len+line_len) = line(:line_len)
      command_len = command_len + line_len

      !-- Swallow blank commands.
      if (command(:command_len) == '') then
        command_len = 0
        cycle loop
      end if

      !-- Loop for continuation.
      if (is_continued) cycle loop

      !-- Accept the command if we get to here.
      status = 0
      return
    end do loop
  end subroutine read_command_file

  subroutine do_do (file_name)

    !-- Do the "do" command to dynamically redirect standard input.
    !-- 14 Oct 92, Richard Maine.

    !-------------------- interface.
    character*(*), intent(in) :: file_name  !-- Name of the new input file.

    !-------------------- local.
    integer :: iostat

    !-------------------- executable code.

    if (do_level >= max_do_level) then
      call write_error_msg('Do nesting limit exceeded.'); return; endif

    !-- Assign a new lun if needed and open the file.
    if (do_lun(do_level+1) == 0) call assign_lun(do_lun(do_level+1))
    open(do_lun(do_level+1), file=file_name, form='formatted', &
         position='rewind', action='read', status='old', iostat=iostat)
    if (iostat /= 0) then
      call write_sys_error(iostat)
      call write_error_msg('Open of command file failed.')
      return
    end if

    !-- Accept the newly opened file as standard input, saving the old.
    if (do_level == 0) do_lun(0) = std_in
    do_level = do_level + 1
    std_in = do_lun(do_level)
    return
  end subroutine do_do

end module command
