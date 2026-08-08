Mini-kernel 2 for PC 386 CPUs
Version 0.1

This is another mini-kernel for PC motherboards, targetting i386 compatible CPUs.
This mini-kernel is still at very early development stage, missing several useful components.
My idea with this project is to make a PC motherboard run a single simple program, similar to an arduino board.
I thought of maybe designing some very simple video-games on this mini-kernel.

I was finally able to integrate assembly language with C. While bootloader, GDT and some kernel parts are still written in assembly,
Most of the kernel is written in C.

This project is meant for didactic purposes.
It shouldn't be used as a replacement for professional projects.

I used GCC to compile the kernel, and NASM to build the bootloader/GDT.

NOTICE:
If you're running this project on an emulator or virtual machine, the boot process might fail if the binary (system.img) is not big enough.
The binary (system.img) is supposed to behave like a floppy disk image. It is devided into sectors where every sector is 512 bytes long.
When loading the kernel, the bootloader will attempt to read a fixed number of sectors (16 sectors in this version) from the virtual floppy disk.
However, the kernel binary is smaller than 16 sectors, which means the binary system.img will not be big enough to satisfy the read process, causing the boot to fail.
This can be mitigated by concatenating multiple blank sectors to the end of the binary file system.img.

There's a folder called "extras" which has the NASM assembly codes to generate blank binaries. These binaries can be concatenated to the end of system.img to make the file big enough.

Some virtual machines might require the system.img file size to be a multiple of 512. This can be done by editing the system.img file through a hex editor and adding some zeros to the end of the file,
until the file size is a multiple of 512 (hex 200h).

None of this should be a problem if you're using a physical floppy disk.

HINT:
If the bootloader process succeeds, it will print a white 'S' on blue background at the top left corner of the screen.
If the bootloader process fails, it will print a white 'F' on red background at the top left corner of the screen.

The kernel process entry-point is the _main function in the kmain.c file, (similar to the "main" function on a regular C/C++ code).
It is recommended to use the console resources to print a sentence like "Kernel Process Started" at the beginning of _main,
Just to be sure that kernel was loaded and _main started successfully.

When _main returns, the kernel will trap the CPU in an infinite loop, waiting for you to power off the machine.
I haven't yet learned how PC ACPI works, or how to restore BIOS interrupts and request a system shut down,
Which means the best I can do when kernel process is over is lock the CPU in an idle state and wait for you to unplug the machine.

Author: Rafael Sabe
Email: rafaelmsabe@gmail.com

