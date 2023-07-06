;Hello World Loop 1.2

org 0x7c00
bits 16

mov ax, word 0x0
mov ss, ax
mov ds, ax
mov es, ax

mov ebp, dword 0x7c00
mov esp, ebp

mov ah, byte 0x0
mov al, byte 0x3
int 0x10

NLINE_ADDR equ 0x7e00
NCOLOR_ADDR equ 0x7e02

mov esi, dword NLINE_ADDR
mov [esi], word 0x0

mov esi, dword NCOLOR_ADDR
mov [esi], byte 0x0

HOLDTIME equ 0x18000000

sysloop:
	mov esp, ebp
	mov bx, word $
	push word bx
	push word text
	jmp print
	times 8 nop
	mov esi, dword NLINE_ADDR
	mov cx, word [esi]
	add cx, word 0xa0
	cmp cx, word 0xfa0
	mov esp, ebp
	mov bx, word $
	push word bx
	jae resetline
	times 8 nop
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

print:
	pop word bx
	mov esi, dword NLINE_ADDR
	mov cx, word [esi]
	and ecx, dword 0xffff
	mov edi, dword 0xb8000
	add edi, ecx
	mov esi, dword NCOLOR_ADDR
	mov ah, byte [esi]
	printloop:
	mov al, byte [bx]
	cmp al, byte 0x0
	je printend
	mov [edi], word ax
	inc bx
	add edi, dword 0x2
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

