; Brief: Simple example for data movement
; Author: Khoi Doan Minh
; Date: Sep 25, 2024
; ************************************************************
; ************************************************************
; Data Section
section .data

; Define constants
EXIT_SUCCESS    equ     0   ; successful operation
SYS_exit        equ     60  ; call code for terminate

; Define variables
dValue  dd  0
bNum    db  42
wNum    dw  5000
dNum    dd  73000
qNum    dq  73000000
bAns    db  0
wAns    dw  0
dAns    dd  0
qAns    dq  0

; ************************************************************
; Code Section
section     .text
global  _start
_start:

; dValue = 27
mov dword [dValue], 27

; bAns = bNum
mov al, byte [bNum]
mov byte [bAns], al

; wAns = wNum
mov ax, word [wNum]
mov word [wAns], ax

; dAns = dNum
mov eax, dword [dNum]
mov dword [dAns], eax

; qAns = qNum
mov rax, qword [qNum]
mov qword [qAns], rax

; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall