%include "globaldef.asm"

P_NTEMP16 equ 0x40000		;Temporary value (in case needed)
TEXTSPACE_ADDR equ 0x40020	;Text buffer

org 0x0
bits 16

times 8 nop

cli
mov ax, word 0x0
mov ss, ax
mov ds, ax
mov es, ax
mov ebp, dword STACK_BASE32_ADDR
mov esp, ebp
sti

sys_start:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_start_cgamode
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_clearscreen
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword 0x20000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp delay
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word CGA_COLOR_LTGRAY
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_setfullcolor
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word textstr_start
	push dword eax
	or bx, word $
	push dword ebx
	jmp cga_println
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word 0
	push word 2
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_settextpos
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word textstr_bootdev
	push dword eax
	or bx, word $
	push dword ebx
	jmp cga_print
	times 20 nop
	xor cx, cx
	mov esi, dword 0x7e00
	mov cl, byte [esi]
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word cx
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_u8
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_println
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword 0x80000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp delay
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_clearscreen
	times 20 nop

sys_main:
%include "tests/test_vga.asm"

sys_terminate:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_start_cgamode
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_clearscreen
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word CGA_COLOR_LTGRAY
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_setfullcolor
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word textstr_end
	push dword eax
	or bx, word $
	push dword ebx
	jmp cga_println
	times 20 nop
	sys_terminate_loop:
	times 4 nop
	jmp sys_terminate_loop

%include "utils.asm"
%include "cga_utils.asm"
%include "vga_utils.asm"

textstr_empty: db 0x0
textstr_start: db 'Kernel load successful', 0x0
textstr_end: db 'Kernel process terminated', 0x0
textstr_bootdev: db 'Boot device ID: ', 0x0

times KERNEL_SIZE_BYTES - ($ - $$) db 0x0

