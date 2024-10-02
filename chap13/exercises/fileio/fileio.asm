; Simple program to read write with file
; *********************************************
; Author: Doan Minh Khoi
; Date: 2/10/2024
; *********************************************
; Data section
section .data

; -----
; Define standard constants
LF              equ     10  ; line feed
NULL            equ     0   ; end of string
TRUE            equ     1
FALSE           equ     0
STRLEN          equ     50
SUCCESS         equ     0
NOSUCCESS       equ     1
MAXPWLEN        equ     12
EXIT_SUCCESS    equ     0

STDIN           equ     0
STDOUT          equ     1
STDERR          equ     2

SYS_read        equ     0
SYS_write       equ     1
SYS_open        equ     2
SYS_close       equ     3
SYS_fork        equ     57
SYS_exit        equ     60
SYS_creat       equ     85
SYS_time        equ     201

O_CREAT         equ     0x40
O_TRUNC         equ     0x200
O_APPEND        equ     0x400

O_RDONLY        equ     000000q
O_WRONLY        equ     000001q
O_RDWR          equ     000002q

S_IRUSR         equ     00400q
S_IWUSR         equ     00200q
S_IXUSR         equ     00100q
; -----
; Define some strings
filename        db      "secret.txt", NULL
password        db      "KhoiYeuHanRatNhieu", NULL
writeDoneStr    db      "Write complete successfully.", LF, NULL
readDoneStr     db      "Read Completed.", LF, NULL
errMsgWrite     db      "Error writing to file", LF, NULL
errMsgRead      db      "Error reading from the file", LF, NULL
newLine         db      LF, NULL  
lenStr          dd      0
; ************************************************
; BSS section
section .bss
inLine      resb    STRLEN+2
; ************************************************
; Code section
section .text
global _start
_start:

; -----
; Save password to file
    mov     rdi, filename
    mov     rsi, password
    call    fileWrite

    mov     rdi, filename
    mov     rsi, inLine
    mov     rdx, MAXPWLEN
    
    mov     rcx, lenStr
    call    fileRead
    
    mov     rdi, inLine
    call    printString

    mov     rdi, newLine
    call    printString
; -----
; Example program done
last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall

; *************************************************
; Generic function to write the content  in the file
;   Create, open and write the string to file and close file
; -----
; HIL call:
;   fileWrite(&filename, &str)
; -----
; Arguments:
;   filename: address - rdi
;   str: address - rsi
; Return:
;   SUCCESS - if operation works correclty
;   NOSUCCESS - if there is a problem
; *************************************************
global  fileWrite
fileWrite:
    ; Prologue
    push    rbx
    mov     rbx, rsi
; -----
; Open file
    mov     rax, SYS_creat
    ; filename is already pass to rdi
    mov     rsi, S_IRUSR | S_IWUSR
    syscall

    cmp     eax, 0
    jl      fileWrite_error

    ; store the file description
    mov     r10, rax    

; -----
; Write to file
    mov     rdi, rbx
    call    countString
    ; store the length of string
    mov     r11, rax
    dec     r11

    mov     rax, SYS_write
    mov     rdi, r10
    mov     rsi, rbx
    mov     rdx, r11
    syscall

    cmp     rax, 0
    jl      fileWrite_error
; -----
; Close the file
    mov     rax, SYS_close
    mov     rdi, r10
    syscall
    mov     rdi, writeDoneStr
    call    printString

    mov     rax, SUCCESS
    jmp     fileWrite_end

fileWrite_error:
    mov     rdi, errMsgWrite
    call    printString
    mov     rax, NOSUCCESS
    jmp     fileWrite_end

fileWrite_end:
    pop     rbx
    ret
; ************************************************

; *************************************************
; Generic function to read the content from a file
;   Open and read the string from file and close file
;   return number characters in password.
; -----
; HIL call:
;   fileRead(&filename, &str, maxlen, &len)
; -----
; Arguments:
;   filename: address - rdi
;   str: address - rsi
;   maxlen: dword value - rdx
;   len: address - rcx
; Return:
;   SUCCESS - if operation works correclty
;   NOSUCCESS - if there is a problea
global fileRead
fileRead:
    ; Prologue
    push    rbx
    push    r12
    mov     rbx, rsi
    ; store the len address without change during function call
    mov     r12, rcx
; -----
; Open file
    mov     rax, SYS_open
    ; filename is already pass to rdi
    mov     rsi, O_RDONLY
    syscall

    cmp     eax, 0
    jl      fileRead_error

    ; store the file description
    mov     r10, rax    

; -----
; Read from file
    mov     rax, SYS_read
    mov     rdi, r10
    mov     rsi, rbx
    ; rdx already hold num characters to read
    syscall

    cmp     rax, 0
    jl      fileRead_error

    mov     dword [r12], eax
; -----
; Close the file
    mov     rax, SYS_close
    mov     rdi, r10
    syscall

    mov     rdi, readDoneStr
    call    printString
    
    mov     rax, SUCCESS
    jmp     fileRead_end

fileRead_error:
    mov     rdi, errMsgRead
    call    printString
    mov     rax, NOSUCCESS

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
; Generic function to count a string characters
; -----
; HIL call:
;   countString(&str)
; -----
; Arguments:
;   str, address - rdi
; -----
; Return:
;   Number of character (including NULL)
; ************************************************
global countString
countString:
    ; prologue
    push    rbx

; -----
; Count characters in string
    mov     rbx, rdi
    mov     rdx, 0
countString_loop:
    cmp     byte [rbx], NULL
    je      countString_end
    inc     rdx
    inc     rbx
    jmp     countString_loop

; -----
; String counted, return to calling routine
countString_end:
    inc     rdx
    mov     rax, rdx
    pop     rbx
    ret
; ************************************************