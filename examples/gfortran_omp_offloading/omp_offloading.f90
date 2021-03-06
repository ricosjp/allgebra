! Copyright 2020 RICOS Co. Ltd.
!
! This file is a part of ricosjp/allgebra, distributed under Apache-2.0 License
! https://github.com/ricosjp/allgebra

program omp_offloading
  implicit none
  integer :: length, status
  integer :: size, i
  character(:), allocatable :: arg
  real, allocatable, dimension(:) :: x, y
  real :: dot
  intrinsic :: command_argument_count, get_command_argument

  if (command_argument_count() /= 1) then
     print *, 'error, $1 is vector size'
  end if

  call get_command_argument(1, length = length, status = status)
  if (status == 0) then
     allocate(character(length) :: arg)
     call get_command_argument(1, arg, status = status)
     if (status == 0) then
        read(arg, *) size
     else
        error stop 1
     end if
     deallocate (arg)
  else
     error stop 1
  end if

  allocate(x(size))
  allocate(y(size))
  x = 1.0
  y = 2.0
  dot = 0.0

  !$omp target map (to: x, y) map(tofrom: dot)
  !$omp teams distribute parallel do reduction(+ : dot) 
  do i = 1, size
     dot = dot + x(i) * y(i)
  end do
  !$omp end target

  deallocate(y)
  deallocate(x)
  if(dot /= 2.0 * size) then
     print *, 'dot =', dot
     print *, 'error!'
     error stop 1
  else
     print *, 'dot = ', dot
     print *, 'Pass!'
  end if
end program omp_offloading
