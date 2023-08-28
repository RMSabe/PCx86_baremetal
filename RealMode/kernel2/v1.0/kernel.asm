%include "globaldef.asm"

org 0x0
bits 16

cli
mov ax, word STACK_SEG16
mov ss, ax
mov bp, word STACK_BP_INDEX16
mov sp, bp
sti

mov ax, word STACKLIST_SEG16
mov es, ax
mov di, word P_STACKLIST_INDEX16
mov [es:di], word 0x0

jmp sys_start

textstr_start: db 'Kernel load successful', 0x0
textstr_terminate: db 'Kernel process finished', 0x0

sys_start:
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	mov bx, word $
	push word bx
	jmp cga_init
	times RETURN_MARGIN_CALLER nop
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word KERNEL_SEG16
	push word textstr_start
	mov bx, word $
	push word bx
	jmp cga_println
	times RETURN_MARGIN_CALLER nop
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word 0x4000
	mov bx, word $
	push word bx
	jmp hold_long
	times RETURN_MARGIN_CALLER nop

;This is where main routine goes
sys_main:

sys_terminate:
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	mov bx, word $
	push word bx
	jmp cga_clearscreen
	times RETURN_MARGIN_CALLER nop
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word CGA_COLOR_DEFAULT
	push word CGA_COLOR_BLACK
	mov bx, word $
	push word bx
	jmp cga_setcolor
	times RETURN_MARGIN_CALLER nop
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word KERNEL_SEG16
	push word textstr_terminate
	mov bx, word $
	push word bx
	jmp cga_println
	times RETURN_MARGIN_CALLER nop
	sys_terminate_loop:
	times 4 nop
	jmp sys_terminate_loop

%include "utils.asm"
%include "cga_utils.asm"
%include "vga_utils.asm"

times KERNEL_SIZE_BYTES - ($ - $$) db 0x0

