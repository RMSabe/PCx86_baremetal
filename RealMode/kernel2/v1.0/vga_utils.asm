;FUNCTION: initialize VGA Mode
;args (push order): return addr (16bit)
vga_init:
	mov ah, byte 0x0
	mov al, byte 0x13
	int 0x10

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: clear screen in VGA Mode
;args (push order): return addr (16bit)
vga_clearscreen:
	mov ax, word 0xa000
	mov es, ax
	mov di, word 0x0

	vga_clearscreen_loop:
	cmp di, word 0xfa00
	jae vga_clearscreen_end
	mov [es:di], byte 0x0
	inc di
	jmp vga_clearscreen_loop
	vga_clearscreen_end:

	pop word bx
	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: paint a pixel of given color at given memory address
;args (push order): pixel color (16bit), pixel address (16bit), return addr (16bit)
vga_paintpixel:
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
	cmp bx, word 0xfa00
	jae vga_paintpixel_return

	mov ax, word 0xa000
	mov es, ax
	mov di, bx

	pop word bx
	and bx, word 0xff

	mov [es:di], byte bl

	vga_paintpixel_return:

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

;FUNCTION: retrive current color for a pixel at given memory address
;args (push order): pixel address (16bit), return addr (16bit)
;return value: al
vga_getpixelcolor:
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
	cmp bx, word 0xfa00
	jae vga_getpixelcolor_return

	mov ax, word 0xa000
	mov es, ax
	mov di, bx

	xor ax, ax
	mov al, byte [es:di]

	vga_getpixelcolor_return:

	mov dx, word STACKLIST_SEG16
	mov ds, dx
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	sub cx, word 0x2
	mov si, cx
	mov bx, word [ds:si]
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

;FUNCTION: paint pixel at given coordinates (x, y)
;args (push order): pixel color (16bit), pixel x position (16bit), pixel y position (16bit), return addr (16bit)
vga_paintpixel_xy:
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
	cmp bx, word 200
	jae vga_paintpixel_xy_return

	xor dx, dx
	mov ax, bx
	mov cx, word 0x140
	mul word cx

	pop word bx
	cmp bx, word 320
	jae vga_paintpixel_xy_return

	add ax, bx

	mov bx, word 0xa000
	mov es, bx
	mov di, ax

	pop word bx
	mov [es:di], byte bl

	vga_paintpixel_xy_return:

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

;FUNCTION: retrive current pixel color at given coordinates (x, y)
;args (push order): pixel x position (16bit), pixel y position (16bit), return addr (16bit)
;return value: al
vga_getpixelcolor_xy:
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
	cmp bx, word 200
	jae vga_getpixelcolor_xy_return

	xor dx, dx
	mov ax, bx
	mov cx, word 0x140
	mul word cx

	pop word bx
	cmp bx, word 320
	jae vga_getpixelcolor_xy_return

	add ax, bx

	mov bx, word 0xa000
	mov es, bx
	mov di, ax

	xor ax, ax
	mov al, byte [es:di]

	vga_getpixelcolor_xy_return:

	mov dx, word STACKLIST_SEG16
	mov ds, dx
	mov si, word P_STACKLIST_INDEX16
	mov cx, word [ds:si]
	sub cx, word 0x2
	mov si, cx
	mov bx, word [ds:si]
	mov si, word P_STACKLIST_INDEX16
	mov [ds:si], word cx

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

