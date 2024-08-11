;Test 5: test string comparison

TESTSTR_1_1 equ _teststr3
TESTSTR_1_2 equ _teststr1
TESTSTR_2_1 equ _teststr2
TESTSTR_2_2 equ _teststr4
TESTSTR_3_1 equ _teststr2
TESTSTR_3_2 equ _teststr1
TESTSTR_4_1 equ _teststr1
TESTSTR_4_2 equ _teststr4

_teststart:

	push word TESTSTR_1_1
	push word TESTSTR_1_2
	push word $
	jmp _test_routine1
	times RETURN_MARGIN_CALLER nop

	push word TESTSTR_2_1
	push word TESTSTR_2_2
	push word $
	jmp _test_routine1
	times RETURN_MARGIN_CALLER nop

	push word TESTSTR_3_1
	push word TESTSTR_3_2
	push word $
	jmp _test_routine1
	times RETURN_MARGIN_CALLER nop

	push word TESTSTR_4_1
	push word TESTSTR_4_2
	push word $
	jmp _test_routine1
	times RETURN_MARGIN_CALLER nop

	push word 0xe000
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

_testend:
	jmp _sysend

;SIDE FUNCTION: run the test routine (avoiding repeated code)
;args (push order): str 1 index (16bit), str 2 index (16bit), return addr (16bit)
_test_routine1:
	push word bp
	mov bp, sp

	;bp + 2 == return addr
	;bp + 4 == str 2 index
	;bp + 6 == str 1 index

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 6
	mov cx, word [ds:si]

	push word KERNEL_SEG16
	push word cx
	push word $
	jmp _cga_printtext
	times RETURN_MARGIN_CALLER nop

	push word 0x20
	push word $
	jmp _cga_printchar
	times RETURN_MARGIN_CALLER nop

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov cx, word [ds:si]

	push word KERNEL_SEG16
	push word cx
	push word $
	jmp _cga_printtext
	times RETURN_MARGIN_CALLER nop

	push word 0x20
	push word $
	jmp _cga_printchar
	times RETURN_MARGIN_CALLER nop

	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 4
	mov dx, word [ds:si]
	add si, word 2
	mov cx, word [ds:si]

	push word KERNEL_SEG16
	push word cx
	push word KERNEL_SEG16
	push word dx
	push word $
	jmp _str_compare
	times RETURN_MARGIN_CALLER nop

	test ax, word 0xffff
	jz _test_routine1_false

	_test_routine1_true:
	mov ax, word 0x31
	jmp _test_routine1_result

	_test_routine1_false:
	mov ax, word 0x30

	_test_routine1_result:
	push word ax
	push word $
	jmp _cga_printchar
	times RETURN_MARGIN_CALLER nop

	push word $
	jmp _cga_addnewline
	times RETURN_MARGIN_CALLER nop

	_test_routine1_return:
	mov bx, ss
	mov ds, bx
	mov si, bp
	add si, word 2
	mov bx, word [ds:si]

	mov sp, bp
	pop word bp

	add sp, word 6

	add bx, word RETURN_MARGIN_CALLEE
	jmp bx

_teststr1: db 'sum', 0x0
_teststr2: db 'sub', 0x0
_teststr3: db 'mult', 0x0
_teststr4: db 'sum', 0x0

