KERNEL_SEG16 equ 0x1000
KERNEL_INDEX16 equ 0x0000
KERNEL_BASE32 equ 0x10000
KERNEL_SIZE_SECTORS equ 8
KERNEL_SIZE_BYTES equ 4096

;Data 0 segment is used for system utilities such as keeping track of text line and color on CGA functions.
;Data 1 segment is used for general purpose

DATA0_SEG16 equ 0x2000
DATA0_BASE32 equ 0x20000

DATA1_SEG16 equ 0x4000
DATA1_BASE32 equ 0x40000

STACK_SEG16 equ 0x3000
STACK_BASE32 equ 0x30000
STACK_BP_INDEX16 equ 0xffff

;STACKLIST is basically a parallel stack.
;The main stack is usually filled by the caller function, while the stacklist is filled by the callee function.
;The INDEX16 value points to the next free space in the stacklist buffer. Its value must be updated every time something is pushed in/popped out the stacklist
STACKLIST_SEG16 equ 0x5000
STACKLIST_BASE32 equ 0x50000
P_STACKLIST_INDEX16 equ 0x1000

P_BOOTDEV equ 0x7e00

;In order to prevent skipping instructions and/or repeating instructions when returning from a function, these margins are used as a "landing area" from the callee function returning to the caller.
;The callee margin works by adding a margin value to the return address
;The callee function will return to address: return address + callee margin
;This is meant to prevent repeating instructions from the caller function.
;The caller margin works by adding no operand "nop" instructions after the callee function is called
;After the jump instruction in the caller function, an amount of "nop" instructions is added before the next "valid" instruction.
;This is meant to prevent skipping instructions from the caller function.
;NOTE: the caller margin should ideally be greater than the callee margin
RETURN_MARGIN_CALLER equ 0x10
RETURN_MARGIN_CALLEE equ 0xc

;Just a memory space that can be used to store a text string
;It can be used in either Data 0 segment or Data 1 segment
TEXTBUFFER equ 0x2000

