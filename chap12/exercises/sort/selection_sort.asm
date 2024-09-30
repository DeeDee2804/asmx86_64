; Simple program to sort a list and calculate some basic 
; statistics of the list.
; Solve the exercises 1, 2, 3, 4, 5
; ******************************************************
; Author: Doan Minh Khoi
; Date: 30/09/2024
; ******************************************************
; Data section
section .data

; -----
; Define constants
EXIT_SUCCESS        equ 0
SYS_exit            equ 60

; Define variables
list        dd  19, -6, 7, -8, 1, -20
len         dd  6
min         dd  0
max         dd  0
med1        dd  0
med2        dd  0
sum         dd  0
ave         dd  0
dev         dd  0

; ***************************************
; Code section
section .text

; -----
; Simple function to sort the list in place
; The algorithm using is selection sort algorithm
; -----
; begin
;   for i = 0 to len-1
;       small = arr(i)
;       index = i
;       for j = i to len - 1
;           if (arr(j) < small) then
;               small = arr(j)
;               index = j
;           end_if
;       end_for
;       arr(index) = arr(i)
;       arr(i) = small
;   end_for
; end_begin
; -----
; HLL call:
;   sort(arr, len)
; -----
; Arguments:
;   arr, address - rdi
;   len, dword value - esi
global selection_sort
selection_sort:
    ; prologue
    mov     r8, 0

outerLoop:
    mov     r10d, dword [rdi+r8*4] ; small value
    mov     r11, r8                ; index value
    mov     r9, r8
innerLoop:
    cmp     r10d, dword [rdi+r9*4]
    jle     innerEnd
    mov     r10d, dword [rdi+r9*4] ; update small value
    mov     r11, r9                ; update index
innerEnd:
    inc     r9
    cmp     r9, rsi
    jl      innerLoop
outerEnd:
    ; Swap value between small value index and current index
    mov     eax, dword [rdi+r8*4]
    mov     dword [rdi+r11*4], eax  
    mov     dword [rdi+r8*4], r10d 
    inc     r8
    cmp     r8, rsi
    jl      outerLoop
ret
; End selection_sort function

; -----
; Simple function to calculate approximately the square root of number
; -----
; Initial sqrt
; sqrt = num
; Then iterate 50 times
; sqrt = ((num / sqrt) + sqrt) / 2
; -----
; HLL call:
;   sqrt(num, res)
; -----
; Arguments:
;   num, positive number - edi
;   res, address of result - rsi
global sqrt
sqrt:
    ; prologue
    mov     rcx, 50
    mov     r10d, edi
    mov     r11d, 2

squareLoop:
    ; (num / sqrt)
    mov     eax, edi
    mov     edx, 0
    div     r10d
    ; (num / sqrt) + sqrt
    add     eax, r10d
    ; ((num / sqrt) + sqrt) / 2
    mov     edx, 0
    div     r11d
    mov     r10d, eax
    loop    squareLoop
; end loop
    mov     dword [rsi], r10d
ret
; End sqrt function

; -----
; Simple example function to find and return the minimum,
; maximum, sum, medians, and average of an sorted array.
; HLL call:
;   stats(arr, len, &min, &med1, &med2, &max, &sum, &ave, &dev)
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
;   dev, address - stack (rbp + 32)
global stats
stats:
    ;prologue     
    push    rbp
    mov     rbp, rsp
    push    r12

; -----
; Get min and max
minmax:
    mov     eax, dword [rdi]
    mov     dword [rdx], eax    ; get the min
    mov     r10, rsi
    dec     r10
    mov     eax, dword [rdi+r10*4]
    mov     dword [r9], eax     ; get the max

; -----
; Get median
    mov     rax, rsi
    mov     rdx, 0
    mov     r10, 2
    div     r10                 ; get length / 2

    cmp     rdx, 0
    je      evenLength

    mov     r10d, dword [rdi+rax*4]
    mov     dword [rcx], r10d   ; get med1
    mov     dword [r8], r10d    ; get med2
    jmp     medDone
evenLength:
    mov     r10d, dword [rdi+rax*4]
    mov     dword [r8], r10d    ; get med2
    dec     rax                 ; get length / 2 - 1
    mov     r10d, dword [rdi+rax*4]
    mov     dword [rcx], r10d   ; get med1

medDone:

; -----
; Find sum
    mov     r10, 0
    mov     rax, 0
sumLoop:
    add     eax, dword [rdi+r10*4]
    inc     r10
    cmp     r10, rsi
    jl      sumLoop

    mov     r10,  qword [rbp+16]
    mov     dword [r10], eax    ; return sum

    cdq
    idiv    esi                 ; compute average
    mov     r10, qword [rbp+24]
    mov     dword [r10], eax    ; return ave
    mov     r12d, eax           ; store average
; -----
; Find deviation
    mov     r10, 0  ; temp index
    mov     r11, 0  ; temp sum
    mov     rax, 0
devLoop:
    ; deviation of each element
    mov     eax, dword [rdi+r10*4]
    sub     eax, r12d
    cdq
    imul    eax
    add     r11d, eax
    inc     r10
    cmp     r10, rsi
    jl      devLoop
    ; average of sum of deviation
    mov     eax, r11d
    cdq
    idiv    esi
    ; save the state of rdi, rsi
    push    rdi
    push    rsi
    mov     edi, eax
    mov     rsi, dev
    call    sqrt
    pop     rsi
    pop     rdi


    ; epilogue
    pop     r12
    pop     rbp
ret


; -----
; Main function
global _start
_start:
    mov     esi, dword [len]
    mov     rdi, list
sort:
    call    selection_sort
    push    dev
    push    ave
    push    sum
    mov     r9, max
    mov     r8, med2
    mov     rcx, med1
    mov     rdx, min
    mov     esi, dword [len]
    mov     rdi, list
    call    stats
    add     rsp, 24
; -----
; Done, terminate the program
last:
    mov     eax, SYS_exit
    mov     ebx, EXIT_SUCCESS
    syscall   
