buildall:
	gcc _kstart.S -c -fno-pic -fno-pie -fno-stack-protector -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -m32 -o bin/kstart.o
	gcc _krodat.S -c -fno-pic -fno-pie -fno-stack-protector -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -m32 -o bin/krodat.o
	gcc kmain.c -c -fno-pic -fno-pie -fno-stack-protector -m32 -o bin/kmain.o
	gcc globldef.c -c -fno-pic -fno-pie -fno-stack-protector -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -m32 -o bin/globldef.o
	gcc cstr.c -c -fno-pic -fno-pie -fno-stack-protector -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -m32 -o bin/cstr.o
	gcc console.c -c -fno-pic -fno-pie -fno-stack-protector -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -m32 -o bin/console.o
	gcc bin/*.o -T lscript.ld -m32 -ffreestanding -nostdlib -no-pie -fno-stack-protector -Wl,--no-eh-frame-hdr,--no-dynamic-linker,--no-ld-generated-unwind-info,--build-id=none -o bin/kernel.elf
	objcopy -j .__kernel__ -j .text.__x86.get_pc_thunk.ax -j .eh_frame -O binary bin/kernel.elf bin/kernel.bin

clearall:
	rm bin/*.o
	rm bin/*.elf
	rm bin/*.bin

