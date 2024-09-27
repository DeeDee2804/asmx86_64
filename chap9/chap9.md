# Process Stack
**1/Which register refers to the top of the stack?**

To tracking the top of the stack by using the register **rsp**.

**2/ What happens as a result of a push rax instruction (two things)?**

The value of rax register will be push on top of the current stack. And decrease the stack pointer to the next address means the register rsp register decreased by 1.

**3/ How many bytes of data does the pop rax instruction remove from the stack?**

When execute the pop rax instruction, the top of the stack's value will copy to the rax register and 8 bytes will remove from the stack.

**4/ Given the following code fragment:**
```asm
mov     r10, 1
mov     r11, 2
mov     r12, 3
push    r10
push    r11
push    r12
pop     r10
pop     r11
pop     r12
```
**What would be in the r10, r11, r12 registers after execution? Show answer in hex, full register size.**

The value of **r10** after execution is: 0x00000003<br>
The value of **r11** after execution is: 0x00000002<br>
The value of **r12** after execution is: 0x00000001

**5/ Given the following variable declarations and code fragment:**
```asm
lst    dq  1, 3, 5, 7, 9

mov     rsi, 0
mov     rcx, 5
lp1:
    push    qword [lst+rsi*8]
    inc     rsi
    loop    lp1
mov     rsi, 0
mov     rcx, 5
lp2:
    pop     qword [lst+rsi*8]
    inc     rsi
    loop    lp2
mov     rbx, qword [lst]
```
**Explain what would be the result of the code (after execution)?**

The lp1 will push all the element of list to the stack, then in lp2 will pop the stack values back to the list. At last, the final values of lst will be in reverse order.

**6/ Provide one advantage to the stack growing downward in memory.**

The stack growing downward in the reversed direction of the heap memory, that make these two memories could growing until there is no space in memory. So it could optimize the memory ultilisation. 
