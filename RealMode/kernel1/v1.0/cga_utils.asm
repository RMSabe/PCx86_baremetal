%include "globaldef.asm"

CGA_MEM_BASE32 equ 0xb8000
CGA_MEM_END32 equ 0xb8fa0
CGA_MEM_LIMIT16 equ 0xfa0

CGA_NWIDTH_CHARS16 equ 80
CGA_NHEIGHT_LINES16 equ 25
CGA_NCOLORS equ 16

P_CGA_NCHAR16 equ 0x40002
P_CGA_NCOLOR8 equ 0x40004

CGA_COLOR_BLACK equ 0
CGA_COLOR_BLUE equ 1
CGA_COLOR_GREEN equ 2
CGA_COLOR_CYAN equ 3
CGA_COLOR_RED equ 4
CGA_COLOR_MAGENTA equ 5
CGA_COLOR_BROWN equ 6
CGA_COLOR_LTGRAY equ 7
CGA_COLOR_DKGRAY equ 8
CGA_COLOR_LTBLUE equ 9
CGA_COLOR_LTGREEN equ 10
CGA_COLOR_LTCYAN equ 11
CGA_COLOR_LTRED equ 12
CGA_COLOR_LTMAGENTA equ 13
CGA_COLOR_YELLOW equ 14
CGA_COLOR_WHITE equ 15

;FUNCTION: set display mode to CGA mode (must only be called in CPU Real Mode)
;args (push order): return addr (32bit)
;return: 8bit value (al) (1 == success / 0 == fail)
cga_start_cgamode:
	mov eax, cr0
	test eax, dword 0x1
	jz cga_start_cgamode_proceed
	xor eax, eax
	mov al, byte 0x0
	jmp cga_start_cgamode_return

	cga_start_cgamode_proceed:
	xor eax, eax
	mov al, byte 0x3
	mov ah, byte 0x0
	int 0x10
	mov al, byte 0x1

	cga_start_cgamode_return:
	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: clear screen in CGA mode
;args (push order):  return addr (32bit)
cga_clearscreen:
	mov esi, dword P_CGA_NCHAR16
	mov [esi], word 0x0
	
	mov edi, dword CGA_MEM_BASE32
	cga_clearscreen_loop:
	mov [edi], word 0x0
	add edi, dword 0x2
	cmp edi, dword CGA_MEM_END32
	jae cga_clearscreen_end
	jmp cga_clearscreen_loop
	cga_clearscreen_end:

	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: set both text and background color in CGA mode
;args (push order): input value (16bit), return addr (32bit)
cga_setfullcolor:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx

	pop word ax
	and ax, word 0xff
	mov esi, dword P_CGA_NCOLOR8
	mov [esi], byte al

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

;FUNCTION: set text color in CGA mode
;args (push order): input value (16bit), return addr (32bit)
cga_settextcolor:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx

	pop word ax
	and ax, word 0xf

	mov esi, dword P_CGA_NCOLOR8
	mov bl, byte [esi]
	and bl, byte 0xf0
	or bl, al
	mov [esi], byte bl

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

;FUNCTION: set background color in CGA mode
;args (push order): input value (16bit), return addr (32bit)
cga_setbkcolor:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx

	pop word ax
	and ax, word 0xf
	shl al, 4

	mov esi, dword P_CGA_NCOLOR8
	mov bl, byte [esi]
	and bl, byte 0xf
	or bl, al
	mov [esi], byte bl

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

;FUNCTION: retrieve current text and background colors in CGA mode
;args (push order): return addr (32bit)
;return: 8bit value (al)
cga_getfullcolor:
	xor ax, ax
	mov esi, dword P_CGA_NCOLOR8
	mov al, byte [esi]

	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: retrieve current text color in CGA mode
;args (push order): return addr (32bit)
;return: 8bit value (al)
cga_gettextcolor:
	xor ax, ax
	mov esi, dword P_CGA_NCOLOR8
	mov al, byte [esi]
	and al, byte 0xf

	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: retrieve current background color in CGA mode
;args (push order): return addr (32bit)
;return: 8bit value (al)
cga_getbkcolor:
	xor ax, ax
	mov esi, dword P_CGA_NCOLOR8
	mov al, byte [esi]
	shr al, 4

	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: set following text position (x, y) in CGA mode
;args (push order): x position (16bit), y position (16bit), return addr (32bit)
cga_settextpos:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx

	pop word ax
	cmp ax, word CGA_NHEIGHT_LINES16
	jae cga_settextpos_return

	mov cx, word CGA_NWIDTH_CHARS16
	shl cx, 1
	mul word cx
	mov bx, ax

	pop word ax
	cmp ax, word CGA_NWIDTH_CHARS16
	jae cga_settextpos_return

	shl ax, 1
	add bx, ax

	mov edi, dword P_CGA_NCHAR16
	mov [edi], word bx

	cga_settextpos_return:

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

;FUNCTION: return current x position of text in CGA mode
;args (push order): return addr
;return 16bit value (ax)
cga_gettextpos_x:
	mov esi, dword P_CGA_NCHAR16
	mov ax, word [esi]

	mov cx, word CGA_NWIDTH_CHARS16
	shl cx, 1
	div word cx

	mov ax, dx
	shr ax, 1

	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: return current y position of text in CGA mode
;args (push order): return addr (32bit)
;return: 16bit value (ax)
cga_gettextpos_y:
	mov esi, dword P_CGA_NCHAR16
	mov ax, word [esi]

	mov cx, word CGA_NWIDTH_CHARS16
	shl cx, 1
	div word cx

	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: add line break to text in CGA mode
;args (push order): return addr (32bit)
cga_add_newline:
	mov esi, dword P_CGA_NCHAR16
	mov bx, word [esi]
	mov ax, bx
	mov dx, word 0x0
	mov cx, word CGA_NWIDTH_CHARS16
	shl cx, 1
	div word cx
	sub bx, dx
	mov cx, word CGA_NWIDTH_CHARS16
	shl cx, 1
	add bx, cx
	mov [esi], word bx

	pop dword ebx
	and ebx, dword 0xffff
	add bx, word 0x10
	jmp bx

;FUNCTION: print text in CGA mode
;args (push order): input text buffer addr (32bit), return addr (32bit)
cga_print:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add edi, dword 0x4
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x8
	mov [esi], dword ecx

	xor ecx, ecx
	mov ebx, dword KERNEL_BASE32_ADDR
	mov esi, dword P_CGA_NCHAR16
	mov cx, word [esi]
	or bx, word $
	cmp cx, word CGA_MEM_LIMIT16
	push dword ebx
	jae cga_clearscreen
	times 20 nop

	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	sub ecx, dword 0x4
	add edi, ecx
	mov ebx, dword [edi]
	mov [esi], dword ecx

	mov esi, ebx
	mov edi, dword P_CGA_NCOLOR8
	mov ah, byte [edi]
	mov edi, dword P_CGA_NCHAR16
	mov cx, word [edi]
	mov edi, dword CGA_MEM_BASE32
	and ecx, dword 0xffff
	add edi, ecx
	cga_printloop:
	mov al, byte [esi]
	cmp al, byte 0x0
	je cga_printend
	mov [edi], word ax
	inc esi
	add edi, dword 0x2
	jmp cga_printloop
	cga_printend:
	mov ebx, edi
	sub ebx, dword CGA_MEM_BASE32
	and ebx, dword 0xffff
	mov esi, dword P_CGA_NCHAR16
	mov [esi], word bx

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

;FUNCTION: print text in CGA mode, add line break at the end
;args (push order): input text buffer addr (32bit), return addr (32bit)
cga_println:
	mov esi, dword P_STACKLIST_INDEX32
	mov edi, dword STACKLIST_BASE32_ADDR
	mov ecx, dword [esi]
	add edi, ecx
	pop dword ebx
	mov [edi], dword ebx
	add ecx, dword 0x4
	mov [esi], dword ecx

	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_print
	times 20 nop

	mov ebx, dword KERNEL_BASE32_ADDR
	or bx, word $
	push dword ebx
	jmp cga_add_newline
	times 20 nop

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


