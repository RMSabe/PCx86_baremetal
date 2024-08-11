;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: compare two text strings
;args (push order): input text1 buffer segment (16bit), input text1 buffer index (16bit), input text2 buffer segment (16bit), input text2 buffer index (16bit), return addr (16bit)
;return value: ax (1 = equal | 0 = not equal)
_str_compare:
	push word bp
	mov bp, sp

	;bp + 2 == arg4 return addr
	;bp + 4 == arg3 text2 index
	;bp + 6 == arg2 text2 segment
	;bp + 8 == arg1 text1 index
	;bp + 10 == arg0 text1 segment

	sub sp, word 4

	;Local var:
	;bp - 2 == str1 length (16bit)
	;bp - 4 == str2 length (16bit)

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 8
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	push word dx
	push word cx
	push word $
	jmp _str_getlength
	times RETURN_MARGIN_CALLER nop

	mov bx, ss
	mov ds, bx
	mov si, bp
	sub si, word 2
	mov [ds:si], word ax

	mov si, bp
	add si, word 4
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	push word dx
	push word cx
	push word $
	jmp _str_getlength
	times RETURN_MARGIN_CALLER nop

	mov bx, ss
	mov ds, bx
	mov si, bp
	sub si, word 4
	mov [ds:si], word ax

	add si, word 2
	mov bx, word [ds:si]

	cmp ax, bx
	jne _str_compare_returnfalse

	mov si, bp
	add si, word 4
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	mov es, dx
	mov di, cx

	add si, word 2
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	mov ds, dx
	mov si, cx

	mov dx, ax
	xor cx, cx
	xor bx, bx
	xor ax, ax

	_str_compare_loop:
	cmp cx, dx
	jae _str_compare_endloop
	mov al, byte [ds:si]
	mov bl, byte [es:di]
	cmp al, bl
	jne _str_compare_returnfalse
	inc si
	inc di
	inc cx
	jmp _str_compare_loop
	_str_compare_endloop:

	_str_compare_returntrue:
	mov ax, word 1
	jmp _str_compare_return

	_str_compare_returnfalse:
	xor ax, ax

	_str_compare_return:
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

;FUNCTION: get text length
;args (push order): input text buffer segment (16bit), input text buffer index (16bit), return addr (16bit)
;return value: ax (text length)
_str_getlength:
	push word bp
	mov bp, sp

	;bp + 2 == return addr
	;bp + 4 == text buffer index
	;bp + 6 == text buffer segment

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	mov ds, dx
	mov si, cx

	xor ax, ax
	xor cx, cx

	_str_getlength_loop:
	mov al, byte [ds:si]
	cmp al, byte 0
	je _str_getlength_endloop
	inc si
	inc cx
	jmp _str_getlength_loop
	_str_getlength_endloop:

	mov ax, cx

	_str_getlength_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 6

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: concatenates an input text to the end of an existing output text buffer
;args (push order): input text buffer segment (16bit), input text buffer index (16bit), output text buffer segment (16bit), output text buffer index (16bit), output text buffer size (16bit), return addr (16bit)
;return value: ax (1 = concat successful / 0 = concat failed)
_str_concat:
	push word bp
	mov bp, sp

	;bp + 2 == return addr
	;bp + 4 == buffer out size
	;bp + 6 == buffer out index
	;bp + 8 == buffer out segment
	;bp + 10 == buffer in index
	;bp + 12 == buffer in segment

	sub sp, word 4

	;local var:
	;bp - 2 == remainder output index (16bit)
	;bp - 4 == remainder output size (16bit)

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4

	mov cx, word [ds:si]
	cmp cx, word 0
	je _str_concat_returnfalse

	add si, word 2
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	push word dx
	push word cx
	push word $
	jmp _str_getlength
	times RETURN_MARGIN_CALLER nop

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov cx, word [ds:si]

	dec cx
	cmp ax, cx
	jae _str_concat_returnfalse

	inc cx
	sub cx, ax

	mov si, bp
	sub si, word 2
	mov [ds:si], word ax
	sub si, word 2
	mov [ds:si], word cx

	mov si, bp
	add si, word 12
	mov dx, word [ds:si]
	sub si, word 2
	mov cx, word [ds:si]

	push word dx
	push word cx

	sub si, word 2
	mov dx, word [ds:si]

	push word dx

	mov si, bp
	sub si, word 2
	mov cx, word [ds:si]

	push word cx

	sub si, word 2
	mov cx, word [ds:si]

	push word cx

	push word $
	jmp _str_copy
	times RETURN_MARGIN_CALLER nop

	test ax, word 0xffff
	jz _str_concat_returnfalse

	_str_concat_returntrue:
	mov ax, word 1
	jmp _str_concat_return

	_str_concat_returnfalse:
	xor ax, ax

	_str_concat_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 12

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: copy an input text to an output text buffer
;args (push order): input text buffer segment (16bit), input text buffer index (16bit), output text buffer segment (16bit), output text buffer index (16bit), output text buffer size (16bit), return addr (16bit)
;return value: ax (1 = copy successful / 0 = copy failed)
_str_copy:
	push word bp
	mov bp, sp

	;bp + 2 == return addr
	;bp + 4 == buffer out size
	;bp + 6 == buffer out index
	;bp + 8 == buffer out segment
	;bp + 10 == buffer in index
	;bp + 12 == buffer in segment

	sub sp, word 2

	;local var:
	;bp - 2 == copy size (16bit)

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4

	mov cx, word [ds:si]
	cmp cx, word 0
	je _str_copy_returnfalse

	add si, word 6
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	push word dx
	push word cx
	push word $
	jmp _str_getlength
	times RETURN_MARGIN_CALLER nop

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov cx, word [ds:si]

	cmp ax, cx
	jb _str_copy_l1

	dec cx
	mov ax, cx

	_str_copy_l1:
	mov si, bp
	sub si, word 2
	mov [ds:si], word ax

	cmp ax, word 0
	je _str_copy_returnfalse

	mov si, bp
	add si, word 6
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	mov es, dx
	mov di, cx

	add si, word 2
	mov cx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	mov ds, dx
	mov si, cx

	mov dx, ax
	xor cx, cx
	xor ax, ax

	_str_copy_loop:
	cmp cx, dx
	jae _str_copy_endloop
	mov al, byte [ds:si]
	mov [es:di], byte al
	inc si
	inc di
	inc cx
	jmp _str_copy_loop
	_str_copy_endloop:

	mov [es:di], byte 0

	_str_copy_returntrue:
	mov ax, word 1
	jmp _str_copy_return

	_str_copy_returnfalse:
	xor ax, ax

	_str_copy_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 12

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx


