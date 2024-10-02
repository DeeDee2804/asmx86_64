; Simple program to practice with console output, input
; *********************************************
; Author: Doan Minh Khoi
; Date: 2/10/2024
; *********************************************
; Data section
section .data

; -----
; Define standard constants
LF              equ     10  ; line feed
NULL            equ     0   ; end of string
TRUE            equ     1
FALSE           equ     0
STRLEN          equ     50

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
message1        db      "Hello World.", LF, NULL
prompt          db      "Enter Answer: ", NULL
newLine         db      LF, NULL

; ************************************************
; BSS section
section .bss

chr         resb    1
inLine      resb    STRLEN+2
; ************************************************
; Code section
section .text
global _start
_start:

; -----
; Display hello message
    mov     rdi, message1
    call    printString

; -----
; Display prompt message
    mov     rdi, prompt
    call    printString

; -----
; Read characters from user (one at a time)
    mov     rbx, inLine
    mov     r12, 0
readCharacters:
    mov     rax, SYS_read
    mov     rdi, STDIN
    lea     rsi, byte [chr]     ; address of char
    mov     rdx, 1              ; how many character to read
    syscall

    mov     al, byte [chr]
    cmp     al, LF
    je      readDone

    inc     r12
    cmp     r12, STRLEN         ; if number character already read
    jae     readCharacters      ; is higher than STRLEN, not write in buffer

    mov     byte [rbx], al
    inc     rbx

    jmp     readCharacters

readDone:
    mov     byte [rbx], NULL

; -----
; Output the line to verigy successful read
    mov     rdi, inLine
    call    printString

    mov     rdi, newLine
    call    printString
; -----
; Example program done
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
;
; Arguments:
;   1) Address, string
; Return:
;   Nothing
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
