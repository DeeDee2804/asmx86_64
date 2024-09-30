# Functions
**1/What are the two main actions of a function call?**

The function call will involves two main actions:
- Linkage: to enable the function could be return in correct place when dealing with multiple source file could contain different functions that being used.
- Argument tranmission: In both direction in and out, function must be able to access the arguments that it works with and could return the result by return value or by reference.

**2/ What are the two instructions that implement linkage?**

They are similar to below which example is the program will want to build:
```sh
yasm -g dwarf2 -f elf64 example.asm -l example.lst
gcc -g -no-pie -o example example.o
```
The first one we deal with assembler to conver the asm file, and then using the gcc compiler toolchain to finally make the executable file by linking.

**3/ When arguments are passed using values, it is referred to as?**

When arguments passed as values, it is referred to as call-by-value.

**4/ When arguments are passed using addresses, it is referred to as?**

When arguments passed as addresses, it is referred to as call-by-reference. We can modify the value of these types of argument.

**5/ If a function is called fifteen (15) times, how many times is the code placed in memory by the assembler?**

Not like the macro, you can call the function multiple times without take care of the code memory will be consumed, because the function is only define once in the code section.

**6/ What happens during the execution of a call instruction (two things)?**

There are two special section during the call instruction that is prologue and epilogue. The prologue help us to save the state of program (enable some reserved register could be used during execution) and before return the epilogue help us to restore the state before calling the function.

**7/ According to the standard calling convention, as discussed in class, what is the purpose of the initial pushes and final pops within most procedures?**

The purpose of it to push to stack at the beginning that enable the function to save the current value of the preserved registers to freely use them within the function. The pop will do the reverse things, return back the original value to the registers before end the procedure.

**8/ If there are six (6) 64-bit integer arguments passed to a function, where specifically should each of the arguments be passed?**

The arguments will be passed one by one into rdi, rsi, rdx, rcx, r8 and r9 registers.

**9/ If there are six (6) 32-bit integer arguments passed to a function, where specifically should each of the arguments be passed?**

The arguments still be passed one by one into rdi, rsi, rdx, rcx, r8 and r9 registers if we call by reference, if we call function by value, they will be edi, esi, edx, ecx, r8d, r9d.

**10/ What does it mean when a register is designated as temporary?**

These registers are defined as temporary for freely use in purpose of intermideate variable during calculation, if we want use other register, we must save the current value of them first by push in the stack then restore it by popping from at the end of the fucntion calling.

**11/ Name two temporary registers?**

They are r10 and r11, btw, eax is still be able to use for this purpose parallely with its main purpose as the return value.

**12/ What is the name for the set of items placed on the stack as part of a function call?**

For the set of items places on stack as part of a function call, we can call it as call frame, stack frame or activation record.

**13/ What does it mean when a function is referred to as a leaf function?**

A leaf function will not call another function inside it. Pass its arguments only in right-purposed register, not altered any saved registers (only use temporary register) and not require stack-based local variables.

**14/ What is the purpose of the ```add rsp, <immediate> ``` after the call statement?**

It will return the state of rsp before call statement when the function might use additional arguments that reserved registers are not enough.

**15/ If three arguments are passed on the stack, what is the value for the ```<immediate>```?**

The ```<immediate>``` value will be 24 = 8 * 3 while 8 bytes is the size of each element in the stack.

**16/ If there are seven (7) arguments passed to a function, and the function itself pushes the rbp, rbx, and r12 registers (in that order), what is the correct offset of the stack-based argument when using the standard calling convention?**

The offset will be 32, because there is one return value rip pushed on the stack as default and three preserved register is used.

**17/ What, if any, is the limiting factor for how many times a function can be called?**

The limite factor is the stack size, when the stack is overflow, there is no more space on the stack that the function could ultilise.

**18/ If a function must return a result for the variable sum, how should the sum variable be passed (call-by-reference or call-by-value)?**

We can passed the sum as an argument using call by reference or can return the sum value and then mov it value to the sum variable.

**19/ If there are eight (8) arguments passed to a function, and the function itself pushes the rbp, rbx, and r12 registers (in that order), what is the correct offset of the two stack-based arguments (7 th and 8th) when using the standard calling convention?**

The offset will be 32 for the 7th argument and 40 for the 8th argument, because there is one return value rip pushed on the stack as default and three preserved register is used.

**20/ What is the advantage of using stack dynamic local variables (as opposed to using all global variables)?**

The advantage is that it will optimize the memory usage while the global variables will take place of space during all the program lifetime. In constrast, the local variables only get spaces when the function is called and will return it back when the function  completes its execution. It may require a small run-time overhead, but it saves a lot of memory and is an efficient way to improve the program performance.