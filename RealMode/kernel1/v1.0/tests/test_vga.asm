mov ebp, dword STACK_BASE32_ADDR
mov esp, ebp
mov ebx, dword KERNEL_BASE32_ADDR
or bx, word $
push dword ebx
jmp vga_start_vgamode
times 20 nop

proc_1:
	mov bx, word 40
	mov edi, dword 0x20000
	mov [edi], word bx
	mov bx, word 20
	add edi, dword 0x2
	mov [edi], word bx
	proc_1_loop:
	mov esi, dword 0x20000
	mov ax, word [esi]
	add esi, dword 0x2
	mov cx, word [esi]
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	cmp ax, 160
	jae proc_1_loop_2
	proc_1_loop_1:
	push word 0x92
	jmp proc_1_loop_3
	proc_1_loop_2:
	push word 0x44
	proc_1_loop_3:
	push word ax
	push word cx
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp vga_paintpixel
	times 20 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword 0x00010000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp delay
	times 20 nop
	mov esi, dword 0x20000
	mov ax, word [esi]
	inc ax
	cmp ax, word 280
	jb proc_1_loop_4
	mov ax, word 40
	mov esi, dword 0x20002
	mov cx, word [esi]
	inc cx
	cmp cx, word 180
	jae proc_2
	mov [esi], word cx
	proc_1_loop_4:
	mov esi, dword 0x20000
	mov [esi], word ax
	jmp proc_1_loop

proc_2:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword 0x40000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp delay
	times 20 nop

proc_end:

