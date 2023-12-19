;Test 10: Test VGA 3

TESTDATA_SEG16 equ DATA0_SEG16
TEST_XPOS_INDEX16 equ 0x0
TEST_YPOS_INDEX16 equ 0x2
TEST_NCYCLE_INDEX16 equ 0x4
TEST_NCOLOR_INDEX16 equ 0x6

TEST_DELAYTIME_START equ 0x4000
TEST_DELAYTIME_LOOP equ 0x0080
TEST_DELAYTIME_END equ 0x4000

TEST_NCYCLE_LIMIT equ 4

_teststart:
	push word $
	jmp _vga_init
	times RETURN_MARGIN_CALLER nop
	add sp, word 2

	mov bx, word TESTDATA_SEG16
	mov es, bx
	mov si, word TEST_XPOS_INDEX16
	mov di, word TEST_YPOS_INDEX16

	mov [es:si], word 0
	mov [es:di], word 0

	mov si, word TEST_NCYCLE_INDEX16
	mov di, word TEST_NCOLOR_INDEX16

	mov [es:si], word 0
	mov [es:di], byte 0

	push word TEST_DELAYTIME_START
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop
	add sp, word 4

_testloop:
	mov bx, word TESTDATA_SEG16
	mov ds, bx
	mov si, word TEST_NCYCLE_INDEX16
	mov cx, word [ds:si]
	cmp cx, word TEST_NCYCLE_LIMIT
	jae _testend

	mov si, word TEST_XPOS_INDEX16
	mov [ds:si], word 0

	_testloop_l1:
	xor ax, ax
	mov si, word TEST_NCOLOR_INDEX16
	mov al, byte [ds:si]

	mov si, word TEST_XPOS_INDEX16
	mov di, word TEST_YPOS_INDEX16
	mov cx, word [ds:si]
	mov dx, word [ds:di]

	push word ax
	push word cx
	push word dx
	push word $
	jmp _vga_paintpixel_xy
	times RETURN_MARGIN_CALLER nop
	add sp, word 8

	mov bx, word TESTDATA_SEG16
	mov ds, bx

	mov si, word TEST_XPOS_INDEX16
	mov cx, word [ds:si]
	cmp cx, word VGA_WIDTH
	jae _testloop_l2

	inc cx
	mov [ds:si], word cx
	jmp _testloop_l1

	_testloop_l2:

	push word TEST_DELAYTIME_LOOP
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop
	add sp, word 4

	mov bx, word TESTDATA_SEG16
	mov es, bx

	xor ax, ax
	mov si, word TEST_NCOLOR_INDEX16
	mov al, byte [es:si]
	inc al
	mov [es:si], byte al

	mov di, word TEST_YPOS_INDEX16
	mov dx, word [es:di]
	cmp dx, word VGA_HEIGHT
	jae _testloop_l3

	inc dx
	jmp _testloop_l4

	_testloop_l3:
	xor dx, dx
	mov si, word TEST_NCYCLE_INDEX16
	mov bx, word [es:si]
	inc bx
	mov [es:si], word bx

	_testloop_l4:
	mov [es:di], word dx

	jmp _testloop

_testend:
	push word TEST_DELAYTIME_END
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop
	add sp, word 4

	push word $
	jmp _cga_init
	times RETURN_MARGIN_CALLER nop
	add sp, word 2

	jmp _sysend

