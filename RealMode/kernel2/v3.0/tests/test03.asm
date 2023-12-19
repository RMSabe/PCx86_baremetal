;Test 3: print 32bit unsigned integers
;WARNING: only compatible with i386 and above CPUs

TESTDATA_SEG16 equ DATA0_SEG16
TEST_NUM32_INDEX equ 0x0

TEST_NUM32_START equ 0
TEST_NUM32_STOP equ 200

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
	add sp, word 6

_testloop:
	mov ax, word TESTDATA_SEG16
	mov ds, ax
	mov si, word TEST_NUM32_INDEX
	mov ecx, dword [ds:si]
	cmp ecx, dword TEST_NUM32_STOP
	jae _testend

	push dword ecx
	push word KERNEL_SEG16
	push word _textbuf
	push word $
	jmp _loadstr_dec_u32
	times RETURN_MARGIN_CALLER nop
	add sp, word 10

	push word KERNEL_SEG16
	push word _textbuf
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop
	add sp, word 6

	push dword TEST_DELAYTIME32_LOOP
	push word $
	jmp _delay32
	times RETURN_MARGIN_CALLER nop
	add sp, word 6

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
	add sp, word 6

	jmp _sysend

