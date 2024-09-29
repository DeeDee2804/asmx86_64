; Simple program find min max by macro
;   minmax <lst>, <len>, <min>, <max>
; ***************************************
; Author: Doan Minh Khoi
; Date: 29/09/2024
; ***************************************

%macro      minmax    4
    mov     eax, 0
    mov     ecx, dword [%2]  ; len
    mov     r11d, dword [%1]  ; temp min
    mov     r12d, dword [%1]  ; temp max
    mov     rsi, 0
    lea     rbx, [%1]       ; lst address
%%minmaxLoop:
    mov     eax, dword [rbx+rsi*4]
    cmp     r11d, eax
    jle      %%findMax
    mov     r11d, eax
%%findMax:
    cmp     r12d, eax
    jge     %%endLoop
    mov     r12d, eax
%%endLoop:
    inc     rsi
    loop    %%minmaxLoop
    ; end Loop
    mov     dword [%3], r11d
    mov     dword [%4], r12d
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
min1        dd  0
max1        dd  0

list2       dd  2, 6, 3, -2, 1, 8, 19
len2        dd  7
min2        dd  0
max2        dd  0

; ***************************************
; Code section
section .text
global _start
_start:
    minmax    list1, len1, min1, max1
    minmax    list2, len2, min2, max2
; -----
; Done, terminate the program
last:
    mov     eax, SYS_exit
    mov     ebx, EXIT_SUCCESS
    syscall