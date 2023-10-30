;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: delay runtime for a short period
;args (push order): delay value (16bit), return addr (16bit)
_delay_short:
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
	xor cx, cx

	_delay_short_loop:
	cmp cx, bx
	jae _delay_short_endloop
	inc cx
	jmp _delay_short_loop

	_delay_short_endloop:

	_delay_short_return:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _stacklist_index
	mov di, word _stacklist
	mov cx, word [ds:si]
	sub cx, word 2
	add di, cx
	mov bx, word [ds:di]
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: delay runtime for a long period
;args (push order): delay value (16bit), return addr (16bit)
_delay_long:
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
	xor cx, cx

	_delay_long_loopout:
	cmp cx, bx
	jae _delay_long_endloopout
	xor ax, ax
	_delay_long_loopin:
	cmp ax, word 0xffff
	je _delay_long_endloopin
	inc ax
	jmp _delay_long_loopin
	_delay_long_endloopin:
	inc cx
	jmp _delay_long_loopout
	_delay_long_endloopout:

	_delay_long_return:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _stacklist_index
	mov di, word _stacklist
	mov cx, word [ds:si]
	sub cx, word 2
	add di, cx
	mov bx, word [ds:di]
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: delay runtime for a period
;WARNING: only compatible with i386 and above CPUs
;args (push order): delay value (32bit), return addr (16bit)
_delay32:
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

	pop dword ebx
	xor ecx, ecx

	_delay32_loop:
	cmp ecx, ebx
	jae _delay32_endloop
	inc ecx
	jmp _delay32_loop
	_delay32_endloop:

	xor ebx, ebx
	xor ecx, ecx

	_delay32_return:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _stacklist_index
	mov di, word _stacklist
	mov cx, word [ds:si]
	sub cx, word 2
	add di, cx
	mov bx, word [ds:di]
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

