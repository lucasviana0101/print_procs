global print_u64
global print_i64
global print_hex

%define STDOUT 1
%define QWORD_SIZE(a) (a * 8)
%define DWORD_SIZE(a) (a * 4)

;section .data
;        MSG DB "16", 0xa

;rax: dividendo/quociente
;rcx: divisor
;rdx: resto
;rbx: contador
;rdi: argumento > STDOUT
;rsi: = rbp
;rbp: BP
;rsp: SP
section .text
;==========================================
;=====PRINT UNSIGNED 64 INTEGER IN HEX=====
;==========================================
print_hex:
        ;start
        PUSH rbp  
        MOV rbp, rsp
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], 0xa;Adiciona uma quebra de linha no final. 

        MOV rax, rdi       ;Guarda o arg0 uint em rax
        MOV rcx, 16        ;Guarda 10 no register divisor, pois é decimal.
        MOV rbx, 1;Limpa o register contador.
loop_hex:
        INC rbx           ;Incrementa o contador.
        MOV rdx, 0        ;Limpa o register resto.
         
        DIV rcx           ;Div para tirar o digito dec menos significativo de rax e guardar em rdx
        CMP dl, 0xA
        JGE case0_eg
        case0_l:
                ADD dl, '0';Add rdx a ascii '0' para obter o simbolo numerico ascii.
                JMP end_case0 
        case0_eg:
                ADD dl, '0'+('@'-'9');Add rdx a ascii '0' para obter o simbolo numerico ascii.
        end_case0:
        
        SUB rsp, 1        ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl;Guarda o digito nesse espaço.
         
        TEST rax, rax     ;Compara o dividendo/quociente
        JNZ loop_hex      ;volta ao inicio do loop se o quociente for diferente de 0

        JMP end
;==========================================
;========PRINT UNSIGNED 64 INTEGER=========
;==========================================
print_u64:
        ;start
        PUSH rbp  
        MOV rbp, rsp
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], 0xa;Adiciona uma quebra de linha no final. 

        MOV rax, rdi       ;Guarda o arg0 uint em rax
        MOV rcx, 10        ;Guarda 10 no register divisor, pois é decimal.
        MOV rbx, 1;Limpa o register contador.
loop_u64:
        INC rbx           ;Incrementa o contador.
        MOV rdx, 0        ;Limpa o register resto.
         
        DIV rcx           ;Div para tirar o digito dec menos significativo de rax e guardar em rdx
        ADD dl, '0'       ;Add rdx a ascii '0' para obter o simbolo numerico ascii.
        
        SUB rsp, 1        ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl;Guarda o digito nesse espaço.
         
        TEST rax, rax     ;Compara o dividendo/quociente
        JNZ loop_u64      ;volta ao inicio do loop se o quociente for diferente de 0

        JMP end


;==========================================
;=========PRINT SIGNED 64 INTEGER==========
;==========================================
print_i64:
        ;start
        PUSH rbp
        MOV rbp, rsp
        SUB rsp, 1         ;Adiciona um byte de espaço a stack para a flag.
        MOV BYTE [rsp], 0  ;Empilha a flag na memoria.
        SUB rsp, 1         ;Adiciona um byte de espaço a stack.
        MOV BYTE [rsp], 0xa;Empilha uma quebra de linha. 
        
        MOV rax, rdi       ;Guarda o arg0 uint em rax

sign_handling:
        MOV rdx, rax       ;Copia rax para edx
        SAR rdx, 0x3F      ;SAR o sign bit para que preencha todo o register.   
        TEST rdx, rdx      ;Compara rdx. rdx = 0 se o numero for positivo e -1 se negativo.
        JZ end_signh       ;Pule se rdx = 0
case_signed:
        MOV BYTE [rbp-1], 1  ;Se rdx = -1, muda a flag para um, será util mais tarde.
        MUL rdx       ;Multiplica rax por -1 para se inverter o sinal.
end_signh:

        MOV rcx, 10        ;Guarda 10 no register divisor, pois é decimal.
        MOV rbx,  1;Limpa o register contador com 1.
loop_i64:
        INC rbx            ;Incrementa o contador.
        MOV rdx, 0         ;Limpa o register resto.
         
        DIV rcx            ;Div para tirar o digito dec menos significativo de rax e guardar em rdx
        ADD dl, '0'        ;Add rdx a ascii '0' para obter o simbolo numerico ascii.
        
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl ;Guarda o digito nesse espaço.
         
        TEST rax, rax      ;Compara o dividendo/quociente
        JNZ loop_i64       ;volta ao inicio do loop se o quociente for diferente de 0
             

        CMP BYTE [rbp-1], 0  ;Lê o valor da flag com 0, isso indica que o valor é positivo
        JE end             ;pula para o final se verdadeiro
case_negative:
        INC rbx
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], '-' ;Guarda o digito nesse espaço.               
        JMP end

end:
        ;write
        MOV rax, 1
        MOV rdi, STDOUT
        MOV rsi, rsp ;guarda o stack pointer rsp no source register rsi
        MOV rdx, rbx ;guarda o numero de bytes a serem lidos no registrador de dados rsx
        SYSCALL 

        ;end
        LEAVE
        RET
