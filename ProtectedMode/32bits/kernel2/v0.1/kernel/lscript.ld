/*
 * Mini Kernel 2 for 386 PCs.
 * Version 0.1
 *
 * Author: Rafael Sabe
 * Email: rafaelmsabe@gmail.com
 */

DISK_SECTOR_SIZE_BYTES = 0x200;

KERNEL_MEMBLOCK_ADDR32 = 0x00010000;
KERNEL_MEMBLOCK_SIZE_SECTORS = 0x10;
KERNEL_MEMBLOCK_SIZE_BYTES = (KERNEL_MEMBLOCK_SIZE_SECTORS*DISK_SECTOR_SIZE_BYTES);

DATA_MEMBLOCK_ADDR32 = 0x00030000;
DATA_MEMBLOCK_SIZE_BYTES = 0x1ffff;

MEMORY
{
	KERNEL (rx) : ORIGIN = KERNEL_MEMBLOCK_ADDR32 , LENGTH = KERNEL_MEMBLOCK_SIZE_BYTES
	DATA (rw) : ORIGIN = DATA_MEMBLOCK_ADDR32 , LENGTH = DATA_MEMBLOCK_SIZE_BYTES
}

ENTRY(_start);

SECTIONS
{
	.__kernel__ : {
		*(.__kernel_start__);
		*(.__kernel__);
		*(.text .text.*);
		*(.__rodata__);
		*(.rodata .rodata.*);
	} > KERNEL

	.__data__ : {
		*(.__data__);
		*(.data .data.*);
		*(.bss .bss.*);
	} > DATA
}

