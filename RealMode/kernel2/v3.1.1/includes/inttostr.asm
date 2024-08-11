;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: loads an unsigned 16bit integer value into a text buffer
;args (push order): input value (16bit), output text buffer segment (16bit), output text buffer index (16bit), return addr (16bit)
_loadstr_dec_u16:
	push word bp
	mov bp, sp

	;bp + 2 == arg3 return addr
	;bp + 4 == arg2 text index
	;bp + 6 == arg1 text segment
	;bp + 8 == arg0 input value

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]
	add si, word 2
	mov bx, word [ds:si]

	mov di, cx
	mov es, dx

	xor dx, dx
	mov ax, bx
	mov cx, word 10000
	div word cx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di
	
	mov bx, dx
	xor dx, dx
	mov ax, bx
	mov cx, word 1000
	div word cx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov bx, dx
	xor dx, dx
	mov ax, bx
	mov cx, word 100
	div word cx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov bx, dx
	xor dx, dx
	mov ax, bx
	mov cx, word 10
	div word cx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov ax, dx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov [es:di], byte 0x0

	_loadstr_dec_u16_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 8

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: loads signed 16bit integer into text buffer
;args (push order): input value (16bit), output text buffer segment (16bit), output text buffer index (16bit), return addr (16bit)
_loadstr_dec_s16:
	push word bp
	mov bp, sp

	;bp + 2 == arg3 return addr
	;bp + 4 == arg2 text index
	;bp + 6 == arg1 text segment
	;bp + 8 == arg0 input value

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]
	add si, word 2
	mov bx, word [ds:si]

	mov di, cx
	mov es, dx

	test bx, word 0x8000
	jz _loadstr_dec_s16_pos

	_loadstr_dec_s16_neg:
	mov [es:di], byte 0x2d
	inc di
	not bx
	inc bx

	_loadstr_dec_s16_pos:
	push word bx
	mov bx, es
	push word bx
	push word di
	push word $
	jmp _loadstr_dec_u16
	times RETURN_MARGIN_CALLER nop

	_loadstr_dec_s16_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 8

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: load unsigned 32bit integer into text buffer
;WARNING: only compatible with i386 and above CPUs
;args (push order): input value (32bit), output text buffer segment (16bit), output text buffer index (16bit), return addr (16bit)
_loadstr_dec_u32:
	push word bp
	mov bp, sp

	;bp + 2 == arg3 return addr
	;bp + 4 == arg2 text index
	;bp + 6 == arg1 text segment
	;bp + 8 == arg0 input value

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]
	add si, word 2
	mov ebx, dword [ds:si]

	mov di, cx
	mov es, dx

	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000000000
	div dword ecx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100000000
	div dword ecx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10000000
	div dword ecx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000000
	div dword ecx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100000
	div dword ecx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10000
	div dword ecx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 1000
	div dword ecx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 100
	div dword ecx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov ebx, edx
	xor edx, edx
	mov eax, ebx
	mov ecx, dword 10
	div dword ecx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov eax, edx
	mov ah, byte 0x0
	add al, byte 0x30
	mov [es:di], byte al
	inc di

	mov [es:di], byte 0x0

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	_loadstr_dec_u32_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 10

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: load signed 32bit integer into text buffer
;WARNING: only compatible with i386 and above CPUs
;args (push order): input value (32bit), output text buffer segment (16bit), output text buffer index (16bit), return addr (16bit)
_loadstr_dec_s32:
	push word bp
	mov bp, sp

	;bp + 2 == arg3 return addr
	;bp + 4 == arg2 text index
	;bp + 6 == arg1 text segment
	;bp + 8 == arg0 input value

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]
	add si, word 2
	mov ebx, dword [ds:si]

	mov di, cx
	mov es, dx

	test ebx, dword 0x80000000
	jz _loadstr_dec_s32_pos

	_loadstr_dec_s32_neg:
	mov [es:di], byte 0x2d
	inc di
	not ebx
	inc ebx

	_loadstr_dec_s32_pos:
	push dword ebx
	mov cx, es
	push word cx
	push word di
	push word $
	jmp _loadstr_dec_u32
	times RETURN_MARGIN_CALLER nop

	_loadstr_dec_s32_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 10

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

