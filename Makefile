CC = clang
ASM = nasm
ASMFLAGS = -f elf64
SRC_C = src/c
SRC_ASM = src/asm
BUILD = build

all: app

release: print_proc64.o print_proc.o

app: print_proc64.o print_proc.o $(SRC_C)/print_procs.h $(SRC_C)/wrapper.c
	$(CC) src/c/wrapper.c print_proc64.o print_proc.o -o build/app
	mv print_proc.o $(BUILD)/print_proc.o
	mv print_proc64.o $(BUILD)/print_proc64.o

print_proc64.o: $(SRC_ASM)/print_proc64.asm
	$(ASM) $(ASMFLAGS) src/asm/print_proc64.asm -o print_proc64.o

print_proc.o: $(SRC_ASM)/print_proc.asm
	$(ASM) $(ASMFLAGS) src/asm/print_proc.asm -o print_proc.o

test: app
	build/app -9 0

install: release ./install.sh
	mv print_proc.o $(BUILD)/print_proc.o
	mv print_proc64.o $(BUILD)/print_proc64.o
	bash ./install.sh

uninstall:
	rm ~/.local/include/print_procs.asmh
	rm ~/.local/lib/print_proc.o
	rm ~/.local/lib/print_proc64.o
