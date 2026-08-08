/*
 * Mini Kernel 2 for 386 PCs.
 * Version 0.1
 *
 * Author: Rafael Sabe
 * Email: rafaelmsabe@gmail.com
 */

#include "_macros.h"

.section .__kernel_start__
.code32

.global _start
.global _end
.extern _main

_start:
	cli

	movl $GDTSEG_DATA_OFFSET, %ebx
	movw %bx, %ds
	movw %bx, %es
	movw %bx, %fs
	movw %bx, %gs
	movw %bx, %ss

	movl $STACK_INIT_BP32, %ebp
	movl %ebp, %esp

	pushl %ebp
	movl %esp, %ebp

	call _main

_end:
	_l_end_loop:
	nop
	nop
	nop
	nop
	jmp _l_end_loop

