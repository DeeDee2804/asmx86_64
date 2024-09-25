# DDD Debugger

**1/How is the debugger started (from the command line)?**

We can use the following code to start the debugger:
```sh
ddd [program_name]
```

**2/ What option is required during the assemble and link step in order to ensure the program be easily debugged**

When assmble and link the program, we must use the -g flag option that enable the debug info in executable file.

**3/ What does the run command do specifically?**

It will run from the start of the program to the first breakpoint in the program in case we have set beforehand.

**4/ What does the continue command do specifically?**

It will continue to execute the program from the last breakpoint that make program stop to the next breakpoint in the program.

**5/ How is the register window displayed?**

To display the register window for debugging, we follow the link:
**Status -> Register**.

**6/ There are three columns in the register window. The first shows the register. What do the other two columns show?**

The second column show the value of register in hex and the last column show the corresponding decimal value. 

**7/ Once the debugger is started, how can the user exit?**

To exit from the debugger, the user can type quit in the command line or click close button.

**8/ Describe how a breakpoint is set (multiple ways).**

The programmer could set the breakpoint by the label, by the line number (both in command line or by right click on the line and select ***Set Breakpoint***)

**9/ What is the debugger command to read debugger commands from a file?**

To read debugger commands from a file, the user can use this syntax:
```sh
source [file_name]
```
**10/ When the DDD shows a green arrow pointing to an instruction, what does that mean?**

It means the current program is run to that instruction but not executed yet and wait for next debugger command to continue.

**11/ Provide the debugger command to display each of the following variables in decimal:**

- bVar1 (byte sized variable): ```x/db &bVar1```
- wVar1 (word sized variable): ```x/dh &wVar1```
- dVar1 (double-word sized variable): ```x/dw &dVar1```
- qVar1 (quadword sized variable): ```x/dg &qVar1```
- bArr1 (30 element array of bytes): ```x/30db &bArr1```
- wArr1 (50 element array of words): ```x/50dh &wArr1```
- dArr1 (75 element array of double-words): ```x/75dw &dArr1```

**12/ Provide the debugger command to display each of the following variables in hexadecimal format:**

- bVar1 (byte sized variable): ```x/xb &bVar1```
- wVar1 (word sized variable): ```x/xh &wVar1```
- dVar1 (double-word sized variable): ```x/xw &dVar1```
- qVar1 (quadword sized variable): ```x/xg &qVar1```
- bArr1 (30 element array of bytes): ```x/30xb &bArr1```
- wArr1 (50 element array of words): ```x/50xh &wArr1```
- dArr1 (75 element array of double-words): ```x/75xw &dArr1```

**13/ What is the debugger command to display the value at the current top of the stack?**
```
x/ug $rsp
```

**14/ What is the debugger command to display five values at the current top of the stack?**
```
x/5ug $rsp
```