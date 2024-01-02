;Mini kernel for 386 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

%include "includes/globaldef.asm"

org 0x7c00
bits 16

RETURN_MARGIN_CALLER equ 0x10
RETURN_MARGIN_CALLEE equ 0xc

section boot ;disk: sector 1 / mem: 0x7c00

cli
xor ax, ax
mov ss, ax
mov bp, word 0x7bfc
mov sp, bp
sti

xor ax, ax
mov ds, ax
mov di, word P_BOOTDEV
mov [ds:di], byte dl

_boot_start:
	mov ah, byte 2
	mov al, byte GDT_SIZE_SECTORS
	mov cl, byte GDT_DISK_SECTOR
	mov ch, byte 0
	mov dh, byte 0
	mov bx, word GDT_SEG16
	mov es, bx
	mov bx, word GDT_INDEX16
	int 0x13
	jc _boot_start_e1
	cmp ah, byte 0
	jne _boot_start_e1

	xor ax, ax
	mov ds, ax
	mov si, word P_BOOTDEV
	mov dl, byte [ds:si]

	mov ah, byte 2
	mov al, byte KERNEL_SIZE_SECTORS
	mov cl, byte KERNEL_DISK_SECTOR
	mov ch, byte 0
	mov dh, byte 0
	mov bx, word KERNEL_SEG16
	mov es, bx
	mov bx, word KERNEL_INDEX16
	int 0x13
	jc _boot_start_e2
	cmp ah, byte 0
	jne _boot_start_e2

	push word _boot_msg_success
	push word $
	jmp _print_msg
	times RETURN_MARGIN_CALLER nop
	add sp, word 4

	mov ah, byte 0
	mov al, byte 3
	int 0x10

	cli
	lgdt [_gdt_descriptor]
	mov eax, cr0
	or eax, dword 1
	mov cr0, eax

	jmp KERNEL_SEGGDT:KERNEL_INDEX16

	_boot_start_e1:
	push word _boot_errmsg1
	jmp _boot_err
	_boot_start_e2:
	push word _boot_errmsg2
	jmp _boot_err

_boot_err:
	push word $
	jmp _print_msg
	times RETURN_MARGIN_CALLER nop
	add sp, word 4

	_boot_err_loop:
	times 4 nop
	jmp _boot_err_loop

;args (push order): input text buffer addr, return addr
_print_msg:
	push word bp
	mov bp, sp

	;bp + 2 == arg1: return addr
	;bp + 4 == arg0: text addr

	mov si, bp
	add si, word 4
	mov bx, word [si]

	mov si, bx
	mov ah, byte 0xe
	_print_msg_loop:
	mov al, byte [si]
	cmp al, byte 0
	je _print_msg_endloop
	int 0x10
	inc si
	jmp _print_msg_loop
	_print_msg_endloop:

	_print_msg_return:
	mov si, bp
	add si, word 2
	mov bx, word [si]

	mov sp, bp
	pop word bp

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

_boot_errmsg1: db 'Error: disk load step 1', 0x0
_boot_errmsg2: db 'Error: disk load step 2', 0x0
_boot_msg_success: db 'Boot successful', 0x0

times 510 - ($ - $$) db 0
db 0x55
db 0xaa

section bootdata ;disk sector 2 / mem: 0x7e00

_gdt_descriptor:
	dw _gdt_end - _gdt_start - 1
	dd _gdt_start

dw 0x0

_gdt_start:
	_gdt_seg0:
	dd 0x0
	dd 0x0
	_gdt_seg1: ;code segment
	dw 0xffff
	dw 0x0000
	db 0x01
	db 0b10011010
	db 0b01000000
	db 0x00
	_gdt_seg2: ;data segment
	dw 0xffff
	dw 0x0000
	db 0x02
	db 0b10010010
	db 0b01000000
	db 0x00
	_gdt_seg3: ;stack data segment
	dw 0xffff
	dw 0x0000
	db 0x03
	db 0b10010010
	db 0b01000000
	db 0x00
_gdt_end:

times GDT_SIZE_BYTES - ($ - $$) db 0

