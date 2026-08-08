; Mini Kernel 2 for 386 PCs.
; Version 0.1
;
; Author: Rafael Sabe
; Email: rafaelmsabe@gmail.com

%include "_globldef.inc"

__BOOTLOADER_STACK_SEG16 equ 0x0
__BOOTLOADER_STACK_BP16 equ 0x7bfc

section __BOOTLOADER_MEMBLOCK__
org BOOTLOADER_MEMBLOCK_ADDR32
bits 16

_boot_start:
	cli

	mov ax, word BOOTDEVID_SEG16
	mov ds, ax
	mov si, word BOOTDEVID_INDEX16
	mov [ds:si], byte dl

	mov ax, word __BOOTLOADER_STACK_SEG16
	mov ss, ax
	mov bp, word __BOOTLOADER_STACK_BP16
	mov sp, bp

	sti

	mov ah, byte 0x2
	mov al, byte GDT_DISKBLOCK_SIZE_SECTORS
	mov cl, byte GDT_DISKBLOCK_SECTOR_INDEX
	xor ch, ch
	xor dh, dh
	mov bx, word GDT_MEMBLOCK_SEG16
	mov es, bx
	mov bx, word GDT_MEMBLOCK_INDEX16
	int 0x13
	jc _boot_err
	test ah, byte 0xff
	jnz _boot_err

	mov ax, word BOOTDEVID_SEG16
	mov ds, ax
	mov si, word BOOTDEVID_INDEX16
	mov dl, byte [ds:si]

	mov ah, byte 0x2
	mov al, byte KERNEL_DISKBLOCK_SIZE_SECTORS
	mov cl, byte KERNEL_DISKBLOCK_SECTOR_INDEX
	xor ch, ch
	xor dh, dh
	mov bx, word KERNEL_MEMBLOCK_SEG16
	mov es, bx
	mov bx, word KERNEL_MEMBLOCK_INDEX16
	int 0x13
	jc _boot_err
	test ah, byte 0xff
	jnz _boot_err

	_l_boot_start_system_loaded:

	call _boot_success

	cli
	lgdt [GDT_DESC_ADDR32]
	mov eax, cr0
	or eax, dword 0x1
	mov cr0, eax

	jmp GDTSEG_KERNEL_OFFSET:KERNEL_MEMBLOCK_INDEX16

_boot_success:
	push word bp
	mov bp, sp

	mov bx, word 0xb800
	mov es, bx
	mov di, word 0x0

	mov [es:di], word 0x1f53

	_l_boot_success_ret:
	mov sp, bp
	pop word bp
	ret

_boot_err:
	mov bx, word 0xb800
	mov es, bx
	mov di, word 0x0

	mov [es:di], word 0x4f46

	_l_boot_err_loop:
	times 4 nop
	jmp _l_boot_err_loop

times (510 - ($ - $$)) db 0
db 0x55
db 0xaa

