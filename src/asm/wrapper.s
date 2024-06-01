global _start
extern printf

%include "print_proc.inc"
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


print:
        PUSH rbp
        MOV rbp, rsp
        ;code here:
        
        MOV rsp, rbp
        POP rbp
        RET
        
