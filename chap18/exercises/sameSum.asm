; Simple program to demonstrate floating computation
; Prove that the comparision and calculation with
; floating include the errors.
; **************************************************
; Author: Doan Minh Khoi
; Date: 09/10/2024
; **************************************************
; Data section
section .data

; -----
; Define constants
NULL        equ     0
LF          equ     10
TRUE        equ     1
FALSE       equ     0
STDOUT      equ     1

EXIT_SUCCESS    equ     0
SYS_write       equ     1
SYS_exit        equ     60

; -----
; Define variables
posOne          dq  1.0
zeroPointOne    dq  0.1
sumOne          dq  0.0             
sameMsg         db  "Are Same", LF, NULL
notSameMsg      db  "Are Not Same", LF, NULL

; **************************************************
; Code section
section .text
global _start
_start:

; -----
; Loop ten times to take the sum
    mov     ecx, 10
    movsd   xmm1, qword [sumOne]
    movsd   xmm0, qword [zeroPointOne]
sumLp:
    addsd   xmm1, xmm0
    loop    sumLp

    movsd   qword [sumOne], xmm1

; -----
; Compare the result
    ucomisd     xmm1, qword [posOne]
    je          sameOne
    mov         rdi, notSameMsg
    call        printString
    jmp         last

sameOne:
    mov     rdi, sameMsg
    call    printString
; -----
; Done, terminate program
last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall

; ************************************************
; Generic function to display a string to the screen.
; String must be NULL terminated
; Algorithm:
;   Count characters in string (excluding NULL)
;   Use syscall to output characters
; -----
; HIL call:
;   printString(&str)
; -----
; Arguments:
;   str, address - rdi
; -----
; Return:
;   Nothing
; ************************************************
global printString
printString:
    ; prologue
    push    rbx

; -----
; Count characters in string
    mov     rbx, rdi
    mov     rdx, 0
countLoop:
    cmp     byte [rbx], NULL
    je      countDone
    inc     rdx
    inc     rbx
    jmp     countLoop
countDone:
    cmp     rdx, 0
    je      printDone

; -----
; Call OS to output string
    mov     rax, SYS_write
    mov     rsi, rdi
    mov     rdi, STDOUT
    ; set rdx = count to write, set above
    syscall
; -----
; String printed, return to calling routine
printDone:
    pop     rbx
    ret
; ************************************************