; Simple program to demonstrate the macro
; Define the macro called with three arguments
;   aver <lst>, <len>, <ave>
; ***************************************
; Author: Doan Minh Khoi
; Date: 29/09/2024
; ***************************************

%macro      aver    3
    mov     eax, 0
    mov     ecx, dword [%2]  ; len
    mov     r12, 0
    lea     rbx, [%1]       ; lst address
%%sumLoop:
    add     eax, dword [rbx+r12*4]
    inc     r12
    loop    %%sumLoop
    ; end Loop
    cdq
    idiv    dword [%2]
    mov     dword [%3], eax
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
ave1        dd  0

list2       dd  2, 6, 3, -2, 1, 8, 19
len2        dd  7
ave2        dd  0

; ***************************************
; Code section
section .text
global _start
_start:
    aver    list1, len1, ave1
    aver    list2, len2, ave2
; -----
; Done, terminate the program
last:
    mov     eax, SYS_exit
    mov     ebx, EXIT_SUCCESS
    syscall