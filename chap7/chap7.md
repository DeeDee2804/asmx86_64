# Instruction Set Overview

**1/Which of the following instructions is legal / illegal? As appropriate, provide an explanation.**

1. ```mov rax, 54``` -> legal
2. ```mov ax, 54``` -> legal
3. ```mov al, 354``` -> legal despite max value of <b>al</b> is only 255, the narrowing conversion will take place.
4. ```mov rax, r11``` -> legal
5. ```mov rax, r11d``` -> legal
6. ```mov 54, ecx`` -> illegal because dest can not be an immediate value.
7. ```mov rax, qword [qVar]``` -> legal
8. ```mov rax, qword [bVar]``` -> legal
9. ```mov rax, [qVar]``` -> legal
10. ```mov rax, qVar``` -> legal that will copy address of qVar to rax
11. ```mov eax, dword [bVar]``` -> legal
12. ```mov qword [qVar2], qword [qVar1]``` -> illegal because can not operate with two memory
13. ```mov qword [bVar2], qword [qVar1]``` -> illegal because can not operate with two memory
14. ```mov r15, 54``` -> legal
15. ```mov r16, 54``` -> illegal due to r16 register not exist
16. ```mov r11b, 54``` -> legal

**2/ Explain what each of the following instructions does.**

1. ```movzx rsi, byte [bVar1]``` -> widening the unsigned byte bVar1 to rsi 8 bytes register
2. ```movsx rsi, byte [bVar1]``` -> widening the signed byte bVar1 to rsi 8 bytes register 

**3/ What instruction is used to:**

- <b>Convert an unsigned byte in al into a word in ax</b>: ```movzx ax, al```
- <b>Convert an signed byte in al into a word in ax</b>: ```movsx ax, al``` or ```cbw```

**4/ What instruction is used to:**

- <b>Convert an unsigned word in ax into a double-word in eax</b>: ```movzx eax, ax```
- <b>Convert an signed word in ax into a double-word in eax</b>: ```movsx eax, ax``` or ```cwde```

**5/ What instruction is used to:**

- <b>Convert an unsigned word in ax into a double-word in dx:ax</b>: ```mov dx, 0```
- <b>Convert an signed word in ax into a double-word in dx:ax</b>: ```cwd```

**6/ Explain the difference between the cwd instruction and the movsx instructions.**

The cwd command will signed conversion word in ax to double-word dx:ax format. This command is a short command can work with only Meanwhile, we have flexible instruction movsx for signed conversion when we can specified which destination and source that we want to convert.

**7/ Explain why the explicit specification (dword in this example) is required on the first instruction and is not required on the second instruction.**
```asm
add dword [dVar], 1
add [dVar], eax
```

For the first instruction, there is no explicit type of immediate value 1 then we need to specify the type of memory dVar. In contrast, in instruction 2 we can implicitly get the type of the operant based on the register eax that indicate dword size.

**8/ Given the following code fragment:**
```asm
mov rax, 9
mov rbx, 2
add rbx, rax
```
**What would be in the rax and rbx registers after execution? Show answer in hex, full register size.**

After the execution the value of register is as below:
- **rax**: 0x0000000000000009
- **rbx**: 0x000000000000000B

**9/ Given the following code fragment:**
```asm
mov rax, 9
mov rbx, 2
sub rax, rbx
```
**What would be in the rax and rbx registers after execution? Show answer in hex, full register size.**

After the execution the value of register is as below:
- **rax**: 0x0000000000000007
- **rbx**: 0x0000000000000002

**10/ Given the following code fragment:**
```asm
mov rax, 9
mov rbx, 2
sub rbx, rax
```
**What would be in the rax and rbx registers after execution? Show answer in hex, full register size.**

After the execution the value of register is as below:
- **rax**: 0x0000000000000009
- **rbx**: 0xFFFFFFFFFFFFFFF9

**11/ Given the following code fragment:**
```asm
mov rax, 4
mov rbx, 3
imul rbx
```
**What would be in the rax and rdx registers after execution? Show answer in hex, full register size.**

After the execution the value of register is as below:
- **rax**: 0x000000000000000C
- **rdx**: 0x0000000000000000

**12/ Given the following code fragment:**
```asm
mov rax, 5
cqo
mov rbx, 3
idiv rbx
```
**What would be in the rax and rdx registers after execution? Show answer in hex, full register size.**

After the execution the value of register is as below:
- **rax**: 0x0000000000000001
- **rdx**: 0x0000000000000002

**13/ Given the following code fragment:**
```asm
mov rax, 11
cqo
mov rbx, 4
idiv rbx
```
**What would be in the rax and rdx registers after execution? Show answer in hex, full register size.**

After the execution the value of register is as below:
- **rax**: 0x0000000000000002
- **rdx**: 0x0000000000000003

**14/ Explain why each of the following statements will not work.**

1. ```mov 42, eax``` -> the [dest] operand of mov can not be an immediate
2. ```div 3``` -> [src] operand of div can not be an immediate
3. ```mov dword [num1], dword [num2]``` -> both operand of mov can not be memory at the same time.
4. ```mov dword [ax], 800``` -> could not take address of the ax register with only 16 bit

**15/ Explain why the following code fragment will not work correctly.**
```asm
mov eax, 500
mov ebx, 10
idiv ebx
```
Because, the division operation will take the edx:eax as the divident, but in this case we don't set the edx register then it coud remain the garbage value and make the result not correct.

**16/ Explain why the following code fragment will not work correctly.**
```asm
mov eax, -500
cdq
mov ebx, 10
div ebx
```
Because, the division operation not take care the signed of operand, but in this case negative value is assign to eax register. Then the result will be not correct if use **div** instruction instead of **idiv**.

**17/ Explain why the following code fragment will not work correctly.**
```asm
mov ax, -500
cwd
mov bx, 10
idiv bx
mov dword [ans], eax
```
Because, the result of this division is only word size then convert whole eax register with double word size to the answer is not correct. In this case, if the size of ans still keep double-word, we will use the movsx for widening conversion of signed vallue.
```asm
; Solution1:
movsx dword [ans], ax

; Solution2:
mov word [ans], ax
```

**18/ Under what circumstances can the three-operand multiple be used**

When we use the imul instruction:
```
imul [dest], [src], [imm]
```
This will be used when we want to assigned the result of multiplication between register/memory with immediate value into a specific register.
