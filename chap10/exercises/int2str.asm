; Simple program to convert an
; singed integer number into an ASCII string.
; Solve exercise 1 and 2
; **********************************************
; Author: Doan Minh Khoi
; Date: 27/09/2024
; **********************************************
; Data section
section .data

; -----
; Define constant
NULL            equ     0
EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; -----
; Define variables
intNum      dq      -123456
isNeg       db      0
; **********************************************
; BSS section
section .bss

strNum      resb    10

; **********************************************
; Code section
section .text
global _start
_start:

; Convert an integer to an ASCII string.
; -----
; Part A - Sign extraction
cmp     qword [intNum], 0
jge     division
; Number is negative, get the absolute value
mov     byte [isNeg], 1

; Part B - Successive division
division:
mov     rax, qword [intNum]
mov     rcx, 0
mov     rbx, 10

divideLoop:
    ; divide number by 10
    cqo
    idiv    rbx
    ; push remainder to the stack
    push    rdx
    ; store the number of digit to rcx
    inc     rcx
    ; Check if the quotient is 0 or not
    cmp     rax, 0
    jne     divideLoop

; -----
; Part C - Convert remainders and store
mov     rbx, strNum
mov     rdi, 0
cmp     byte [isNeg], 0
; Add sign character if negative
je      popLoop
mov     byte [rbx+rdi], '-'
inc     rdi
popLoop:
    pop     rax
    ; If number is negative, only take the absolute value
    cmp     byte [isNeg], 0
    je      addAbs
    not     al
    inc     al
addAbs:
    add     al, '0'
    mov     byte [rbx+rdi], al
    inc     rdi
    loop    popLoop
mov     byte [rbx+rdi], 0
; -----
; Done, terminate program.
last:
    mov     rax, SYS_exit
    mov     rbx, EXIT_SUCCESS
    syscall