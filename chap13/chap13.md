# System Services
**1/When using a system service, where is the call code placed?**

The call code will passed in the rax register when using a system service.

**2/ Where is the code located when the syscall instruction is executed (in the user program or in the operating system)?**

The code of syscall is located in the operating system. The system call is the interface between executing process and the operating system.

**3/ What is the call code and required arguments for a system service call to perform console output?**

The call code will be passed in rax register that the syscall could know which service need to perform. The SYS_write have the call code is 1. The required arguments will be:
- 1st argument: STDOUT
- 2nd argument: address of the output string
- 3nd argument: number of character need to write

**4/ Why was only one character read for interactive keyboard input?**

When arguments passed as addresses, it is referred to as call-by-reference. We can modify the value of these types of argument.

**5/ What is returned for a successful file open system service call?**

A successful file open system service call will return the file description of the opened file. 

**6/ What is returned for an unsuccessful file open system service call?**

If there is error during this process - indicate an unsuccesshul file open system call, a negative number will return.

**7/ If a system service call requires six (6) arguments, where specifically should they be passed?**

The six arguments will be passed to below registers:
- 1st argument: rdi
- 2nd argument: rsi
- 3rd argument: rdx
- 4th argument: rcx
- 5th argument: r8
- 6th argument: r9

