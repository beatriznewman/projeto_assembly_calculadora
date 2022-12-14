TITLE Beatriz Newman, RA: 22002150 / Luana Baptista, RA: 22006563
.model small

.data       ; segmento de dados
abertura DB 10, "----------------------------", '$'
introd DB 10, "  CALCULADORA EM ASSEMBLY", '$'
fecha DB 10, "----------------------------", '$'
escolha DB 10, " Escolha a operacao que deseja realizar: ", '$'
numero1  DB 10, " Entre com o primeiro numero(1 digito): " ,'$'
numero2  DB 10, " Entre com o segundo numero(1 digito): "  , '$'
resultado DB 10, " Resultado da operacao escolhida: ", '$'
errado DB 10, " Operando nao identificado, aceito apenas +, -, *, //",'$'
repetir DB 10, " Realizar outra operacao? (Digite s para sim)" , '$'

.code                          ; segmento que inicia o codigo 
  main PROC                    ; codigo principal

    MOV AX, @DATA
    MOV DS, AX                 ; DS é o registrador que guarda o endereço do segmento de dados 

    MOV AH, 09                 ; funcao para impressao de string 
    LEA DX, abertura           ; coloca o endereco da mensagem 'abertura' no registrador DX
    INT 21H                    ; executa funcao, imprimindo o conteudo do endereco DX            
    
    MOV AH, 09                 ; funcao para impressao de string 
    LEA DX, introd             ; coloca o endereco da mensagem 'introd' no registrador DX
    INT 21H                    ; executa funcao, imprimindo o conteudo do endereco DX              

    MOV AH, 09                 ; funcao para impressao de string 
    LEA DX, fecha              ; coloca o endereco da mensagem 'fecha' no registrador DX
    INT 21H                    ; executa funcao, imprimindo o conteudo do endereco DX                    

    inicio:
      CALL pula                ; chama procedimento 'pula', para pular a linha

      MOV AH, 09               ; funcao para impressao de string 
      LEA DX, escolha          ; coloca o endereco da mensagem 'escolha' no registrador DX
      INT 21H                  ; executa funcao, imprimindo o conteudo do endereco DX               

      MOV AH, 01               ; funçao de leitura de caractere(para leitura da operacao a ser realizada)
      INT 21H                  ; executa funcao, guardando o caractere inserido em AL

      CMP AL, "+"              ; comparar conteúdo de AL(sinal da operacao a ser realizada) com '+'
      JE  verifica             ; saltar se igual a zero para 'verifica'
      CMP AL, "-"              ; comparar conteúdo de AL(sinal da operacao a ser realizada) com '-'
      JE verifica              ; saltar se igual a zero para 'verifica'
      CMP AL, "*"              ; comparar conteúdo de AL(sinal da operacao a ser realizada) com '*'
      JE verifica              ; saltar se igual a zero para 'verifica'
      CMP AL, "/"              ; comparar conteúdo de AL(sinal da operacao a ser realizada) com '/'
      JE verifica              ; saltar se igual a zero para 'verifica'
      
      JMP erro                 ; se a entrada não for as possíveis operações, dará 'erro'
 
    verifica:
      MOV CH, AL               ; colocar o conteudo de AL(operacao da conta a ser executada) em CH 

      MOV AH, 09               ; funcao para impressao de string 
      LEA DX, numero1          ; coloca o endereco da mensagem 'numero1' no registrador DX
      INT 21H                  ; executa funcao, imprimindo o conteudo do endereco DX         

      MOV AH, 01               ; funçao de leitura de caractere
      INT 21H                  ; executa funcao, guardando o caractere inserido em AL                  
      MOV BH, AL               ; colocar o conteudo de AL(caractere inserido) em BH 
      SUB BH, 30h              ; subtrai 30h de BH(codigo ascii do numero inserido)
     
      MOV AH, 09               ; funcao para impressao de string 
      LEA DX, numero2          ; coloca o endereco da mensagem 'numero2' no registrador DX
      INT 21H                  ; executa funcao, imprimindo o conteudo do endereco DX           

      MOV AH, 01               ; funçao de leitura de caractere
      INT 21H                  ; executa funcao, guardando o caractere inserido em AL                 
      MOV BL, AL               ; colocar o conteudo de AL(caractere inserido) em BH 
      SUB BL, 30h              ; subtrair 30h de BL(codigo ascii do numero inserido)

    CMP CH,"+"                 ; compara o sinal '+' com o registardor CH, que contem a operacao a ser realizada 
    JNZ nao_adic               ; pular para a proxima comparacao (->nao_adic) caso nao for o sinal de '+'
    CALL adicionar             ; chama o procedimento de soma -> adicionar
     
    nao_adic: 
      CMP CH,"-"               ; compara o sinal '-' com o registardor CH, que contem a operacao a ser realizada 
      JNZ nao_sub              ; pular para a proxima comparacao (->nao_sub) caso nao for o sinal de '-'
      CALL subtrair            ; chama o procedimento de subtracao -> 'subtrair'

    nao_sub: 
      CMP CH,"*"               ; comparar o sinal '*' com o registardor CH, que contem a operacao a ser realizada 
      JNZ nao_mult             ; pular para a proxima comparacao (->nao_mult) caso nao for o sinal de '*'
      CALL multiplicar         ; chama o procedimento de multiplicacao -> 'multiplicar'

    nao_mult: 
      CMP CH,"/"               ; compara o sinal '/' com o registardor CH, que contem a operacao a ser realizada 
      JNZ nao_div              ; pular para a proxima comparacao (->nao_div) caso nao for o sinal de '/'
      CALL dividir             ; chama oprocedimento de divisao -> 'dividir'
  
    nao_div: 
      CALL pula                ; chama procedimento 'pula', para pular a linha      
      CALL imprimir            ; chama procedimento 'imprimir', para impressao da conta

      MOV AH, 09               ; funcao para impressao de string 
      LEA DX, repetir          ; colocar o endereco da mensagem 'erro'no registrador DX
      INT 21H                  ; executa funcao, imprimindo o conteudo do endereco DX         

      MOV AH, 01               ; funçao de leitura de caractere
      INT 21H                  ; executa funcao, imprimindo o conteudo do endereco DX         

      CMP AL, 's'              ; compara o registrador AL com o s minusculo 
      JE inicio                ; jump para o 'inicio', caso a pessoa escreva 's' para realizar outra operacao
      CMP AL, 'S'              ; compara o registrador AL com o S maiusculo 
      JE inicio                ; jump para o 'inicio', caso a pessoa escreva 'S' para realizar outra operacao 

      JMP fim                  ; pula para o final do programa

    erro:
      MOV AH, 09               ; funcao para impressao de string 
      LEA DX, errado           ; colocar o endereco da mensagem 'erro'no registrador DX
      INT 21h                  ; executa funcao, imprimindo o conteudo do endereco DX 
      JMP inicio               ; pular para o 'inicio'

    fim:
      MOV AH,4CH               ; exit 
      INT 21H
main ENDP


pula PROC
  POP SI

  MOV AH, 02                   ; funcao para impressao de caractere
  MOV DL, 10                   ; mover para DL o codigo ascii do <pula linha> -> 10h
  INT 21h                      ; executa funcao, imprimindo o conteudo de DL

  PUSH SI
  RET
pula ENDP

adicionar PROC
    POP SI

    MOV CL, BH                 ; colocar o valor de BH em CL 
    ADD CL, BL                 ; somar entre os dois registradores, resultado em CL (CL + BL)
    MOV DH, " "                ; mover para DH o <espaço>, para na impressao nao imprimir sinal junto ao resultado(positivo)

    PUSH SI
    RET
adicionar ENDP

subtrair PROC
    POP SI

    MOV CL, BH                 ; colocar o valor de BH em CL 
    SUB CL, BL                 ; subtrair entre os dois registradores, resultado em CL (CL - BL)
    JS resultado_neg           ; pula para 'resultado_neg', se o flag de sinal = 1 (negativo)

    MOV DH, " "                ; mover para DH o <espaço>, para na impressao nao imprimir sinal junto ao resultado(positivo)
    JMP final1                 ; pula para o 'final1' do procedimento

    resultado_neg:          
      NEG CL
      MOV DH, "-"              ; mover para DH o <espaço>, para na impressao nao imprimir sinal junto ao resultado(positivo)

    final1:
      PUSH SI
      RET
subtrair ENDP

multiplicar PROC
    POP SI
    PUSH BX                    ; salva os conteudos de BX (numeros inseridos)

    XOR CL, CL                 ; operador XOR entre CX e CX, zerando o registrador CX, para guardar resultado (XOR entre numeros iguais = 0)


    multiplica:
      SHR BH, 1                ; desloca BH para a direita 1 bit (valor mais a direita vai para flag de Carry-CF)
      JNC pula1                ; pular para 'pula1' caso nao haja Carry (CF = 0) 
      ADD CL, BL               ; somar o valor de BL no resultado (CL), se houver Carry (CF = 1) -> CL (CL + BL)

    
      pula1:
        SHL BL, 1              ; desloca BH para a esquerda 1 bit (valor mais a esquerda vai para flag de Carry-CF)
        ADD BH, 0              ; somar 0 ao valor de BH, se houver Carry (CF = 1) -> BH (BH + 0) (operacao feita para gerar flag ZF)
        JNZ multiplica         ; pular para a multiplica caso BH nao for 0

      POP BX                   ; restaura os conteudos de BX (numeros inseridos)

      PUSH SI
      RET
multiplicar ENDP

dividir PROC
  POP SI

  

  PUSH SI
  RET
dividir ENDP

imprimir PROC
   POP SI

   MOV AH, 02                  ; funcao para impressao de caractere
   MOV DL, " "                 ; mover para DL o número a ser impresso, <espaco> (para padronizacao na impressao)
   INT 21H                     ; executa funcao, imprimindo o conteudo de DL

   MOV AH, 02                  ; funcao para impressao de caractere
   ADD BH, 30h                 ; somar 30 no numero guardado em BH para obter o codigo ascii do numero
   MOV DL, BH                  ; mover para DL o número a ser impresso, guardado em BH
   INT 21H                     ; executa funcao, imprimindo o conteudo de DL

   MOV AH, 02                  ; funcao para impressao de caractere
   MOV DL, CH                  ; mover para DL o simbolo (+, -, *, /) a ser impresso 
   INT 21H                     ; executa funcao, imprimindo o conteudo de DL

   MOV AH, 02                  ; funcao para impressao de caractere
   ADD BL, 30h                 ; somar 30 no numero guardado em BL para obter o codigo ascii do numero
   MOV DL, BL                  ; mover para DL o número a ser impresso, guardado em BL
   INT 21H                     ; executa funcao, imprimindo o conteudo de DL

   MOV AH, 02                  ; funcao para impressao de caractere 
   MOV DL, '='                 ; mover para DL o simbulo de igul "="
   INT 21H                     ; executa funcao, imprimindo o conteudo de DL

   MOV AH, 02                  ; funcao para impressao de caractere
   MOV DL, DH                  ; mover para DL o simbolo '-' ou ' ', guardado em DH
   INT 21H                     ; executa funcao, imprimindo o conteudo de DL

    ;impressao resultado: numero com 2 digitos:

   XOR CH, CH                  ; operador XOR entre CH e CH, zerando o registrador CH, para guardar resultado (XOR entre numeros iguais = 0)
   MOV AX, CX                  ; mover para AX o conteudo de CL(resultado da conta)
   MOV BL, 10                  ; mover para BL o numero 10
   DIV BL                      ; dividir AX(registrador utilizado pela funcao), por 10(BL). Guarda o resultado em AL e o resto em AH
   MOV CX, AX                  ; mover AX(resultado da conta) para CX, para evitar perda dos valores armazenados

   MOV DL, CL                  ; mover para DL o resultado da divisao (CL: primeiro numero a ser impresso)
   OR DL, 30h                  ; operador OR entre o conteudo de DL e o numero hexadecimal 30h, obtendo o valor decimal em DL
   MOV AH, 02                  ; funcao para impressao de caractere
   INT 21H                     ; executa funcao, imprimindo o conteudo de DL

   MOV DL, CH                  ; mover para DL o resto da divisao (CH: segundo numero a ser impresso) 
   OR DL, 30h                  ; operador OR entre o conteudo de DL e o numero hexadecimal 30h, obtendo o valor decimal em DL
   MOV AH, 02                  ; funcao para impressao de caractere
   INT 21H                     ; executa funcao, imprimindo o conteudo de DL

   PUSH SI
   RET
imprimir ENDP

end main
