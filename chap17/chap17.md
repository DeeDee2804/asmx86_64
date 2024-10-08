# Input/Output Buffering
**1/ What is the end of line character or characters for Linux and Windows?**

On Linux, the end of line character is LF -line feed with value 0x10 in ASCII table.<br>
On Windows, the line end is indicated by two characters, CR - cariage return (0x0D in ASCII table) followed by LF.

**2/ Based on the explanations in this chapter, what is I/O buffering?**

I/O buffering is a process that improves the overall throughput and efficiency of I/O operations.

**3/ In reference to a high-level language, where are the I/O buffering routines located?**

It is covered and abstract in the standard library functions that hide the complexity to the programmer.

**4/ What is the advantage of hiding the I/O buffering complexity from the programmer?**

It helps programmer save time for coding agian this feature and enable them to focus on the main application they develop without thinking about the I/O problem.

**5/ What is the key advantage of performing I/O buffering (as opposed to reading one character at a time)?**

Perform I/O buffering will reduce the overhead of system call for  I/O manipulation that could take significant time to complete and expensive in terms of run-time then help to accelerate the overall performance. The large amount will be read and store in buffer, then everytime a read request is called, the data will be obtained from buffer without other read call until the buffer is outdated or there is no more character to read.

**6/ Why is it difficult to use the file read system service to read one text line from a file?**

Because the number of characters need to read is not sepcified at the beginning of the system call while that is a mandatory input, that make it has to check for every character to detect line end character.

**7/ In terms of the memory hierarchy, why is buffering advantageous?**

Because the secondary storage where the files mostly are located is significantly more expensive to access than the main memory. Then by limit the system call to secondary memory is encouraged by using the buffer in main memory.

**8/ In terms of system overhead, why is buffering advantageous?**

Each time an I/O system service is called,it will temporary pause the program and turn over the control to the OS.
Then, the OS will validate the request and pass it to the secondary storage control via system bus.
Next step, the secondary storage will do whatever to obtain the requested data and place it directly into main memory location instructed by OS, again accessing the system bus to perform the transfer.
Once this process is complete, it notifies the OS.As its turn, OS will then notify and resume the program.
So, it make sense when read more data rather than less to obviously limit the system call and reduce the system overhead. The abundant data will be stored in buffer for later use if needed.

**9/ Why does the file read buffering algorithm require statically declared variables?**

The stack dynamic variables could not be used here because the data need to be maintained between successive calls.

**10/ How is the end of file recognized by the program?**
The end of file could be detected by comparing the actual character read and the character requested. If the actual one is lower, then the program could know that it already reach to the end of file.

**11/ Provide one, of many, reasons that a file read request might return an error even when the file has been opened successfully.**

There are several reasons:
- The file may be deleted or moved during reading.
- The hard drive is removed from computer
- The hardware error happens.

**12/ What must be done to address the case when the file size is an exact multiple of the buffer size?**

The case when actual number of charaters is 0 must be checked explicitly.

**13/ Why is the maximum length of the text line passed as an argument?**

This maximum length of text line is passed to avoid the unexpected part of the array is overwritten.

**14/ How does the presented algorithm ensure that the very first call the myGetLine() will read the buffer?**

That will be done in the initialization phase when all variables is set to make the condition all the buffer is read and need to perform the I/O system call.
 

