; Brief: Simple program to nth fibonacci number
; Author: Khoi Doan Minh
; Date: 26/09/2024
; ****************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60
n               equ     20
fib0            equ     0
fib1            equ     1

; Define variable
fibn         dd      0

; Code section
section .text
global _start
_start:
mov     eax, fib0
mov     ebx, fib1
mov     ecx, n
dec     ecx

startLoop:
    mov     edx, ebx
    add     ebx, eax
    mov     eax, edx
    loop    startLoop

mov dword [fibn], ebx

last:
    mov rax, SYS_exit
    mov rbx, EXIT_SUCCESS
    syscall