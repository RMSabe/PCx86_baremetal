KERNEL_SEG16_ADDR equ 0x1000
KERNEL_INDEX16_ADDR equ 0x0000
KERNEL_BASE32_ADDR equ 0x10000
KERNEL_SIZE_BYTES equ 4096
KERNEL_SIZE_SECTORS equ 8

STACK_BASE32_ADDR equ 0x7c00

P_BOOTDEVICE equ 0x7e00

HOLDTIME equ 0x20000000

org 0x7c00
bits 16

cli
mov ax, word 0x0
mov ss, ax
mov ds, ax
mov es, ax
mov ebp, dword STACK_BASE32_ADDR
mov esp, ebp
sti

mov esi, dword P_BOOTDEVICE
mov [esi], byte dl

mov ah, byte 0x0
mov al, byte 0x3
int 0x10

boot_start:
	mov ah, byte 0x2
	mov al, byte KERNEL_SIZE_SECTORS
	mov ch, byte 0x0
	mov cl, byte 0x2
	mov dh, byte 0x0
	mov dl, byte [esi]
	mov bx, word KERNEL_SEG16_ADDR
	mov es, bx
	mov bx, word KERNEL_INDEX16_ADDR
	int 0x13
	jc boot_err
	cmp ah, byte 0x0
	jne boot_err
	mov esp, ebp
	mov bx, word $
	push word bx
	push word textstr_bootsuccess
	jmp print_msg
	times 16 nop
	mov esp, ebp
	mov bx, word $
	push word bx
	jmp hold
	times 8 nop
	jmp KERNEL_SEG16_ADDR:KERNEL_INDEX16_ADDR

boot_err:
	mov esp, ebp
	mov bx, word $
	push word bx
	push word textstr_bootfail
	jmp print_msg
	times 16 nop
	jmp terminate

print_msg:
	pop word bx
	mov edi, dword 0xb8000
	mov ah, byte 0xf
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
	add bx, word 0xa
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

terminate:
	times 4 nop
	jmp terminate

textstr_bootfail: db 'Boot failed', 0x0
textstr_bootsuccess: db 'Boot successful', 0x0

times 510 - ($ - $$) db 0x0
db 0x55
db 0xaa

