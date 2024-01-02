;Mini kernel for 386 PC
;Author: Rafael Sabe
;Email: rafaelmsabe@gmail.com

%include "includes/globaldef.asm"

org KERNEL_BASE32
bits 32

section kernel

_sysstart:
	mov ebp, dword STACK_BP_32
	mov esp, ebp

	call _cga_init

	call _cga_clearscreen

	mov eax, dword _kernelstr_loadsuccessful
	call _cga_printtextln

	mov eax, dword 0x20000000
	call _delay32

	jmp _sysmain

_sysend:
	call _cga_clearscreen

	mov eax, dword CGA_TEXTCOLOR_DEFAULT
	mov ebx, dword CGA_BKCOLOR_DEFAULT
	call _cga_setcolor

	mov eax, dword _kernelstr_processfinished
	call _cga_printtextln

	_sysend_loop:
	times 4 nop
	jmp _sysend_loop

_sysmain:
;Add main routine here

	jmp _sysend

%include "includes/time.asm"
%include "includes/inttostr.asm"
%include "includes/str_utils.asm"
%include "includes/cga_utils.asm"

_kernelstr_loadsuccessful: db 'Kernel load successful', 0x0
_kernelstr_processfinished: db 'Kernel process finished', 0x0

times KERNEL_SIZE_BYTES - ($ - $$) db 0x0

