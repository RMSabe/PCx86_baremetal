;Test 6: Test CGA 1 (setting text position, setting color, enable/disable blink)

TESTEND_DELAYTIME equ 0xc000

TESTSTR1_CHARPOS equ 20
TESTSTR1_LINEPOS equ 4

_teststart:
	push word TESTSTR1_CHARPOS
	push word TESTSTR1_LINEPOS
	push word $
	jmp _cga_settextpos
	times RETURN_MARGIN_CALLER nop

	push word CGA_TEXTCOLOR_YELLOW
	push word CGA_BKCOLOR_BLUE
	push word $
	jmp _cga_setcolor
	times RETURN_MARGIN_CALLER nop

	push word KERNEL_SEG16
	push word _teststr1
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop

	push word 1
	push word $
	jmp _cga_setblinkenable
	times RETURN_MARGIN_CALLER nop

	push word KERNEL_SEG16
	push word _teststr2
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop

	push word CGA_TEXTCOLOR_LTGREEN
	push word CGA_BKCOLOR_RED
	push word $
	jmp _cga_setcolor
	times RETURN_MARGIN_CALLER nop

	push word KERNEL_SEG16
	push word _teststr3
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop

	push word 0
	push word $
	jmp _cga_setblinkenable
	times RETURN_MARGIN_CALLER nop

	push word KERNEL_SEG16
	push word _teststr4
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop

	push word CGA_TEXTCOLOR_BLACK
	push word CGA_BKCOLOR_LTGRAY
	push word $
	jmp _cga_setcolor
	times RETURN_MARGIN_CALLER nop

	push word KERNEL_SEG16
	push word _teststr5
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop

_testend:
	push word TESTEND_DELAYTIME
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

	jmp _sysend

_teststr1: db 'This text should not be blinking', 0x0
_teststr2: db 'This text should be blinking', 0x0
_teststr3: db 'This text should also be blinking', 0x0
_teststr4: db 'But this text should not be blinking', 0x0
_teststr5: db 'This text neither', 0x0

