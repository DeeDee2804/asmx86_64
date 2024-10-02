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
    mov     rsi, 20
    call    readString

; -----
; Store the length of string
    mov     edi, eax
    mov     rsi, lenStr
    call    int2str

    mov     rdi, outputMesg
    call    printString


    mov     rdi, inLine
    call    printString

; -----
; Output the legnth of output text
    mov     rdi, newLine
    call    printString

    mov     rdi, lenMesg
    call    printString

    mov     rdi, lenStr
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
    inc     rsp
    push    rbx
    push    r12
    
; -----
; Read characters from user (one at a time)
    mov     rbx, rdi
    mov     r12, 0
    mov     r9, rsi     ; store the maximum length
    dec     r9          ; exclude the NULL character

readCharacters:
    mov     rax, SYS_read
    mov     rdi, STDIN
    lea     rsi, byte [rbp-1]     ; address of char
    mov     rdx, 1              ; how many character to read
    syscall

    mov     al, byte [rbp-1]
    cmp     al, LF
    je      readDone


    ; If number character already reads higher than len, 
    ; then not write in buffer
    inc     r12
    cmp     r12, r9         
    jae     readCharacters


    mov     byte [rbx], al
    inc     rbx

    jmp     readCharacters

readDone:
    mov     byte [rbx], NULL
    cmp     r12, r9
    jae     maxLen
    mov     rax, r12
    jmp     prtDone
maxLen:
    mov     rax, r9
readStringDone:
    ; prologue
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
; Simple function to convert an integer to ASCII string
; -----
; -----
; HLL call:
;   int2str(num, *str)
; -----
; Arguments:
;   num, dword value - edi
;   str, address - rsi
; ************************************************
global int2str
int2str:
    ; prologue
    push    rbp
    mov     rbp, rsp
    ; Allocate the space for dword local variable
    sub     rsp, 1
    push    rbx  
; -----
; Part A - Sign extraction
    mov     byte [rbp-1], 0
    cmp     edi, 0
    jge     division
    ; Set the local variable to 1 if number is negative
    mov     byte [rbp-1], 1

; Part B - Successive division
division:
    mov     eax, edi
    mov     rcx, 0
    mov     rbx, 10

divideLoop:
    ; divide number by 10
    cdq
    idiv    ebx
    ; push remainder to the stack
    push    rdx
    ; store the number of digit to rcx
    inc     rcx
    ; Check if the quotient is 0 or not
    cmp     eax, 0
    jne     divideLoop

; -----
; Part C - Convert remainders and store
    mov     rdi, 0

addSign:      
    cmp     byte [rbp-1], 0
; Add minus sign character if negative
    je      popLoop
    mov     byte [rsi+rdi], '-'
    inc     rdi

popLoop:
    pop     rax
    ; If number is negative, only take the absolute value
    cmp     byte [rbp-1], 0
    je      addAbs
    neg     al
addAbs:
    add     al, '0'
    mov     byte [rsi+rdi], al
    inc     rdi
    loop    popLoop
    ; Add NULL at the end of string
    mov     byte [rsi+rdi+1], NULL

    ; epilogue
    pop     rbx
    mov     rsp, rbp
    pop     rbp
ret
; *****************************************