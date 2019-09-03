!
!  Copyright 2019 SALMON developers
!
!  Licensed under the Apache License, Version 2.0 (the "License");
!  you may not use this file except in compliance with the License.
!  You may obtain a copy of the License at
!
!      http://www.apache.org/licenses/LICENSE-2.0
!
!  Unless required by applicable law or agreed to in writing, software
!  distributed under the License is distributed on an "AS IS" BASIS,
!  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!  See the License for the specific language governing permissions and
!  limitations under the License.
!
!=======================================================================
!=======================================================================

subroutine calc_env_trigon(ipulse,tenv_trigon)
  !$ use omp_lib
  use inputoutput
  use scf_data

  implicit none
  integer,intent(in)  :: ipulse  ! 1: first pulse, 2: second pulse
  real(8),intent(out) :: tenv_trigon

  real(8) :: alpha,beta
  real(8) :: theta1,theta2,theta1_0,theta2_0,tenv_trigon_0
  character(16) :: tae_shape

  if(ipulse==1)then
    tae_shape=ae_shape1
    ! cos(theta1)**2
    theta1=Pi/tw1*(dble(itt)*dt-0.5d0*tw1)
    alpha=Pi/tw1
    ! cos(theta2)
    theta2=omega1*(dble(itt)*dt-0.5d0*tw1)+phi_cep1*2d0*pi
    beta=omega1
    ! for iperiodic=3 .and. ae_shape1='Ecos2'
    theta1_0=Pi/tw1*(0-0.5d0*tw1)
    theta2_0=omega1*(0-0.5d0*tw1)+phi_cep1*2d0*pi
  else if(ipulse==2)then
    tae_shape=ae_shape2
    ! cos(theta1)**2
    theta1=Pi/tw2*(dble(itt)*dt-t1_t2-0.5d0*tw1)
    alpha=Pi/tw2
    ! cos(theta2)
    theta2=omega2*(dble(itt)*dt-t1_t2-0.5d0*tw1)+phi_cep2*2d0*pi
    beta=omega2
    ! for iperiodic=3 .and. ae_shape2='Ecos2'
    theta1_0=Pi/tw2*(0-0.5d0*tw1)
    theta2_0=omega2*(0-0.5d0*tw1)+phi_cep2*2d0*pi
  end if

  select case(iperiodic)
  case(0)
    if(tae_shape=='Ecos2')then
      tenv_trigon=cos(theta1)**2*cos(theta2)
    else if(tae_shape=='Acos2')then
      tenv_trigon=-(-alpha*sin(2.d0*theta1)*cos(theta2)   &
                    -beta*cos(theta1)**2*sin(theta2))/beta
    end if
  case(3)
    if(tae_shape=='Ecos2')then
      tenv_trigon_0=sin(theta2_0)/(2.d0*beta)   &
                   +sin(2.d0*theta1_0+theta2_0)/(4.d0*(2.d0*alpha+beta))   &
                   +sin(2.d0*theta1_0-theta2_0)/(4.d0*(2.d0*alpha-beta))
      tenv_trigon  =-(sin(theta2)/(2.d0*beta)   &
                   +sin(2.d0*theta1+theta2)/(4.d0*(2.d0*alpha+beta))   &
                   +sin(2.d0*theta1-theta2)/(4.d0*(2.d0*alpha-beta))   &
                   -tenv_trigon_0)
    else if(tae_shape=='Acos2')then
      tenv_trigon=(1/beta)*cos(theta1)**2*cos(theta2)
    end if
  end select

  return

end subroutine calc_env_trigon
