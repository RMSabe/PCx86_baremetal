;Test 9: Test 2 VGA1
;WARNING: This test routine makes the screen blink in different colors, following the VGA1 color palette.
;If you have any history of seizures or epilepsy, make sure to set TEST_DELAYTIME_LOOP to a relatively high value, to avoid fast screen blinking

TESTDATA_SEG16 equ DATA0_SEG16
TEST_NCYCLE_INDEX16 equ 0x0
TEST_NCOLOR_INDEX16 equ 0x2

TEST_DELAYTIME_START equ 0x4000
TEST_DELAYTIME_LOOP equ 0x0400
TEST_DELAYTIME_END equ 0x8000

TEST_NCYCLE_LIMIT equ 1

_teststart:
	push word $
	jmp _vga1_init
	times RETURN_MARGIN_CALLER nop

	mov bx, word TESTDATA_SEG16
	mov es, bx

	mov di, word TEST_NCYCLE_INDEX16
	mov si, word TEST_NCOLOR_INDEX16

	mov [es:di], word 0
	mov [es:si], byte 0

	push word TEST_DELAYTIME_START
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

_testloop:
	mov bx, word TESTDATA_SEG16
	mov ds, bx
	mov si, word TEST_NCYCLE_INDEX16
	mov cx, word [ds:si]
	cmp cx, word TEST_NCYCLE_LIMIT
	jae _testend

	xor ax, ax
	mov si, word TEST_NCOLOR_INDEX16
	mov al, byte [ds:si]

	push word ax
	push word $
	jmp _vga1_paintscreen
	times RETURN_MARGIN_CALLER nop

	push word TEST_DELAYTIME_LOOP
	push word $
	jmp _delay_long
	times RETURN_MARGIN_CALLER nop

	mov bx, word TESTDATA_SEG16
	mov es, bx

	xor ax, ax
	mov si, word TEST_NCOLOR_INDEX16
	mov al, byte [es:si]

	cmp al, byte 0xff
	je _testloop_l1

	jmp _testloop_l2

	_testloop_l1:
	mov di, word TEST_NCYCLE_INDEX16
	mov cx, word [es:di]
	inc cx
	mov [es:di], word cx

	_testloop_l2:
	inc al
	mov [es:si], byte al

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

