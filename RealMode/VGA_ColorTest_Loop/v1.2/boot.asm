;VGA Color Test Loop 1.2

org 0x7c00
bits 16

mov ax, word 0x0
mov ss, ax
mov ds, ax
mov es, ax

mov ebp, dword 0x7c00
mov esp, ebp

mov ah, byte 0x0
mov al, byte 0x13
int 0x10

NPIXEL_ADDR equ 0x7e00
NCOLOR_ADDR equ 0x7e02

mov esi, dword NPIXEL_ADDR
mov [esi], word 0x0

mov esi, dword NCOLOR_ADDR
mov [esi], byte 0x0

HOLDTIME equ 0x01000000

sysloop:
	mov esp, ebp
	mov bx, word $
	push word bx
	jmp drawline
	times 8 nop
	and ecx, dword 0xffff
	cmp cx, word 0xfa00
	mov esp, ebp
	mov bx, word $
	push word bx
	jae resetnpixel
	times 8 nop
	mov esi, dword NPIXEL_ADDR
	mov [esi], word cx
	mov esi, dword NCOLOR_ADDR
	mov al, byte [esi]
	inc al
	mov [esi], byte al
	mov esp, ebp
	mov bx, word $
	push word bx
	jmp hold
	times 8 nop
	jmp sysloop

drawline:
	mov esi, dword NPIXEL_ADDR
	mov cx, word [esi]
	and ecx, dword 0xffff
	mov edi, dword 0xa0000
	add edi, ecx
	add cx, word 0x140
	mov esi, dword NCOLOR_ADDR
	mov al, byte [esi]
	drawlineloop:
	cmp cx, di
	jbe drawlineend
	mov [edi], byte al
	inc edi
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

