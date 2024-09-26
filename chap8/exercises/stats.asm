; Simple program for simple statistics of the list
; It will solve the problem 1, 2, 4, 5 in book
; ************************************************************
; Author: Khoi Doan Minh
; Date: 27/09/2024
; ************************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; Define variable
lst     dd  1002, -1004, -1008, 1006, 1010, 0
len     dd  6
sum     dd  0
min     dd  0
max     dd  0
avg     dd  0
mid     dd  0
neg_sum dd  0
neg_avg dd  0
neg_cnt dd  0
ddTwo   dd  2

; ************************************************************
; Code section
section .text
global  _start
_start:

; -----
; Summation, Min, Max loop
mov     ecx, dword [len]      
mov     rsi, 0                 ; index is 0
mov     eax, dword[lst]
mov     dword [min], eax
mov     dword [max], eax

statLoop:
    mov     eax, dword [lst+rsi*4]
    add     dword [sum], eax    ; Add next element
    cmp     eax, dword [min]
    jge     NotNewMin
    mov     dword [min], eax
NotNewMin:
    cmp     eax, dword [max]
    jle     NotNewMax
    mov     dword [max], eax
NotNewMax:
    cmp     eax, 0
    jge     NotNegative
    inc     dword [neg_cnt]
    add     dword [neg_sum], eax
NotNegative:
    inc     rsi                 ; Set next index
    loop    statLoop

; Calculate average
mov     eax, dword [sum]
cdq
idiv    dword [len]
mov     dword [avg], eax

mov     eax, dword [neg_sum]
cdq
idiv    dword [neg_cnt]
mov     dword [neg_avg], eax

; Calculate middle value
mov     eax, dword [len]
cdq
div     dword [ddTwo]
mov     esi, eax
cmp     edx, 0
jne     OddMid
jmp     EvenMid
OddMid:
    mov eax, dword [lst+esi*4]
    mov dword [mid], eax
    jmp last
EvenMid:
    mov eax, dword [lst+esi*4]
    add eax, dword [lst+esi*4-4]
    cdq
    idiv dword [ddTwo]
    mov dword [mid], eax
; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall

