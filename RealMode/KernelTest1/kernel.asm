KERNEL_BASE32_ADDR equ 0x10000
KERNEL_SIZE_BYTES equ 4096
KERNEL_SIZE_SECTORS equ 8

DATA_BASE32_ADDR equ 0x20000
STACK_BASE32_ADDR equ 0x40000

P_BOOTDEVICE equ 0x7e00

STACKLIST_BASE32_ADDR equ 0x50000
P_STACKLIST_INDEX32 equ 0x51000

NTEMP16_ADDR equ 0x40000
NLINE16_ADDR equ 0x40002
TEXTSPACE_ADDR equ 0x40020

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

mov ah, byte 0x0
mov al, byte 0x3
int 0x10

sys_start:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword 0x20000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp hold
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word textstr_start
	push dword eax
	or bx, word $
	push dword ebx
	jmp print
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word textstr_bootdev
	push dword eax
	or bx, word $
	push dword ebx
	jmp print
	times 32 nop
	xor ecx, ecx
	mov esi, dword 0x7e00
	mov cl, byte [esi]
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword ecx
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_u32
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp print
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword 0x80000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp hold
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp resetscreen
	times 32 nop

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
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp print
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword 0x08000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp hold
	times 32 nop
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
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp print
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword 0x08000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp hold
	times 32 nop
	mov esi, dword 0x20000
	mov ecx, dword [esi]
	cmp ecx, dword 100
	jge terminate
	inc ecx
	mov [esi], dword ecx
	jmp proc_2_loop

terminate:
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp resetscreen
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word textstr_end
	push dword eax
	or bx, word $
	push dword ebx
	jmp print
	times 32 nop
	terminate_loop:
	times 4 nop
	jmp terminate_loop

loaddec_u32:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx

	pop dword ebx
	mov edi, ebx

	pop dword ebx

	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000000000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100000000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10000000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov eax, edx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov [edi], byte 0x0

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]
	mov [esi], dword ecx

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

loaddec_s32:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx

	pop dword ebx
	mov edi, ebx

	pop dword ebx

	test ebx, dword 0x80000000
	jz loaddec_s32_pos

	loaddec_s32_neg:
	mov [edi], byte 0x2d
	inc edi
	not ebx
	inc ebx
	loaddec_s32_pos:
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000000000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100000000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10000000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10
	div dword ecx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov eax, edx
	and eax, dword 0xff
	add al, byte 0x30
	mov [edi], byte al
	inc edi
	mov [edi], byte 0x0

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]
	mov [esi], dword ecx

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

resetscreen:
	mov esi, dword NLINE16_ADDR
	mov [esi], word 0x0
	
	mov edi, dword 0xb8000
	resetscreen_loop:
	mov [edi], word 0x0
	add edi, dword 0x2
	cmp edi, dword 0xb8fa0
	jae resetscreen_end
	jmp resetscreen_loop
	resetscreen_end:

	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

print:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add edi, dword 0x4
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x8
	mov [esi], dword ecx

	xor ecx, ecx
	mov ebx, dword KERNEL_BASE32_ADDR
	mov esi, dword NLINE16_ADDR
	mov cx, word [esi]
	or bx, word $
	cmp cx, word 0xfa0
	push dword ebx
	jae resetscreen
	times 32 nop

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]
	mov [esi], dword ecx

	mov esi, ebx
	mov edi, dword NLINE16_ADDR
	mov cx, word [edi]
	mov edi, dword 0xb8000
	and ecx, dword 0xffff
	add edi, ecx
	mov ah, byte 0xf
	print_loop:
	mov al, byte [esi]
	cmp al, byte 0x0
	je print_end
	mov [edi], word ax
	inc esi
	add edi, dword 0x2
	jmp print_loop
	print_end:
	mov ebx, edi
	sub ebx, dword 0xb8000
	and ebx, dword 0xffff
	mov ax, bx
	mov dx, word 0x0
	mov cx, word 0xa0
	div word cx
	sub bx, dx
	add bx, word 0xa0
	mov esi, dword NLINE16_ADDR
	mov [esi], word bx

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]
	mov [esi], dword ecx

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

hold:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx
	
	pop dword eax
	xor ebx, ebx
	holdloop:
	cmp ebx, eax
	jae holdend
	inc ebx
	jmp holdloop
	holdend:
	xor eax, eax

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]
	mov [esi], dword ecx

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

textstr_empty: db 0x0
textstr_start: db 'Kernel load successful', 0x0
textstr_end: db 'Kernel process terminated', 0x0
textstr_bootdev: db 'Boot device ID:', 0x0

times KERNEL_SIZE_BYTES - ($ - $$) db 0x0

