; Simple example to call an external function.
; *******************************************
; Data section
section .data

; -----
; Define constant data
LF              equ     10  ; line feed
NULL            equ     0   ; end of string

TRUE            equ     1
FALSE           equ     0

EXIT_SUCCESS    equ     0
SYS_exit        equ     60

; -----
; Declare the data

lst1            dd  1, -2, 3, -4, 5
                dd  7, 9, 11
len1            dd  8

lst2            dd  2, -3, 4, 5, 6
                dd  -7, 10, 12, 14, 16
len2            dd  10

; *******************************************
; BSS section
section .bss
sum1        resd    1
ave1        resd    1

sum2        resd    1
ave2        resd    1

extern stats

; *******************************************
; Code section
section .text
global _start
_start:

; -----
; Call the function
;   HIL call: stats(&lst, len, &sum, &ave)

    mov     rdi, lst1
    mov     esi, dword [len1]
    mov     rdx, sum1
    mov     rcx, ave1
    call    stats

    mov     rdi, lst2
    mov     esi, dword [len2]
    mov     rdx, sum2
    mov     rcx, ave2
    call    stats

; -----
; Terminate program
last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall

