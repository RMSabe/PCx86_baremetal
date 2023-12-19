;Test 1: print 16bit unsigned integers

TESTDATA_SEG16 equ DATA0_SEG16
TEST_NUM16_INDEX equ 0x0

TEST_NUM16_START equ 0
TEST_NUM16_STOP equ 200

TEST_DELAYTIME_START equ 0x1000
TEST_DELAYTIME_LOOP equ 0x0400
TEST_DELAYTIME_END equ 0x1000

_teststart:
	mov ax, word TESTDATA_SEG16
	mov es, ax
	mov di, word TEST_NUM16_INDEX

	mov [es:di], word TEST_NUM16_START

	push word TEST_DELAYTIME_START
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop
	add sp, word 4

_testloop:
	mov ax, word TESTDATA_SEG16
	mov ds, ax
	mov si, word TEST_NUM16_INDEX
	mov cx, word [ds:si]
	cmp cx, word TEST_NUM16_STOP
	jae _testend

	push word cx
	push word KERNEL_SEG16
	push word _textbuf
	push word $
	jmp _loadstr_dec_u16
	times RETURN_MARGIN_CALLER nop
	add sp, word 8

	push word KERNEL_SEG16
	push word _textbuf
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop
	add sp, word 6

	push word TEST_DELAYTIME_LOOP
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop
	add sp, word 4

	mov ax, word TESTDATA_SEG16
	mov ds, ax
	mov si, word TEST_NUM16_INDEX
	mov cx, word [ds:si]
	inc cx
	mov [ds:si], word cx

	jmp _testloop

_testend:
	push word TEST_DELAYTIME_END
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop
	add sp, word 4

	jmp _sysend

