; Simple program to convert an
; integer number into an ASCII string.
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
intNum      dd      1498

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
; Part A - Successive division
mov     eax, dword [intNum]
mov     rcx, 0
mov     ebx, 10
mov     rdx, 0

divideLoop:
    ; divide number by 10
    mov     edx, 0
    div     ebx
    ; push remainder to the stack
    push    rdx
    ; store the number of digit to rcx
    inc     rcx
    ; Check if the quotient is 0 or not
    cmp     eax, 0
    jne     divideLoop

; -----
; Part B - Convert remainders and store
mov     rbx, strNum
mov     rdi, 0
popLoop:
    pop     rax
    add     al, '0'
    mov     byte [rbx+rdi], al
    inc     rdi
    loop    popLoop     ; rcx is set during divideLoop
mov     byte [rbx+rdi], 0
; -----
; Done, terminate program.
last:
    mov     rax, SYS_exit
    mov     rbx, EXIT_SUCCESS
    syscall