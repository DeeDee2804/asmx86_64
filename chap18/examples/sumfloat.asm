; Simple program to demonstrate floating computation
; Calculate the sum and average
; **************************************************
; Author: Doan Minh Khoi
; Date: 09/10/2024
; **************************************************
; Data section
section .data

; -----
; Define constants
NULL        equ     0
TRUE        equ     1
FALSE       equ     0

EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; -----
; Define variables
fltLst      dq  21.34,  6.15,   9.12,   10.05,  7.75
            dq  1.44,   14.50,  3.32,   75.71,  11.87
            dq  17.23,  18.25,  13.65,  24.24,  8.88
length      dd  15
lstSum      dq  0.0
lstAve      dq  0.0

; **************************************************
; Code section
section .text
global _start
_start:

; -----
; Loop to find floating-point sum
    mov     ecx, dword [length]
    mov     rbx, fltLst
    mov     rsi, 0
    movsd   xmm1, qword [lstSum]

sumLp:
    movsd   xmm0, qword [rbx+rsi*8]
    addsd   xmm1, xmm0
    inc     rsi
    loop    sumLp

    movsd   qword [lstSum], xmm1

; -----
; Compute average of the list
    cvtsi2sd    xmm0, dword [length]
    divsd       xmm1, xmm0
    movsd       qword [lstAve], xmm1

; -----
; Done, terminate program
last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall