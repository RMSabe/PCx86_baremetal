%include "globaldef.asm"

org 0x7c00
bits 16

cli

mov ax, word 0x0
mov ds, ax
mov ss, ax
mov si, word P_BOOTDEV

mov [ds:si], byte dl
mov bp, word 0x7c00
mov sp, bp

sti

mov ah, byte 0x0
mov al, byte 0x3
int 0x10

boot_start:
	mov ah, byte 0x2
	mov al, byte KERNEL_SIZE_SECTORS
	mov ch, byte 0x0
	mov cl, byte 0x2
	mov dh, byte 0x0
	mov bx, word KERNEL_SEG16
	mov es, bx
	mov bx, word KERNEL_INDEX16
	int 0x13
	jc boot_err
	cmp ah, byte 0x0
	jne boot_err
	mov bp, word 0x7c00
	mov sp, bp
	mov bx, word $
	push word bx
	push word textstr_success
	jmp print_msg
	times 16 nop
	mov bp, word 0x7c00
	mov sp, bp
	mov bx, word $
	push word bx
	jmp hold
	times 16 nop
	mov ah, byte 0x0
	mov al, byte 0x3
	int 0x10
	jmp KERNEL_SEG16:KERNEL_INDEX16

boot_err:
	mov bp, word 0x7c00
	mov sp, bp
	mov bx, word $
	push word bx
	push word textstr_fail
	jmp print_msg
	times 16 nop
	mov bp, word 0x7c00
	mov sp, bp
	mov bx, word $
	push word bx
	jmp hold
	times 16 nop
	mov ah, byte 0x0
	mov al, byte 0x3
	int 0x10
	err_loop:
	times 4 nop
	jmp err_loop

print_msg:
	pop bx
	mov ax, word 0xb800
	mov es, ax
	mov di, word 0x0
	mov ah, byte 0x7
	print_msg_loop:
	mov al, byte [bx]
	cmp al, byte 0x0
	je print_msg_end
	mov [es:di], word ax
	inc bx
	add di, word 0x2
	jmp print_msg_loop
	print_msg_end:
	pop bx
	add bx, word 0xc
	jmp bx

HOLDTIME_IN equ 0xffff
HOLDTIME_OUT equ 0x4000

hold:
	xor cx, cx
	hold_out_loop:
	cmp cx, word HOLDTIME_OUT
	jae hold_out_end
	xor ax, ax
	hold_in_loop:
	cmp ax, word HOLDTIME_IN
	jae hold_in_end
	inc ax
	jmp hold_in_loop
	hold_in_end:
	inc cx
	jmp hold_out_loop
	hold_out_end:
	pop bx
	add bx, word 0xc
	jmp bx
	

textstr_success: db 'Boot successful', 0x0
textstr_fail: db 'Boot failed', 0x0

times 510 - ($ - $$) db 0x0
db 0x55
db 0xaa

