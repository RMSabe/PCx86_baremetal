KERNEL_SEG16_ADDR equ 0x1000
KERNEL_INDEX16_ADDR equ 0x0000
KERNEL_BASE32_ADDR equ 0x10000
KERNEL_SIZE_BYTES equ 4096
KERNEL_SIZE_SECTORS equ 8

DATA_BASE32_ADDR equ 0x20000
STACK_BASE32_ADDR equ 0x40000

P_BOOTDEVICE equ 0x7e00

STACKLIST_BASE32_ADDR equ 0x50000
P_STACKLIST_INDEX32 equ 0x51000
;This stacklist is a parallel stack. It's useful when dealing with conditional functions inside other functions
;Values on stacklist should always be pushed in/popped out by the callee function
;Index32 is an 32bit unsigned integer that stores the offset to the next available space in the stacklist
;Index32 value should be updated every time a value is pushed in/popped out stacklist

