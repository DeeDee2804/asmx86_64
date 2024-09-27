; Program to check a string null terminated is palindrome
; Return the boolean value 0 if not and 1 if it is palindrome
; Method: Ignore the punctuation (comma, dash, exclamation point),
;         and spaces
; ************************************************************
; Author: Khoi Doan Minh
; Date: 27/09/2024
; ************************************************************
; Data section
section .data

; Define constant
EXIT_SUCCESS    equ     0
SYS_exit        equ     60
MAX_LOOP        equ     100

; Define variable
input_string    db  'a man, a plan, a canal - panama!', 0
len             db  0         
res             db  1
; ************************************************************
; BSS section
section .bss

; Define uninit
formated_string resb    30

; ************************************************************
; Code section
section .text
global  _start
_start:
; Find the length of formatted string
mov     rsi, 0
mov     rdi, 0
mov     rbx, input_string
mov     rcx, formated_string
lenLoop:
    mov     al, byte [rbx+rsi]
    ; Check if the string is terminated
    cmp     al, 0
    je      endString
    ; Check if the character is special
    cmp     al, ' '
    je      endLoop
    cmp     al, '!'
    je      endLoop
    cmp     al, '-'
    je      endLoop
    cmp     al, ','
    je      endLoop
    ; Add valid character to the formatted string
    movzx   rdi, byte [len]
    mov     byte [rcx+rdi], al
    inc     byte [len]
endLoop:
    inc     rsi
    ; Check to avoid the infinite loop with bad input
    cmp     rsi, MAX_LOOP
    je      endString
    jmp     lenLoop

; Add NULL terminate at the end of format string
endString:
    movzx rdi, byte [len]
    mov byte [formated_string+rdi], 0

; Check the formatted string is palindrome or not
; by reuse the logic of simple program
movzx   rcx, byte [len]
mov     rsi, 0
mov     rbx, formated_string
mov     rax, 0

; -----
; Loop to put character on stack
pushLoop:
    movzx   rax, byte [rbx+rsi]
    push    rax
    inc     rsi
    loop    pushLoop

movzx   rcx, byte [len]
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

