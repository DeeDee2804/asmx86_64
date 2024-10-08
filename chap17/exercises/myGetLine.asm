; Program to test the getLine function by using the
; I/O buffering
; ************************************************
; Author: Doan Minh Khoi
; Date: 08/10/2024
; ************************************************
section .note.GNU-stack noalloc noexec nowrite progbits

; Data section
section .data

; Define constants
TRUE            equ     0
FALSE           equ     1
NULL            equ     0
LF              equ     10
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

O_RDONLY        equ     000000q
O_WRONLY        equ     000001q
O_RDWR          equ     000002q

; Plus with the first argument is the program name
EXPECTED_ARGS_NUM   equ     2
BUFFER_SIZE         equ     100
MAX_STRING_LEN      equ     255

; Define variables
mesg_wrongnumargs   db  'Error: Only one file name is accepted', LF, NULL
mesg_fileopenerror  db  'Error: File can not be open', LF, NULL
mesg_filereaderror  db  'Error: File read is not successful', LF, NULL
newLine             db  LF, NULL
eofFlag             db  FALSE
buffIdx             dw  BUFFER_SIZE
buffSize            dw  BUFFER_SIZE

; ************************************************
; BSS section
section .bss
; Define variables
strLine      resb    MAX_STRING_LEN
strBuf       resb    BUFFER_SIZE

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
; Open the file
    mov     eax, SYS_open
    mov     rdi, qword [rsi+8]
    mov     rsi, O_RDONLY
    syscall

    cmp     eax, 0
    jl      fileOpenError
    
    ; Store the file descriptor
    mov     r12, rax

; -----
; Get one line from string
    mov     rdi, r12
    mov     rsi, strLine
    mov     rdx, MAX_STRING_LEN
    call    myGetLine
    cmp     rax, TRUE
    jne     fileReadError
; -----
; Print the string
    mov     rdi, strLine
    call    printString
    mov     rdi, newLine
    call    printString

; -----
; Get one line from string
    mov     rdi, r12
    mov     rsi, strLine
    mov     rdx, MAX_STRING_LEN
    call    myGetLine
    cmp     rax, TRUE
    jne     fileReadError
; -----
; Print the string
    mov     rdi, strLine
    call    printString
    mov     rdi, newLine
    call    printString

; -----
; Get one line from string
    mov     rdi, r12
    mov     rsi, strLine
    mov     rdx, MAX_STRING_LEN
    call    myGetLine
    cmp     rax, TRUE
    jne     fileReadError
; -----
; Print the string
    mov     rdi, strLine
    call    printString
    mov     rdi, newLine
    call    printString

; -----
; Close the file
    mov     rax, SYS_close
    mov     rdi, r12
    syscall
    jmp     last

; -----
; Error handling
fileReadError:
    mov     rdi, mesg_filereaderror
    call    printString
    jmp     last

fileOpenError:
    mov     rdi, mesg_fileopenerror
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

; *************************************************
; Generic function to get a line from the file
; -----
; repeat {
;   if current index >= buffer maximum
;       read buffer (buffer size)
;       if error
;           handle read error
;           display error message
;           exit routine (with false)
;       reset pointers
;       if chars read = 0
;           add NULL character to text line
;           exit with true
;       if chars read < characters request read
;           set eofFlag = TRUE
;           
;   get one character from buffer at current index
;   place character in text line buffer
;   increment current index
;   if current index >= max length
;       add NULL character to text line
;       exit with true
;   if character is LF
;       add NULL character to text line
;       exit with true
;       }
; HIL call:
;   myGetLine(filedesc, &textLine, maxLength)
; -----
; Arguments:
;   filedesc: dword value - rdi
;   textLine: address - rsi
;   maxLength: dword value - rdx
; Return:
;   TRUE - if operation works correclty
;   FALSE - if there is a problem
global myGetLine
myGetLine:
    ; Prologue
    push    rbx
    push    r12
    push    r13
    push    r14
    ; File descriptor
    mov     rbx, rdi
    ; Address of the line buffer
    mov     r12, rsi
    ; Max length of the line without NULL pointer
    mov     r13, rdx
    dec     r13
    ; Index of the line buffer
    mov     r14, 0

; -----
; Check the buffer is empty or not
readCharLoop:
    mov     r9w, word [buffSize]
    cmp     r9w, word [buffIdx]
    ja      getFromBuffer
    mov     r9b, byte [eofFlag]
    cmp     r9b, TRUE
    je      endOfLine
; -----
; Read from file
    mov     rax, SYS_read
    mov     rdi, rbx
    mov     rsi, strBuf
    mov     rdx, BUFFER_SIZE
    syscall

    ; Check if read is success
    cmp     rax, 0
    jl      getLine_error

    ; Reset current index and current buffer size
    mov     word [buffIdx], 0
    mov     word [buffSize], ax  

    ; Check if actual read is less than expected
    cmp     ax, BUFFER_SIZE
    jl      endOfFile
    jmp     getFromBuffer
; -----
; Check end of file
endOfFile:
    mov     byte [eofFlag], TRUE
    cmp     ax, 0
    je      endOfLine
; -----
; Get index from buffer
getFromBuffer:
    mov     di, word [buffIdx]
    mov     al, byte [strBuf+rdi]
    mov     byte [r12+r14], al
    inc     r14
    inc     word [buffIdx]
    
    ; Check if the line text reach its max length
    cmp     r14, r13
    jae     endOfLine

    cmp     al, LF
    je      endOfLine

    ; Repeat the loop
    jmp     readCharLoop
endOfLine:
    mov     byte [r12+r14], NULL
    mov     rax, TRUE
    jmp     getLine_end

getLine_error:
    mov     rax, FALSE

getLine_end:
    pop     r14
    pop     r13
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