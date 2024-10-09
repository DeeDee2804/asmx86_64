# Floating-Point Instructions
**1/ List the floating-point registers**

There are 16 registers reserved only for floating point calculations. They are **xmm0**, **xmm1**, ..., **xmm15**.

**2/ How many bytes are used by single precision floating-point values and how many bytes are used for double precision floating-point values?**

For single precision, 32 bytes will be used.
For double precision, 64 bytes are required.

**3/ Explain why 0.1 added 10 times does not equal 1.0.**

Because the floating not exactly represent the value of 0.1 and the sum of 10 times of this value also include the accumulative error then the final result will not equal to 1.0.

**4/ Where is the result of a value returning floating-point function such as sin(x) returned?**

The floating point return from function will pass to **xmm0** register.

**5/ For a value returning floating-point function, which floating-point registers must be preserved across the function call?**

No register need to preserved accross the function call, then when using them, we must take care of it thoroughly.