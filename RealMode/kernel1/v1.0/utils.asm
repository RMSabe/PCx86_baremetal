%include "globaldef.asm"

;FUNCTION: write 32bit unsigned integer value into text buffer
;args (push order): input value (32bit), output text buffer addr (32bit), return addr (32bit)
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

;FUNCTION: write 32bit signed integer value into text buffer
;args (push order): input value (32bit), output text buffer addr (32bit), return addr (32bit)
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
	
	push dword ebx
	push dword edi
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_u32
	times 20 nop

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

;FUNCTION: write 16bit unsigned integer value into text buffer
;args (push order): input value (16bit), output text buffer addr (32bit), return addr (32bit)
loaddec_u16:
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

	pop word bx
	and ebx, dword 0xffff

	push dword ebx
	push dword edi
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_u32
	times 20 nop

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

;FUNCTION: write 16bit signed integer value into text buffer
;args (push order): input value (16bit), output text buffer addr (32bit), return addr (32bit)
loaddec_s16:
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

	pop word bx
	and ebx, dword 0xffff

	test bx, word 0x8000
	jz loaddec_s16_pos

	loaddec_s16_neg:
	or ebx, dword 0xffff0000
	loaddec_s16_pos:

	push dword ebx
	push dword edi
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_s32
	times 20 nop

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

;FUNCTION: write 8bit unsigned integer value into text buffer
;args (push order): input value (16bit), output text buffer addr (32bit), return addr (32bit)
loaddec_u8:
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

	pop word bx
	and ebx, dword 0xff

	push dword ebx
	push dword edi
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_u32
	times 20 nop

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

;FUNCTION: write 8bit signed integer value into text buffer
;args (push order): input value (16bit), output text buffer addr (32bit), return addr (32bit)
loaddec_s8:
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

	pop word bx
	and ebx, dword 0xff

	test bl, byte 0x80
	jz loaddec_s8_pos

	loaddec_s8_neg:
	or ebx, dword 0xffffff00
	loaddec_s8_pos:

	push dword ebx
	push dword edi
	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp loaddec_s32
	times 20 nop

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

;FUNCTION: delay system
;args (push order): delay time (number of cycles) (32bit), return addr (32bit)
delay:
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

