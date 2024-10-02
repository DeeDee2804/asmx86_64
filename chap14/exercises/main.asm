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

sumMesg         db  "Sum of array: ", NULL
aveMesg         db  "Average of array: ", NULL
newLine         db  LF, NULL

lst2            dd  2, -3, 4, 5, 6
                dd  -7, 10, 12, 14, 17
len2            dd  10

; *******************************************
; BSS section
section .bss

sum2        resd    1
ave2        resd    1
sumStr      resb    5
aveStr      resb    5

extern lstSum, lstAverage
extern printString, int2str
; *******************************************
; Code section
section .text
global _start
_start:

; -----
; Call the function
;   HIL call: stats(&lst, len, &sum, &ave)

    mov     rdi, lst2
    mov     esi, dword [len2]
    call    lstSum
    mov     dword [sum2], eax

    mov     rdi, lst2
    mov     esi, dword [len2]
    call    lstAverage
    mov     dword [ave2], eax

    mov     rdi, sumMesg
    call    printString

    mov     edi, dword [sum2]
    mov     rsi, sumStr
    call    int2str

    mov     rdi, sumStr
    call    printString

    mov     rdi, newLine
    call    printString

    mov     rdi, aveMesg
    call    printString

    mov     edi, dword [ave2]
    mov     rsi, aveStr
    call    int2str

    mov     rdi, aveStr
    call    printString

    mov     rdi, newLine
    call    printString

; -----
; Terminate program
last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall

