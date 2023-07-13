%include "globaldef.asm"

VGA_MEM_BASE32 equ 0xa0000
VGA_MEM_END32 equ 0xafa00
VGA_MEM_LIMIT16 equ 0xfa00

VGA_NWIDTH16 equ 320
VGA_NHEIGHT16 equ 200
VGA_NCOLORS16 equ 256

;FUNCTION: Set display mode to VGA mode (must be called in CPU Real Mode)
;args (push order): return addr (32bit)
;return: 8bit value (al) (1 == success / 0 == fail)
vga_start_vgamode:
	mov eax, cr0
	test eax, dword 0x1
	jz vga_start_vgamode_proceed
	xor eax, eax
	mov al, byte 0x0
	jmp vga_start_vgamode_return

	vga_start_vgamode_proceed:
	xor eax, eax
	mov al, byte 0x13
	mov ah, byte 0x0
	int 0x10
	mov al, byte 0x1

	vga_start_vgamode_return:
	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: clear screen in VGA mode
;args (push order): return addr (32bit)
vga_clearscreen:
	mov edi, dword VGA_MEM_BASE32

	vga_clearscreen_loop:
	cmp edi, dword VGA_MEM_END32
	jae vga_clearscreen_end
	mov [edi], byte 0x0
	inc edi
	jmp vga_clearscreen_loop

	vga_clearscreen_end:
	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: paint a pixel on coordinates (x, y) of specified color in VGA mode
;args (push order): color (16bit), x position (16bit), y posision (16bit), return addr (32bit)
vga_paintpixel:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx

	pop word ax
	cmp ax, word VGA_NHEIGHT16
	jae vga_paintpixel_return

	mov cx, word VGA_NWIDTH16
	mul word cx

	mov bx, ax

	pop word ax
	cmp ax, word VGA_NWIDTH16
	jae vga_paintpixel_return

	add bx, ax

	pop word ax
	and ax, word 0xff

	mov edi, dword VGA_MEM_BASE32
	and ebx, dword 0xffff
	add edi, ebx
	mov [edi], byte al

	vga_paintpixel_return:

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]
	mov [esi], dword ecx

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: retrieves the current color of a specific pixel in VGA mode
;args (push order): x position (16bit), y position (16bit), return addr (32bit)
;return 8bit value (al)
vga_getpixelcolor:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx

	pop word ax
	cmp ax, word VGA_NHEIGHT16
	jae vga_getpixelcolor_return

	mov cx, word VGA_NWIDTH16
	mul word cx

	mov bx, ax

	pop word ax
	cmp ax, word VGA_NWIDTH16
	jae vga_getpixelcolor_return

	add bx, ax

	xor ax, ax
	mov esi, dword VGA_MEM_BASE32
	and ebx, dword 0xffff
	add esi, ebx
	mov al, byte [esi]

	vga_getpixelcolor_return:

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]
	mov [esi], dword ecx

	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

