qemu:
	nasm -fbin src/boot.asm -o src/boot.bin
	nasm -fbin src/helloworld.asm -o src/helloworld.bin
	cat src/boot.bin src/helloworld.bin > out/program.bin
	qemu-system-i386 out/program.bin

hardware:
	nasm -fbin src/boot.asm -o src/boot.bin
	nasm -fbin src/helloworld.asm -o src/helloworld.bin
	cat src/boot.bin src/helloworld.bin > out/program.bin

clean:
	rm src/*.bin