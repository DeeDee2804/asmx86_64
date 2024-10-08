; Simple example demonstrating basic stack operations.
; Reverse a list of numbers - in place.
; Method: Put each number on stack, then pop each number
;         back off, and then put back into memory.
; ************************************************************
; Author: Khoi Doan Minh
; Date: 27/09/2024
; ************************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; Define variable
numbers     dq  121, 122, 123, 124, 125
len         dq  5

; ************************************************************
; Code section
section .text
global  _start
_start:

; -----
; Loop to put numbers on stack
mov     rcx, qword [len]
mov     rbx, numbers
mov     r12, 0
mov     rax, 0

pushLoop:
    push    qword [rbx+r12*8]
    inc     r12
    loop    pushLoop

; -----
; All the numbers are on stack (in reverse order)
; Loop to get them back off. Put them back into
; the original list...
mov     rcx, qword [len]
mov     r12, 0

popLoop:
    pop     rax
    mov     qword [rbx+r12*8], rax
    inc     r12
    loop    popLoop
    
; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall

