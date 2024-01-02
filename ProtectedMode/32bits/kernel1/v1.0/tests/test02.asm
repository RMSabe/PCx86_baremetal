;Test 2: print 32bit signed integers

TEST_NUM32_ADDR equ USER_MEMSPACE

TEST_NUM32_START equ -100
TEST_NUM32_STOP equ 100

TEST_DELAYTIME_START equ 0x10000000
TEST_DELAYTIME_LOOP equ 0x04000000
TEST_DELAYTIME_END equ 0x10000000

_teststart:
	mov edi, dword TEST_NUM32_ADDR
	mov [edi], dword TEST_NUM32_START

	mov eax, dword TEST_DELAYTIME_START
	call _delay32

_testloop:
	mov esi, dword TEST_NUM32_ADDR
	mov ecx, dword [esi]
	cmp ecx, dword TEST_NUM32_STOP
	jge _testend

	mov eax, ecx
	mov ebx, dword TEXTBUF_ADDR
	call _loadstr_dec_s32

	mov eax, dword TEXTBUF_ADDR
	call _cga_printtextln

	mov eax, dword TEST_DELAYTIME_LOOP
	call _delay32

	mov edi, dword TEST_NUM32_ADDR
	mov ecx, dword [edi]
	inc ecx
	mov [edi], dword ecx

	jmp _testloop

_testend:
	mov eax, dword TEST_DELAYTIME_END
	call _delay32

	jmp _sysend

