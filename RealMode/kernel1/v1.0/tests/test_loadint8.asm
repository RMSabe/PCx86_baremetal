proc_1:
	mov esi, dword 0x20000
	mov cl, byte 0
	mov [esi], byte cl
	proc_1_loop:
	and cx, word 0xff
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
	push dword 0x08000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp delay
	times 20 nop
	mov esi, dword 0x20000
	mov cl, byte [esi]
	cmp cl, byte 200
	jae proc_2
	inc cl
	mov [esi], byte cl
	jmp proc_1_loop

proc_2:
	mov esi, dword 0x20000
	mov cl, byte -100
	mov [esi], byte cl
	proc_2_loop:
	and cx, word 0xff
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push word cx
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_s8
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
	mov cl, byte [esi]
	cmp cl, byte 100
	jge proc_end
	inc cl
	mov [esi], byte cl
	jmp proc_2_loop

proc_end:

