;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

%include "includes/globaldef.asm"

org KERNEL_INDEX16
bits 16

section .kernel

cli
mov ax, word STACK_SEG16
mov ss, ax
mov bp, word STACK_BP16
mov sp, bp
sti

_sysstart:
	push word $
	jmp _cga_init
	times RETURN_MARGIN_CALLER nop

	push word KERNEL_SEG16
	push word _textstr_kernelstart
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop

	push word 0x4000
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

_sysmain:
;Add main routine here

	jmp _teststart

_sysend:
	push word $
	jmp _cga_clearscreen
	times RETURN_MARGIN_CALLER nop

	push word CGA_TEXTCOLOR_DEFAULT
	push word CGA_BKCOLOR_DEFAULT
	push word $
	jmp _cga_setcolor
	times RETURN_MARGIN_CALLER nop

	push word KERNEL_SEG16
	push word _textstr_kernelend
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop

	_sysend_loop:
	times 4 nop
	jmp _sysend_loop

_textbuf:
times TEXTBUF_SIZE db 0x0

%include "includes/time.asm"
%include "includes/inttostr.asm"
%include "includes/str_utils.asm"
%include "includes/cga_utils.asm"
%include "includes/vga_utils.asm"

_textstr_kernelstart: db 'Kernel load successful', 0x0
_textstr_kernelend: db 'Kernel process finished', 0x0

%include "tests/test05.asm"

times KERNEL_SIZE_BYTES - ($ - $$) db 0x0

