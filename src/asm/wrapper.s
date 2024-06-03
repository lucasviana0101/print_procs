global _start
extern printf

%include "print_procs.asmh"
section .text
_start:
        MOV rbp, rsp
             
        MOV rdi, rbp
        CALL print_u64
        MOV rdi, rbp
        CALL print_u64

end:
        MOV rax, 60
        SYSCALL       
