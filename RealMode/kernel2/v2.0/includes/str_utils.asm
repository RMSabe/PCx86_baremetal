;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: compare two text strings
;args (push order): input text1 buffer segment (16bit), input text1 buffer index (16bit), input text2 buffer segment (16bit), input text2 buffer index (16bit), return addr (16bit)
;return value: ax (1 = equal | 0 = not equal)
_compare_str:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _stacklist_index
	mov di, word _stacklist
	mov cx, word [ds:si]
	add di, cx
	pop word bx
	mov [ds:di], word bx
	add cx, word 2
	mov [ds:si], word cx

	pop word bx
	mov di, bx

	pop word bx
	mov es, bx

	pop word bx
	mov si, bx

	pop word bx
	mov ds, bx

	xor cx, cx
	xor dx, dx

	_compare_str_getlen1:
	mov al, byte [ds:si]
	cmp al, byte 0
	je _compare_str_gotlen1
	inc si
	inc cx
	jmp _compare_str_getlen1
	_compare_str_gotlen1:
	sub si, cx

	_compare_str_getlen2:
	mov al, byte [es:di]
	cmp al, byte 0
	je _compare_str_gotlen2
	inc di
	inc dx
	jmp _compare_str_getlen2
	_compare_str_gotlen2:
	sub di, dx

	cmp cx, dx
	jne _compare_str_returnfalse

	xor cx, cx
	_compare_str_loop:
	cmp cx, dx
	jae _compare_str_endloop
	mov al, byte [ds:si]
	mov bl, byte [es:di]
	cmp al, bl
	jne _compare_str_returnfalse
	inc si
	inc di
	inc cx
	jmp _compare_str_loop
	_compare_str_endloop:

	_compare_str_returntrue:
	mov ax, word 1
	jmp _compare_str_return

	_compare_str_returnfalse:
	xor ax, ax

	_compare_str_return:
	mov bx, word KERNEL_SEG16
	mov ds, bx
	mov si, word _stacklist_index
	mov di, word _stacklist
	mov cx, word [ds:si]
	sub cx, word 2
	add di, cx
	mov bx, word [ds:di]
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

