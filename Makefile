qemu:
	nasm -fbin src/boot.asm -o src/boot.bin
	nasm -fbin src/game.asm -o src/game.bin
	cat src/boot.bin src/game.bin > out/program.bin
	qemu-system-i386 out/program.bin

debugServer:
	nasm -fbin src/boot.asm -o src/boot.bin
	nasm -fbin src/game.asm -o src/game.bin
	cat src/boot.bin src/game.bin > out/program.bin
	qemu-system-i386 -s -S out/program.bin

debugClient:
	gdb -ex "target remote localhost:1234" -ex "set architecture i8086" -ex "set disassembly-flavor intel" -ex "b *0x7C00" -ex "b *0x8000" -ex "c"

hardware:
	nasm -fbin src/boot.asm -o src/boot.bin
	nasm -fbin src/game.asm -o src/game.bin
	cat src/boot.bin src/game.bin > out/program.bin
	sudo umount /dev/sdb
	sudo dd if=out/program.bin of=/dev/sdb bs=1536 count=1

hardwareU:
	nasm -fbin src/boot.asm -o src/boot.bin
	nasm -fbin src/game.asm -o src/game.bin
	cat src/boot.bin src/game.bin > out/program.bin
	sudo dd if=out/program.bin of=/dev/sdb1 bs=1536 count=1

clean:
	rm src/*.bin