; Brief: Simple program for sum of square in assembly
; Author: Khoi Doan Minh
; Date: 26/09/2024
; ************************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; Define variable
n       dd  10
sum     dq  0

; Code section
section .text
global  _start
_start:

; -----
; Compute sum of squares from 1 to n (inclusive).
; Approach:
; for (i=1; i<=n; i++)
;   sumOfSquares += i^2;
; the loop command will decrement the rcx register to run the loop
mov     ecx, dword [n]      
mov     rbx, 1                 

sumLoop:
    mov     rax, rbx
    mul     rax   
    add     qword [sum], rax    ; Sum current square integer
    inc     rbx                 ; Set next integer
    loop    sumLoop

; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall

