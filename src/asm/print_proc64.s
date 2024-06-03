global print_u64
global print_i64
global print_hex

%define STDOUT 1
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
;=====PRINT UNSIGNED 64 INTEGER IN HEX=====
;==========================================
print_hex:
        ;start
        PUSH rbp  
        MOV rbp, rsp
        SUB rsp, 2         ;Empilha 2 bytes de espaço a stack. Um para o contador e outro pra LF.
        MOV BYTE [rsp], 0xa;Adiciona uma quebra neste byte. 

        MOV rax, rdi       ;Guarda o arg0 em rax.
        MOV rcx, 16        ;Guarda 16 no register divisor, pois é hexadecimal.
        MOV BYTE counter, 1;Limpa o register contador.
loop_hex:                  ;Inicio do loop.
        INC BYTE counter        ;Incrementa o contador.
        MOV rdx, 0         ;Limpa o register resto.
         
        DIV rcx            ;Div para tirar o digito hex menos significativo de rax e guardar em rdx.
        CMP dl, 0xA
        JGE case0_eg
        case0_l:
                ADD dl, '0';Add rdx a ascii '0' para obter o simbolo numerico ascii.
                JMP end_case0 
        case0_eg:
                ADD dl, '0'+('@'-'9')
        end_case0:
        
        SUB rsp, 1        ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl;Guarda o digito neste espaço.
         
        TEST rax, rax     ;Compara rax.
        JNZ loop_hex      ;volta ao inicio do loop enquanto o quociente for diferente de 0.

        JMP end
        
;==========================================
;========PRINT UNSIGNED 64 INTEGER=========
;==========================================
print_u64:
        ;start
        PUSH rbp  
        MOV rbp, rsp
        SUB rsp, 2         ;Empilha 2 bytes de espaço a stack.
        MOV BYTE [rsp], 0xa;Adiciona uma quebra de linha neste byte. 

        MOV rax, rdi       ;Guarda o primeiro argumento em rax.
        MOV rcx, 10        ;Guarda 10 no register divisor, pois é decimal.
        MOV BYTE counter, 1;Limpa o register contador.
loop_u64:
        INC BYTE counter   ;Incrementa o contador.
        MOV rdx, 0         ;Limpa o register resto.
         
        DIV rcx            ;Div para tirar o digito dec menos significativo de rax e guardar em rdx.
        ADD dl, '0'        ;Add rdx a ascii '0' para obter o simbolo numerico ascii.
        
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl ;Guarda o digito neste espaço.
         
        TEST rax, rax      ;Compara rax.
        JNZ loop_u64       ;volta ao inicio do loop enquanto o quociente for diferente de 0.

        JMP end


;==========================================
;=========PRINT SIGNED 64 INTEGER==========
;==========================================
print_i64:
        ;start
        PUSH rbp
        MOV rbp, rsp
        SUB rsp, 3            ;Adiciona 3 bytes de espaço a stack.
        MOV BYTE is_neg, FALSE;Empilha a flag que indica se o numero é negativo na memoria.
        MOV BYTE [rsp], 0xa   ;Empilha uma quebra de linha. 
        
        MOV rax, rdi       ;Guarda o primeiro e único argumento em rax.

sign_handling:
        MOV rdx, rax       ;Copia rax para edx.
        SAR rdx, 0x3F      ;SAR o sign bit para que preencha todo o register.
        TEST rdx, rdx      ;Compara rdx. rdx = 0 se o numero for positivo e -1 se negativo.
        JZ end_signh       ;Pule se rdx = 0
case_signed:
        MOV BYTE is_neg, TRUE;Se rdx = -1, muda a flag para um, será util mais tarde.
        MUL rdx              ;Multiplica rax por -1 para se inverter o sinal.
end_signh:
        MOV rcx, 10        ;Guarda 10 no register divisor, pois é decimal.
        MOV BYTE counter, 1;Limpa o register contador com 1.

loop_i64:
        INC BYTE counter   ;Incrementa o contador.
        MOV rdx, 0         ;Limpa o register resto.
         
        DIV rcx            ;Div para tirar o digito dec menos significativo de rax e guardar em rdx.
        ADD dl, '0'        ;Add rdx a ascii '0' para obter o simbolo numerico ascii.
        
        SUB rsp, 1         ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], dl ;Guarda o digito neste espaço.
         
        TEST rax, rax      ;Compara rax.
        JNZ loop_i64       ;volta ao inicio do loop se o quociente for diferente de 0.
             

        CMP BYTE is_neg, FALSE;Compara o valor da flag com 0, isso indica que o valor é positivo.
        JE end                ;pula para o final se positivo
case_negative:                ;Mas se for negativo...
        INC BYTE counter      ;Incremento o contador.
        SUB rsp, 1            ;Empilha um byte de espaço a stack.
        MOV BYTE [rsp], '-'   ;Guarda o digito neste espaço.               
        JMP end

;==========================================
;=================THE END==================
;==========================================
;Isso não é um procedimento.
;É uma label que é compartilhado com todos os 3 procedimetos deste arquivo.
;Essa única label contém o epilogo que finaliza todos os 3 procedimentos deste arquivo. 
;Sua função é imprimir o que tiver de imprimir, e finalizar o procedimento que a chamar.
end:
        ;write
        MOV rax, 1
        MOV rdi, STDOUT
        MOV rsi, rsp          ;guarda o stack pointer rsp no source register rsi
        mov rdx, 0            ;limpa rdx
        MOV dl, counter       ;guarda o numero de bytes a serem lidos no registrador de dados rsx
        SYSCALL 

        ;end
        LEAVE
        RET
