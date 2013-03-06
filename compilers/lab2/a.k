MODULE Main 0 0
IMPORT Lib 0
ENDHDR

PROC MAIN 0 0 0
!   i := 0;
CONST 0
STGW _i
LABEL 1
!     i := i + 1; 
LDGW _i
CONST 1
PLUS
STGW _i
!     i := i * i;
LDGW _i
LDGW _i
TIMES
STGW _i
!     print i; newline
LDGW _i
GLOBAL Lib.Print
CALL 1
GLOBAL Lib.Newline
CALL 0
!   until i mod 5 = 0
LDGW _i
CONST 5
MOD
CONST 0
JEQ 1
RETURN
END

GLOVAR _i 4
