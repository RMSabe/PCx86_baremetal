;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: delay runtime for a short period
;args (push order): delay value (16bit), return addr (16bit)
_delay_short:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 delay time

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	xor cx, cx

	_delay_short_loop:
	cmp cx, bx
	jae _delay_short_endloop
	inc cx
	jmp _delay_short_loop

	_delay_short_endloop:

	_delay_short_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 4

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: delay runtime for a long period
;args (push order): delay value (16bit), return addr (16bit)
_delay_long:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 delay time

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

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
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 4

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: delay runtime for a period
;WARNING: only compatible with i386 and above CPUs
;args (push order): delay value (32bit), return addr (16bit)
_delay32:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 delay time

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov ebx, dword [ds:si]

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

