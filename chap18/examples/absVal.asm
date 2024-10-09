; Simple program to demonstrate floating computation
; Calculate absolute value
; **************************************************
; Author: Doan Minh Khoi
; Date: 09/10/2024
; **************************************************
; Data section
section .data

; -----
; Define constants
TRUE        equ     1
FALSE       equ     0

EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; -----
; Define variables
dZero       dq  0.0
dNegOne     dq  -1.0
fltVal      dq  -8.25

; **************************************************
; Code section
section .text
global _start
_start:

; -----
; Perform absolute function
    movsd   xmm0, qword [fltVal]
    ucomisd xmm0, qword [dZero]
    jae     isPos
    mulsd   xmm0, qword [dNegOne]
    movsd   qword [fltVal], xmm0

isPos:

; -----
; Done, terminate program
last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall