;Test 7: "Hello World" loop in CGA

TESTDATA_SEG16 equ DATA0_SEG16
TEST_NCYCLE_INDEX16 equ 0x0
TEST_NCOLOR_INDEX16 equ 0x2

TEST_CYCLELIMIT equ 4

TEST_DELAYTIME_START equ 0x1000
TEST_DELAYTIME_LOOP equ 0x0200
TEST_DELAYTIME_END equ 0x1000

_teststart:
	push word $
	jmp _cga_clearscreen
	times RETURN_MARGIN_CALLER nop

	mov bx, word TESTDATA_SEG16
	mov es, bx
	mov di, word TEST_NCYCLE_INDEX16
	mov [es:di], word 0
	mov di, word TEST_NCOLOR_INDEX16
	mov [es:di], byte 0

	push word TEST_DELAYTIME_START
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

_testloop:
	mov bx, word TESTDATA_SEG16
	mov ds, bx
	mov si, word TEST_NCYCLE_INDEX16
	mov cx, word [ds:si]
	cmp cx, word TEST_CYCLELIMIT
	jae _testend

	xor ax, ax
	mov si, word TEST_NCOLOR_INDEX16
	mov al, byte [ds:si]

	push word ax
	push word $
	jmp _cga_setcolorbyte
	times RETURN_MARGIN_CALLER nop

	push word KERNEL_SEG16
	push word _teststr
	push word $
	jmp _cga_printtextln
	times RETURN_MARGIN_CALLER nop

	push word TEST_DELAYTIME_LOOP
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

	mov bx, word TESTDATA_SEG16
	mov es, bx

	mov di, word TEST_NCOLOR_INDEX16

	xor ax, ax
	mov al, byte [es:di]
	cmp al, byte 0x7f
	jae _testloop_l1

	inc al
	jmp _testloop_l2

	_testloop_l1:
	xor al, al
	mov si, word TEST_NCYCLE_INDEX16
	mov cx, word [es:si]
	inc cx
	mov [es:si], word cx

	_testloop_l2:
	mov [es:di], byte al

	jmp _testloop

_testend:
	push word TEST_DELAYTIME_END
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

	jmp _sysend

_teststr: db 'Hello World', 0x0

