Assembler instructions:
Only "boot.asm" and "kernel.asm" must be assembled individually.
All other ".asm" files are included in "kernel.asm".
I used the NASM assembler to assemble these files. Output format should be raw binary.
Binary kernel file should be concatenated right after binary boot file.

This kernel uses 32bit registers, therefore it is only compatible with i386 and above CPUs.
