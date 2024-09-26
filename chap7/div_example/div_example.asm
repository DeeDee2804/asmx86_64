; Brief: Simple program for division operation in assembly
; Author: Khoi Doan Minh
; Date: 26/09/2024
; ************************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; Define variable
bNumA   db  63
bNumB   db  17
bNumC   db  5
bAns1   db  0
bAns2   db  0
bRem2   db  0
bAns3   db  0

wNumA   dw  4321
wNumB   dw  1234
wNumC   dw  167
wAns1   dw  0
wAns2   dw  0
wRem2   dw  0
wAns3   dw  0

dNumA   dd  42000
dNumB   dd  -3157
dNumC   dd  -293
dAns1   dd  0
dAns2   dd  0
dRem2   dd  0
dAns3   dd  0

qNumA   dq  730000
qNumB   dq  -13456
qNumC   dq  -1279
qAns1   dq  0
qAns2   dq  0
qRem2   dq  0
qAns3   dq  0

; Code section
section .text
global  _start
_start:

normalDiv: 
    ; bAns1 = bNumA / 3
    mov     al, byte [bNumA]
    mov     ah, 0
    ; Divident src in div could not be a immediate
    mov     bl, 3
    div     bl
    mov     byte [bAns1], al

    ; bAns2 = bNumA / bNumB
    ; bRem2 = bNumA % bNumB
    mov     ax, 0
    mov     al, byte [bNumA]
    div     byte [bNumB]
    mov     byte [bAns2], al
    mov     byte [bRem2], ah

    ; bAns3 = (bNumA * bNumC) / bNumB
    mov     al, byte [bNumA]
    mul     byte [bNumC]
    div     byte [bNumB]
    mov     byte [bAns3], al

    ; wAns1 = wNumA / 5
    mov     ax, word [wNumA]
    mov     dx, 0
    ; Divident src in div could not be a immediate
    mov     bx, 5
    div     bx
    mov     word [wAns1], ax

    ; wAns2 = wNumA / wNumB
    ; wRem2 = wNumA % wNumB
    mov     ax, word [wNumA]
    mov     dx, 0
    div     word [wNumB]
    mov     word [wAns2], ax
    mov     word [wRem2], dx

    ; wAns3 = (wNumA * wNumC) / wNumB
    mov     ax, word [wNumA]
    mul     word [wNumC]
    div     word [wNumB]
    mov     word [wAns3], ax

signedDiv:
    ; dAns1 = dNumA / 7
    mov     eax, dword [dNumA]
    cdq     ; eax -> edx:eax
    ; Divident src in div could not be a immediate
    mov     ebx, 7
    idiv    ebx
    mov     dword [dAns1], eax

    ; dAns2 = dNumA / dNumB
    ; dRem2 = dNumA % dNumB
    mov     eax, dword [dNumA]
    cdq     ; eax -> edx:eax
    idiv    dword [dNumB]
    mov     dword [dAns2], eax
    mov     dword [dRem2], edx

    ; dAns3 = (dNumA * dNumC) / dNumB
    mov     eax, dword [dNumA]
    imul    dword [dNumC]
    idiv    dword [dNumB]
    mov     dword [dAns3], eax

    ; qAns1 = qNumA / 9
    mov     rax, qword [qNumA]
    cqo     ; rax -> rdx:rax
    ; Divident src in div could not be a immediate
    mov     rbx, 9
    idiv    rbx
    mov     qword [qAns1], rax

    ; qAns2 = qNumA / qNumB
    ; qRem2 = qNumA % qNumB
    mov     rax, qword [qNumA]
    cqo     ; rax -> rdx:rax
    idiv    qword [qNumB]
    mov     qword [qAns2], rax
    mov     qword [dRem2], rdx

    ; qAns3 = (qNumA * qNumC) / qNumB
    mov     rax, qword [qNumA]
    imul    qword [qNumC]
    idiv    qword [qNumB]
    mov     qword [qAns3], rax
    
; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall