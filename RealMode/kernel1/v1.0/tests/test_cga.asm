proc_1:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word CGA_COLOR_YELLOW
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_setbkcolor
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word CGA_COLOR_LTBLUE
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_settextcolor
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word 0
	push word 4
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_settextpos
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word testcga_str_1
	push dword eax
	or bx, word $
	push dword ebx
	jmp cga_print
	times 20 nop

proc_2:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word CGA_COLOR_LTRED
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_setbkcolor
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word CGA_COLOR_LTGREEN
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_settextcolor
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word 20
	push word 8
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_settextpos
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word testcga_str_2
	push dword eax
	or bx, word $
	push dword ebx
	jmp cga_print
	times 20 nop

mov ebp, dword STACK_BASE32_ADDR
mov esp, ebp
push dword 0x80000000
mov ebx, dword KERNEL_BASE32_ADDR
or bx, word $
push dword ebx
jmp delay
times 20 nop

jmp proc_end

testcga_str_1: db 'This is just a text', 0x0
testcga_str_2: db 'This is just another text', 0x0

proc_end:

