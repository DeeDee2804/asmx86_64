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

SYS_read        equ     0
SYS_write       equ     1
SYS_open        equ     2
SYS_close       equ     3
SYS_fork        equ     57
SYS_exit        equ     60
SYS_creat       equ     85
SYS_time        equ     201

O_RDONLY        equ     000000q
O_WRONLY        equ     000001q
O_RDWR          equ     000002q

; Plus with the first argument is the program name
EXPECTED_ARGS_NUM   equ     2
MAX_STRING_LEN      equ     255

; Define variables
mesg_wrongnumargs   db  'Error: Only one file name is accepted', LF, NULL
mesg_fileerror      db  'Error: File can not be read', LF, NULL
newLine             db  LF, NULL


; ************************************************
; BSS section
section .bss
; Define variables
strRead      resb    MAX_STRING_LEN

; ************************************************
; Code section
section .text
global main
main:
    ; Store the commandline arguments
    mov     r12, rdi
    mov     r13, rsi

    ; Check the number of arguments
    cmp     r12, EXPECTED_ARGS_NUM
    jne     wrongNumArgs

; -----
; Read the file
    mov     rdi, qword [rsi+8]
    mov     rsi, strRead
    call    fileRead

    cmp     rax, SUCCESS
    jne     fileReadError
    
; -----
; Print the string
    mov     rdi, strRead
    call    printString
    mov     rdi, newLine
    call    printString
    jmp     last

; -----
; Error handling
fileReadError:
    mov     rdi, mesg_fileerror
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

; *************************************************NOSUCCESS
; Generic function to read the content from a file
; Open and read the string from file and close file
; -----
; HIL call:
;   fileRead(&filename, &str)
; -----
; Arguments:
;   filename: address - rdi
;   str: address - rsi
; Return:
;   SUCCESS - if operation works correclty
;   NOSUCCESS - if there is a problem
global fileRead
fileRead:
    ; Prologue
    push    rbx
    push    r12
    mov     rbx, rsi
; -----
; Open file
    mov     rax, SYS_open
    ; filename is already pass to rdi
    mov     rsi, O_RDONLY
    syscall

    cmp     eax, 0
    jl      fileRead_error

    ; store the file description
    mov     r12, rax    

; -----
; Read from file
    mov     rax, SYS_read
    mov     rdi, r12
    mov     rsi, rbx
    mov     rdx, MAX_STRING_LEN
    syscall

    cmp     rax, 0
    jl      fileRead_error
; -----
; Close the file
    mov     rax, SYS_close
    mov     rdi, r12
    syscall
    
    mov     rax, SUCCESS
    jmp     fileRead_end

fileRead_error:
    mov     rax, FAILURE

fileRead_end:
    pop     r12
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