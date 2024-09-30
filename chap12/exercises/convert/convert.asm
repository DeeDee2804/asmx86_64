; Simple program to convert an integer to right-justified
; ASCII string with sign and NULL terminated. It also support
; to revert valid string back to integer
; Solve the exercises 6, 7
; ******************************************************
; Author: Doan Minh Khoi
; Date: 30/09/2024
; ******************************************************
; Data section
section .data

; -----
; Define constants
EXIT_SUCCESS        equ     0
SYS_exit            equ     60
NULL                equ     0
TRUE                equ     1
FALSE               equ     0

; Define variables
num1    dd  2300
num2    dd  -32768
num3    dd  -101
teststr1   db  ' -1456', NULL
teststr2   db  '  +23458', NULL
teststr3   db  ',101', NULL
teststr4   db  '12ab', NULL
testint1   dd   0
testint2   dd   0
testint3   dd   0
testint4   dd   0
testret1   db   0
testret2   db   0
testret3   db   0
testret4   db   0
len     dd  4

; ******************************************************
; BSS section
section .bss

str1        resd    10
str2        resd    10
str3        resd    10

; ***************************************
; Code section
section .text

; -----
; Simple function to convert an integer to ASCII string
; -----
; -----
; HLL call:
;   int2str(num, *str, len)
; -----
; Arguments:
;   num, dword value - edi
;   str, address - rsi
;   len, dword value - edx
global int2str
int2str:
    ; prologue
    push    rbp
    mov     rbp, rsp
    ; Allocate the space for dword local variable
    sub     rsp, 1
    push    rbx
    ; Pass the len argument to temp register
    mov     r10, rdx    
; -----
; Part A - Sign extraction
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
    mov     r11, rcx
    ; Length of the string add sign and NULL character
    add     r11, 2
    cmp     r10, r11
    jge     blanklLoop
    sub     r10, 2
    mov     rcx, r10
    jmp     addSign
; Add blank space if length of converted string is 
; less than expected length
blanklLoop:
    cmp     r11, r10
    je      addSign
    mov     byte [rsi+rdi], ' '
    inc     r11
    inc     rdi
    jmp     blanklLoop

addSign:      
    cmp     byte [rbp-1], 0
; Add minus sign character if negative
    je      addPlusSign
    mov     byte [rsi+rdi], '-'
    jmp     popLoop
; Else add plus sign
addPlusSign:
    mov     byte [rsi+rdi], '+'

popLoop:
    inc     rdi
    pop     rax
    ; If number is negative, only take the absolute value
    cmp     byte [rbp-1], 0
    je      addAbs
    neg     al
addAbs:
    add     al, '0'
    mov     byte [rsi+rdi], al
    loop    popLoop
    ; Add NULL at the end of string
    mov     byte [rsi+rdi+1], NULL

    ; epilogue
    pop     rbx
    mov     rsp, rbp
    pop     rbp
ret
; End int2str function

; -----
; Simple function to convert ASCII string to integer
; -----
; -----
; HLL call:
;   str2int(&str, &num)
; -----
; Arguments:
;   &str, address - rdi
;   &num, address - rsi
global str2int
str2int:
    ; prologue
    push rbx
    ; r10 will stored the base factor
    mov     r10, 10
    ; r11 will stored the current factor
    mov     r11, 1
    ; -----
    ; Part A - Sign extraction
extractSign:
    cmp     byte [rdi], '-'
    je      isNeg
    cmp     byte [rdi], '+'
    je      updateBase
    cmp     byte [rdi], ' '
    jne     invalidStr
    inc     rdi
    jmp     extractSign

    ; Number is negative, modify the pos and base address
    isNeg:
    neg     r11
    ; Move to next character
    updateBase:
    inc     rdi     

; Part B - Successive extract number
extractNum:
    mov     rcx, 0

extractLoop:
    mov     al, byte [rdi+rcx]
    cmp     al, NULL
    je      aggregate
    cmp     al, '0'
    jb      invalidStr
    cmp     al, '9'
    ja      invalidStr
    sub     al, '0'
    movzx   rax, al
    ; push number to stack
    push    rax
    ; store the number of digit to rcx
    inc     rcx
    jmp     extractLoop

; -----
; Part C - Aggreate all number to the complete number
aggregate:
; store the temp number
mov     rbx, 0

sumLoop:
    pop     rax
    cdq
    ; Multiply with current factor
    imul    r11
    add     rbx, rax
    ; Update current factor
    mov     rax, r11
    cdq
    imul    r10
    mov     r11, rax
    loop    sumLoop

    ; Return the converted number and return value
    mov     dword [rsi], ebx
    mov     eax, TRUE
    jmp     str2intRet

invalidStr:
    mov     eax, FALSE

str2intRet:
    pop     rbx
    ret
; End str2int function

; -----
; Main function
global _start
_start:
    mov     edx, dword [len]
    mov     rsi, str1
    mov     edi, dword [num1] 
    call    int2str
    mov     edx, dword [len]
    mov     rsi, str2
    mov     edi, dword [num2] 
    call    int2str
    mov     edx, dword [len]
    mov     rsi, str3
    mov     edi, dword [num3] 
    call    int2str

    mov     rsi, testint1
    mov     rdi, teststr1 
    call    str2int
    mov     byte [testret1], al

    mov     rsi, testint2
    mov     rdi, teststr2 
    call    str2int
    mov     byte [testret2], al

    mov     rsi, testint3
    mov     rdi, teststr3 
    call    str2int
    mov     byte [testret3], al

    mov     rsi, testint4
    mov     rdi, teststr4 
    call    str2int
    mov     byte [testret4], al
; -----
; Done, terminate the program
last:
    mov     eax, SYS_exit
    mov     ebx, EXIT_SUCCESS
    syscall   
