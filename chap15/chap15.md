# Stack Buffer Overflow
**1/ When stack buffer overflow is caused deliberately as part of an attack it is referred as what?**

It is called as stack smashing 

**2/ What does it mean when a C function is considered unsafe?**

The C function does not check the array bounds of the input arguments that make the stack buffer could be overflowed and can inject the malicious code in the start of call frame.

**3/ Is a program that reads user input still vulnerable if the input buffer is sufficiently large (e.g., >1024 bytes)?**

Yes, because it is easy for automate the input process that make a any large size of input could be provide to the programe 

**4/ How might an attacker determine if an interactive program is vulnerable to a buffer overflow attack?**

By trial and error with a large input that let hacker know the vulneribility of the program.

**5/ What is a “NOP slide”?**

NOP slide will help "slide" the CPU's instruction execution flow to the injected code.

**6/ The text example injected code to open a new shell. Provide at least one different idea for injected code that would cause problems.**

We could inject code to delete files from computer or network connection that enable the hacker to know the personal info of the user.

**7/ Name three techniques designed to prevent stack buffer overflow attacks.**
These are three techniques that used for prevent stack buffer overflow attacks:
- Data Stacking Smashing Protector
- Data Execution Prevention
- Data Address Space Layout Randomization

