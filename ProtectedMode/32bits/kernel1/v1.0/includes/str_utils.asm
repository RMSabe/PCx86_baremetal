;Mini kernel for 386 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: compare two text strings
;args: eax (input text1 buffer addr), ebx (input text2 buffer addr)
;return value: eax (1 == equal / 0 == not equal)
_strcompare:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax
	sub esi, dword 4
	mov [esi], dword ebx

	sub esp, dword 8

	;ebp - 4 == text buffer 1
	;ebp - 8 == text buffer 2

	mov esi, eax
	mov edi, ebx

	xor ecx, ecx
	xor edx, edx

	_strcompare_getlen1:
	mov al, byte [esi]
	cmp al, byte 0
	je _strcompare_gotlen1
	inc ecx
	inc esi
	jmp _strcompare_getlen1
	_strcompare_gotlen1:
	sub esi, ecx

	_strcompare_getlen2:
	mov al, byte [edi]
	cmp al, byte 0
	je _strcompare_gotlen2
	inc edx
	inc edi
	jmp _strcompare_getlen2
	_strcompare_gotlen2:
	sub edi, edx

	cmp ecx, edx
	jne _strcompare_returnfalse

	xor ecx, ecx
	_strcompare_loop:
	cmp ecx, edx
	jae _strcompare_endloop
	mov al, byte [esi]
	mov bl, byte [edi]
	cmp al, bl
	jne _strcompare_returnfalse
	inc ecx
	inc esi
	inc edi
	jmp _strcompare_loop
	_strcompare_endloop:

	_strcompare_returntrue:
	mov eax, dword 1
	jmp _strcompare_return

	_strcompare_returnfalse:
	xor eax, eax

	_strcompare_return:
	mov esp, ebp
	pop dword ebp
	ret

