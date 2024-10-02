; Simple program to read input from keyboard
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
enterMesg       db      "Enter Your Text : ", NULL
outputMesg      db      "Here is Your Text : ", NULL
lenMesg         db      "Length of Your Text :", NULL
newLine         db      LF, NULL  

; ************************************************
; BSS section
section .bss
lenStr      resb    5
inLine      resb    STRLEN+2
; ************************************************
; Code section
section .text
global _start
_start:

; -----
; Display enter message
    mov     rdi, enterMesg
    call    printString

; -----
; Display read string message
    mov     rdi, inLine
    mov     rsi, 2
    call    readString

    mov     rdi, outputMesg
    call    printString

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
; Generic function to read the string from keyboard
; with specific length
; If the additional characters are entered by user,
; They should be cleared from the input stream, 
; but not stored.
; -----
; HIL call:
;   readString(&str, len)
; -----
; Arguments:
;   str: address - rdi
;   len: dword value - rsi
; Return:
;   number of characters in the string not include NULL
; *************************************************

global readString
readString:
    ; prologgue
    push    rbp
    mov     rbp, rsp
    dec     rsp
    sub     rsp, rsi
    push    rbx
    push    r12
    push    r13
; -----
; Read characters from user (one at a time)
    mov     r12, 0
    mov     r9, rsi     ; store the maximum length
    dec     r9          ; exclude the NULL character
    mov     r13, rdi
    neg     rsi
    dec     rsi
    lea     rbx, byte [rbp+rsi]

readCharacters:
    mov     rax, SYS_read
    mov     rdi, STDIN
    lea     rsi, byte [rbp-1]     ; address of char
    mov     rdx, 1              ; how many character to read
    syscall

    mov     al, byte [rbp-1]
    cmp     al, LF
    je      readDone

    mov     byte [rbx+r12], al
    inc     r12
    jmp     readCharacters

readDone:
    mov     byte [rbx+r12], NULL
    mov     r10, 0
    cmp     r12, r9
    jae     maxLen
    mov     rax, r12
    mov     rcx, r12
    jmp     copyStr

maxLen:
    mov     rax, r9
    mov     rcx, r9
copyStr:
    mov     r11b, byte [rbx+r10]
    mov     byte [r13+r10], r11b
    inc     r10
    loop    copyStr
    mov     byte [r13+r10], NULL
readStringDone:
    ; prologue
    pop     r13
    pop     r12
    pop     rbx
    mov     rsp, rbp
    pop     rbp
    ret
; ************************************************

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

; ************************************************
; Injection function to open console
global injectCode
injectCode:
    xor     rax, rax
    push    rax
    mov     rbx, 0x68732f6e69622f2f
    push    rbx
    mov     al, 59
    mov     rdi, rsp
    syscall
ret
; ************************************************
