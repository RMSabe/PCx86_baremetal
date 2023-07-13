proc_1:
	mov esi, dword 0x20000
	mov cx, word 0
	mov [esi], word cx
	proc_1_loop:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word cx
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_u16
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
	push dword 0x08000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp delay
	times 20 nop
	mov esi, dword 0x20000
	mov cx, word [esi]
	cmp cx, word 200
	jae proc_2
	inc cx
	mov [esi], word cx
	jmp proc_1_loop

proc_2:
	mov esi, dword 0x20000
	mov cx, word -100
	mov [esi], word cx
	proc_2_loop:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word cx
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_s16
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
	push dword 0x08000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp delay
	times 20 nop
	mov esi, dword 0x20000
	mov cx, word [esi]
	cmp cx, word 100
	jge proc_end
	inc cx
	mov [esi], word cx
	jmp proc_2_loop

proc_end:

