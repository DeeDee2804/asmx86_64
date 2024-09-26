; Brief: Simple program to calculate the square of sum
; Author: Khoi Doan Minh
; Date: 26/09/2024
; ****************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60
n               equ     10

; Define variable
sum         dd      0
squaredSum  dd      0

; Code section
section .text
global _start
_start:
mov     ebx, 1
mov     ecx, n

startLoop:
    add     dword [sum], ebx
    inc     ebx
    loop    startLoop

mov eax, dword [sum]
mul eax
mov dword [squaredSum], eax

last:
    mov rax, SYS_exit
    mov rbx, EXIT_SUCCESS
    syscall