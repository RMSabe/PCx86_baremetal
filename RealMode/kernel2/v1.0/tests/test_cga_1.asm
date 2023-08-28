test_cga_1:
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	mov bx, word $
	push word bx
	jmp cga_clearscreen
	times RETURN_MARGIN_CALLER nop

	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word CGA_COLOR_YELLOW
	push word CGA_COLOR_BLUE
	mov bx, word $
	push word bx
	jmp cga_setcolor
	times RETURN_MARGIN_CALLER nop

	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word 0
	push word 3
	mov bx, word $
	push word bx
	jmp cga_settextpos
	times RETURN_MARGIN_CALLER nop

	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word KERNEL_SEG16
	push word testcga_textstr1
	mov bx, word $
	push word bx
	jmp cga_print
	times RETURN_MARGIN_CALLER nop

	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word CGA_COLOR_LTGREEN
	push word CGA_COLOR_LTRED
	mov bx, word $
	push word bx
	jmp cga_setcolor
	times RETURN_MARGIN_CALLER nop

	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word 40
	push word 12
	mov bx, word $
	push word bx
	jmp cga_settextpos
	times RETURN_MARGIN_CALLER nop

	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word KERNEL_SEG16
	push word testcga_textstr2
	mov bx, word $
	push word bx
	jmp cga_print
	times RETURN_MARGIN_CALLER nop

	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word 0x4000
	mov bx, word $
	push word bx
	jmp hold_long
	times RETURN_MARGIN_CALLER nop

	jmp testcga_end

testcga_textstr1: db 'This is some text', 0x0
testcga_textstr2: db 'This is some other text', 0x0

testcga_end:

