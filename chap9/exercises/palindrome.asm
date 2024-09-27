; Simple program to check a string null terminated is 
; Reverse a list of numbers - in place.
; Method: Put each number on stack, then pop each number
;         back off, and then put back into memory.
; ************************************************************
; Author: Khoi Doan Minh
; Date: 27/09/2024
; ************************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; Define variable
string1 db  "hannah", 0
len1    db  6
string2 dw  'hanna', 0
len2    db  5
res     db  1
; ************************************************************
; Code section
section .text
global  _start
_start:
movzx   rcx, byte [len1]
mov     rsi, 0
mov     rbx, string1
mov     rax, 0

; -----
; Loop to put character on stack
pushLoop:
    movzx   rax, byte [rbx+rsi]
    push    rax
    inc     rsi
    loop    pushLoop

movzx   rcx, byte [len1]
mov     rsi, 0
popLoop:
    pop     rax
    cmp     byte [rbx+rsi], al
    jne     notPalindrome
    inc     rsi
    loop    popLoop
jmp last

notPalindrome:
    mov     byte [res], 0
; ************************************************************
; Done, terminate program.

last:
    mov     rax, SYS_exit       ; Call code for exit
    mov     rbx, EXIT_SUCCESS   ; Exit program with success
    syscall

