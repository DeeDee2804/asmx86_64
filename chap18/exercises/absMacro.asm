; Simple program find absolute of float in macro
;   fAbsf <float>
;   fAbsd <double>
; ***************************************
; Author: Doan Minh Khoi
; Date: 09/10/2024
; ***************************************

%macro      fAbsf    1
    movss       xmm0, dword [%1]  
    mov         eax, 0
    cvtsi2ss    xmm1, eax
    ucomiss     xmm0, xmm1
    jae         %%isPos
    mov         eax, -1
    cvtsi2ss    xmm1, eax
    mulss       xmm0, xmm1
    movss       dword [%1], xmm0
%%isPos:

%endmacro

%macro      fAbsd    1
    movsd       xmm0, qword [%1]  
    mov         eax, 0
    cvtsi2sd    xmm1, eax
    ucomisd     xmm0, xmm1
    jae         %%isPos
    mov         eax, -1
    cvtsi2sd    xmm1, eax
    mulsd       xmm0, xmm1
    movsd       qword [%1], xmm0
%%isPos:

%endmacro
; ***************************************
; Data section
section .data

; -----
; Define constants
EXIT_SUCCESS        equ 0
SYS_exit            equ 60

; Define variables
num1     dd     -32.67
num2     dq     -12345.678
num3     dd     -3258.134

; ***************************************
; Code section
section .text
global _start
_start:
    fAbsf   num1
    fAbsd   num2
    fAbsf   num3
; -----
; Done, terminate the program
last:
    mov     eax, SYS_exit
    mov     ebx, EXIT_SUCCESS
    syscall