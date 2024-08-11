;Mini kernel for x86 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

%include "includes/globaldef.asm"

org 0x7c00
bits 16

section .boot

cli

mov ax, word 0x0
mov ss, ax
mov bp, word 0x7bfc
mov sp, bp

mov ax, word BOOTDEV_SEG16
mov ds, ax
mov si, word BOOTDEV_INDEX16
mov [ds:si], byte dl

sti

mov ah, byte 0x0
mov al, byte 0x3
int 0x10

_bootstart:
	mov ah, byte 0x2
	mov al, byte KERNEL_SIZE_SECTORS
	mov cl, byte KERNEL_DISK_SECTOR
	mov ch, byte KERNEL_DISK_CYLINDER
	mov dh, byte KERNEL_DISK_HEAD
	mov bx, word KERNEL_SEG16
	mov es, bx
	mov bx, word KERNEL_INDEX16
	int 0x13
	jc _booterr
	cmp ah, byte 0x0
	jne _booterr
	jmp KERNEL_SEG16:KERNEL_INDEX16

_booterr:
	push word _textstr_bootfail
	push word $
	jmp _printmsg
	times RETURN_MARGIN_CALLER nop
	_booterr_loop:
	times 4 nop
	jmp _booterr_loop

_printmsg:
	push word bp
	mov bp, sp

	;bp + 2 == return addr
	;bp + 4 == input text

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4

	mov bx, word [ds:si]
	mov si, bx

	mov bx, word 0xb800
	mov es, bx
	mov di, word 0x0
	mov ah, byte 0x7
	_printmsg_loop:
	mov al, byte [si]
	cmp al, byte 0x0
	je _printmsg_endloop
	mov [es:di], word ax
	inc si
	add di, word 0x2
	jmp _printmsg_loop
	_printmsg_endloop:

	_printmsg_return:
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

_textstr_bootfail: db 'Boot failed', 0x0

times 510 - ($ - $$) db 0x0
db 0x55
db 0xaa

