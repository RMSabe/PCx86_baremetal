;Test 3: test string comparison

TESTSTR_0_0 equ _teststr3
TESTSTR_0_1 equ _teststr1
TESTSTR_1_0 equ _teststr2
TESTSTR_1_1 equ _teststr4
TESTSTR_2_0 equ _teststr4
TESTSTR_2_1 equ _teststr1
TESTSTR_3_0 equ _teststr2
TESTSTR_3_1 equ _teststr3

TEST_DELAYTIME equ 0xfff00000

_teststart:
	call _cga_clearscreen

	mov eax, dword TESTSTR_0_0
	call _cga_printtext

	mov eax, dword 8
	call _cga_settextpos_x

	mov eax, dword TESTSTR_0_1
	call _cga_printtext

	mov eax, dword 16
	call _cga_settextpos_x

	mov eax, dword TESTSTR_0_0
	mov ebx, dword TESTSTR_0_1
	call _strcompare

	mov edi, dword TEXTBUF_ADDR

	test eax, dword 0xffffffff
	jz _test0_false

	_test0_true:
	mov [edi], word 0x31
	jmp _test_l1

	_test0_false:
	mov [edi], word 0x30

	_test_l1:
	mov eax, dword TEXTBUF_ADDR
	call _cga_printtextln

	mov eax, dword TESTSTR_1_0
	call _cga_printtext

	mov eax, dword 8
	call _cga_settextpos_x

	mov eax, dword TESTSTR_1_1
	call _cga_printtext

	mov eax, dword 16
	call _cga_settextpos_x

	mov eax, dword TESTSTR_1_0
	mov ebx, dword TESTSTR_1_1
	call _strcompare

	mov edi, dword TEXTBUF_ADDR

	test eax, dword 0xffffffff
	jz _test1_false

	_test1_true:
	mov [edi], word 0x31
	jmp _test_l2

	_test1_false:
	mov [edi], word 0x30

	_test_l2:
	mov eax, dword TEXTBUF_ADDR
	call _cga_printtextln

	mov eax, dword TESTSTR_2_0
	call _cga_printtext

	mov eax, dword 8
	call _cga_settextpos_x

	mov eax, dword TESTSTR_2_1
	call _cga_printtext

	mov eax, dword 16
	call _cga_settextpos_x

	mov eax, dword TESTSTR_2_0
	mov ebx, dword TESTSTR_2_1
	call _strcompare

	mov edi, dword TEXTBUF_ADDR

	test eax, dword 0xffffffff
	jz _test2_false

	_test2_true:
	mov [edi], word 0x31
	jmp _test_l3

	_test2_false:
	mov [edi], word 0x30

	_test_l3:
	mov eax, dword TEXTBUF_ADDR
	call _cga_printtextln

	mov eax, dword TESTSTR_3_0
	call _cga_printtext

	mov eax, dword 8
	call _cga_settextpos_x

	mov eax, dword TESTSTR_3_1
	call _cga_printtext

	mov eax, dword 16
	call _cga_settextpos_x

	mov eax, dword TESTSTR_3_0
	mov ebx, dword TESTSTR_3_1
	call _strcompare

	mov edi, dword TEXTBUF_ADDR

	test eax, dword 0xffffffff
	jz _test3_false

	_test3_true:
	mov [edi], word 0x31
	jmp _test_l4

	_test3_false:
	mov [edi], word 0x30

	_test_l4:
	mov eax, dword TEXTBUF_ADDR
	call _cga_printtextln

	mov eax, dword TEST_DELAYTIME
	call _delay32

_testend:
	jmp _sysend

_teststr1: db 'sum', 0x0
_teststr2: db 'sub', 0x0
_teststr3: db 'mult', 0x0
_teststr4: db 'sum', 0x0

