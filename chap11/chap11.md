# Macros
**1/Where is the macro definition placed in the assembly language source file?**

The macro should be defined at the beginning of the source file before the data and text section to avoid the reference without define error.

**2/ When a macro is invoked, how many times is the code placed in the code segment?**

The macro will invoked once or multiple times in the text section. Everytime, it is invoked, the macro will be replace by its definition in the code segment. So it could take lot of memory if we don't take care of it.

**3/ Explain why, in a macro, labels are typically preceded by a %% (double percent sign)**

That is because the macro has been defined with % sign, and we should not use the normal label because it can conflict with other labeling in the text code and could lead to some unexpected scenario. Then %% sign is preferable and commonly used.

**4/ Explain what might happen if the %% is not included on a label?**

If the macro label not defined with %% sign, the other code section can refer and jump to this label that will lead to unexpected result. And every time the macro invoked the same label is define and lead to name conflict where one label name is used multiple times.

**5/ Is it legal to jump to a label that does not include the %%? If not legal, explain why. If legal, explain under what circumstances that might be useful.**

It legal, if the label we want to jump on is already exist an define in source code. It is useful in some case that we already the purpose of the code under the label, and we can actively jump on it if we want to handle some specific action.

**6/ When does the macro argument substitution occur?**

It will be done when the macro is invoked with parameter and the assembler will replaced it for us.
