global print_i32
global print_i16
;global print_i8

%define STDOUT 1
%define QWORD_SIZE(a) (a * 8)
%define DWORD_SIZE(a) (a * 4)
%define counter [rbp-1]
%define is_neg [rbp-2]
%define FALSE 0
%define TRUE 1

;rax: dividendo/quociente
;rcx: divisor
;rdx: resto
;rdi: argumento > STDOUT
;rsi: = rbp
;rbp: BP
;rsp: SP
section .text
;==========================================
;=========PRINT SIGNED 32 INTEGER==========
;==========================================
print_i32:
        ;start
        PUSH rbp
        MOV rbp, rsp
        SUB rsp, 3            ;Adiciona um byte de espaço a stack para a flag.
        MOV BYTE is_neg, FALSE;Empilha a flag na memoria.
        MOV BYTE [rsp], 0xa   ;Empilha uma quebra de linha. 
        
        MOV eax, edi        ;Guarda o arg0 uint em rax
        
;Gerenciamento de sinal
        TEST eax, eax       ;Compara rdx. rdx = 0 se o numero for positivo e -1 se negativo.
        JNS end_sh32         ;Pule se rdx = 0
;case_signed
        MOV BYTE is_neg, TRUE;Se rdx = -1, muda a flag para um, será util mais tarde.
        MOV edx, DWORD -1
        MUL edx              ;Multiplica rax por -1 para se inverter o sinal.
end_sh32:

        MOV ecx, 10         ;Guarda 10 no register divisor, pois é decimal.
        MOV BYTE counter,  1     ;Limpa o register contador com 1.
loop_i32:
        INC BYTE counter         ;Incrementa o contador.
        MOV edx, 0          ;Limpa o register resto.
         
        DIV ecx             ;Div para tirar o digito dec menos significativo de rax e guardar em rdx
        ADD dl, '0'         ;Add rdx a ascii '0' para obter o simbolo numerico ascii.
        
        SUB rsp, 1          ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl  ;Guarda o digito nesse espaço.
         
        TEST eax, eax       ;Compara o dividendo/quociente
        JNZ loop_i32        ;volta ao inicio do loop se o quociente for diferente de 0
      
        CMP BYTE is_neg, FALSE;Lê o valor da flag com 0, isso indica que o valor é positivo
        JE end                ;pula para o final se verdadeiro
        ;case_negative
        INC BYTE counter
        SUB rsp, 1          ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], '-' ;Guarda o digito nesse espaço.               
        JMP end
        
;==========================================
;=========PRINT SIGNED 32 INTEGER==========
;==========================================       
print_i16:
        ;start
        PUSH rbp
        MOV rbp, rsp
        SUB rsp, 3            ;Adiciona um byte de espaço a stack para a flag.
        MOV BYTE is_neg, FALSE;Empilha a flag na memoria.
        MOV BYTE [rsp], 0xa   ;Empilha uma quebra de linha.
                
        MOV ax, di         ;Guarda o arg0 uint em rax

;Gerenciamento de sinal
        TEST ax, ax        ;Compara rdx. rdx = 0 se o numero for positivo e -1 se negativo.
        JNS end_sh16        ;Pule se rdx = 0
;case_signed
        MOV BYTE is_neg, TRUE ;Se rdx = -1, muda a flag para um, será util mais tarde.
        MOV dx, WORD -1
        MUL dx                ;Multiplica rax por -1 para se inverter o sinal.
end_sh16:

        MOV cx, 10         ;Guarda 10 no register divisor, pois é decimal.
        MOV BYTE counter, 1;Limpa o register contador com 1.
loop_i16:
        INC BYTE counter   ;Incrementa o contador.
        MOV dx, 0          ;Limpa o register resto.
         
        DIV cx             ;Div para tirar o digito dec menos significativo de rax e guardar em rdx
        ADD dl, '0'        ;Add rdx a ascii '0' para obter o simbolo numerico ascii.
        
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl ;Guarda o digito nesse espaço.
         
        TEST ax, ax        ;Compara o dividendo/quociente
        JNZ loop_i16       ;volta ao inicio do loop se o quociente for diferente de 0

        CMP BYTE is_neg, FALSE ;Lê o valor da flag com 0, isso indica que o valor é positivo
        JE end                 ;pula para o final se verdadeiro
        ;case_negative
        INC BYTE counter
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], '-';Guarda o digito nesse espaço.               
        JMP end

end:
        ;write
        MOV rax, 1
        MOV rdi, STDOUT
        MOV rsi, rsp     ;guarda o stack pointer rsp no source register rsi
        MOV rdx, 0
        MOV dl, counter ;guarda o numero de bytes a serem lidos no registrador de dados rsx
        SYSCALL 

        ;end
        LEAVE
        RET
