; Simple example void function
; ***************************************
; Data section
section .data

NULL        equ     0
SYS_write   equ     1
STDOUT      equ     1
; ***************************************
; Code section
section .text

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