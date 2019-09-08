all: run

.PHONY=clean run


run: Image
	- @qemu-system-i386 -boot a -fda Image


bootsect.o: bootsect.S
	- @as --32 bootsect.S -o bootsect.o


bootsect: bootsect.o ld-bootsect.ld
	- @ld -T ld-bootsect.ld bootsect.o -o bootsect
	- @objcopy -O binary -j .text bootsect

Image:	bootsect setup binary
	- @dd if=bootsect of=Image bs=512 count=1
	- @dd if=setup of=Image bs=512 count=4 seek=1
	- @dd if=binary of=Image bs=512 seek=5
	- @echo "Image build done"
setup: setup.o
	- @ld -T ld-bootsect.ld setup.o -o setup
	- @objcopy -O binary -j .text setup

binary: binary.o
	- @ld -T ld-bootsect.ld binary.o -o binary
	- @objcopy -O binary -j .text binary

binary.o: binary.S
	- @as --32 binary.S -o binary.o

clean:
	- @rm -f *.o bootsect setup binary Image 

setup.o: setup.S
	- @as --32 setup.S -o setup.o
