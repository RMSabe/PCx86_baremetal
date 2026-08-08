; Mini Kernel 2 for 386 PCs.
; Version 0.1
;
; Author: Rafael Sabe
; Email: rafaelmsabe@gmail.com

%include "_globldef.inc"

section __GDT_MEMBLOCK__
org GDT_MEMBLOCK_ADDR32
bits 16

_gdt_desc:
	dw (GDT_SIZE_BYTES - 1)
	dd GDT_ADDR32

times (GDT_DESC_SIZE_BYTES - ($ - $$)) db 0

_gdt:
	_gdt_seg_0:
	dd 0
	dd 0
	_gdt_seg_1:
	dw (KERNEL_MEMBLOCK_SIZE_BYTES & 0xffff)
	dw (KERNEL_MEMBLOCK_ADDR32 & 0xffff)
	db ((KERNEL_MEMBLOCK_ADDR32 >> 16) & 0xff)
	db 0b10011010
	db ((0b0100 << 4) | (KERNEL_MEMBLOCK_SIZE_BYTES >> 16))
	db (KERNEL_MEMBLOCK_ADDR32 >> 24)
	_gdt_seg_2:
	dw (DATA_MEMBLOCK_SIZE_BYTES & 0xffff)
	dw (DATA_MEMBLOCK_ADDR32 & 0xffff)
	db ((DATA_MEMBLOCK_ADDR32 >> 16) & 0xff)
	db 0b10010010
	db ((0b0100 << 4) | (DATA_MEMBLOCK_SIZE_BYTES >> 16))
	db (DATA_MEMBLOCK_ADDR32 >> 24)

times (GDT_DISKBLOCK_SIZE_BYTES - ($ - $$)) db 0

