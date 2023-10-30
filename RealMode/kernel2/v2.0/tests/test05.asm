;Test 5: test string comparison

TESTSTR1 equ _teststr1
TESTSTR2 equ _teststr4

_teststart:
	push word KERNEL_SEG16
	push word TESTSTR1
	push word $
	jmp _cga_printtext
	times RETURN_MARGIN_CALLER nop
	mov sp, bp

	mov bx, word KERNEL_SEG16
	mov es, bx
	mov di, word _textbuf

	mov [es:di], byte 0x20
	inc di
	mov [es:di], byte 0x0

	push word KERNEL_SEG16
	push word _textbuf
	push word $
	jmp _cga_printtext
	times RETURN_MARGIN_CALLER nop
	mov sp, bp

	push word KERNEL_SEG16
	push word TESTSTR2
	push word $
	jmp _cga_printtext
	times RETURN_MARGIN_CALLER nop
	mov sp, bp

	mov bx, word KERNEL_SEG16
	mov es, bx
	mov di, word _textbuf

	mov [es:di], byte 0x20
	inc di
	mov [es:di], byte 0x0

	push word KERNEL_SEG16
	push word _textbuf
	push word $
	jmp _cga_printtext
	times RETURN_MARGIN_CALLER nop
	mov sp, bp

	push word KERNEL_SEG16
	push word TESTSTR1
	push word KERNEL_SEG16
	push word TESTSTR2
	push word $
	jmp _compare_str
	times RETURN_MARGIN_CALLER nop
	mov sp, bp

	mov bx, word KERNEL_SEG16
	mov es, bx
	mov di, word _textbuf

	test ax, word 0xffff
	jz _test_false

	_test_true:
	mov [es:di], byte 0x31
	jmp _test_l1

	_test_false:
	mov [es:di], byte 0x30

	_test_l1:
	inc di
	mov [es:di], byte 0x0

	push KERNEL_SEG16
	push _textbuf
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop
	mov sp, bp

	push word 0x8000
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop
	mov sp, bp

_testend:
	jmp _sysend

_teststr1: db 'sum', 0x0
_teststr2: db 'sub', 0x0
_teststr3: db 'mult', 0x0
_teststr4: db 'sum', 0x0

