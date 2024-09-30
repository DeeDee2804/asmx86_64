; Simple program to demonstrate the function
; Calculate the sum and average of array
;   stats1(arr, len, &sum, &ave)
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
list1       dd  4, 5, 2, -3, 1
len1        dd  5
sum1        dd  0
ave1        dd  0

list2       dd  2, 6, 3, -2, 1, 8, 19
len2        dd  7
sum2        dd  0
ave2        dd  0

; -----
; Simple example function to find and return
; the sum and average of an array
; HLL call:
;   stats1(arr, len, sum, ave)
; -----
; Arguments:
;   arr, address -rdi
;   len, dword value -esi
;   sum, address - rdx
;   ave, address - rcx

; ***************************************
; Code section
section .text
global stats1
stats1:
    ;prologue
    push    r12     
    
    mov     r12, 0  ; index
    mov     rax, 0  ; temporary sum
sumLoop:
    add     eax, dword [rdi+r12*4]
    inc     r12
    cmp     r12, rsi
    jl      sumLoop

    mov     dword [rdx], eax    ; return sum

    cdq
    idiv    esi                 ; compute average
    mov     dword [rcx], eax    ; return ave
    ; epilogue
    pop     r12
    ret

global _start
_start:
    mov     rcx, ave1
    mov     rdx, sum1
    mov     esi, dword [len1]
    mov     rdi, list1
    call stats1
    mov     rcx, ave2
    mov     rdx, sum2
    mov     esi, dword [len2]
    mov     rdi, list2
    call stats1

; -----
; Done, terminate the program
last:
    mov     eax, SYS_exit
    mov     ebx, EXIT_SUCCESS
    syscall