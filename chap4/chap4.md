# Program Format

**1/ What is the name of the assembler being used in this chapter?**

YASM is the assembler is used in this chapter.

**2/ How are comments marked in an assembly language program?**

The comments can be added in the program by add ";" at first that marked the beginning of the comment.

**3/ What is the name of the section where the initialized data declared?**

Section that contains initialized data declared and defined is the section <b>data</b>.

**4/ What is the name of the section where the uninitialized data declared?**

Section where the uninitialized data declared is the section <b>bss</b>.


**5/ What is the name of the section where the code is placed?**

Section <b>text</b> is where the code is placed.

**6/ What is the data declaration for each of the following variables with the given values?**

- bNum  db  10
- wNum  dw  10291
- dwNum dd  2126010
- qwNum dq  10000000000

**7/ What is the uninitialized data declaration for each of the following:**

- bArr  resb    100
- wArr  resw    3000
- dwArr resd    200
- qArr  resq    5000

**8/ What are the required declarations to signify the start of a program (in the text section)?**
The section .text must include the following lines at beginning:
```assembly
global _start
_start:
``` 