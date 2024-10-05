; Program to read three integers from command line 
; and print the sum of it to console.
; Raise error if the argument is not valid.
; Assume all the arguments are unsigned integers
; ************************************************
; Author: Doan Minh Khoi
; Date: 06/10/2024
; ************************************************
section .note.GNU-stack noalloc noexec nowrite progbits

; Data section
section .data

; Define constants
SUCCESS         equ     0
FAILURE         equ     1
NULL            equ     0
LF              equ     10
EXIT_SUCCESS    equ     0

STDOUT          equ     01

SYS_write       equ     01
SYS_exit        equ     60

; Plus with the first argument is the program name
EXPECTED_ARGS_NUM   equ     4 

; Define variables
mesg_wrongnumargs   db  'Error: The number of arguments must be 3', LF, NULL
mesg_wrongfmtargs   db  'Error: The argument must be valid number', LF, NULL
newLine             db  LF, NULL

sum      dq      0

; ************************************************
; BSS section
section .bss
; Define variables
num         resq    1
sumStr      resb    15

; ************************************************
; Code section
section .text
global main
main:
    ; Store the commandline arguments
    mov     rcx, rdi
    mov     r13, rsi

    ; Check the number of arguments
    cmp     rcx, EXPECTED_ARGS_NUM
    jne     wrongNumArgs

; -----
; Check each argument
    mov     rbx, 1
checkLoop:
    mov     r12, [r13+rbx*8]
    ; Print the argument
    mov     rdi, r12
    call    printString
    mov     rdi, newLine
    call    printString
    ; Convert each argument
    mov     rdi, [r13+rbx*8]
    mov     rsi, num
    call    str2int
    ; If wrong format, stop the program
    cmp     eax, SUCCESS
    jne     wrongFmtArgs
    mov     rax, qword [num]
    add     qword [sum], rax
    ; Process the loop
    inc     rbx
    cmp     rbx, EXPECTED_ARGS_NUM
    jne     checkLoop
; -----
; Print the sum
    mov     rdi, qword [sum]
    mov     rsi, sumStr
    call    int2str

    mov     rdi, sumStr
    call    printString
    mov     rdi, newLine
    call    printString
    jmp     last

; -----
; Error handling
wrongFmtArgs:
    mov     rdi, mesg_wrongfmtargs
    call    printString
    jmp     last

wrongNumArgs:
    mov     rdi, mesg_wrongnumargs
    call    printString
    jmp     last

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall


; ************************************************
; Simple function to convert an string to unsinged
; integer
; -----
; -----
; HLL call:
;   str2int(&str, &num)
; -----
; Arguments:
;   &str, address - rdi
;   &num, address - rsi
; Return:
;   SUCCESS if the string is valid else FAILURE
global str2int
str2int:
; -----
; Prologue
    push    rbp
    push    rbx
    mov     rbp, rsp

    ; Base factor
    mov     r10, 10
    ; Current factor
    mov     r11, 1

; -----
; Step 1: Split the string and verify each character
    mov     rcx, 0

extractLoop:
    mov     al, byte [rdi+rcx]
    
    ; Loop until meet NULL character
    cmp     al, NULL
    je      combineDigits

    ; Check the character in range
    cmp     al, '0'
    jb      invalidStr
    cmp     al, '9'
    ja      invalidStr
    
    ; Convert to number and push to stack
    sub     al, '0'
    movzx   rax, al
    push    rax

    ; Increase num of digits and repeat loop
    inc     rcx
    jmp     extractLoop

; -----
; Step 2: Combine all digits to complete number
combineDigits:
; Init the number
    mov     rbx, 0

combineLoop:
    ; Pop digit from stack and add with its base
    ; position to number
    pop     rax
    mul     r11
    add     rbx, rax

    ; Update current factor
    mov     rax, r11
    mul     r10  
    mov     r11, rax
    loop    combineLoop

    ; Return the converted number and return value
    mov     qword [rsi], rbx
    mov     eax, SUCCESS
    jmp     str2intRet

invalidStr:
    mov     eax, FAILURE

str2intRet:
    ; Must store the rsp before go into function to 
    ; hanlde the failure case where the stack not pop
    ; off correctly
    mov     rsp, rbp
    pop     rbx
    pop     rbp
    ret
; ************************************************

; ************************************************
; Simple function to convert unsigned integer to 
; ASCII string
; -----
; -----
; HLL call:
;   int2str(num, *str)
; -----
; Arguments:
;   num, qword value - rdi
;   str, address - rsi
; ************************************************
global int2str
int2str:
; Prologue
    push    rbx  

; Step 1: Successive division
division:
    mov     rax, rdi
    mov     rcx, 0
    mov     rbx, 10

divideLoop:
    ; divide number by 10
    mov     rdx, 0
    div     rbx
    ; push remainder to the stack
    push    rdx
    ; store the number of digit to rcx
    inc     rcx
    ; Check if the quotient is 0 or not
    cmp     rax, 0
    jne     divideLoop

; -----
; Step 2: Convert remainders and store
    mov     rdi, 0

popLoop:
    pop     rax
    add     al, '0'
    mov     byte [rsi+rdi], al
    inc     rdi
    loop    popLoop
    ; Add NULL at the end of string
    mov     byte [rsi+rdi+1], NULL

; Epilogue
    pop     rbx
    ret
; *****************************************

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