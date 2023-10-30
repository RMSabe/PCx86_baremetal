;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

VGA_WIDTH equ 320
VGA_HEIGHT equ 200

;FUNCTION: initialize VGA Mode
;args (push order): return addr (16bit)
_vga_init:
	mov ah, byte 0x0
	mov al, byte 0x13
	int 0x10

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: clear screen
;args (push order): return addr (16bit)
_vga_clearscreen:
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

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: paint screen on a given color
;args (push order): pixel color (16bit), return addr (16bit)
_vga_paintscreen:
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

	mov bx, word 0xa000
	mov es, bx
	mov di, word 0

	pop word ax
	and ax, word 0xff

	_vga_paintscreen_loop:
	cmp di, word 0xfa00
	jae _vga_paintscreen_endloop
	mov [es:di], byte al
	inc di
	jmp _vga_paintscreen_loop
	_vga_paintscreen_endloop:

	_vga_paintscreen_return:
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

;FUNCTION: paint a pixel of given color at given memory address
;args (push order): pixel color (16bit), pixel address (16bit), return addr (16bit)
_vga_paintpixel:
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
	cmp bx, word 0xfa00
	jae _vga_paintpixel_return

	mov ax, word 0xa000
	mov es, ax
	mov di, bx

	pop word bx
	and bx, word 0xff

	mov [es:di], byte bl

	_vga_paintpixel_return:
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

;FUNCTION: retrive current color for a pixel at given memory address
;args (push order): pixel address (16bit), return addr (16bit)
;return value: ax (pixel color)
_vga_getpixelcolor:
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
	cmp bx, word 0xfa00
	jae _vga_getpixelcolor_return

	mov ax, word 0xa000
	mov es, ax
	mov di, bx

	xor ax, ax
	mov al, byte [es:di]

	_vga_getpixelcolor_return:
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

;FUNCTION: paint pixel at given coordinates (x, y)
;args (push order): pixel color (16bit), pixel x position (16bit), pixel y position (16bit), return addr (16bit)
_vga_paintpixel_xy:
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
	cmp bx, word VGA_HEIGHT
	jae _vga_paintpixel_xy_return

	xor dx, dx
	mov ax, bx
	mov cx, word 0x140
	mul word cx

	pop word bx
	cmp bx, word VGA_WIDTH
	jae _vga_paintpixel_xy_return

	add ax, bx

	mov bx, word 0xa000
	mov es, bx
	mov di, ax

	pop word bx
	and bx, word 0xff

	mov [es:di], byte bl

	_vga_paintpixel_xy_return:
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

;FUNCTION: retrive current pixel color at given coordinates (x, y)
;args (push order): pixel x position (16bit), pixel y position (16bit), return addr (16bit)
;return value: ax (pixel color)
_vga_getpixelcolor_xy:
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
	cmp bx, word VGA_HEIGHT
	jae _vga_getpixelcolor_xy_return

	xor dx, dx
	mov ax, bx
	mov cx, word 0x140
	mul word cx

	pop word bx
	cmp bx, word VGA_WIDTH
	jae _vga_getpixelcolor_xy_return

	add ax, bx

	mov bx, word 0xa000
	mov es, bx
	mov di, ax

	xor ax, ax
	mov al, byte [es:di]

	_vga_getpixelcolor_xy_return:
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

