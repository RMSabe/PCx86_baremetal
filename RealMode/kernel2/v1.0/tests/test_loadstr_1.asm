P_NUMBER16 equ 0x0
TEST_HOLDTIME equ 0x400

test_loadstr_l1:
	mov ax, word DATA1_SEG16
	mov ds, ax
	mov si, word P_NUMBER16
	mov [ds:si], word 0

test_loadstr_loop_1:
	mov ax, word DATA1_SEG16
	mov ds, ax
	mov si, word P_NUMBER16
	mov cx, word [ds:si]
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word cx
	push word DATA0_SEG16
	push word TEXTBUFFER
	mov bx, word $
	push word bx
	jmp loadstr_dec_u16
	times RETURN_MARGIN_CALLER nop
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word DATA0_SEG16
	push word TEXTBUFFER
	mov bx, word $
	push word bx
	jmp cga_println
	times RETURN_MARGIN_CALLER nop
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word TEST_HOLDTIME
	mov bx, word $
	push word bx
	jmp hold_long
	times RETURN_MARGIN_CALLER nop
	mov ax, word DATA1_SEG16
	mov ds, ax
	mov si, word P_NUMBER16
	mov cx, word [ds:si]
	cmp cx, word 200
	jae test_loadstr_l2
	inc cx
	mov [ds:si], word cx
	jmp test_loadstr_loop_1

test_loadstr_l2:
	mov ax, word DATA1_SEG16
	mov ds, ax
	mov si, word P_NUMBER16
	mov [ds:si], word -100

test_loadstr_loop_2:
	mov ax, word DATA1_SEG16
	mov ds, ax
	mov si, word P_NUMBER16
	mov cx, word [ds:si]
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word cx
	push word DATA0_SEG16
	push word TEXTBUFFER
	mov bx, word $
	push word bx
	jmp loadstr_dec_s16
	times RETURN_MARGIN_CALLER nop
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word DATA0_SEG16
	push word TEXTBUFFER
	mov bx, word $
	push word bx
	jmp cga_println
	times RETURN_MARGIN_CALLER nop
	mov bp, word STACK_BP_INDEX16
	mov sp, bp
	push word TEST_HOLDTIME
	mov bx, word $
	push word bx
	jmp hold_long
	times RETURN_MARGIN_CALLER nop
	mov ax, word DATA1_SEG16
	mov ds, ax
	mov si, word P_NUMBER16
	mov cx, word [ds:si]
	cmp cx, word 100
	jge test_loadstr_end
	inc cx
	mov [ds:si], word cx
	jmp test_loadstr_loop_2

test_loadstr_end:

