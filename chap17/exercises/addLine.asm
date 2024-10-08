; Program to add the number line to the input file
; then write to a new output file
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

O_CREAT         equ     0x40
O_TRUNC         equ     0x200
O_APPEND        equ     0x400

O_RDONLY        equ     000000q
O_WRONLY        equ     000001q
O_RDWR          equ     000002q

S_IRUSR         equ     00400q
S_IWUSR         equ     00200q
S_IXUSR         equ     00100q

; Plus with the first argument is the program name
EXPECTED_ARGS_NUM   equ     3
BUFFER_SIZE         equ     100
MAX_STRING_LEN      equ     255

; Define variables
mesg_wrongnumargs       db  'Error: Two file names are required', LF, NULL
mesg_fileopenerror      db  'Error: Input file can not be open', LF, NULL
mesg_filereaderror      db  'Error: File read is not successful', LF, NULL
mesg_filewriteerror     db  'Error: File write is not successful', LF, NULL
mesg_filecreateerror    db  'Error: File creation is not successful', LF, NULL
newLine                 db  LF, NULL
eofFlag                 db  FALSE
buffIdx                 dw  BUFFER_SIZE
buffSize                dw  BUFFER_SIZE

; ************************************************
; BSS section
section .bss
; Define variables
strLine         resb    MAX_STRING_LEN
readBuf         resb    BUFFER_SIZE
writeBuf        resb    BUFFER_SIZE

; ************************************************
; Code section
section .text
global main
main:
    ; Store the commandline arguments
    mov     r12, rdi
    mov     r13, rsi
    ; Initialize the line number
    mov     rbx, 0
    ; Check the number of arguments
    cmp     r12, EXPECTED_ARGS_NUM
    jne     wrongNumArgs

; -----
; Open the read file
    mov     eax, SYS_open
    mov     rdi, qword [r13+8]
    mov     rsi, O_RDONLY
    syscall

    cmp     eax, 0
    jl      fileOpenError
    
    ; Store the input file descriptor
    mov     r12, rax

; -----
; Open or create the output file
    mov     rax, SYS_creat
    mov     rdi, qword [r13+16]
    mov     rsi, S_IRUSR | S_IWUSR
    syscall

    cmp     eax, 0
    jl      fileCreateError

    ; Store the output file description
    mov     r13, rax

; -----
; Read each line from input and
; add line number to output file
copyLine:
; -----
; Get one line from input
    mov     rdi, r12
    mov     rsi, strLine
    mov     rdx, MAX_STRING_LEN
    call    myGetLine
    cmp     rax, TRUE
    jne     fileReadError

    ; Check if no line is left
    cmp     byte [strLine], NULL
    je      closeFile

    ; Increment the line number
    inc     rbx
    mov     rdi, r13
    mov     rsi, strLine
    mov     rdx, rbx
    call    myWriteLine
    cmp     rax, TRUE
    jne     fileWriteError
    jmp     copyLine
    
closeFile:
; -----
; Close the output file
    mov     rax, SYS_close
    mov     rdi, r13
    syscall
    jmp     last

; -----
; Close the reading file
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

fileWriteError:
    mov     rdi, mesg_filewriteerror
    call    printString
    jmp     last

fileOpenError:
    mov     rdi, mesg_fileopenerror
    call    printString
    jmp     last

fileCreateError:
    mov     rdi, mesg_filecreateerror
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
    mov     rsi, readBuf
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
    mov     al, byte [readBuf+rdi]
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

; *************************************************
; Generic function to write a line to the file
; repeat {
;   if current idx >= buffer size
;       write buffer (buffer size)
;       if error
;           handle write error
;           display error message
;           exit routine (with false)
;       reset pointers
;   get one char from input text
;   if char is NULL
;       write buffer
;       break the loop
;   place the char to the write buffer
;}
; -----
; HIL call:
;   myWriteLine(filedesc, &textLine, lineno)
; -----
; Arguments:
;   filedesc: dword value - rdi
;   textLine: address - rsi
;   lineno: dword value - rdx
; Return:
;   TRUE - if operation works correclty
;   FALSE - if there is a problem
global myWriteLine
myWriteLine:
    ; Prologue
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    ; File descriptor
    mov     rbx, rdi
    ; Address of the text line
    mov     r12, rsi
    ; Line number
    mov     r13, rdx
    ; Initialization the buffer index, line index
    mov     r14, 0
    mov     r15, 0

; -----
; Add line number to buffer
    mov     rdi, r13
    mov     rsi, writeBuf
    call    int2str
    ; Update the buffer index
    mov     r14, rax
    mov     byte [writeBuf+r14], '.'
    inc     r14
; -----
; Check the buffer is empty or not
writeCharLoop:
    cmp     r14, BUFFER_SIZE
    jne     writeToBuffer

; -----
; Write the buffer to file
    mov     rax, SYS_write
    mov     rdi, rbx
    mov     rsi, writeBuf
    mov     rdx, BUFFER_SIZE
    syscall

    ; Check if write is success
    cmp     rax, 0
    jl      writeLine_error

    ; Reset current index
    mov     r14, 0

; -----
; Write to buffer
writeToBuffer:
    mov     al, byte [r12+r15]
    cmp     al, NULL
    je      flushBuffer
    mov     byte [writeBuf+r14], al
    inc     r14
    inc     r15

    ; Repeat the loop
    jmp     writeCharLoop

flushBuffer:
    mov     rax, SYS_write
    mov     rdi, rbx
    mov     rsi, writeBuf
    mov     rdx, r14
    syscall

    ; Check if write is success
    cmp     rax, 0
    jl      writeLine_error
    mov     rax, TRUE
    jmp     writeLine_end

writeLine_error:
    mov     rax, FALSE

writeLine_end:
    pop     r15
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