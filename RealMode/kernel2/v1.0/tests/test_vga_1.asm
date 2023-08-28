TESTVGA_COLOR1 equ 0x44
TESTVGA_COLOR2 equ 0x2f
TESTVGA_COLOR3 equ 0x21
TESTVGA_COLOR4 equ 0x28

TESTVGA_XSTART equ 20
TESTVGA_YSTART equ 20
TESTVGA_XEND equ 300
TESTVGA_YEND equ 180

TESTVGA_HOLDTIME_START equ 0x8000
TESTVGA_HOLDTIME_LOOP equ 0x2
TESTVGA_HOLDTIME_END equ 0x8000

P_TESTVGA_XPOS16 equ 0x0
P_TESTVGA_YPOS16 equ 0x2

test_vga:
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	mov bx, word $
	push word bx
	jmp vga_init
	times RETURN_MARGIN_CALLER nop
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word TESTVGA_HOLDTIME_START
	mov bx, word $
	push word bx
	jmp hold_long
	times RETURN_MARGIN_CALLER nop

	mov ax, word DATA1_SEG16
	mov ds, ax
	mov si, word P_TESTVGA_XPOS16
	mov [ds:si], word TESTVGA_XSTART
	mov si, word P_TESTVGA_YPOS16
	mov [ds:si], word TESTVGA_YSTART

test_vga_loop:
	mov ax, word DATA1_SEG16
	mov ds, ax
	mov si, word P_TESTVGA_XPOS16
	mov cx, word [ds:si]
	mov si, word P_TESTVGA_YPOS16
	mov dx, word [ds:si]

	cmp dx, word 100
	ja test_vga_loop_l3

	test_vga_loop_l2:
	cmp cx, word 160
	ja test_vga_loop_color2
	jmp test_vga_loop_color1

	test_vga_loop_l3:
	cmp cx, word 160
	ja test_vga_loop_color4
	jmp test_vga_loop_color3

	test_vga_loop_color1:
	mov ax, word TESTVGA_COLOR1
	jmp test_vga_loop_l1

	test_vga_loop_color2:
	mov ax, word TESTVGA_COLOR2
	jmp test_vga_loop_l1

	test_vga_loop_color3:
	mov ax, word TESTVGA_COLOR3
	jmp test_vga_loop_l1

	test_vga_loop_color4:
	mov ax, word TESTVGA_COLOR4

	test_vga_loop_l1:
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word ax
	push word cx
	push word dx
	mov bx, word $
	push word bx
	jmp vga_paintpixel_xy
	times RETURN_MARGIN_CALLER nop

	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word TESTVGA_HOLDTIME_LOOP
	mov bx, word $
	push word bx
	jmp hold_long
	times RETURN_MARGIN_CALLER nop

	mov ax, word DATA1_SEG16
	mov ds, ax
	mov si, word P_TESTVGA_XPOS16
	mov cx, word [ds:si]
	mov si, word P_TESTVGA_YPOS16
	mov dx, word [ds:si]

	cmp cx, word TESTVGA_XEND
	ja test_vga_loop_l5
	inc cx
	jmp test_vga_loop_l4

	test_vga_loop_l5:
	mov cx, word TESTVGA_XSTART
	cmp dx, word TESTVGA_YEND
	ja test_vga_hold
	inc dx
	mov si, word P_TESTVGA_YPOS16
	mov [ds:si], word dx

	test_vga_loop_l4:
	mov si, word P_TESTVGA_XPOS16
	mov [ds:si], word cx

	jmp test_vga_loop

test_vga_hold:
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word TESTVGA_HOLDTIME_END
	mov bx, word $
	push word bx
	jmp hold_long
	times RETURN_MARGIN_CALLER nop

test_vga_end:
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	mov bx, word $
	push word bx
	jmp cga_init
	times RETURN_MARGIN_CALLER nop

