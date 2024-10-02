; Simple program to demonstrate file I/O
; This example program will open a file, read the file
; and write the contents to the screen.
; This routine also provides some very simple examples
; regarding handling various errors on system services.
; Note the file name is hardcoded for this example
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

BUFF_SIZE       equ     255
; -----
; Define some strings
header          db      LF, "File I/O example"
                db      LF, LF, NULL
filename        db      "filetest.txt", NULL
contents        db      "Hello, World!", LF, NULL
len             dq      $-contents-1
newLine         db      LF, NULL
fileDesc        dq      0
writeDone       db      "Write Completed.", LF, NULL
readDone        db      "Read Completed.", LF, NULL
errMsgOpen      db      "Error opening the file.", LF, NULL
errMsgWrite     db      "Error writing to file", LF, NULL
errMsgRead      db      "Error reading from the file", LF, NULL

; ************************************************
; BSS section
section .bss

readBuffer      resb    BUFF_SIZE
; ************************************************
; Code section
section .text
global _start
_start:

; -----
; Display header message
    mov     rdi, header
    call    printString

; *************************************************
; Write file content
; *************************************************
; -----
; Attempt to open file
;   Use system service for file open
;
; System Service - Open/Create
;   rax = SYS_creat (file open/create)
;   rdi = address of file name string
;   rsi = attributes (i.e., read only, etc.)
;
; Returns:
;   if error -> eax < 0
;   if success -> eax = file descriptor number

; The file descriptor points to the File Control
; Block (FCB). The FCB is maintained by the OS.
; The file descriptor is used for all subsequent
; file operations (read, write, close).

    mov     rax, SYS_creat
    mov     rdi, filename
    mov     rsi, S_IRUSR | S_IWUSR
    syscall

    cmp     eax, 0
    jl      errorOnOpen

    mov     qword [fileDesc], rax

; -----
; Write to file
;
; System Service - write
;   rax = SYS_write
;   rdi = file descriptor
;   rsi = address of characters to write
;   rdx = count of characters to write
; Returns:
;   if error -> rax < 0
;   if success -> rax = count of characters actually write

    mov     rax, SYS_write
    mov     rdi, qword [fileDesc]
    mov     rsi, contents
    mov     rdx, qword [len]
    syscall

    cmp     rax, 0
    jl      errorOnWrite

    mov     rdi, writeDone
    call    printString
; -----
; Close the file
;
; System Service - close
;   rax = SYS_close
;   rdi = file descriptor
closeFile:
    mov     rax, SYS_close
    mov     rdi, qword [fileDesc]
    syscall
; *************************************************
; Read file content
; *************************************************
; -----
; Attempt to open file
;   Use system service for file open
;
; System Service - Open/Create
;   rax = SYS_open (file open/create)
;   rdi = address of file name string
;   rsi = attributes (i.e., read only, etc.)
;
; Returns:
;   if error -> eax < 0
;   if success -> eax = file descriptor number

; The file descriptor points to the File Control
; Block (FCB). The FCB is maintained by the OS.
; The file descriptor is used for all subsequent
; file operations (read, write, close).
readProcess:
    mov     rax, SYS_open
    mov     rdi, filename
    mov     rsi, O_RDONLY
    syscall

    cmp     rax, 0
    jl      errorOnOpen

    mov     qword [fileDesc], rax

; -----
; Read from file
;
; System Service - read
;   rax = SYS_read
;   rdi = file descriptor
;   rsi = address of where to place data
;   rdx = count of characters to read
; Returns:
;   if error -> rax < 0
;   if success -> rax = count of characters actually read

    mov     rax, SYS_read
    mov     rdi, qword [fileDesc]
    mov     rsi, readBuffer
    mov     rdx, BUFF_SIZE
    syscall

    cmp     rax, 0
    jl      errorOnRead

; -----
; Print the buffer.
;   Add NULL for the print string
    mov     rsi, readBuffer
    mov     byte [rsi+rax], NULL

    mov     rdi, readBuffer
    call    printString

    mov     rdi, newLine
    call    printString

; -----
; Close the file
;
; System Service - close
;   rax = SYS_close
;   rdi = file descriptor
    mov     rax, SYS_close
    mov     rdi, qword [fileDesc]
    syscall

    mov     rdi, readDone
    call    printString
    jmp     last

; -----
; Error on open.
errorOnOpen:
    mov     rdi, errMsgOpen
    call    printString
    jmp     last

; -----
; Error on write
errorOnWrite:
    mov     rdi, errMsgWrite
    call    printString
    jmp     last

; -----
; Error on read
errorOnRead:
    mov     rdi, errMsgRead
    call    printString
    jmp     last
; -----
; Example program done
last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall

; ************************************************
; Generic function to display a string to the screen.
; String must be NULL terminated
; Algorithm:
;   Count characters in string (excluding NULL)
;   Use syscall to output characters
;
; Arguments:
;   1) Address, string
; Return:
;   Nothing
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
