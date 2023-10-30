This is an upgrade of kernel 2 v1.0
It still uses mostly 16bit registers, however some new functions using 32bit registers were added.

Code architecture changed a bit. Since the code runs on real mode, I thought it to be easier to have all system variables within the kernel segment, as labels.
For example: TEXTBUFFER is now a label in the code called _textbuf. It can be accessed by using address (segment:index) KERNEL_SEG16:_textbuf

Just as kernel1 and kernel2 v1.0, this project uses a specific calling convention:
all arguments are pushed into the stack before jumping to a function. Return address should always be the last argument.

RETURN_MARGIN_CALLEE and RETURN_MARGIN_CALLER: is a "landing area" used when jumping back from the callee routine/function to the caller routine/function. 
These are used to prevent repeating/skipping instructions in the caller routine/function.

_stacklist and _stacklist_index: _stacklist is a memory buffer that behaves as a parallel stack. 
_stacklist is meant to be used by callee routines/functions, every value pushed into _stacklist must be popped out of _stacklist before returning to the caller routine/function.
_stacklist_index is the index value pointing to the next free space in the _stacklist buffer. This value should be updated every time a value is pushed into/popped out of _stacklist buffer.

Assembler:
I used the NASM assembler.
Only the boot.asm and kernel.asm files must be assembled individually.
Output format should be raw binary.
The binary from kernel.asm should be concatenated after the binary from boot.asm, to generate final binary file.
I left a bash script called "build.sh" to run all these actions.

Author: Rafael Sabe
Email: rafaelmsabe@gmail.com

