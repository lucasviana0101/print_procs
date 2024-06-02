CC = clang
ASM = nasm
ASMFLAGS = -f elf64

all: app

app: print_proc64.o print_proc.o src/c/print_proc.h src/c/wrapper.c
	$(CC) src/c/wrapper.c print_proc64.o print_proc.o -o build/app
	mv print_proc.o build/print_proc.o
	mv print_proc64.o build/print_proc64.o

print_proc64.o: src/asm/print_proc64.s
	$(ASM) $(ASMFLAGS) src/asm/print_proc64.s -o print_proc64.o

print_proc.o: src/asm/print_proc.s
	$(ASM) $(ASMFLAGS) src/asm/print_proc.s -o print_proc.o

test: app
	build/app -9 0
