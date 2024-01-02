;Test 4: Test CGA 1 (setting text position, setting color, enable/disable blink)

TESTEND_DELAYTIME equ 0xc0000000

TESTSTR1_CHARPOS equ 3
TESTSTR1_LINEPOS equ 4

_teststart:
	mov eax, dword TESTSTR1_CHARPOS
	mov ebx, dword TESTSTR1_LINEPOS
	call _cga_settextpos

	mov eax, dword CGA_TEXTCOLOR_YELLOW
	mov ebx, dword CGA_BKCOLOR_BLUE
	call _cga_setcolor

	mov eax, dword _teststr1
	call _cga_printtextln

	mov eax, dword 1
	call _cga_setblinkenable

	mov eax, dword _teststr2
	call _cga_printtextln

	mov eax, dword CGA_TEXTCOLOR_LTGREEN
	mov ebx, dword CGA_BKCOLOR_RED
	call _cga_setcolor

	mov eax, dword _teststr3
	call _cga_printtextln

	xor eax, eax
	call _cga_setblinkenable

	mov eax, dword _teststr4
	call _cga_printtextln

	mov eax, dword CGA_TEXTCOLOR_BLACK
	mov ebx, dword CGA_BKCOLOR_LTGRAY
	call _cga_setcolor

	mov eax, dword _teststr5
	call _cga_printtextln

_testend:
	mov eax, dword TESTEND_DELAYTIME
	call _delay32

	jmp _sysend

_teststr1: db 'This text should not be blinking', 0x0
_teststr2: db 'This text should be blinking', 0x0
_teststr3: db 'This text should also be blinking', 0x0
_teststr4: db 'But this text should not be blinking', 0x0
_teststr5: db 'This text neither', 0x0

