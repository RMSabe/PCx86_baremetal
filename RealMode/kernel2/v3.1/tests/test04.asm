;Test 4: print 32bit signed integers
;WARNING: only compatible with i386 and above CPUs

TESTDATA_SEG16 equ DATA0_SEG16
TEST_NUM32_INDEX equ 0x0

TEST_NUM32_START equ -100
TEST_NUM32_STOP equ 100

TEST_DELAYTIME32_START equ 0x10000000
TEST_DELAYTIME32_LOOP equ 0x08000000
TEST_DELAYTIME32_END equ 0x10000000

_teststart:
	mov ax, word TESTDATA_SEG16
	mov es, ax
	mov di, word TEST_NUM32_INDEX

	mov [es:di], dword TEST_NUM32_START

	push dword TEST_DELAYTIME32_START
	push word $
	jmp _delay32
	times RETURN_MARGIN_CALLER nop

_testloop:
	mov ax, word TESTDATA_SEG16
	mov ds, ax
	mov si, word TEST_NUM32_INDEX
	mov ecx, dword [ds:si]
	cmp ecx, dword TEST_NUM32_STOP
	jge _testend

	push dword ecx
	push word KERNEL_SEG16
	push word _textbuf
	push word $
	jmp _loadstr_dec_s32
	times RETURN_MARGIN_CALLER nop

	push word KERNEL_SEG16
	push word _textbuf
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop

	push dword TEST_DELAYTIME32_LOOP
	push word $
	jmp _delay32
	times RETURN_MARGIN_CALLER nop

	mov ax, word TESTDATA_SEG16
	mov ds, ax
	mov si, word TEST_NUM32_INDEX
	mov ecx, dword [ds:si]
	inc ecx
	mov [ds:si], dword ecx

	jmp _testloop

_testend:
	push dword TEST_DELAYTIME32_END
	push word $
	jmp _delay32
	times RETURN_MARGIN_CALLER nop

	jmp _sysend

