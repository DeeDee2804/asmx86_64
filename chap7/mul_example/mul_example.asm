; Brief: Simple program for multiplication operation in assembly
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
wAns    dw  0
wAns1   dw  0

wNum1   dw  4321
wNum2   dw  1234
dAns2   dd  0

dNum1   dd  42000
dNum2   dd  73000
qAns3   dq  0

qNum1   dq  42000000
qNum2   dq  73000000
dqAns4  ddq 0

wNumA   dw  1200
wNumB   dw  -2000
wAns5   dw  0
wAns6   dw  0
dAns6   dd  0

dNumA   dd  42000
dNumB   dd  -13000
dAns7   dd  0
dAns8   dd  0

qNumA   dq  120000
qNumB   dq  -230000
qAns9   dq  0
qAns10  dq  0

; Code section
section .text
global  _start
_start:

normalMul: 
    ; wAns = bNum1 ^ 2
    mov     al, byte [bNum1]
    mul     byte [bNum1]
    mov     word [wAns], ax

    ; wAns1 = bNum1 * bNum2
    mov     al, byte [bNum1]
    mul     byte [bNum2]
    mov     word [wAns1], ax

    ; dAns2 = wNum1 * wNum2
    mov     ax, word [wNum1]
    mul     word [wNum2]
    mov     word [dAns2], ax
    mov     word [dAns2+2], dx

    ; qAns3 = dNum1 * dNum2
    mov     eax, dword [dNum1]
    mul     dword [dNum2]
    mov     dword [qAns3], eax
    mov     dword [qAns3+4], edx

    ; dqAns4 = qNum1 * qNum2
    mov     rax, qword [qNum1]
    mul     qword [qNum2]
    mov     qword [dqAns4], rax
    mov     qword [dqAns4+8], rdx

signedMul:
    ; wAns5 = wNumA * -13
    mov     ax, word [wNumA]
    imul    ax, -13
    mov     word [wAns5], ax

    ; wAns6 = wNumA * wNumB
    mov     ax, word [wNumA]
    imul    ax, word [wNumB]
    mov     word [wAns6], ax

    ; wAns6 = wNumA * wNumB
    mov     ax, word [wNumA]
    imul    word [wNumB]
    mov     word [dAns6], ax
    mov     word [dAns6+2], dx

    ; dAns7 = dNumA * 113
    mov     eax, dword [dNumA]
    imul    eax, 113
    mov     dword [dAns7], eax

    ; dAns8 = dNumA * dNumB
    mov     eax, dword [dNumA]
    imul    eax, dword [dNumB]
    mov     dword [dAns8], eax

    ; qAns9 = qNumA * 7096
    mov     rax, qword [qNumA]
    imul    rax, 7096
    mov     qword [qAns9], rax

    ; qAns10 = qNumA * qNumB
    mov     rax, qword [qNumA]
    imul    rax, qword [qNumB]
    mov     qword [qAns10], rax


; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall