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
EXIT_FAILURE    equ     1
SYS_exit        equ     60
MAX_LOOP        equ     100
; -----
; Define variables
strNum      db      '-123456', NULL
intNum      dq      0

; **********************************************
; Code section
section .text
global _start
_start:

; Convert an integer to an ASCII string.
; -----
; r8 will stored the base factor
mov     r8, 10
; r9 will stored the current factor
mov     r9, 1
; rbx store the base address of string
mov     rbx, strNum
; Part A - Sign extraction
; 
cmp     byte [strNum], '-'
je      isNeg
cmp     byte [strNum], '+'
je      updateBase
jmp     extractNum
; Number is negative, modify the pos and base address
isNeg:
not     r9
inc     r9
updateBase:
inc     rbx     

; Part B - Successive extract number
extractNum:
    mov     rcx, 0

extractLoop:
    mov     al, byte [rbx+rcx]
    cmp     al, 0
    je      aggregate
    cmp     al, '0'
    jb      error
    cmp     al, '9'
    ja      error
    sub     al, '0'
    movzx   rax, al
    ; push number to stack
    push    rax
    ; store the number of digit to rcx
    inc     rcx
    cmp     rcx, MAX_LOOP
    je      error
    jmp     extractLoop

; -----
; Part C - Aggreate all number to the complete number
aggregate:
; store the temp number
mov     rbx, 0

sumLoop:
    pop     rax
    ; Multiply with current factor
    imul    r9
    add     rbx, rax
    ; Update current factor
    mov     rax, r9
    imul    r8
    mov     r9, rax
    loop    sumLoop

mov     qword [intNum], rbx
jmp     last

error:
    mov     rax, SYS_exit
    mov     rbx, EXIT_FAILURE
    syscall
; -----
; Done, terminate program.
last:
    mov     rax, SYS_exit
    mov     rbx, EXIT_SUCCESS
    syscall