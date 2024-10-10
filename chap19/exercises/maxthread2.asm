; Simple program to demonstrate the race condition
; **************************************************
; Author: Doan Minh Khoi
; Date: 09/10/2024
; **************************************************
extern pthread_create
extern pthread_join

; **************************************************
section .note.GNU-stack noalloc noexec nowrite progbits

; **************************************************
; Data section
section .data

; -----
; Define constants
TRUE        equ     1
FALSE       equ     0
LF          equ     10
NULL        equ     0
MAX         equ     10000000

EXIT_SUCCESS    equ     0

STDIN           equ     00
STDOUT          equ     01
STDERR          equ     02

SYS_read        equ     0
SYS_write       equ     1
SYS_open        equ     2
SYS_close       equ     3
SYS_fork        equ     57
SYS_exit        equ     60
SYS_creat       equ     85
SYS_time        equ     201

; -----
; Define variables
pthreadID0  dq  0
pthreadID1  dq  0
newLine     db  LF, NULL
myValue     dq  0
x           dq  1
y           dq  1

; **************************************************
; BSS section
section .bss

numstr      resq    1
timestr     resq    1

; **************************************************
; Code section
section .text
global main
main:
    ; Stack alignment to enable syscall run success
    sub     rsp, 8
; -----
; Start the timer
    rdtsc
    shl     rdx, 32
    or      rax, rdx
    mov     rbx, rax    
; -----
; Create thread
; pthread_create(&pthreadID0, NULL, &threadFunc, NULL)
    lea     rdi, [pthreadID0]
    mov     rsi, NULL
    lea     rdx, [threadFunc0]
    mov     rcx, NULL
    mov     r10, NULL
    call    pthread_create

    mov     rdi, pthreadID1
    mov     rsi, NULL
    mov     rdx, threadFunc1
    mov     rcx, NULL
    call    pthread_create

; pthread_join (pthreadID0, NULL);
    mov     rdi, qword [pthreadID0]
    mov     rsi, NULL
    call    pthread_join

    mov     rdi, qword [pthreadID1]
    mov     rsi, NULL
    call    pthread_join

; -----
; Stop the timer
    rdtsc
    shl     rdx, 32
    or      rax, rdx
    sub     rax, rbx   

; -----
; Show the time elapsed
    mov     rdi, rax
    lea     rsi, [timestr]
    call    int2str

    mov     rdi, timestr
    call    printString

    mov     rdi, newLine
    call    printString
; -----
; print the final value
    mov     rdi, qword [myValue]
    mov     rsi, numstr
    call    int2str

    mov     rdi, numstr
    call    printString

    mov     rdi, newLine
    call    printString

; -----
; Done, terminate program
last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall

; ************************************************
global threadFunc0
threadFunc0:
; Perform MAX / 2 iterations to update the myValue
    ; Prologue
    push    rsp
    mov     rbp, rsp
    sub     rsp, 8

    mov     rcx, MAX
    shr     rcx, 1
    mov     r10, qword [x]
    mov     r11, qword [y]

incLoop0:
    ; myValue
    mov     rax, qword [myValue]
    cqo     
    div     r10
    add     rax, r11
    mov     qword [myValue], rax
    loop    incLoop0
    ;epilogue
    mov     rsp, rbp
    pop     rbp
    ret
; ************************************************

; ************************************************
global threadFunc1
threadFunc1:
; Perform MAX / 2 iterations to update the myValue
    ; Prologue
    push    rsp
    mov     rbp, rsp
    sub     rsp, 8

    mov     rcx, MAX
    shr     rcx, 1
    mov     r10, qword [x]
    mov     r11, qword [y]
incLoop1:
    ; myValue
    mov     rax, qword [myValue]
    cqo     
    div     r10
    add     rax, r11
    mov     qword [myValue], rax
    loop    incLoop1
    ;epilogue
    mov     rsp, rbp
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
; Return:
;   Number of characters excepted NULL
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
    mov     byte [rsi+rdi], NULL
    ; Return the number of characters
    mov     rax, rdi
; Epilogue
    pop     rbx
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