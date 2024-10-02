; Simple example void function
; ***************************************
; Fix for the warning
section .note.GNU-stack noalloc noexec nowrite progbits

; Data section
section .data

; ***************************************
; Code section
section .text

; ***************************************
; Simple example function to find and return
; the sum and average of an array
; HLL call:
;   stats1(&arr, len, &sum, &ave)
; -----
; Arguments:
;   arr, address -rdi
;   len, dword value -esi
;   sum, address - rdx
;   ave, address - rcx
; ***************************************

global stats
stats:
    ;prologue
    push    r12     
    
    mov     r12, 0  ; index
    mov     rax, 0  ; temporary sum
stats_sumLoop:
    add     eax, dword [rdi+r12*4]
    inc     r12
    cmp     r12, rsi
    jl      stats_sumLoop

    mov     dword [rdx], eax    ; return sum

    cdq
    idiv    esi                 ; compute average
    mov     dword [rcx], eax    ; return ave
    ; epilogue
    pop     r12
    ret
; ***************************************