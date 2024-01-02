;Test 6: Test CGA: "Hello World" loop in CGA

TEST_NCYCLE_ADDR equ USER_MEMSPACE
TEST_NCOLOR_ADDR equ (USER_MEMSPACE + 4)

TEST_CYCLELIMIT equ 4

TEST_DELAYTIME_START equ 0x10000000
TEST_DELAYTIME_LOOP equ 0x02000000
TEST_DELAYTIME_END equ 0x10000000

_teststart:
	call _cga_clearscreen

	mov edi, dword TEST_NCYCLE_ADDR
	mov [edi], dword 0
	mov edi, dword TEST_NCOLOR_ADDR
	mov [edi], byte 0

	mov eax, dword TEST_DELAYTIME_START
	call _delay32

_testloop:
	mov esi, dword TEST_NCYCLE_ADDR
	mov ecx, dword [esi]
	cmp ecx, dword TEST_CYCLELIMIT
	jae _testend

	xor eax, eax
	mov esi, dword TEST_NCOLOR_ADDR
	mov al, byte [esi]

	call _cga_setcolorbyte

	mov eax, dword _teststr
	call _cga_printtextln

	mov eax, dword TEST_DELAYTIME_LOOP
	call _delay32

	mov edi, dword TEST_NCOLOR_ADDR

	xor eax, eax
	mov al, byte [edi]
	cmp al, byte 0x7f
	jae _testloop_l1

	inc al
	jmp _testloop_l2

	_testloop_l1:
	xor al, al
	mov esi, dword TEST_NCYCLE_ADDR
	mov ecx, dword [esi]
	inc ecx
	mov [esi], dword ecx

	_testloop_l2:
	mov [edi], byte al

	jmp _testloop

_testend:
	mov eax, dword TEST_DELAYTIME_END
	call _delay32

	jmp _sysend

_teststr: db 'Hello World', 0x0

