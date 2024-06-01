global print_i32
global print_i16
;global print_i8

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
print_i32:
        ;start
        PUSH rbp
        MOV rbp, rsp
        SUB rsp, 1         ;Adiciona um byte de espaço a stack para a flag.
        MOV BYTE [rsp], 0  ;Empilha a flag na memoria.
        SUB rsp, 1         ;Adiciona um byte de espaço a stack.
        MOV BYTE [rsp], 0xa;Empilha uma quebra de linha. 
        
        MOV eax, edi       ;Guarda o arg0 uint em rax

sh32:
        MOV edx, eax       ;Copia rax para edx
        SAR edx, 0x1F      ;SAR o sign bit para que preencha todo o register.   
        TEST edx, edx      ;Compara rdx. rdx = 0 se o numero for positivo e -1 se negativo.
        JZ end_sh32       ;Pule se rdx = 0
;case_signed
        MOV BYTE [rbp-1], 1  ;Se rdx = -1, muda a flag para um, será util mais tarde.
        MUL edx       ;Multiplica rax por -1 para se inverter o sinal.
end_sh32:

        MOV ecx, 10        ;Guarda 10 no register divisor, pois é decimal.
        MOV rbx,  1;Limpa o register contador com 1.
loop_i32:
        INC rbx            ;Incrementa o contador.
        MOV edx, 0         ;Limpa o register resto.
         
        DIV ecx            ;Div para tirar o digito dec menos significativo de rax e guardar em rdx
        ADD dl, '0'        ;Add rdx a ascii '0' para obter o simbolo numerico ascii.
        
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl ;Guarda o digito nesse espaço.
         
        TEST eax, eax      ;Compara o dividendo/quociente
        JNZ loop_i32       ;volta ao inicio do loop se o quociente for diferente de 0
      
        CMP BYTE [rbp-1], 0  ;Lê o valor da flag com 0, isso indica que o valor é positivo
        JE end             ;pula para o final se verdadeiro
        ;case_negative
        INC rbx
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], '-' ;Guarda o digito nesse espaço.               
        JMP end
        
print_i16:
        ;start
        PUSH rbp
        MOV rbp, rsp
        SUB rsp, 1         ;Adiciona um byte de espaço a stack para a flag.
        MOV BYTE [rsp], 0  ;Empilha a flag na memoria.
        SUB rsp, 1         ;Adiciona um byte de espaço a stack.
        MOV BYTE [rsp], 0xa;Empilha uma quebra de linha.
                
        MOV ax, di       ;Guarda o arg0 uint em rax

sh16:
        MOV dx, ax       ;Copia rax para edx
        SAR dx, 0x1F      ;SAR o sign bit para que preencha todo o register.   
        TEST dx, dx      ;Compara rdx. rdx = 0 se o numero for positivo e -1 se negativo.
        JZ end_sh16       ;Pule se rdx = 0
;case_signed
        MOV BYTE [rbp-1], 1  ;Se rdx = -1, muda a flag para um, será util mais tarde.
        MUL dx       ;Multiplica rax por -1 para se inverter o sinal.
end_sh16:

        MOV cx, 10        ;Guarda 10 no register divisor, pois é decimal.
        MOV rbx, 1;Limpa o register contador com 1.
loop_i16:
        INC rbx            ;Incrementa o contador.
        MOV dx, 0         ;Limpa o register resto.
         
        DIV cx            ;Div para tirar o digito dec menos significativo de rax e guardar em rdx
        ADD dl, '0'        ;Add rdx a ascii '0' para obter o simbolo numerico ascii.
        
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl ;Guarda o digito nesse espaço.
         
        TEST ax, ax      ;Compara o dividendo/quociente
        JNZ loop_i16       ;volta ao inicio do loop se o quociente for diferente de 0

        CMP BYTE [rbp-1], 0  ;Lê o valor da flag com 0, isso indica que o valor é positivo
        JE end             ;pula para o final se verdadeiro
        ;case_negative
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
