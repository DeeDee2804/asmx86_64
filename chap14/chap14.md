# Multiple Source Files
**1/ What is the statement to declare the functions, func1() and func2(), as external assuming no arguments are needed for either function?**

It will be
```
extern void func1(void);
extern void func2(void);
```

**2/ What is the statement to declare the functions, func1() and func2(), as external if two integer arguments are used for each function?**

It will be
```
extern void func1(int, int);
extern void func2(int, int);
```

**3/ What will happen if an external function is called but is not declared as external?**

It will lead to an error that compiler could not find the function at anywhere.

**4/ If an externally declared function is called but the programmer did not actually write the function, when would the error be flagged, assemble-time, link-time, or run-time?**

The error will show in linking process.

**5/ If an externally declared function is called but the programmer did not actually write the function, what might the error be?**

When complie the object file, it is still ok for the source file call that function. In link-time, the external function must be linked to pass the complete compilation but we could not find it.

**6/ If the “-g” option is omitted from the assemble and link commands, would the program be able to execute?**

Yes, the program is still executable but we can not use the debug tool to get more info about it during run time.

