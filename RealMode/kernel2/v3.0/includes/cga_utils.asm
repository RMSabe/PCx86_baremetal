;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

CGA_COLOR_BLACK equ 0x0
CGA_COLOR_BLUE equ 0x1
CGA_COLOR_GREEN equ 0x2
CGA_COLOR_CYAN equ 0x3
CGA_COLOR_RED equ 0x4
CGA_COLOR_MAGENTA equ 0x5
CGA_COLOR_BROWN equ 0x6
CGA_COLOR_LTGRAY equ 0x7

CGA_TEXTCOLOR_BLACK equ CGA_COLOR_BLACK
CGA_TEXTCOLOR_BLUE equ CGA_COLOR_BLUE
CGA_TEXTCOLOR_GREEN equ CGA_COLOR_GREEN
CGA_TEXTCOLOR_CYAN equ CGA_COLOR_CYAN
CGA_TEXTCOLOR_RED equ CGA_COLOR_RED
CGA_TEXTCOLOR_MAGENTA equ CGA_COLOR_MAGENTA
CGA_TEXTCOLOR_BROWN equ CGA_COLOR_BROWN
CGA_TEXTCOLOR_LTGRAY equ CGA_COLOR_LTGRAY
CGA_TEXTCOLOR_DKGRAY equ 0x8
CGA_TEXTCOLOR_LTBLUE equ 0x9
CGA_TEXTCOLOR_LTGREEN equ 0xa
CGA_TEXTCOLOR_LTCYAN equ 0xb
CGA_TEXTCOLOR_LTRED equ 0xc
CGA_TEXTCOLOR_LTMAGENTA equ 0xd
CGA_TEXTCOLOR_YELLOW equ 0xe
CGA_TEXTCOLOR_WHITE equ 0xf

CGA_BKCOLOR_BLACK equ CGA_COLOR_BLACK
CGA_BKCOLOR_BLUE equ CGA_COLOR_BLUE
CGA_BKCOLOR_GREEN equ CGA_COLOR_GREEN
CGA_BKCOLOR_CYAN equ CGA_COLOR_CYAN
CGA_BKCOLOR_RED equ CGA_COLOR_RED
CGA_BKCOLOR_MAGENTA equ CGA_COLOR_MAGENTA
CGA_BKCOLOR_BROWN equ CGA_COLOR_BROWN
CGA_BKCOLOR_LTGRAY equ CGA_COLOR_LTGRAY

CGA_TEXTCOLOR_DEFAULT equ CGA_TEXTCOLOR_LTGRAY
CGA_BKCOLOR_DEFAULT equ CGA_BKCOLOR_BLACK

CGA_NCHARS equ 80
CGA_NLINES equ 25

;FUNCTION: initializes CGA Mode
;args (push order): return addr (16bit)
_cga_init:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ah, byte 0x0
	mov al, byte 0x3
	int 0x10

	xor ax, ax
	mov al, byte CGA_BKCOLOR_DEFAULT
	shl al, 4
	or al, byte CGA_TEXTCOLOR_DEFAULT

	mov bx, word KERNEL_SEG16
	mov ds, bx

	mov si, word _cga_ncolor
	mov [ds:si], byte al

	_cga_init_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: clear screen in CGA Mode
;args (push order): return addr (16bit)
_cga_clearscreen:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_npos
	mov [ds:si], word 0x0

	mov ax, word 0xb800
	mov es, ax
	mov di, word 0x0

	_cga_clearscreen_loop:
	cmp di, word 0xfa0
	jae _cga_clearscreen_endloop
	mov [es:di], word 0x0
	add di, word 0x2
	jmp _cga_clearscreen_loop
	_cga_clearscreen_endloop:

	_cga_clearscreen_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text position
;args (push order): character position (16bit), line number (16bit), return addr (16bit)
_cga_settextpos:
	push word bp
	mov bp, sp

	;bp + 2 == arg2 return addr
	;bp + 4 == arg1 line number
	;bp + 6 == arg0 character position

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	cmp bx, word CGA_NLINES
	jae _cga_settextpos_return

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	mul word cx

	mov si, bp
	add si, word 6
	mov bx, word [ds:si]

	cmp bx, word CGA_NCHARS
	jae _cga_settextpos_return

	shl bx, 1
	add ax, bx

	mov bx, word KERNEL_SEG16
	mov es, bx

	mov di, word _cga_npos
	mov [es:di], word ax

	_cga_settextpos_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get current text position
;args (push order): return addr (16bit)
;return value: ax (ah = line number | al = character position)
_cga_gettextpos:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_npos
	mov bx, word [ds:si]

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	div word cx

	shr dx, 1
	and dx, word 0xff

	shl ax, 8
	or ax, dx

	_cga_gettextpos_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text character position
;args (push order): character position (16bit), return addr (16bit)
_cga_settextpos_x:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 character position

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_npos

	mov bx, word [es:di]

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	div word cx

	sub bx, dx

	mov ax, word STACK_SEG16
	mov ds, ax
	mov si, bp
	add si, word 4
	mov ax, word [ds:si]

	cmp ax, word CGA_NCHARS
	jae _cga_settextpos_x_return

	shl ax, 1
	add bx, ax

	mov [es:di], word bx

	_cga_settextpos_x_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get text character position
;args (push order): return addr (16bit)
;return value: ax (character position)
_cga_gettextpos_x:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_npos
	mov ax, word [ds:si]

	xor dx, dx
	mov cx, word 0xa0
	div word cx

	shr dx, 1
	mov ax, dx

	_cga_gettextpos_x_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text line position
;args (push order): text line position (16bit), return addr (16bit)
_cga_settextpos_y:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 text line position

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	cmp bx, word CGA_NLINES
	jae _cga_settextpos_y_return

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	mul word cx

	mov bx, ax

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_npos
	mov ax, word [es:di]

	xor dx, dx
	mov cx, word 0xa0
	div word cx

	add bx, dx

	mov [es:di], word bx

	_cga_settextpos_y_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get text line position
;args (push order): return addr (16bit)
;return value: ax (line position)
_cga_gettextpos_y:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_npos
	mov ax, word [ds:si]

	xor dx, dx
	mov cx, word 0xa0
	div word cx

	_cga_gettextpos_y_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set position word value
;args (push order): position word value (16bit), return addr (16bit)
_cga_setposword:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 position word value

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	cmp bx, word 0xfa0
	jae _cga_setposword_return

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_npos

	mov [es:di], word bx

	_cga_setposword_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get position word value
;args (push order): return addr (16bit)
;return value: ax (position word value)
_cga_getposword:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_npos

	mov ax, word [ds:si]

	_cga_getposword_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text color
;args (push order): text color (16bit), background color (16bit), return addr (16bit)
_cga_setcolor:
	push word bp
	mov bp, sp

	;bp + 2 == arg2 return addr
	;bp + 4 == arg1 bk color
	;bp + 6 == arg0 text color

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]
	add si, word 2
	mov cx, word [ds:si]

	and bx, word 0x7
	and cx, word 0xf

	shl bl, 4
	or bl, cl

	mov ax, KERNEL_SEG16
	mov es, ax
	mov di, word _cga_ncolor

	xor ax, ax
	mov al, byte [es:di]
	and al, byte 0x80
	or al, bl

	mov [es:di], byte al

	_cga_setcolor_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get text color
;args (push order): return addr (16bit)
;return value: ax (ah = background color | al = text color)
_cga_getcolor:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_ncolor

	xor ax, ax
	xor bx, bx

	mov al, byte [ds:si]
	mov bl, al

	and al, byte 0xf
	shr bl, 4
	and bl, byte 0x7

	mov ah, bl

	_cga_getcolor_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text foreground color
;args (push order): text color (16bit), return addr (16bit)
_cga_settextcolor:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 text color

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	and bx, word 0xf

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_ncolor

	xor ax, ax
	mov al, byte [es:di]

	and al, byte 0xf0
	or al, bl

	mov [es:di], byte al

	_cga_settextcolor_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get text foreground color
;args (push order): return addr (16bit)
;return value: ax (text color)
_cga_gettextcolor:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_ncolor

	xor ax, ax

	mov al, byte [ds:si]
	and ax, word 0xf

	_cga_gettextcolor_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text background color
;args (push order): background color (16bit), return addr (16bit)
_cga_setbkcolor:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 bk color

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	and bx, word 0x7

	shl bl, 4

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_ncolor

	xor ax, ax
	mov al, byte [es:di]

	and al, byte 0x8f
	or al, bl

	mov [es:di], byte al

	_cga_setbkcolor_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get text background color
;args (push order): return addr (16bit)
;return value: ax (background color)
_cga_getbkcolor:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_ncolor

	xor ax, ax
	mov al, byte [ds:si]

	shr al, 4
	and ax, word 0x7

	_cga_getbkcolor_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set color byte value
;args (push order): color byte value (16bit), return addr (16bit)
_cga_setcolorbyte:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 color byte value

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	and bx, word 0xff

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_ncolor

	mov [es:di], byte bl

	_cga_setcolorbyte_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get color byte value
;args (push order): return addr (16bit)
;return value: ax (color byte value)
_cga_getcolorbyte:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_ncolor

	xor ax, ax
	mov al, byte [ds:si]

	_cga_getcolorbyte_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: enable/disable text blink
;WARNING: does not affect previously written text
;args (push order): enable bool value (1 = enable | 0 = disable) (16bit), return addr (16bit)
_cga_setblinkenable:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 bool enable

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_ncolor

	xor ax, ax
	mov al, byte [es:di]

	test bx, word 0xffff
	jz _cga_setblinkenable_disable

	_cga_setblinkenable_enable:
	or al, byte 0x80
	jmp _cga_setblinkenable_l1

	_cga_setblinkenable_disable:
	and al, byte 0x7f

	_cga_setblinkenable_l1:
	mov [es:di], byte al

	_cga_setblinkenable_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: get current blink enabled status
;args (push order): return addr (16bit)
;return value: ax (1 = blink is enabled | 0 = blink is disabled)
_cga_getblinkenable:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_ncolor

	xor ax, ax
	mov al, byte [ds:si]

	test al, byte 0x80
	jz _cga_getblinkenable_returnfalse

	_cga_getblinkenable_returntrue:
	mov ax, word 1
	jmp _cga_getblinkenable_return

	_cga_getblinkenable_returnfalse:
	xor ax, ax

	_cga_getblinkenable_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: add a new line
;args (push order): return addr (16bit)
_cga_addnewline:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_npos

	mov bx, word [es:di]

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	div word cx

	sub bx, dx
	add bx, word 0xa0

	mov [es:di], word bx

	_cga_addnewline_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: print text
;args (push order): input text buffer segment (16bit), input text buffer index (16bit), return addr (16bit)
_cga_printtext:
	push word bp
	mov bp, sp

	;bp + 2 == arg2 return addr
	;bp + 4 == arg1 text index
	;bp + 6 == arg0 text segment

	mov ax, KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_npos
	mov cx, word [ds:si]
	cmp cx, word 0xfa0
	jb _cga_printtext_noclear

	_cga_printtext_clear:
	push word $
	jmp _cga_clearscreen
	times RETURN_MARGIN_CALLER nop
	add sp, word 2
	xor cx, cx

	_cga_printtext_noclear:
	mov bx, word 0xb800
	mov es, bx
	mov di, cx

	mov bx, word KERNEL_SEG16
	mov ds, bx
	mov si, word _cga_ncolor

	mov ah, byte [ds:si]

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]
	add si, word 2
	mov dx, word [ds:si]

	mov si, bx
	mov ds, dx

	_cga_printtext_loop:
	mov al, byte [ds:si]
	cmp al, byte 0
	je _cga_printtext_endloop
	mov [es:di], word ax
	inc si
	add di, word 2
	jmp _cga_printtext_loop
	_cga_printtext_endloop:

	mov bx, word KERNEL_SEG16
	mov ds, bx
	mov si, word _cga_npos

	mov [ds:si], word di

	_cga_printtext_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: print text, add new line
;args (push order): input text buffer segment (16bit), input text buffer index (16bit), return addr (16bit)
_cga_printtextln:
	push word bp
	mov bp, sp

	;bp + 2 == arg2 return addr
	;bp + 4 == arg1 text index
	;bp + 6 == arg0 text segment

	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]
	add si, word 2
	mov cx, word [ds:si]

	push word cx
	push word bx
	push word $
	jmp _cga_printtext
	times RETURN_MARGIN_CALLER nop
	add sp, word 6

	push word $
	jmp _cga_addnewline
	times RETURN_MARGIN_CALLER nop
	add sp, word 2

	_cga_printtextln_return:
	mov bx, word STACK_SEG16
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

_cga_npos: dw 0x0
_cga_ncolor: db 0x0

