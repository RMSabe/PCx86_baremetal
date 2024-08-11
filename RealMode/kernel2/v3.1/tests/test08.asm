;Test 8: Test VGA 1

TESTDATA_SEG16 equ DATA0_SEG16
TEST_XPOS_INDEX16 equ 0x0
TEST_YPOS_INDEX16 equ 0x2

TEST_XPOS_START equ 20
TEST_XPOS_STOP equ 300
TEST_YPOS_START equ 20
TEST_YPOS_STOP equ 180

TEST_DELAYTIME_START equ 0x4000
TEST_DELAYTIME_LOOP equ 0x0001
TEST_DELAYTIME_END equ 0x8000

TEST_PAINTCOLOR1 equ 0x9
TEST_PAINTCOLOR2 equ 0xa
TEST_PAINTCOLOR3 equ 0xc
TEST_PAINTCOLOR4 equ 0xe

_teststart:
	push word $
	jmp _vga_init
	times RETURN_MARGIN_CALLER nop

	mov bx, word TESTDATA_SEG16
	mov es, bx

	mov si, TEST_XPOS_INDEX16
	mov di, TEST_YPOS_INDEX16

	mov [es:si], word TEST_XPOS_START
	mov [es:di], word TEST_YPOS_START

	push word TEST_DELAYTIME_START
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

_testloop:
	mov bx, word TESTDATA_SEG16
	mov ds, bx
	mov si, word TEST_YPOS_INDEX16
	mov dx, word [ds:si]
	cmp dx, word TEST_YPOS_STOP
	jae _testend

	mov si, word TEST_XPOS_INDEX16
	mov cx, word [ds:si]

	xor ax, ax

	cmp dx, word 100
	jae _testloop_paint3

	cmp cx, word 160
	jae _testloop_paint2

	_testloop_paint1:
	mov al, byte TEST_PAINTCOLOR1
	jmp _testloop_l1

	_testloop_paint2:
	mov al, byte TEST_PAINTCOLOR2
	jmp _testloop_l1

	_testloop_paint3:
	cmp cx, word 160
	jae _testloop_paint4

	mov al, byte TEST_PAINTCOLOR3
	jmp _testloop_l1

	_testloop_paint4:
	mov al, byte TEST_PAINTCOLOR4

	_testloop_l1:
	push word ax
	push word cx
	push word dx
	push word $
	jmp _vga_paintpixel_xy
	times RETURN_MARGIN_CALLER nop

	push word TEST_DELAYTIME_LOOP
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

	mov bx, word TESTDATA_SEG16
	mov es, bx

	mov si, word TEST_XPOS_INDEX16
	mov di, word TEST_YPOS_INDEX16

	mov cx, word [es:si]
	cmp cx, word TEST_XPOS_STOP
	jae _testloop_l2

	inc cx
	jmp _testloop_l3

	_testloop_l2:
	mov cx, word TEST_XPOS_START
	mov dx, word [es:di]
	inc dx
	mov [es:di], word dx

	_testloop_l3:
	mov [es:si], word cx

	jmp _testloop

_testend:
	push word TEST_DELAYTIME_END
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

	push word $
	jmp _cga_init
	times RETURN_MARGIN_CALLER nop

	jmp _sysend

