; Simple program to demonstrate the function
; Calculate the min, max, median, sum and 
; average of array
;   stats2(arr, len, &min, &med1, &med2, &max, &sum, &ave)
; Assume the array is sorted ascending.
; ***************************************
; Author: Doan Minh Khoi
; Date: 29/09/2024
; ***************************************
; Data section
section .data

; -----
; Define constants
EXIT_SUCCESS        equ 0
SYS_exit            equ 60

; Define variables
list        dd  1, 6, 9, 10, 14, 19
len         dd  6
min         dd  0
max         dd  0
med1        dd  0
med2        dd  0
sum         dd  0
ave         dd  0

; ***************************************
; Code section
section .text

; -----
; Simple example function to find and return the minimum,
; maximum, sum, medians, and average of an array.
; HLL call:
;   stats2(arr, len, &min, &med1, &med2, &max, &sum, &ave)
; -----
; Arguments:
;   arr, address -rdi
;   len, dword value -esi
;   min, address - rdx
;   med1, address - rcx
;   med2, address - r8
;   max, address - r9
;   sum, address - stack (rbp + 16)
;   ave, address - stack (rbp + 24)
global stats2
stats2:
    ;prologue     
    push    rbp
    mov     rbp, rsp
    push    r12

; -----
; Get min and max
    mov     eax, dword [rdi]
    mov     dword [rdx], eax    ; get the min
    mov     r12, rsi
    dec     r12
    mov     eax, dword [rdi+r12*4]
    mov     dword [r9], eax     ; get the max

; -----
; Get median
    mov     rax, rsi
    mov     rdx, 0
    mov     r12, 2
    div     r12                 ; get length / 2

    cmp     rdx, 0
    je      evenLength

    mov     r12d, dword [rdi+rax*4]
    mov     dword [rcx], r12d   ; get med1
    mov     dword [r8], r12d    ; get med2
    jmp     medDone
evenLength:
    mov     r12d, dword [rdi+rax*4]
    mov     dword [r8], r12d    ; get med2
    dec     rax                 ; get length / 2 - 1
    mov     r12d, dword [rdi+rax*4]
    mov     dword [rcx], r12d   ; get med1

medDone:

; -----
; Find sum
    mov     r12, 0
    mov     rax, 0
sumLoop:
    add     eax, dword [rdi+r12*4]
    inc     r12
    cmp     r12, rsi
    jl      sumLoop

    mov     r12,  qword [rbp+16]
    mov     dword [r12], eax    ; return sum

    cdq
    idiv    rsi                 ; compute average
    mov     r12, qword [rbp+24]
    mov     dword [r12], eax    ; return ave
    ; epilogue
    pop     r12
    pop     rbp
    ret

; -----
; Main function
global _start
_start:
    push    ave
    push    sum
    mov     r9, max
    mov     r8, med2
    mov     rcx, med1
    mov     rdx, min
    mov     esi, dword [len]
    mov     rdi, list
    call stats2
    add     rsp, 16     ; free the additional argument spaces
    
; -----
; Done, terminate the program
last:
    mov     eax, SYS_exit
    mov     ebx, EXIT_SUCCESS
    syscall