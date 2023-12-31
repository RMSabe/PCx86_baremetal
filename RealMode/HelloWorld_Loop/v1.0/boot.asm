;Hello World Loop 1.0

org 0x7c00
bits 16

mov ax, word 0x0
mov ss, ax
mov ds, ax

mov ax, word 0xb800
mov es, ax
mov di, word 0x0

mov bp, word 0x7c00
mov sp, bp

mov ah, byte 0x0
mov al, byte 0x3
int 0x10

mov cx, word 0x0
mov ah, byte 0x0

HOLDTIME equ 0x08000000

sysloop:
	mov sp, bp
	mov bx, word $
	push word bx
	push word text
	jmp print
	times 8 nop
	add cx, word 0xa0
	cmp cx, word 0xfa0
	mov sp, bp
	mov bx, word $
	push word bx
	jae resetline
	times 8 nop
	inc ah
	mov sp, bp
	mov bx, word $
	push word bx
	jmp hold
	times 8 nop
	jmp sysloop

print:
	pop word bx
	mov di, cx
	printloop:
	mov al, byte [bx]
	cmp al, byte 0x0
	je printend
	mov [es:di], word ax
	inc bx
	add di, word 0x2
	jmp printloop
	printend:
	pop word bx
	add bx, word 0x6
	jmp bx

resetline:
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

text: db 'Hello World', 0x0

times 510 - ($ - $$) db 0x0
db 0x55
db 0xaa

