Assembler instructions:
Only "boot.asm" and "kernel.asm" must be assembled individually.
All other ".asm" files are included in "kernel.asm".
I used the NASM assembler to assemble these files. Output format should be raw binary.
Binary kernel file should be concatenated right after binary boot file.

This is another version of kernel 1, however this one uses only 16bit registers, therefore it is fully compatible with any x86 CPU.
