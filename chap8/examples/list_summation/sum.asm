; Brief: Simple program for sum of the list
; Author: Khoi Doan Minh
; Date: 26/09/2024
; ************************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; Define variable
lst     dd  1002, 1004, 1006, 1008, 1010
len     dd  5
sum     dd  0

; ************************************************************
; Code section
section .text
global  _start
_start:

; -----
; Summation loop
mov     ecx, dword [len]      
mov     rsi, 0                 ; index is 0

sumLoop:
    mov     eax, dword [lst+rsi*4]
    add     dword [sum], eax    ; Add next element
    inc     rsi                 ; Set next index
    loop    sumLoop

; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall

