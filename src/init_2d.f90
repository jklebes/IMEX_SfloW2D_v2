!********************************************************************************
!> \brief Initial solution
!
!> This module contains the variables and the subroutine for the
!> initialization of the solution for a Riemann problem.
!********************************************************************************

MODULE init_2d

  USE parameters_2d, ONLY : verbose_level
  USE parameters_2d, ONLY : n_solid

  IMPLICIT none

  REAL*8, ALLOCATABLE :: q_init(:,:,:)

  REAL*8, ALLOCATABLE :: thickness_init(:,:)
  
  !> Riemann problem interface relative position. It is a value
  !> between 0 and 1
  REAL*8 :: riemann_interface  

  REAL*8 :: hB_W         !< Left height
  REAL*8 :: u_W          !< Left velocity x
  REAL*8 :: v_W          !< Left velocity y
  REAL*8,ALLOCATABLE :: alphas_W(:)         !< Left sediment concentration
  REAL*8 :: T_W          !< Left temperature

  REAL*8 :: hB_E         !< Right height
  REAL*8 :: u_E          !< Right velocity x
  REAL*8 :: v_E          !< Right velocity y
  REAL*8,ALLOCATABLE :: alphas_E(:)         !< Right sediment concentration
  REAL*8 :: T_E          !< Right temperature


CONTAINS


  !******************************************************************************
  !> \brief Riemann problem initialization
  !
  !> This subroutine initialize the solution for a Riemann problem. The 
  !> values for the left and right states and the interface location 
  !> are read from the input file.\
  !> \date 26/08/2011
  !******************************************************************************

  SUBROUTINE riemann_problem

    USE constitutive_2d, ONLY : qp_to_qc

    USE geometry_2d, ONLY : x_comp , comp_cells_x , comp_cells_y , B_cent

    ! USE geometry_2d, ONLY : x0 , xN , y0 , yN

    USE parameters_2d, ONLY : n_vars , verbose_level , n_solid

    USE solver_2d, ONLY : q

    IMPLICIT none

    ! REAL*8 :: hB            !< height + topography
    ! REAL*8 :: u             !< velocity
    ! REAL*8 :: v             !< velocity

    REAL*8 :: qp(n_vars,comp_cells_x,comp_cells_y) , qj(n_vars)

    INTEGER :: j,k          !< loop counter
    INTEGER :: i1           !< last index with left state

    INTEGER :: i_solid

    REAL*8 :: eps

    IF ( verbose_level .GE. 1 ) THEN

       WRITE(*,*) 'Riemann problem initialization'
       WRITE(*,*) 'x_comp(1)',x_comp(1)
       WRITE(*,*) 'x_comp(comp_cells_x)',x_comp(comp_cells_x)
       WRITE(*,*) 'riemann_interface',riemann_interface

    END IF


    i1 = 0
    
    riemann_int_search:DO j = 1,comp_cells_x
       
       IF ( x_comp(j) .LT. riemann_interface ) THEN

          i1 = j

       ELSE

          EXIT riemann_int_search

       END IF

    END DO riemann_int_search
    
    eps = 1.D-10

    ! Left initial state
    qp(1,1:i1,:) = hB_W
    qp(2,1:i1,:) = u_W
    qp(3,1:i1,:) = v_W
    qp(4,1:i1,:) = T_W

    ALLOCATE( alphas_W(n_solid) )

    DO i_solid=1,n_solid

       qp(4+i_solid,1:i1,:) = alphas_W(i_solid)

    END DO

    IF ( verbose_level .GE. 1 ) WRITE(*,*) 'Left state'

    DO j = 1,i1

       DO k = 1,comp_cells_y

         ! evaluate the vector of conservative variables
         CALL qp_to_qc( qp(:,j,k) , B_cent(j,k) , qj )

         q(1:n_vars,j,k) = qj

         IF ( verbose_level .GE. 1 ) THEN 
            
            WRITE(*,*) j,k,B_cent(j,k)
            WRITE(*,*) qp(:,j,k)
            WRITE(*,*) q(1:n_vars,j,k)

         END IF

       ENDDO

    END DO

    IF ( verbose_level .GE. 1 ) READ(*,*)

    ! Right initial state
    qp(1,i1+1:comp_cells_x,:) = hB_E
    qp(2,i1+1:comp_cells_x,:) = u_E
    qp(3,i1+1:comp_cells_x,:) = v_E
    qp(4,i1+1:comp_cells_x,:) = T_E

    ALLOCATE( alphas_E(n_solid) )

    DO i_solid=1,n_solid

       qp(4+i_solid,1:i1,:) = alphas_E(i_solid)

    END DO

    IF ( verbose_level .GE. 1 ) WRITE(*,*) 'Right state'

    DO j = i1+1,comp_cells_x

       DO k = 1,comp_cells_y

         ! evaluate the vector of conservative variables
         CALL qp_to_qc( qp(:,j,k) , B_cent(j,k) , qj )

         q(1:n_vars,j,k) = qj

         IF ( verbose_level .GE. 1 ) THEN 
            
            WRITE(*,*) j,k,B_cent(j,k)
            WRITE(*,*) qp(:,j,k)
            WRITE(*,*) q(1:n_vars,j,k)

         END IF
    
      END DO

    ENDDO

    IF ( verbose_level .GE. 1 ) READ(*,*)

    RETURN

  END SUBROUTINE riemann_problem
  
END MODULE init_2d
