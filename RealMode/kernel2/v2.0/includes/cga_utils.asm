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

	pop bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: clear screen in CGA Mode
;args (push order): return addr (16bit)
_cga_clearscreen:
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

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text position
;args (push order): character position (16bit), line number (16bit), return addr (16bit)
_cga_settextpos:
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
	cmp bx, word CGA_NLINES
	jae _cga_settextpos_return

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	mul word cx

	pop word bx
	cmp bx, word CGA_NCHARS
	jae _cga_settextpos_return

	shl bx, 1
	add ax, bx

	mov bx, word KERNEL_SEG16
	mov es, bx

	mov di, word _cga_npos
	mov [es:di], word ax

	_cga_settextpos_return:
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

;FUNCTION: get current text position
;args (push order): return addr (16bit)
;return value: ax (ah = line number | al = character position)
_cga_gettextpos:
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
	mov al, dl

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text character position
;args (push order): character position (16bit), return addr (16bit)
_cga_settextpos_x:
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

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_npos

	mov bx, word [es:di]

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	div word cx

	sub bx, dx

	pop word dx
	cmp dx, word CGA_NCHARS
	jae _cga_settextpos_x_return

	shl dx, 1

	add bx, dx

	mov [es:di], word bx

	_cga_settextpos_x_return:
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

;FUNCTION: get text character position
;args (push order): return addr (16bit)
;return value: ax (character position)
_cga_gettextpos_x:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_npos
	mov ax, word [ds:si]

	xor dx, dx
	mov cx, word 0xa0
	div word cx

	shr dx, 1
	mov ax, dx

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text line position
;args (push order): text line position (16bit), return addr (16bit)
_cga_settextpos_y:
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

;FUNCTION: get text line position
;args (push order): return addr (16bit)
;return value: ax (line position)
_cga_gettextpos_y:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_npos
	mov ax, word [ds:si]

	xor dx, dx
	mov cx, word 0xa0
	div word cx

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set position word value
;args (push order): position word value (16bit), return addr (16bit)
_cga_setposword:
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

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_npos

	mov [es:di], word bx

	_cga_setposword_return:
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

;FUNCTION: get position word value
;args (push order): return addr (16bit)
;return value: ax (position word value)
_cga_getposword:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_npos

	mov ax, word [ds:si]

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text color
;args (push order): text color (16bit), background color (16bit), return addr (16bit)
_cga_setcolor:
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
	and bx, word 0x7

	pop word cx
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

;FUNCTION: get text color
;args (push order): return addr (16bit)
;return value: ax (ah = background color | al = text color)
_cga_getcolor:
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

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text foreground color
;args (push order): text color (16bit), return addr (16bit)
_cga_settextcolor:
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

;FUNCTION: get text foreground color
;args (push order): return addr (16bit)
;return value: ax (text color)
_cga_gettextcolor:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_ncolor

	xor ax, ax

	mov al, byte [ds:si]
	and ax, word 0xf

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set text background color
;args (push order): background color (16bit), return addr (16bit)
_cga_setbkcolor:
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

;FUNCTION: get text background color
;args (push order): return addr (16bit)
;return value: ax (background color)
_cga_getbkcolor:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_ncolor

	xor ax, ax
	mov al, byte [ds:si]

	shr al, 4
	and ax, word 0x7

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: set color byte value
;args (push order): color byte value (16bit), return addr (16bit)
_cga_setcolorbyte:
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
	and bx, word 0xff

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_ncolor

	mov [es:di], byte bl

	_cga_setcolorbyte_return:
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

;FUNCTION: get color byte value
;args (push order): return addr (16bit)
;return value: ax (color byte value)
_cga_getcolorbyte:
	mov ax, word KERNEL_SEG16
	mov ds, ax
	mov si, word _cga_ncolor

	xor ax, ax
	mov al, byte [ds:si]

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: enable/disable text blink
;WARNING: does not affect previously written text
;args (push order): enable value (1 = enable | 0 = disable) (16bit), return addr (16bit)
_cga_setblinkenable:
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

	mov ax, word KERNEL_SEG16
	mov es, ax
	mov di, word _cga_ncolor

	xor ax, ax
	mov al, byte [es:di]

	pop word bx
	test bx, word 0xffff
	jz _cga_setblinkenable_disable

	_cga_setblinkenable_enable:
	or al, byte 0x80
	mov [es:di], byte al
	jmp _cga_setblinkenable_return

	_cga_setblinkenable_disable:
	and al, byte 0x7f
	mov [es:di], byte al

	_cga_setblinkenable_return:
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

;FUNCTION: get current blink enabled status
;args (push order): return addr (16bit)
;return value: ax (1 = blink is enabled | 0 = blink is disabled)
_cga_getblinkenable:
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
	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: add a new line
;args (push order): return addr (16bit)
_cga_addnewline:
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

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: print text
;args (push order): input text buffer segment (16bit), input text buffer index (16bit), return addr (16bit)
_cga_printtext:
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
	xor cx, cx

	_cga_printtext_noclear:
	mov bx, word 0xb800
	mov es, bx
	mov di, cx

	mov bx, word KERNEL_SEG16
	mov ds, bx
	mov si, word _cga_ncolor

	mov ah, byte [ds:si]

	pop word bx
	mov si, bx

	pop word bx
	mov ds, bx

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

;FUNCTION: print text, add new line
;args (push order): input text buffer segment (16bit), input text buffer index (16bit), return addr (16bit)
_cga_printtextln:
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

	push word $
	jmp _cga_printtext
	times RETURN_MARGIN_CALLER nop

	push word $
	jmp _cga_addnewline
	times RETURN_MARGIN_CALLER nop

	_cga_printtextln_return:
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

_cga_npos: dw 0x0
_cga_ncolor: db 0x0

