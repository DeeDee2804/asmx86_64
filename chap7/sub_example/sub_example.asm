; Brief: Simple program for subtraction operation in assembly
; Author: Khoi Doan Minh
; Date: 26/09/2024
; ************************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; Define variable
bNum1   db  42
bNum2   db  73
bAns    db  0

wNum1   dw  4321
wNum2   dw  1234
wAns    dw  0

dNum1   dd  42000
dNum2   dd  73000
dAns    dd  0

qNum1   dq  73000000
qNum2   dq  73000000
qAns    dq  0

; Code section
section .text
global  _start
_start:

normalMul: 
    ; bAns = bNum1 - bNum2
    mov     al, byte [bNum1]
    sub     al, byte [bNum2]
    mov     byte [bAns], al

    ; wAns = wNum1 - wNum2
    mov     ax, word [wNum1]
    sub     ax, word [wNum2]
    mov     word [wAns], ax

    ; dAns = dNum1 - dNum2
    mov     eax, dword [dNum1]
    sub     eax, dword [dNum2]
    mov     dword [dAns], eax

    ; qAns = qNum1 - qNum2
    mov     rax, qword [qNum1]
    sub     rax, qword [qNum2]
    mov     qword [qAns], rax

decSub:
    dec     byte [bAns]
    dec     word [wAns]
    dec     dword [dAns]
    dec     qword [qAns]

; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall

