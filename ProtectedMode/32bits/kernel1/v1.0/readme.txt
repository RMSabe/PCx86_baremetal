Mini Kernel for 386 PC
Protected Mode 32 bits kernel 1 version 1.0

Calling convention: This kernel uses a call stack calling convention.
Functions are called and returned using the "call" and "ret" instructions.
Arguments are passed from the caller function to the callee function using registers eax through edx.
Callee function will create its own stack base (call stack). Callee function must restore the values in the "ebp" and "esp" registers before returning to the caller function.
Caller function must save the values of all registers (except "ebp" and "esp") before calling the callee function. Callee function will not restore values in these registers if they're changed.

Assembler instructions:
I used the NASM assembler
Only files "boot.asm" and "kernel.asm" must be individually assembled.
The output format should be raw binary.
The "kernel" binary file should be concatenated right after the "boot" binary file to generate full binary.

Example:
"nasm boot.asm -f bin -o boot.bin"
"nasm kernel.asm -f bin -o kernel.bin"
"cat boot.bin kernel.bin >> system.img"

I left a "build.sh" file in the code, just in case.

Author: Rafael Sabe
Email: rafaelmsabe@gmail.com

