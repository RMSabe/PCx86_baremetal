#!/bin/bash

if [ -f "system.img" ]; then
	rm system.img
fi

nasm boot.asm -f bin -o boot.bin
nasm kernel.asm -f bin -o kernel.bin
cat boot.bin kernel.bin >> system.img

