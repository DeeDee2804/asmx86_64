; Simple program convert int to str
; in macro
;   int2str <int>, <str>
; ***************************************
; Author: Doan Minh Khoi
; Date: 29/09/2024
; ***************************************

%macro      int2str    2
; Part A - Successive division
    mov     eax, dword [%1]
    mov     rcx, 0
    mov     ebx, 10
    mov     rdx, 0

%%divideLoop:
    mov     edx, 0
    div     ebx
    push    rdx
    inc     rcx
    cmp     eax, 0
    jne     %%divideLoop

; -----
; Part B - Convert remainders and store
    lea     rbx, [%2]
    mov     rdi, 0
%%popLoop:
    pop     rax
    add     al, '0'
    mov     byte [rbx+rdi], al
    inc     rdi
    loop    %%popLoop

mov     byte [rbx+rdi], 0
%endmacro

; ***************************************
; Data section
section .data

; -----
; Define constants
EXIT_SUCCESS        equ 0
SYS_exit            equ 60

; Define variables
num1    dd  1234
num2    dd  10000
num3    dd  0

; ***************************************
; BSS section
section .bss

str1    resb    7
str2    resb    7
str3    resb    7

; ***************************************
; Code section
section .text
global _start
_start:
    int2str    num1, str1
    int2str    num2, str2
    int2str    num3, str3
; -----
; Done, terminate the program
last:
    mov     eax, SYS_exit
    mov     ebx, EXIT_SUCCESS
    syscall