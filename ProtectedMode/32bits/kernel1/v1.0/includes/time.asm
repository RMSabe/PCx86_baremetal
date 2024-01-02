;Mini kernel for 386 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

;FUNCTION: delay runtime by a given number of cycles
;args: eax (delay time)
_delay32:
	push dword ebp
	mov ebp, esp

	mov esi, ebp
	sub esi, dword 4
	mov [esi], dword eax

	sub esp, dword 4

	;ebp + 4 == return

	;ebp - 4 == arg0 delay time

	mov ebx, eax

	xor ecx, ecx
	_delay32_loop:
	cmp ecx, ebx
	jae _delay32_endloop
	inc ecx
	jmp _delay32_loop
	_delay32_endloop:

	_delay32_return:
	mov esp, ebp
	pop dword ebp
	ret

