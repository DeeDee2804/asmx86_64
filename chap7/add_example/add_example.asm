; Brief: Simple program for add operation in assembly
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

qNum1   dq  42000000
qNum2   dq  73000000
qAns    dq  0

dquad1  ddq 0x1A000000000000000
dquad2  ddq 0x2C000000000000000
dqSum   ddq 0

; Code section
section .text
global  _start
_start:

normalAdd: 
    ; bAns = bNum1 + bNum2
    mov     al, byte [bNum1]
    add     al, byte [bNum2]
    mov     byte [bAns], al

    ; wAns = wNum1 + wNum2
    mov     ax, word [wNum1]
    add     ax, word [wNum2]
    mov     word [wAns], ax

    ; dAns = dNum1 + dNum2
    mov     eax, dword [dNum1]
    add     eax, dword [dNum2]
    mov     dword [dAns], eax

    ; qAns = qNum1 + qNum2
    mov     rax, qword [qNum1]
    add     rax, qword [qNum2]
    mov     qword [qAns], rax

incAdd:
    inc     byte [bAns]
    inc     word [wAns]
    inc     dword [dAns]
    inc     qword [qAns]

carryAdd:
    ; dqSum = dquad1 + dquad2
    mov     rax, qword [dquad1]
    mov     rdx, qword [dquad1+8]
    add     rax, qword [dquad2]
    adc     rdx, qword [dquad2+8]
    mov     qword [dqSum], rax
    mov     qword [dqSum+8], rdx

; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall