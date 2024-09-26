; Brief: Simple program for sum of odds in assembly
; Author: Khoi Doan Minh
; Date: 26/09/2024
; ************************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; Define variable
lpCnt   dq  15
sum     dq  0

; Code section
section .text
global  _start
_start:

mov     rcx, qword [lpCnt]      ; Initialize loop counter
mov     rax, 1                  ; Current odd integer

sumLoop:
    add     qword [sum], rax    ; Sum current odd integer
    add     rax, 2              ; Set next odd integer
    dec     rcx                 ; Decrement loop counter
    cmp     rcx, 0
    jne     sumLoop

; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall

