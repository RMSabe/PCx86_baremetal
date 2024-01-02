;Mini kernel for 386 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

CGA_COLOR_BLACK equ 0x0
CGA_COLOR_BLUE equ 0x1
CGA_COLOR_GREEN equ 0x2
CGA_COLOR_CYAN equ 0x3
CGA_COLOR_RED equ 0x4
CGA_COLOR_MAGENTA equ 0x5
CGA_COLOR_BROWN equ 0x6
CGA_COLOR_LTGRAY equ 0x7

CGA_TEXTCOLOR_BLACK equ CGA_COLOR_BLACK
CGA_TEXTCOLOR_BLUE equ CGA_COLOR_BLUE
CGA_TEXTCOLOR_GREEN equ CGA_COLOR_GREEN
CGA_TEXTCOLOR_CYAN equ CGA_COLOR_CYAN
CGA_TEXTCOLOR_RED equ CGA_COLOR_RED
CGA_TEXTCOLOR_MAGENTA equ CGA_COLOR_MAGENTA
CGA_TEXTCOLOR_BROWN equ CGA_COLOR_BROWN
CGA_TEXTCOLOR_LTGRAY equ CGA_COLOR_LTGRAY
CGA_TEXTCOLOR_DKGRAY equ 0x8
CGA_TEXTCOLOR_LTBLUE equ 0x9
CGA_TEXTCOLOR_LTGREEN equ 0xa
CGA_TEXTCOLOR_LTCYAN equ 0xb
CGA_TEXTCOLOR_LTRED equ 0xc
CGA_TEXTCOLOR_LTMAGENTA equ 0xd
CGA_TEXTCOLOR_YELLOW equ 0xe
CGA_TEXTCOLOR_WHITE equ 0xf

CGA_BKCOLOR_BLACK equ CGA_COLOR_BLACK
CGA_BKCOLOR_BLUE equ CGA_COLOR_BLUE
CGA_BKCOLOR_GREEN equ CGA_COLOR_GREEN
CGA_BKCOLOR_CYAN equ CGA_COLOR_CYAN
CGA_BKCOLOR_RED equ CGA_COLOR_RED
CGA_BKCOLOR_MAGENTA equ CGA_COLOR_MAGENTA
CGA_BKCOLOR_BROWN equ CGA_COLOR_BROWN
CGA_BKCOLOR_LTGRAY equ CGA_COLOR_LTGRAY

CGA_TEXTCOLOR_DEFAULT equ CGA_TEXTCOLOR_LTGRAY
CGA_BKCOLOR_DEFAULT equ CGA_BKCOLOR_BLACK

CGA_NCHARS equ 80
CGA_NLINES equ 25

_CGA_NPOS equ CGA_MEMSPACE
_CGA_NCOLOR equ (CGA_MEMSPACE + 2)

;FUNCTION: initializes CGA mode
_cga_init:
	push dword ebp
	mov ebp, esp

	mov esi, dword _CGA_NPOS
	mov [esi], word 0

	mov eax, dword CGA_TEXTCOLOR_DEFAULT
	mov ebx, dword CGA_BKCOLOR_DEFAULT
	call _cga_setcolor

	_cga_init_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: clear screen
_cga_clearscreen:
	push dword ebp
	mov ebp, esp

	mov esi, dword _CGA_NPOS
	mov [esi], word 0

	mov edi, dword 0xb8000
	_cga_clearscreen_loop:
	cmp edi, dword 0xb8fa0
	jae _cga_clearscreen_endloop
	mov [edi], word 0
	add edi, dword 2
	jmp _cga_clearscreen_loop
	_cga_clearscreen_endloop:

	_cga_clearscreen_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION clear screen, preserve background color
_cga_cleartext:
	push dword ebp
	mov ebp, esp

	mov esi, dword _CGA_NPOS
	mov [esi], word 0

	xor eax, eax

	mov esi, dword _CGA_NCOLOR
	mov ah, byte [esi]
	mov al, byte 0

	mov edi, dword 0xb8000
	_cga_cleartext_loop:
	cmp edi, dword 0xb8fa0
	jae _cga_cleartext_endloop
	mov [edi], word ax
	add edi, dword 2
	jmp _cga_cleartext_loop
	_cga_cleartext_endloop:

	_cga_cleartext_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: set text cursor position
;args: eax (character position), ebx (line number)
_cga_settextpos:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax
	sub esi, dword 4
	mov [esi], dword ebx

	sub esp, dword 8

	;ebp - 4 == x position
	;ebp - 8 == y position

	cmp eax, dword CGA_NCHARS
	jae _cga_settextpos_return

	cmp ebx, dword CGA_NLINES
	jae _cga_settextpos_return

	xor edx, edx
	mov eax, ebx
	mov ecx, dword 0xa0
	mul dword ecx

	mov esi, ebp
	sub esi, dword 4
	mov ebx, dword [esi]

	shl ebx, 1
	add eax, ebx

	and eax, dword 0xffff
	mov edi, dword _CGA_NPOS
	mov [edi], word ax

	_cga_settextpos_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: get text cursor position
;args: none
;return value: eax (ah == line number | al == character position)
_cga_gettextpos:
	push dword ebp
	mov ebp, esp

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	mov esi, dword _CGA_NPOS
	mov bx, word [esi]

	mov ax, bx
	mov cx, word 0xa0
	div word cx

	shl ax, 8
	shr dx, 1
	and dx, word 0xff
	or ax, dx

	_cga_gettextpos_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: set text cursor character position
;args: eax (character position)
_cga_settextpos_x:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp - 4 == x position

	cmp eax, dword CGA_NCHARS
	jae _cga_settextpos_x_return

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	mov edi, dword _CGA_NPOS
	mov bx, word [edi]

	mov ax, bx
	mov cx, word 0xa0
	div word cx

	sub bx, dx

	mov esi, ebp
	sub esi, dword 4
	mov eax, dword [esi]

	and eax, dword 0xffff
	shl ax, 1

	add bx, ax
	mov [edi], word bx

	_cga_settextpos_x_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: get text cursor character position
;args: none
;return value: eax (character position)
_cga_gettextpos_x:
	push dword ebp
	mov ebp, esp

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	mov esi, dword _CGA_NPOS
	mov bx, word [esi]

	mov ax, bx
	mov cx, word 0xa0
	div word cx

	shr dx, 1
	mov ax, dx

	_cga_gettextpos_x_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: set text cursor line position
;args: eax (line position)
_cga_settextpos_y:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp - 4 == y position

	cmp eax, dword CGA_NLINES
	jae _cga_settextpos_y_return

	xor edx, edx
	mov ecx, dword 0xa0
	mul dword ecx

	mov ebx, eax
	and ebx, dword 0xffff

	xor eax, eax
	xor ecx, ecx
	xor edx, edx

	mov edi, dword _CGA_NPOS
	mov ax, word [edi]

	mov cx, word 0xa0
	div word cx

	add bx, dx
	mov [edi], word bx

	_cga_settextpos_y_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: get text cursor line position
;args: none
;return value: eax (line position)
_cga_gettextpos_y:
	push dword ebp
	mov ebp, esp

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	mov esi, dword _CGA_NPOS
	mov bx, word [esi]

	mov ax, bx
	mov cx, word 0xa0
	div word cx

	_cga_gettextpos_y_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: set text cursor word value
;args: eax (word value)
_cga_setposword:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp - 4 == word value

	cmp eax, dword 0xfa0
	jae _cga_setposword_return

	and eax, dword 0xffff

	mov edi, dword _CGA_NPOS
	mov [edi], word ax

	_cga_setposword_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: get current text cursor word value
;args: none
;return value: eax (word value)
_cga_getposword:
	push dword ebp
	mov ebp, esp

	xor eax, eax

	mov esi, dword _CGA_NPOS
	mov ax, word [esi]

	_cga_getposword_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: set text and background color
;args: eax (text color), ebx (background color)
_cga_setcolor:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax
	sub esi, dword 4
	mov [esi], dword ebx

	sub esp, dword 8

	;ebp - 4 == text color
	;ebp - 8 == bk color

	and eax, dword 0xf
	and ebx, dword 0x7

	shl bl, 4
	or al, bl

	mov edi, dword _CGA_NCOLOR
	mov bl, byte [edi]

	and bl, byte 0x80
	or bl, al

	mov [edi], byte bl

	_cga_setcolor_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: get text and background color
;args: none
;return value: eax (ah == background color | al == text color)
_cga_getcolor:
	push dword ebp
	mov ebp, esp

	xor eax, eax
	xor ebx, ebx

	mov esi, dword _CGA_NCOLOR
	mov bl, byte [esi]

	mov al, bl

	and al, byte 0xf
	shr bl, 4
	and bl, byte 0x7

	mov ah, bl

	_cga_getcolor_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: set text color
;args: eax (text color)
_cga_settextcolor:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp - 4 == text color

	and eax, dword 0xf
	xor ebx, ebx

	mov edi, dword _CGA_NCOLOR
	mov bl, byte [edi]

	and bl, byte 0xf0
	or bl, al

	mov [edi], byte bl

	_cga_settextcolor_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: get text color
;args: none
;return value: eax (text color)
_cga_gettextcolor:
	push dword ebp
	mov ebp, esp

	xor eax, eax

	mov esi, dword _CGA_NCOLOR
	mov al, byte [esi]

	and al, byte 0xf

	_cga_gettextcolor_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: set background color
;args: eax (background color)
_cga_setbkcolor:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp - 4 == bk color

	and eax, dword 0x7
	xor ebx, ebx

	mov edi, dword _CGA_NCOLOR
	mov bl, byte [edi]

	shl al, 4
	and bl, byte 0x8f
	or bl, al

	mov [edi], byte bl

	_cga_setbkcolor_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: get background color
;args: none
;return value: eax (background color)
_cga_getbkcolor:
	push dword ebp
	mov ebp, esp

	xor eax, eax

	mov esi, dword _CGA_NCOLOR
	mov al, byte [esi]

	shr al, 4
	and al, byte 0x7

	_cga_getbkcolor_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: set color byte value
;args: eax (byte value)
_cga_setcolorbyte:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp - 4 == byte value

	and eax, dword 0xff

	mov edi, dword _CGA_NCOLOR
	mov [edi], byte al

	_cga_setcolorbyte_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: get color byte value
;args: none
;return value: eax (byte value)
_cga_getcolorbyte:
	push dword ebp
	mov ebp, esp

	xor eax, eax

	mov esi, dword _CGA_NCOLOR
	mov al, byte [esi]

	_cga_getcolorbyte_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: enable/disable text blink
;args: eax (bool enable)
_cga_setblinkenable:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp - 4 == bool enable

	xor ebx, ebx

	mov edi, dword _CGA_NCOLOR
	mov bl, byte [edi]

	test eax, dword 0xffffffff
	jz _cga_setblinkenable_false

	_cga_setblinkenable_true:
	or bl, byte 0x80
	jmp _cga_setblinkenable_l1

	_cga_setblinkenable_false:
	and bl, byte 0x7f

	_cga_setblinkenable_l1:
	mov [edi], byte bl

	_cga_setblinkenable_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: get blink enable status
;args: none
;return value: eax (1 == enabled / 0 == disabled)
_cga_getblinkenable:
	push dword ebp
	mov ebp, esp

	xor ebx, ebx

	mov esi, dword _CGA_NCOLOR
	mov bl, byte [esi]

	test bl, byte 0x80
	jz _cga_getblinkenable_returnfalse

	_cga_getblinkenable_returntrue:
	mov eax, dword 1
	jmp _cga_getblinkenable_return

	_cga_getblinkenable_returnfalse:
	xor eax, eax

	_cga_getblinkenable_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: add new line
_cga_addnewline:
	push dword ebp
	mov ebp, esp

	mov esi, dword _CGA_NPOS
	mov bx, word [esi]

	xor dx, dx
	mov ax, bx
	mov cx, word 0xa0
	div word cx

	sub bx, dx
	add bx, word 0xa0

	mov [esi], word bx

	_cga_addnewline_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: print a text
;args: eax (input text buffer addr)
_cga_printtext:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp + 4 == return

	;ebp - 4 == text buffer

	mov esi, dword _CGA_NPOS
	mov cx, word [esi]

	cmp cx, word 0xfa0
	jb _cga_printtext_noclear

	call _cga_clearscreen
	xor ecx, ecx

	_cga_printtext_noclear:
	and ecx, dword 0xffff
	mov edi, dword 0xb8000
	add edi, ecx

	mov esi, dword _CGA_NCOLOR
	mov ah, byte [esi]

	mov esi, ebp
	sub esi, dword 4
	mov ebx, dword [esi]

	mov esi, ebx

	_cga_printtext_loop:
	mov al, byte [esi]
	cmp al, byte 0
	je _cga_printtext_endloop
	mov [edi], word ax
	inc esi
	add edi, dword 2
	jmp _cga_printtext_loop
	_cga_printtext_endloop:

	mov ebx, edi
	sub ebx, dword 0xb8000
	and ebx, dword 0xffff
	mov esi, dword _CGA_NPOS
	mov [esi], word bx

	_cga_printtext_return:
	mov esp, ebp
	pop dword ebp
	ret

;FUNCTION: print a text, add new line
;args: eax (input text buffer addr)
_cga_printtextln:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp + 4 == return

	;ebp - 4 == text buffer

	call _cga_printtext

	call _cga_addnewline

	_cga_printtextln_return:
	mov esp, ebp
	pop dword ebp
	ret

