KERNEL_BASE32_ADDR equ 0x10000
KERNEL_SIZE_BYTES equ 4096
KERNEL_SIZE_SECTORS equ 8

DATA_BASE32_ADDR equ 0x20000
STACK_BASE32_ADDR equ 0x40000

P_BOOTDEVICE equ 0x7e00

STACKLIST_BASE32_ADDR equ 0x50000
P_STACKLIST_INDEX32 equ 0x51000
;This STACKLIST behaves as a secondary stack.
;Its main usage is when calling functions. The stacklist is always filled by the callee function as needed, which is useful for conditional functions
;The return address of each function is the last value pushed into the regular stack before calling the function
;The way I set in this kernel was the following: I divided the function types in 3 groups:
;Group 1: no args, no conditional functions: this function doesnt need to use the stacklist. Just pop the last value of regular stack and jump back to it
;Group 2: args, no conditional functions: in this case, stacklist should be used to store at least the return value of the function
;Group 3: args, conditional function: in this case, stacklist should be used to store all arguments (including return value) of the function
;Index value stores the offset to the next available space on stacklist. It should be updated every time a value is pushed on, popped off the stacklist
;For both the regular stack and the stacklist, I use only 32bit integer values

NTEMP16_ADDR equ 0x40000 ;16bit temporary value, in case needed
NLINE16_ADDR equ 0x40002 ;16bit unsigned value: I used it to keep track of the current character position on screen
TEXTSPACE_ADDR equ 0x40020 ;Just a text buffer

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
	jmp hold	;wait 20000000h cycles before proceeding
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word textstr_start
	push dword eax
	or bx, word $
	push dword ebx
	jmp print	;print kernel loaded message
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov eax, dword KERNEL_BASE32_ADDR
	mov ebx, eax
	or ax, word textstr_bootdev
	push dword eax
	or bx, word $
	push dword ebx
	jmp print	;print boot device message
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
	jmp loaddec_u32		;load text buffer with boot device number
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword TEXTSPACE_ADDR
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp print		;print boot device number
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	push dword 0x80000000
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp hold		;wait 80000000h cycles before proceeding
	times 32 nop
	mov ebp, dword STACK_BASE32_ADDR
	mov esp, ebp
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp resetscreen
	times 32 nop

;proc 1: print unsigned numbers from 0 to 200 with a 08000000h delay
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

;proc 2: print signed numbers from -100 to 100 with a 08000000 delay
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

;display terminate message and stop
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

;function: load unsigned int32 into text buffer
;args (push order): input value, output buffer addr, return addr
loaddec_u32:
	;this function has args, but no conditional functions inside
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx	;push return addr into stacklist
	add ecx, dword 0x4
	mov [esi], dword ecx	;update stacklist index value

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
	mov ebx, dword [edi]	;fetch return addr from stacklist
	mov [esi], dword ecx	;update stacklist index value

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;function: load signed int32 into text buffer
;args (push order): input value, output buffer addr, return addr
loaddec_s32:
	;this function has args, but no conditional functions inside
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx	;push return addr into stacklist
	add ecx, dword 0x4
	mov [esi], dword ecx	;update stacklist index value

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
	push dword ebx
	push dword edi
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_u32
	times 32 nop

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]	;fetch return addr from stacklist
	mov [esi], dword ecx	;update stacklist index value

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;function: clear screen/reset nline16 value
;args (push order): return addr
resetscreen:
	;This function has no args, no conditional functions inside
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

;function: print a text on the screen
;args (push order): input text buffer addr, return addr
print:
	;this function has args and conditional functions inside
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx	;push return addr into stacklist
	add edi, dword 0x4
	pop dword ebx
	mov [edi], dword ebx	;push arg into stacklist
	add ecx, dword 0x8
	mov [esi], dword ecx	;update stacklist index value

	xor ecx, ecx
	mov ebx, dword KERNEL_BASE32_ADDR
	mov esi, dword NLINE16_ADDR
	mov cx, word [esi]
	or bx, word $
	cmp cx, word 0xfa0
	push dword ebx
	jae resetscreen		;conditional function
	times 32 nop

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]	;fetch arg from stacklist
	mov [esi], dword ecx	;update stacklist index value

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
	mov ebx, dword [edi]	;fetch return addr from stacklist
	mov [esi], dword ecx	;update stacklist index value

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;function: delay system
;args (push order): hold time (cycles), return addr
hold:
	;this function has args, but no conditional functions inside
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx	;push return addr into stacklist
	add ecx, dword 0x4
	mov [esi], dword ecx	;update stacklist index value
	
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
	mov ebx, dword [edi]	;fetch return addr from stacklist
	mov [esi], dword ecx	;update stacklist index value

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

textstr_empty: db 0x0
textstr_start: db 'Kernel load successful', 0x0
textstr_end: db 'Kernel process terminated', 0x0
textstr_bootdev: db 'Boot device ID:', 0x0

times KERNEL_SIZE_BYTES - ($ - $$) db 0x0

