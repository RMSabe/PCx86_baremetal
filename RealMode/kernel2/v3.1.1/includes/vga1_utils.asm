;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;VGA Mode 1 (320x200 256 colors)

VGA1_VRAM_SEG16 equ 0xa000
VGA1_VRAM_BASE32 equ (VGA1_VRAM_SEG16*0x10)

VGA1_VRAM_SIZE_BYTES equ 0xfa00
VGA1_VRAM_SIZE_PIXELS equ VGA1_VRAM_SIZE_BYTES

VGA1_WIDTH_BYTES equ 320
VGA1_WIDTH_PIXELS equ VGA1_WIDTH_BYTES

VGA1_HEIGHT_PIXELS equ (VGA1_VRAM_SIZE_PIXELS/VGA1_WIDTH_PIXELS)

;FUNCTION: initialize VGA Mode 1
;args (push order): return addr (16bit)
_vga1_init:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	mov ah, byte 0x0
	mov al, byte 0x13
	int 0x10

	_vga1_init_return:
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
_vga1_clearscreen:
	push word bp
	mov bp, sp

	;bp + 2 == arg0 return addr

	push word 0
	push word $
	jmp _vga1_paintscreen
	times RETURN_MARGIN_CALLER nop

	_vga1_clearscreen_return:
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
_vga1_paintscreen:
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

	mov bx, word VGA1_VRAM_SEG16
	mov es, bx
	mov di, word 0

	_vga1_paintscreen_loop:
	cmp di, word VGA1_VRAM_SIZE_BYTES
	jae _vga1_paintscreen_endloop
	mov [es:di], byte al
	inc di
	jmp _vga1_paintscreen_loop
	_vga1_paintscreen_endloop:

	_vga1_paintscreen_return:
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
_vga1_paintpixel:
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

	cmp bx, word VGA1_VRAM_SIZE_BYTES
	jae _vga1_paintpixel_return

	mov ax, word VGA1_VRAM_SEG16
	mov es, ax
	mov di, bx

	and cx, word 0xff

	mov [es:di], byte cl

	_vga1_paintpixel_return:
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
_vga1_getpixelcolor:
	push word bp
	mov bp, sp

	;bp + 2 == arg1 return addr
	;bp + 4 == arg0 pixel addr

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov bx, word [ds:si]

	cmp bx, word VGA1_VRAM_SIZE_BYTES
	jae _vga1_getpixelcolor_return

	mov ax, word VGA1_VRAM_SEG16
	mov es, ax
	mov di, bx

	xor ax, ax
	mov al, byte [es:di]

	_vga1_getpixelcolor_return:
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
_vga1_paintpixel_xy:
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

	cmp bx, word VGA1_HEIGHT_PIXELS
	jae _vga1_paintpixel_xy_return

	xor dx, dx
	mov ax, bx
	mov cx, word VGA1_WIDTH_BYTES
	mul word cx

	mov si, bp
	add si, word 6
	mov bx, word [ds:si]

	cmp bx, word VGA1_WIDTH_PIXELS
	jae _vga1_paintpixel_xy_return

	add ax, bx

	mov bx, word VGA1_VRAM_SEG16
	mov es, bx
	mov di, ax

	mov si, bp
	add si, word 8
	mov bx, word [ds:si]

	and bx, word 0xff

	mov [es:di], byte bl

	_vga1_paintpixel_xy_return:
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
_vga1_getpixelcolor_xy:
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

	cmp bx, word VGA1_HEIGHT_PIXELS
	jae _vga1_getpixelcolor_xy_return

	xor dx, dx
	mov ax, bx
	mov cx, word VGA1_WIDTH_BYTES
	mul word cx

	mov si, bp
	add si, word 6
	mov bx, word [ds:si]

	cmp bx, word VGA1_WIDTH_PIXELS
	jae _vga1_getpixelcolor_xy_return

	add ax, bx

	mov bx, word VGA1_VRAM_SEG16
	mov es, bx
	mov di, ax

	xor ax, ax
	mov al, byte [es:di]

	_vga1_getpixelcolor_xy_return:
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

