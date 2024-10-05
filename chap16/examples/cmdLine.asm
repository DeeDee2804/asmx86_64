; Command line arguments example
; *******************************
; Author: Doan Minh Khoi
; Date: 03/10/2024
; *******************************
section .note.GNU-stack noalloc noexec nowrite progbits

; Data section
section .data

; -----
; Define standard constants
LF              equ     10  ; line feed
NULL            equ     0   ; end of string
TRUE            equ     1
FALSE           equ     0
EXIT_SUCCESS    equ     0

STDIN           equ     0
STDOUT          equ     1
STDERR          equ     2

SYS_read        equ     0
SYS_write       equ     1
SYS_open        equ     2
SYS_close       equ     3
SYS_fork        equ     57
SYS_exit        equ     60
SYS_creat       equ     85
SYS_time        equ     201

; -----
; Define some strings
newLine         db      LF, NULL  

; *****************************************
section .text
global main
main:
; -----
; Get command line arguments and echo to the screen
; Based on the standard calling convention.
;   rdi = argc (argument count)
;   rsi = argv (starting address of argument vector)

    mov     r12, rdi
    mov     r13, rsi

; -----
; Simple loop to display each argument to the screen
; Each argument is a NULL terminated string, so can just
; print directly.
printArguments:
    mov     rbx, 1
printLoop:
    mov     rdi, qword [r13+rbx*8]
    call    printString

    mov     rdi, newLine
    call    printString

    inc     rbx
    cmp     rbx, r12
    jl      printLoop

; -----
; Example done
exampleDone:
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
    je      prtDone

; -----
; Call OS to output string
    mov     rax, SYS_write
    mov     rsi, rdi
    mov     rdi, STDOUT
    ; set rdx = count to write, set above
    syscall
; -----
; String printed, return to calling routine
prtDone:
    pop     rbx
    ret
; ************************************************