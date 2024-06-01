ASM = nasm
ASM_FLAGS = -felf64

all: test

test: print_proc.o print_proc64.o wrapper.o
	ld wrapper.o print_proc.o print_proc64.o -o test

print_proc.o: print_proc.s
	$(ASM) $(ASM_FLAGS) print_proc.s

print_proc64.o: print_proc64.s
	$(ASM) $(ASM_FLAGS) print_proc64.s

wrapper.o: wrapper.s
	$(ASM) $(ASM_FLAGS) wrapper.s
