; Simple example void function
; ***************************************
; Data section
section .data

; ***************************************
; Code section
section .text

; ***************************************
; Simple example function to find and return
; the sum of an array
; HLL call:
;   lstSum(&arr, len)
; -----
; Arguments:
;   arr, address -rdi
;   len, dword value -esi
; ***************************************

global lstSum
lstSum:
    ;prologue
    push    r12     
    
    mov     r12, 0  ; index
    mov     eax, 0  ; return sum
lstSum_sumLoop:
    add     eax, dword [rdi+r12*4]
    inc     r12
    cmp     r12, rsi
    jl      lstSum_sumLoop

    ; epilogue
    pop     r12
    ret
; ***************************************

; ***************************************
; Simple example function to find and return
; the average of an array
; HLL call:
;   lstAverage(&arr, len)
; -----
; Arguments:
;   arr, address -rdi
;   len, dword value -esi
; ***************************************

global lstAverage
lstAverage:
    ;prologue
    push    r12     
    mov     r12d, esi
    call    lstSum
    ; sum of list return in eax
    cdq
    idiv    r12d
    ; average return in eax
    ; epilogue
    pop     r12
    ret
; ***************************************