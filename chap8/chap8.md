# Addressing Modes

**1/Explain the difference between the following two instructions:**

1. ```mov rdx, qword [qVar1]```
2. ```mov rdx, qVar1```

In the first instruction the value of memory qVar1 is copied to rdx register but in the second one, the address of qVar1 is copied to rdx.

**2/ What is the address mode of the source operand for each of the instructions listed below. Respond with Register, Immediate, Memory, or Illegal Instruction.**

1. ```mov ebx, 14``` -> Immediate
1. ```mov ecx, dword [rbx]``` -> Memory
1. ```mov byte [rbx+4], 10``` -> Immediate
1. ```mov 10, rcx``` -> Illegal
1. ```mov dl, ah``` -> Register
1. ```mov ax, word [rsi+4]``` -> Memory
1. ```mov cx, word [rbx+rsi]``` -> Memory
1. ```mov ax, byte [rbx]``` -> Illegal

**3/ Given the following variable declarations and code fragment:**
```asm
ans1    dd  7
mov     rax, 3
mov     rbx, ans1
add     eax, dword [rbx]
```
**What would be in the eax register after execution? Show answer in hex, full register size.**

The value of **eax** after execution is: 0x0000000A

**4/ Given the following variable declarations and code fragment:**
```asm
list1    dd  2, 3, 4, 5, 6, 7

mov     rbx, list1
add     rbx, 4
mov     eax, dword [rbx]
mov     edx, dword [list1]
```
**What would be in the eax and edx registers after execution? Show answer in hex, full register size.**

The value of **eax** after execution is: 0x00000003<br>
The value of **edx** after execution is: 0x00000002

**5/ Given the following variable declarations and code fragment:**
```asm
lst    dd  2, 3, 5, 7, 9

mov     rsi, 4
mov     eax, 1
mov     rcx, 2
lp:
    add     eax, dword [lst+rsi]
    add     rsi, 4
    loop    lp
mov     ebx, dword [lst]
```
**What would be in the eax, ebx, rcx and rsi registers after execution? Show answer in hex, full register size. Note, pay close attention to the register sizes (32-bit vs. 64-bit).**

The value of **eax** after execution is: 0x00000009<br>
The value of **ebx** after execution is: 0x00000002<br>
The value of **rcx** after execution is: 0x00000000<br>
The value of **rsi** after execution is: 0x0000000C

**6/ Given the following variable declarations and code fragment:**
```asm
list    dd  8, 6, 4, 2, 1, 0

mov     rbx, list
mov     rsi, 1
mov     rcx, 3
mov     edx, dword [rbx]
lp:
    mov     eax, dword [list+rsi*4]
    inc     rsi
    loop    lp
imul    dword [list]
```
**What would be in the eax, edx, rcx and rsi registers after execution? Show answer in hex, full register size. Note, pay close attention to the register sizes (32-bit vs. 64-bit).**

The value of **eax** after execution is: 0x00000010<br>
The value of **edx** after execution is: 0x00000000<br>
The value of **rcx** after execution is: 0x00000000<br>
The value of **rsi** after execution is: 0x00000004

**7/ Given the following variable declarations and code fragment:**
```asm
list    dd  8, 7, 6, 5, 4, 3, 2, 1, 0

mov     rbx, list
mov     rsi, 0
mov     rcx, 3
mov     edx, dword [rbx]
lp:
    add     eax, dword [list+rsi*4]
    inc     rsi
    loop    lp
cdq
idiv    dword [list]
```
**What would be in the eax, edx, rcx and rsi registers after execution? Show answer in hex, full register size. Note, pay close attention to the register sizes (32-bit vs. 64-bit).**

The value of **eax** after execution is: 0x00000002<br>
The value of **edx** after execution is: 0x00000005<br>
The value of **rcx** after execution is: 0x00000000<br>
The value of **rsi** after execution is: 0x00000003

**8/ Given the following variable declarations and code fragment:**
```asm
list    dd  2, 7, 4, 5, 6, 3

mov     rbx, list
mov     rsi, 1
mov     rcx, 2
mov     eax, 0
mov     edx, dword [rbx+4]
lp:
    add     eax, dword [rbx+rsi*4]
    add     rsi, 2
    loop    lp
imul    dword [rbx]
```
**What would be in the eax, edx, rcx and rsi registers after execution? Show answer in hex, full register size. Note, pay close attention to the register sizes (32-bit vs. 64-bit).**

The value of **eax** after execution is: 0x00000018<br>
The value of **edx** after execution is: 0x00000000<br>
The value of **rcx** after execution is: 0x00000000<br>
The value of **rsi** after execution is: 0x00000005