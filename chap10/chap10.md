# Program Development
**1/What is an algorithm?**

The algorithm is a sequence of logical step to resolve a problem. It is often displayed as the pseudocode (freestyle) to instruct the reader how to complete a task. 

**2/ What are the four main steps in algorithm development?**

The four steps are:
- Understand the problem
- Create the algorithm
- Implement the program
- Test/Debug the program

**3/ Are the four main steps in algorithm development applicable only to assembly language programming?**

No, it can be applied for all the language programming that aim to resolve any problem.

**4/ What type of error, if any, occurs if the one operand multiply instruction uses an immediate value operand? Respond with assemble-time or run-time.**

This is the assemnle-time error, when assembler detect an incorrect instruction (operand can't be an immediate value) when parsing the code.

**5/ If an assembly language instruction is spelled incorrectly (e.g., “mv” instead of “mov”), when will the error be found? Respond with assemble-time or run-time.**

This is the assemble-time error, when assembler detect an incorrect instruction (mispelling) when parsing the code.

**6/ If a label is referenced, but not defined, when will the error be found? Respond with assemble-time or run-time.**

This is the assemble-time error, when assembler detect an undefined label when parsing the code after look up in the symbol table address.

**7/ If a program performing a series of divides on values in an array divides by 0, when will the error be found? Respond with assemble-time or run-time.**

This is the run-time error, when divide by 0 is not support from machine. An arithmethic exception will appear