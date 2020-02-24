!-- precision.f90
!-- 4 Mar 92, Richard Maine: Version 1.0.

module precision

  !-- Kind constants for system-independent precision specification.
  !-- 4 Mar 92, Richard Maine.

  implicit none
  public

  !-- System default kinds.
  integer, parameter :: i_kind = kind(0)      !-- default integer
  integer, parameter :: rs_kind = kind(0.)    !-- real single precision
  integer, parameter :: rd_kind = kind(0.d0)  !-- real double precision

  !-- Kinds for specified real precisions.
  integer, parameter :: r4_kind = selected_real_kind(6,30)   !-- 6 digits
  integer, parameter :: r8_kind = selected_real_kind(12,30)  !-- 12 digits

  !-- Kinds for specified integer ranges.
  integer, parameter :: i1_kind = selected_int_kind(2)  !-- 99 max
  integer, parameter :: i2_kind = selected_int_kind(4)  !-- 9,999 max
  integer, parameter :: i4_kind = selected_int_kind(9)  !-- 999,999,999 max

  !-- Kind for working real precision.
  integer, parameter :: r_kind = r8_kind

  !-- Big constants.  These are less than huge so that we have some
  !-- room for comparisons and other arithmetic without overflowing.
  integer, parameter :: big_int = huge(i_kind)/16
  real(r_kind), parameter :: r_zero = 0.
  real(r_kind), parameter :: big_real = huge(r_zero)/16.
end module precision
