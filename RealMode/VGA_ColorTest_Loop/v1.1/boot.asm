;VGA Color Test Loop 1.1

org 0x7c00
bits 16

mov ax, word 0x0
mov ss, ax
mov ds, ax

mov bp, word 0x7c00
mov sp, bp

mov ax, word 0xa000
mov es, ax
mov di, word 0x0

mov ah, byte 0x0
mov al, byte 0x13
int 0x10

NPIXEL_ADDR equ 0x7e00
NCOLOR_ADDR equ 0x7e02

mov [ds:NPIXEL_ADDR], word 0x0
mov [ds:NCOLOR_ADDR], byte 0x0

HOLDTIME equ 0x01000000

sysloop:
	mov sp, bp
	mov bx, word $
	push word bx
	jmp drawline
	times 8 nop
	cmp cx, word 0xfa00
	mov sp, bp
	mov bx, word $
	push word bx
	jae resetnpixel
	times 8 nop
	mov [ds:NPIXEL_ADDR], word cx
	mov al, byte [ds:NCOLOR_ADDR]
	inc al
	mov [ds:NCOLOR_ADDR], byte al
	mov sp, bp
	mov bx, word $
	push word bx
	jmp hold
	times 8 nop
	jmp sysloop

drawline:
	mov cx, word [ds:NPIXEL_ADDR]
	mov di, cx
	add cx, word 0x140
	mov al, byte [ds:NCOLOR_ADDR]
	drawlineloop:
	cmp cx, di
	jbe drawlineend
	mov [es:di], byte al
	inc di
	jmp drawlineloop
	drawlineend:
	pop word bx
	add bx, word 0x6
	jmp bx

resetnpixel:
	xor cx, cx
	pop word bx
	add bx, word 0x6
	jmp bx

hold:
	xor ebx, ebx
	holdloop:
	cmp ebx, dword HOLDTIME
	jae holdend
	inc ebx
	jmp holdloop
	holdend:
	xor ebx, ebx
	pop word bx
	add bx, word 0x6
	jmp bx

times 510 - ($ - $$) db 0x0
db 0x55
db 0xaa

