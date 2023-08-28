;FUNCTION: loads an unsigned 16bit integer value into a text buffer
;args (push order): input value (16bit), output text buffer segment (16bit), output text buffer index (16bit), return addr (16bit)
loadstr_dec_u16:
	mov ax, word STACKLIST_SEG16
	mov ds, ax
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	mov si, cx
	pop word bx
	mov [ds:si], word bx
	add cx, word 0x2
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	pop word bx
	mov di, bx
	pop word bx
	mov es, bx

	pop word bx

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
	inc di

	mov ax, word STACKLIST_SEG16
	mov ds, ax
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	sub cx, word 0x2
	mov si, cx
	mov bx, word [ds:si]
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: loads signed 16bit integer into text buffer
;args (push order): input value (16bit), output text buffer segment (16bit), output text buffer index (16bit), return addr (16bit)
loadstr_dec_s16:
	mov ax, word STACKLIST_SEG16
	mov ds, ax
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	mov si, cx
	pop word bx
	mov [ds:si], word bx
	add cx, word 0x2
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	pop word bx
	mov di, bx
	pop word bx
	mov es, bx

	pop word bx
	test bx, word 0x8000
	jz loadstr_dec_s16_pos

	loadstr_dec_s16_neg:
	mov [es:di], byte 0x2d
	inc di
	not bx
	inc bx

	loadstr_dec_s16_pos:

	push word bx
	mov bx, es
	push word bx
	push word di
	mov bx, word $
	push word bx
	jmp loadstr_dec_u16
	times RETURN_MARGIN_CALLER nop

	mov ax, word STACKLIST_SEG16
	mov ds, ax
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	sub cx, word 0x2
	mov si, cx
	mov bx, word [ds:si]
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: hold for short period
;args (push order): delay time (16bit), return addr (16bit)
hold_short:
	mov ax, word STACKLIST_SEG16
	mov ds, ax
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	mov si, cx
	pop word bx
	mov [ds:si], word bx
	add cx, word 0x2
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	pop word bx
	xor cx, cx
	hold_short_loop:
	cmp cx, bx
	jae hold_short_end
	inc cx
	jmp hold_short_loop
	hold_short_end:

	mov ax, word STACKLIST_SEG16
	mov ds, ax
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	sub cx, word 0x2
	mov si, cx
	mov bx, word [ds:si]
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: hold for long period
;args (push order): delay time (16bit), return addr (16bit)
hold_long:
	mov ax, word STACKLIST_SEG16
	mov ds, ax
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	mov si, cx
	pop word bx
	mov [ds:si], word bx
	add cx, word 0x2
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	pop word bx
	xor cx, cx
	hold_long_out_loop:
	cmp cx, bx
	jae hold_long_out_end
	xor ax, ax
	hold_long_in_loop:
	cmp ax, word 0xffff
	je hold_long_in_end
	inc ax
	jmp hold_long_in_loop
	hold_long_in_end:
	inc cx
	jmp hold_long_out_loop
	hold_long_out_end:

	mov ax, word STACKLIST_SEG16
	mov ds, ax
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	sub cx, word 0x2
	mov si, cx
	mov bx, word [ds:si]
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

