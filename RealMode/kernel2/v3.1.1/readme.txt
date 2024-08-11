Kernel 2 version 3.1.1

This version uses mostly 16bit registers, however some functions using 32bit registers were added (requires 386 compatible CPUs).

_textbuf is a buffer space that can be used for loading text strings in memory. The full address of _textbuf is KERNEL_SEG16:_textbuf

This version uses the same calling convention as v3.1.

RETURN_MARGIN_CALLEE and RETURN_MARGIN_CALLER: is a "landing area" used when jumping back from the callee subroutine/function to the caller routine/function. 
These are used to prevent repeating/skipping instructions in the caller routine/function.

All arguments to the callee function are passed by the caller function using the stack. Return address should always be the last value pushed into the stack before jumping to the callee function.
The callee function will create its own stack base (call stack procedure). When returning to the caller function, callee function should restore the stack top and stack base register values before jumping back.
It's important to notice that callee function should always clear the arguments that were pushed into the stack by the caller function. Caller function will not clear these arguments from the stack after callee function jumped back.
All registers except "sp" and "bp" must be saved by caller function before jumping to a callee function. Callee function will not restore the values in these registers in case they're changed.

Assembler:
I used the NASM assembler.
Only the boot.asm and kernel.asm files must be assembled individually.
Output format should be raw binary.
The binary from kernel.asm should be concatenated after the binary from boot.asm, to generate final binary file.
I left a bash script called "build.sh" to run all these actions.

Author: Rafael Sabe
Email: rafaelmsabe@gmail.com

