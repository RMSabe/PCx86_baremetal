P_CGA_NLINE16 equ 0x0
P_CGA_NCOLOR8 equ 0x2

CGA_COLOR_BLACK equ 0x0
CGA_COLOR_BLUE equ 0x1
CGA_COLOR_GREEN equ 0x2
CGA_COLOR_CYAN equ 0x3
CGA_COLOR_RED equ 0x4
CGA_COLOR_MAGENTA equ 0x5
CGA_COLOR_BROWN equ 0x6
CGA_COLOR_LTGRAY equ 0x7
CGA_COLOR_DKGRAY equ 0x8
CGA_COLOR_LTBLUE equ 0x9
CGA_COLOR_LTGREEN equ 0xa
CGA_COLOR_LTCYAN equ 0xb
CGA_COLOR_LTRED equ 0xc
CGA_COLOR_LTMAGENTA equ 0xd
CGA_COLOR_YELLOW equ 0xe
CGA_COLOR_WHITE equ 0xf

CGA_COLOR_DEFAULT equ CGA_COLOR_LTGRAY

;FUNCTION: initializes CGA Mode
;args (push order): return addr (16bit)
cga_init:
	mov ah, byte 0x0
	mov al, byte 0x3
	int 0x10

	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NLINE16
	mov [ds:si], word 0x0
	mov si, word P_CGA_NCOLOR8
	mov [ds:si], byte CGA_COLOR_DEFAULT

	pop bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: clear screen in CGA Mode
;args (push order): return addr (16bit)
cga_clearscreen:
	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NLINE16
	mov [ds:si], word 0x0

	mov ax, word 0xb800
	mov es, ax
	mov di, word 0x0

	cga_clearscreen_loop:
	cmp di, word 0xfa0
	jae cga_clearscreen_end
	mov [es:di], word 0x0
	add di, word 0x2
	jmp cga_clearscreen_loop
	cga_clearscreen_end:

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text position
;args (push order): character position (16bit), line number (16bit), return addr (16bit)
cga_settextpos:
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

	xor dx, dx
	pop word ax
	and ax, word 0xff
	mov cx, word 0xa0
	mul word cx

	pop word bx
	and bx, word 0xff

	add ax, bx

	mov bx, word DATA0_SEG16
	mov ds, bx
	mov si, word P_CGA_NLINE16
	mov [ds:si], word ax

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

;FUNCTION: get text position
;args (push order): return addr (16bit)
;return value: ax (high byte = line number | low byte = character position)
cga_gettextpos:
	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NLINE16
	mov bx, word [ds:si]
	
	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	div word cx

	shl ax, 8
	and dx, word 0xff
	or ax, dx

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get text character position
;args (push order): return addr (16bit)
;return value: al
cga_gettextpos_x:
	mov bx, word $
	push word bx
	jmp cga_gettextpos
	times RETURN_MARGIN_CALLER nop

	and ax, word 0xff

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get text line position
;args (push order): return addr (16bit)
;return value: al
cga_gettextpos_y:
	mov bx, word $
	push word bx
	jmp cga_gettextpos
	times RETURN_MARGIN_CALLER nop

	shr ax, 8

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text color
;args (push order): text color (16bit), background color (16bit), return addr (16bit)
cga_setcolor:
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
	shl bx, 4
	pop word cx
	and cx, word 0xf
	or bx, cx

	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NCOLOR8
	mov [ds:si], byte bl

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

;FUNCTION: get text color
;args (push order): return addr (16bit)
;return value: al (high 4 bits = background color | low 4 bits = text color)
cga_getcolor:
	mov bx, word DATA0_SEG16
	mov ds, bx
	mov si, word P_CGA_NCOLOR8

	xor ax, ax
	mov al, byte [ds:si]

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get text foreground color
;args (push order): return addr (16bit)
;return value: al
cga_getcolor_text:
	mov bx, word $
	push word bx
	jmp cga_getcolor
	times RETURN_MARGIN_CALLER nop

	and ax, word 0xf

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get text background color
;args (push order): return addr (16bit)
;return value: al
cga_getcolor_background:
	mov bx, word $
	push word bx
	jmp cga_getcolor
	times RETURN_MARGIN_CALLER nop

	shr ax, 4

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: add a new line
;args (push order): return addr (16bit)
cga_newline:
	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NLINE16
	mov bx, word [ds:si]

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	div word cx

	sub bx, dx
	add bx, word 0xa0

	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NLINE16
	mov [ds:si], word bx

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: print text in CGA Mode
;args (push order): input text segment (16bit), input text index (16bit), return addr (16bit)
cga_print:
	mov ax, word STACKLIST_SEG16
	mov ds, ax
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	mov si, cx
	pop word bx
	mov [ds:si], word bx
	add si, word 0x2
	pop word bx
	mov [ds:si], word bx
	add si, word 0x2
	pop word bx
	mov [ds:si], word bx
	add cx, word 0x6
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NLINE16
	mov cx, word [ds:si]
	cmp cx, word 0xfa0
	jb cga_print_noreset

	cga_print_reset:
	mov bx, word $
	push word bx
	jmp cga_clearscreen
	times RETURN_MARGIN_CALLER nop

	cga_print_noreset:

	mov ax, word STACKLIST_SEG16
	mov es, ax
	mov di, word P_STACKLIST_INDEX16
	mov cx, word [es:di]
	mov di, cx
	sub di, word 0x2
	mov bx, word [es:di]
	mov ds, bx
	sub di, word 0x2
	mov bx, word [es:di]
	mov si, bx
	sub cx, word 0x4
	mov di, word P_STACKLIST_INDEX16
	mov [es:di], word cx

	mov dx, word DATA0_SEG16
	mov es, dx
	mov di, word P_CGA_NCOLOR8
	mov ah, byte [es:di]

	mov di, word P_CGA_NLINE16
	mov bx, word [es:di]
	mov di, bx

	mov dx, word 0xb800
	mov es, dx

	cga_print_loop:
	mov al, byte [ds:si]
	cmp al, byte 0x0
	je cga_print_end
	mov [es:di], word ax
	inc si
	add di, word 0x2
	jmp cga_print_loop
	cga_print_end:
	mov bx, di
	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NLINE16
	mov [ds:si], word bx
	
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

;FUNCTION: print text with new line at the end
;args (push order): input text segment (16bit), input text index (16bit), return addr (16bit)
cga_println:
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

	mov bx, word $
	push word bx
	jmp cga_print
	times RETURN_MARGIN_CALLER nop

	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NLINE16
	mov bx, word [ds:si]

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	div word cx

	sub bx, dx
	add bx, word 0xa0

	mov ax, word DATA0_SEG16
	mov ds, ax
	mov si, word P_CGA_NLINE16
	mov [ds:si], word bx

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

