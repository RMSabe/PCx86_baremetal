;Test 5: Test CGA 2 test clear text

TEST_TEXTCOLOR equ CGA_TEXTCOLOR_WHITE
TEST_BKCOLOR equ CGA_BKCOLOR_BLUE

TEST_DELAYTIME_START equ 0x80000000
TEST_DELAYTIME_MID1 equ 0x80000000
TEST_DELAYTIME_MID2 equ 0x80000000
TEST_DELAYTIME_END equ 0x80000000

_teststart:
	mov eax, dword TEST_TEXTCOLOR
	mov ebx, dword TEST_BKCOLOR
	call _cga_setcolor

	call _cga_cleartext

	mov eax, dword TEST_DELAYTIME_START
	call _delay32

	mov eax, dword _teststr1
	call _cga_printtextln

	mov eax, dword TEST_DELAYTIME_MID1
	call _delay32

	call _cga_cleartext

	mov eax, dword TEST_DELAYTIME_MID2
	call _delay32

	mov eax, dword _teststr2
	call _cga_printtextln

	mov eax, dword TEST_DELAYTIME_END
	call _delay32

_testend:
	jmp _sysend

_teststr1: db 'Hello There', 0x0
_teststr2: db 'Oh hi', 0x0

