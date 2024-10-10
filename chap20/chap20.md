# Interrupts
**1/ What is the operating system responsible for? Name some of the resources.**

OS supports multiple program executings, manage and share the resources. The resources include
CPU cores, primary memory, secondary storage, display screen, keyboard, and mouse.

**2/ What is an interrupt?**

When an interrupt occurs, the OS will interrupt the current process, and handle the interrupt signal, and then resume back to the orignal process eventually.

**3/ What is an exception?**

An exception is a term of interrupt that caused by the current process and needs attention of the kernel.

**4/ What is an ISR and what is it for?**

ISR is the Interrupt Service Routine, it is responsible for handling the interrupt signal, it is a code execution specific for that interrupt.

**5/ Where (name of the data structure) does the operating system obtain the address when an interrupt occurs and what is contained in it?**

When an interrupt occurs, the OS will look up in the IDT (Interrupt Descriptor Table) to obtain the address of the corresponding ISR, and its additional information including task gate (priority and privilege information).

**6/ When an interrupt occurs, how is the appropriate offset into the IDT calculated?**

The offset will be the interrupt number multipled by 16 (which is 16 bytes of each IDT entry)

**7/ What is the difference between the iret and ret instructions?**

**ret** is used to return from called function to calle<br>
**iret** is used to return from ISR to interrupted process

**8/ Why does the OS use the interrupt mechanism instead of just performing a standard call.**

Because there are many use cases that the time function need to be called is unidentified. The call need to a specific target address. While ISR may be changed during run-time and need to lookup everytime there is any changed from hardware or software updates.

**9/ What is meant by asynchronously occurring interrupts?**

It will be executed at arbitrary time with respect to the program execution. It is unpredictable relative to any specific location within the executing process.

**10/ What is meant by synchronously occurring interrupts?**

Synchronously interrupts in the different way occur under the CPU control and are caused by or on behalf of the currently executing process.

**11/ When an interrupt occurs, the rip and rFlags registers are pushed on the stack. Much like the call statement, the rip register is pushed to save the return address. Explain why is the rFlag register pushed on the stack.**

rFlags is stored to save the state of the interrupted function that help to restore its closure after return from ISR help the process it runs is still correct.

**12/ Name two hardware interrupts.**

That is mouse interrupt, keyboard interrupt or timer interrupt.

**13/ List one way for a program to generate an exception.**

An exception may be generated due to a arithmetic error like division by zero.

**14/ What is the difference between a maskable and non-maskable interrupt?**

Maskable related to interrupt issued by I/O device, it could be ignored or masked in a short time that make ISR handle in delay.
On the other hand, the non-maskable refers interrupts must be handled immediately, oftenly are the OS functions or critical malfunction such as hardware failures. It is always processed by CPU.