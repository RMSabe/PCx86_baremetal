proc_1:
	mov esi, dword 0x20000
	mov ecx, dword 0
	mov [esi], dword ecx
	proc_1_loop:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword ecx
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_u32
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
	mov ecx, dword [esi]
	cmp ecx, dword 200
	jae proc_2
	inc ecx
	mov [esi], dword ecx
	jmp proc_1_loop

proc_2:
	mov esi, dword 0x20000
	mov ecx, dword -100
	mov [esi], dword ecx
	proc_2_loop:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword ecx
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_s32
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
	mov ecx, dword [esi]
	cmp ecx, dword 100
	jge proc_end
	inc ecx
	mov [esi], dword ecx
	jmp proc_2_loop

proc_end:

