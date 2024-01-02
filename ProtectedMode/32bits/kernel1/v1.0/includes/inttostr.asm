;Mini kernel for 386 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: load unsigned 32bit integer into text buffer
;args: eax (input value), ebx (output text buffer addr)
_loadstr_dec_u32:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax
	sub esi, dword 4
	mov [esi], dword ebx

	sub esp, dword 8

	;ebp - 4 == input value
	;ebp - 8 == text buffer

	mov edi, ebx

	mov ebx, eax

	xor edx, edx
	mov ecx, dword 1000000000
	div dword ecx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100000000
	div dword ecx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10000000
	div dword ecx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000000
	div dword ecx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100000
	div dword ecx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10000
	div dword ecx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000
	div dword ecx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100
	div dword ecx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10
	div dword ecx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov eax, edx
	and eax, dword 0xff
	add eax, dword 0x30
	mov [edi], byte al
	inc edi

	mov [edi], byte 0

	_loadstr_dec_u32_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: load signed 32bit integer into text buffer
;args: eax (input value), ebx (output text buffer addr)
_loadstr_dec_s32:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax
	sub esi, dword 4
	mov [esi], dword ebx

	sub esp, dword 8

	;ebp - 4 == input value
	;ebp - 8 == text buffer

	mov edi, ebx

	test eax, dword 0x80000000
	jz _loadstr_dec_s32_pos

	_loadstr_dec_s32_neg:
	mov [edi], byte 0x2d
	inc edi

	not eax
	inc eax

	_loadstr_dec_s32_pos:
	mov ebx, edi
	call _loadstr_dec_u32

	_loadstr_dec_s32_return:
	mov esp, ebp
	pop dword ebp
	ret

