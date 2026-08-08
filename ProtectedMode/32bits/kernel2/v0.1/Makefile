buildboot:
	make -C boot buildall

buildkernel:
	make -C kernel buildall

buildextras:
	make -C extras buildall

system.img: buildboot buildkernel buildextras
	cat boot/bin/boot.bin boot/bin/gdt.bin kernel/bin/kernel.bin extras/bin/blankkernel.bin > system.img

buildall: buildboot buildkernel buildextras system.img

clearboot:
	make -C boot clearall

clearkernel:
	make -C kernel clearall

clearextras:
	make -C extras clearall

clearall: clearboot clearkernel clearextras
	rm system.img

run:
	qemu-system-i386 system.img


