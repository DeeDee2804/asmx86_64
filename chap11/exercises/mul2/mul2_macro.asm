; Simple program update the list by multiply 2
; in macro
;   mul2 <lst>, <len>
; ***************************************
; Author: Doan Minh Khoi
; Date: 29/09/2024
; ***************************************

%macro      mul2    2
    mov     r8d, 2      ; constant 2
    mov     rsi, 0
    mov     ecx, dword [%2]
    lea     rbx, [%1]
%%mulLoop:
    mov     eax, dword [rbx+rsi*4]
    cdq
    imul    r8d
    mov     dword [rbx+rsi*4], eax
    inc     rsi
    loop    %%mulLoop
%endmacro

; ***************************************
; Data section
section .data

; -----
; Define constants
EXIT_SUCCESS        equ 0
SYS_exit            equ 60

; Define variables
list1       dd  4, 5, 2, -3, 1
len1        dd  5

list2       dd  2, 6, 3, -2, 1, 8, 19
len2        dd  7


; ***************************************
; Code section
section .text
global _start
_start:
    mul2    list1, len1
    mul2    list2, len2
    mul2    list2, len2
; -----
; Done, terminate the program
last:
    mov     eax, SYS_exit
    mov     ebx, EXIT_SUCCESS
    syscall