;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

VGA_WIDTH equ 320
VGA_HEIGHT equ 200

;FUNCTION: initialize VGA Mode
;args (push order): return addr (16bit)
_vga_init:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ah, byte 0x0
	mov al, byte 0x13
	int 0x10

	_vga_init_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 2

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: clear screen
;args (push order): return addr (16bit)
_vga_clearscreen:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ax, word 0xa000
	mov es, ax
	mov di, word 0x0

	_vga_clearscreen_loop:
	cmp di, word 0xfa00
	jae _vga_clearscreen_endloop
	mov [es:di], byte 0x0
	inc di
	jmp _vga_clearscreen_loop
	_vga_clearscreen_endloop:

	_vga_clearscreen_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 2

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: paint screen on a given color
;args (push order): pixel color (16bit), return addr (16bit)
_vga_paintscreen:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 pixel color

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov ax, word [ds:si]

	and ax, word 0xff

	mov bx, word 0xa000
	mov es, bx
	mov di, word 0

	_vga_paintscreen_loop:
	cmp di, word 0xfa00
	jae _vga_paintscreen_endloop
	mov [es:di], byte al
	inc di
	jmp _vga_paintscreen_loop
	_vga_paintscreen_endloop:

	_vga_paintscreen_return:
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

;FUNCTION: paint a pixel of given color at given memory address
;args (push order): pixel color (16bit), pixel address (16bit), return addr (16bit)
_vga_paintpixel:
	push word bp
	mov bp, sp

	;bp + 2 == arg2 return addr
	;bp + 4 == arg1 pixel addr
	;bp + 6 == arg0 pixel color

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]
	add si, word 2
	mov cx, word [ds:si]

	cmp bx, word 0xfa00
	jae _vga_paintpixel_return

	mov ax, word 0xa000
	mov es, ax
	mov di, bx

	and cx, word 0xff

	mov [es:di], byte cl

	_vga_paintpixel_return:
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

;FUNCTION: retrive current color for a pixel at given memory address
;args (push order): pixel address (16bit), return addr (16bit)
;return value: ax (pixel color)
_vga_getpixelcolor:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 pixel addr

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	cmp bx, word 0xfa00
	jae _vga_getpixelcolor_return

	mov ax, word 0xa000
	mov es, ax
	mov di, bx

	xor ax, ax
	mov al, byte [es:di]

	_vga_getpixelcolor_return:
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

;FUNCTION: paint pixel at given coordinates (x, y)
;args (push order): pixel color (16bit), pixel x position (16bit), pixel y position (16bit), return addr (16bit)
_vga_paintpixel_xy:
	push word bp
	mov bp, sp

	;bp + 2 == arg3 return addr
	;bp + 4 == arg2 pixel y pos
	;bp + 6 == arg1 pixel x pos
	;bp + 8 == arg0 pixel color

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	cmp bx, word VGA_HEIGHT
	jae _vga_paintpixel_xy_return

	xor dx, dx
	mov ax, bx
	mov cx, word 0x140
	mul word cx

	mov si, bp
	add si, word 6
	mov bx, word [ds:si]

	cmp bx, word VGA_WIDTH
	jae _vga_paintpixel_xy_return

	add ax, bx

	mov bx, word 0xa000
	mov es, bx
	mov di, ax

	mov si, bp
	add si, word 8
	mov bx, word [ds:si]

	and bx, word 0xff

	mov [es:di], byte bl

	_vga_paintpixel_xy_return:
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

;FUNCTION: retrive current pixel color at given coordinates (x, y)
;args (push order): pixel x position (16bit), pixel y position (16bit), return addr (16bit)
;return value: ax (pixel color)
_vga_getpixelcolor_xy:
	push word bp
	mov bp, sp

	;bp + 2 == arg2 return addr
	;bp + 4 == arg1 pixel y pos
	;bp + 6 == arg0 pixel x pos

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	cmp bx, word VGA_HEIGHT
	jae _vga_getpixelcolor_xy_return

	xor dx, dx
	mov ax, bx
	mov cx, word 0x140
	mul word cx

	mov si, bp
	add si, word 6
	mov bx, word [ds:si]

	cmp bx, word VGA_WIDTH
	jae _vga_getpixelcolor_xy_return

	add ax, bx

	mov bx, word 0xa000
	mov es, bx
	mov di, ax

	xor ax, ax
	mov al, byte [es:di]

	_vga_getpixelcolor_xy_return:
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

