Copyright>
Copyright> Copyright (C) 1986-2025 Altair Engineering Inc.
Copyright>    
Copyright> Permission is hereby granted, free of charge, to any person obtaining 
Copyright> a copy of this software and associated documentation files (the "Software"), 
Copyright> to deal in the Software without restriction, including without limitation 
Copyright> the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
Copyright> sell copies of the Software, and to permit persons to whom the Software is 
Copyright> furnished to do so, subject to the following conditions:
Copyright> 
Copyright> The above copyright notice and this permission notice shall be included in all 
Copyright> copies or substantial portions of the Software.
Copyright> 
Copyright> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
Copyright> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
Copyright> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
Copyright> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
Copyright> WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
Copyright> IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
Copyright>




Chd|====================================================================
Chd|  USERWIS                                                     
Chd|-- called by -----------
Chd|-- calls ---------------
Chd|====================================================================
      SUBROUTINE USERWIS(IIN     ,IOUT    ,NUMNOD   ,ITAB    ,
     .                   X       ,V       ,VR       ,MASS    ,INER    ,
     .                   NUVAR   ,NUVARI  ,UVAR     ,IUVAR   )
C-----------------------------------------------
C   I m p l i c i t   T y p e s
C-----------------------------------------------
       IMPLICIT NONE
C----------+---------+---+---+--------------------------------------------
C VAR      | SIZE    |TYP| RW| DEFINITION
C----------+---------+---+---+--------------------------------------------
C IIN      |  1      | I | R | INPUT FILE UNIT (D00 file) 
C IOUT     |  1      | I | R | OUTPUT FILE UNIT (L00 file)
C NUVAR    |  1      | I | R | SIZE OF USER REAL ARRAY
C NUVARI   |  1      | I | R | SIZE OF USER INTEGER ARRAY
C NUMNOD   |  1      | I | R | NUMBER OF NODES
C----------+---------+---+---+--------------------------------------------
C IUVAR    | NUVARI  | I | W | USER INTEGER ARRAY
C----------+---------+---+---+--------------------------------------------
C UVAR     |  NUVAR  | F | W | USER D PRECISION ARRAY
C----------+---------+---+---+--------------------------------------------
C ITAB     | NUMNOD  | I | R | USER NODE ID  
C----------+---------+---+---+--------------------------------------------
C X        |3,NUMNOD | F | R | X,Y,Z COORDINATES
C V        |3,NUMNOD | F | R | X,Y,Z VELOCITIES
C VR       |3,NUMNOD | F | R | XX,YY,ZZ ROTATIONAL VELOCITIES
C----------+---------+---+---+--------------------------------------------
C MASS     | NUMNOD  | F |R/W| NODAL MASS
C INER     | NUMNOD  | F |R/W| NODAL SHERICAL INERTIA
C----------+---------+---+---+--------------------------------------------
C
C     This subroutine initialize global user's window  
C     and fill up the user variable buffers :
C            UVAR  for floating points and
C            IUVAR for integers
C-----------------------------------------------
C   D u m m y   A r g u m e n t s
C-----------------------------------------------
      INTEGER ::  IIN   ,IOUT  ,NUMNOD, NUVAR ,NUVARI
      INTEGER ::  ITAB(NUMNOD)
      DOUBLE PRECISION , INTENT (IN)  ::  
     .   X(3,NUMNOD) ,V(3,NUMNOD),VR(3,NUMNOD),MASS(NUMNOD),INER(NUMNOD)
      INTEGER          , DIMENSION(NUVARI) ::  IUVAR
      DOUBLE PRECISION , DIMENSION(NUVAR)  ::  UVAR
C=================================================================
C FUNCTION TO ACCESS USER'S PROPERTIES AND MATERIALS
C-------------------------------------------------------------------------
C INTEGER II = GET_U_PNU(I,IP,KK)
C         IFUNCI = GET_U_PNU(I,IP,KFUNC)
C         IPROPI = GET_U_PNU(I,IP,KPROP)
C         IMATI = GET_U_PNU(I,IP,KMAT)
C         I     :     VARIABLE INDEX(1 for first variable,...)
C         IP    :     PROPERTY NUMBER
C         KK    :     PARAMETER KFUNC,KMAT,KPROP
C         THIS FUNCTION RETURN THE USER STORED FUNCTION(IF KK=KFUNC), 
C         MATERIAL(IF KK=KMAT) OR PROPERTY(IF KK=KPROP) NUMBERS. 
C         SEE LECG29 FOR CORRESPONDING ID STORAGE.
C-------------------------------------------------------------------------
C INTEGER IFUNCI = GET_U_MNU(I,IM,KFUNC)
C         I     :     VARIABLE INDEX(1 for first function)
C         IM    :     MATERIAL NUMBER
C         KFUNC :     ONLY FUNCTION ARE YET AVAILABLE.
C         THIS FUNCTION RETURN THE USER STORED FUNCTION NUMBERS(function 
C         refered by users materials).
C         SEE LECM29 FOR CORRESPONDING ID STORAGE.
C-------------------------------------------------------------------------
C my_real PARAMI = GET_U_GEO(I,IP)
C         I     :     PARAMETER INDEX(1 for first parameter,...)
C         IP    :     PROPERTY NUMBER
C         THIS FUNCTION RETURN THE USER GEOMETRY PARAMETERS 
C-------------------------------------------------------------------------
C my_real PARAMI = GET_U_MAT(I,IM)
C         I     :     PARAMETER INDEX(1 for first parameter,...)
C         IM    :     MATERIAL NUMBER
C         THIS FUNCTION RETURN THE USER MATERIAL PARAMETERS 
C         NOTE: GET_U_MAT(0,IMAT) RETURN THE DENSITY
C-------------------------------------------------------------------------
C INTEGER PID = GET_U_PID(IP)
C         IP    :     PROPERTY NUMBER
C         THIS FUNCTION RETURN THE USER PROPERTY ID CORRESPONDING TO
C         USER PROPERTY NUMBER IP. 
C-------------------------------------------------------------------------
C INTEGER MID = GET_U_MID(IM)
C         IM   :     MATERIAL NUMBER
C         THIS FUNCTION RETURN THE USER MATERIAL ID CORRESPONDING TO
C         USER MATERIAL NUMBER IM. 
C-------------------------------------------------------------------------
C   L o c a l   V a r i a b l e s
C-------------------------------------------------------------------------
      INTEGER KRITERIA,IDEBUG,IFUN, GET_U_NUMFUN
      DOUBLE PRECISION  FNMAX, FTMAX, SCAL, ALPHA, FREQ
      CHARACTER*80   LINE
      EXTERNAL GET_U_NUMFUN
C----------------------------------------------- 
      CHARACTER OPTION*256
      INTEGER SIZE
C----------------------------------------------- 
        OPTION='USER WINDOWS READ'
        SIZE=LEN_TRIM(OPTION)
        WRITE(6,'(A)')
     .     '** ERROR IN USER LIBRARY SDK'
         WRITE(6,'(A,A)')
     .     ' OPTION : ',OPTION(1:SIZE)
        WRITE(6,'(A)')
     .     'USER INTERFACE OPTION USED, BUT NO USER INTERFACE ROUTINE IS FOUND IN SDK'

        CALL ARRET(2)
      END 
