# Architecture Overview

**1/ Draw the picture of Von Neumann Architecture**
![Von Neumann](./VonNeumann.png)

**2/ What architecture component connects the memory to the CPU?**

The bus component takes the role as communication channel between  memory and CPU

**3/ Where are programs stored when the computer is turned off?**

The program will be stored in the non-volatile memory which is secondary storage that could remains the data after the computer is turned off.

**4/ Where must programs be located when they are executing?**

When the program executing, it must be stored in the RAM, which is copied from the secondary storage, and then send to the CPU for execution.

**5/ How does cache memory help overall performance?**

Cache memory with the rapid speed for data retrieval could be used to stored the most frequent data that is requested from the program to avoid the repetition retrieval.

**6/ How many bytes does a C++ integer declared with the declaration int use?**

The *int* type will take 4 bytes when declaration in **C++**.

**7/ On the Intel X86-64 architecture, how many bytes can be stored at each address?**

For each address, 1 bytes of information could be stored in the Intel x86-64 architecture.

**8/ Given the 32-bit hex 004C4B40<sub>16</sub> what is the LSB and MSB?**

The LSB is 40 and the MSB will be 00.

**9/ Given the 32-bit hex 004C4B40<sub>16</sub>, show the little edian memory layout showing each byte in memory?**

![little edian](./little_endian.png)

**10/ Draw a picture of the layout for the rax register**

![rax layout](./rax_layout.png)

**11/ How many bits does each of the following represent?**
- **al**: 1 byte
- **rcx**: 8 bytes
- **bx**: 2 bytes
- **edx**: 4 bytes
- **r1**: 8 bytes
- **r8b**: 1 byte
- **sil**: 1 byte
- **r14w**: 2 bytes

**12/ Which register points to the next instruction to be executed?**

Register **rip** is used to point to the next instruction.

**13/ Which register points to the current top of the stack?**

Register **rsp** is used to point to the current top of the stack.

**14/ If al is set to 05<sub>16</sub> and ax is set to 0007<sub>16</sub>, eax is set to 00000020<sub>16</sub>, and rax is set to 0000000000000000<sub>16</sub>, and show the final complete contents of the complete rax register?**

After setting all the registers above, the complete content of rax will be 0000000000000000<sub>16</sub>.

**15/ If the rax register is set to 123456789ABCDEF<sub>16</sub>,
what are the contents of the following registers in hex?**

- **al**: EF<sub>16</sub>
- **ax**: CDEF<sub>16</sub>
- **eax**: 89ABCDEF<sub>16</sub>
- **rax**: 123456789ABCDEF<sub>16</sub>

