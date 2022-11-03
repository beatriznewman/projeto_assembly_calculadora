TITLE Beatriz Newman, RA: 22002150 / Luana Baptista, RA: 22006563
.model small

.data       ; segmento de dados
abertura DB 10, "----------------------------", '$'
introd DB 10, "  CALCULADORA EM ASSEMBLY", '$'
fecha DB 10, "----------------------------", '$'
escolha DB 10, "Escolha a operacao que deseja realizar: ", '$'
numero1  DB 10, "Entre com o primeiro numero(1 digito): " ,'$'
numero2  DB 10, "Entre com o segundo numero(1 digito): "  , '$'
resultado DB 10, "Resultado da operacao escolhida: ", '$'
errado DB 10, "Operando nao identificado, aceito apenas +, -, *, //",'$'
repetir DB 10, "Realizar outra operacao? (Digite s para sim)" , '$'

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

    CALL pula                  ;chama procedimento 'pula'(), para pular a linha

   inicializa:
      MOV AH, 09               ; funcao para impressao de string 
      LEA DX, escolha          ; coloca o endereco da mensagem 'escolha' no registrador DX
      INT 21H                  ; executa funcao, imprimindo o conteudo do endereco DX               

      MOV AH, 01               ; funçao de leitura de caractere(para leitura da operacao a ser realizada)
      INT 21H                  ; executa funcao, guardando o caractere inserido em AL

      CMP AL, "+"              ; comparar conteúdo de AL(sinal da operacao a ser realizada) com '+'
      JE  verifica             ; saltar se igual a zero para 'verifica'(53)
      CMP AL, "-"              ; comparar conteúdo de AL(sinal da operacao a ser realizada) com '-'
      JE verifica              ; saltar se igual a zero para 'verifica'(53)
      CMP AL, "*"              ; comparar conteúdo de AL(sinal da operacao a ser realizada) com '*'
      JE verifica              ; saltar se igual a zero para 'verifica'(53)
      CMP AL, "/"              ; comparar conteúdo de AL(sinal da operacao a ser realizada) com '/'
      JE verifica              ; saltar se igual a zero para 'verifica'(53)
      
      JMP erro                 ; se a entrada não for as possíveis operações, dará erro(103)
 
   verifica:
     MOV CH, AL

     MOV AH, 09                ; funcao para impressao de string 
     LEA DX, numero1           ; coloca o endereco da mensagem 'numero1' no registrador DX
     INT 21H                   ; executa funcao, imprimindo o conteudo do endereco DX         

     MOV AH, 01                ; funçao de leitura de caractere
     INT 21H                   ; executa funcao, guardando o caractere inserido em AL                  
     MOV BH, AL                ; colocar o conteudo de AL(caractere inserido) em BH 
     SUB BH, 30h               ; subtrai 30h de BH(codigo ascii do numero inserido)
     
     MOV AH, 09                ; funcao para impressao de string 
     LEA DX, numero2           ; coloca o endereco da mensagem 'numero2' no registrador DX
     INT 21H                   ; executa funcao, imprimindo o conteudo do endereco DX           

     MOV AH, 01                ; funçao de leitura de caractere
     INT 21H                   ; executa funcao, guardando o caractere inserido em AL                 
     MOV BL, AL                ; colocar o conteudo de AL(caractere inserido) em BH 
     SUB BL, 30h               ; subtrair 30h de BL(codigo ascii do numero inserido)

   CMP CH,"+"                  ; compara o sinal '+' com o registardor CH, que contem a operacao a ser realizada 
   JNZ nao_adic                ; pular para a proxima comparacao (->nao_adic(78)) caso nao for o sinal de '+'
   CALL adicionar              ; chama o procedimento de soma -> adicionar(125)
     
   nao_adic: 
     CMP CH,"-"                ; compara o sinal '-' com o registardor CH, que contem a operacao a ser realizada 
     JNZ nao_sub               ; pular para a proxima comparacao (->nao_sub(83)) caso nao for o sinal de '-'
     CALL subtrair             ; chama o procedimento de subtracao -> subtrair(133)

   nao_sub: 

     ;CMP CH,"*"                ; comparar o sinal '*' com o registardor CH, que contem a operacao a ser realizada 
     ;JNZ nao_mult              ; pular para a proxima comparacao (->nao_mult(89)) caso nao for o sinal de '*'
     ;CALL multiplica           ; chama o procedimento de multiplicacao -> multiplica()

   ;nao_mult: 
     ;CMP CH,"/"                ; comparae o sinal '/' com o registardor CH, que contem a operacao a ser realizada 
     ;JNZ nao_div               ; pular para a proxima comparacao (->nao_div(94)) caso nao for o sinal de '/'
     ;CALL divisao              ; chama o procedimento de divisao -> divisao()
  
   ;nao_div: 

     CALL pula                  ; chama procedimento 'pula'(), para pular a linha      
     CALL imprimir1             ; chama procedimento 'imprimir1'(), para impressao da conta-> res. posit. 1 alg.

     JMP fim                    ; pula para o final do programa



erro:
MOV AH, 09                      ; funcao para impressao de string 
lea DX, errado                  ; colocar o endereco da mensagem 'erro'no registrador DX
INT 21h                         ; executa funcao, imprimindo o conteudo do endereco DX 
JMP inicializa                  ; pular para o inicio -> inicializa(34)


fim:
MOV AH,4CH                     ; exit 
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
    ADD CL, BL                 ; somar entre os dois registradores, resultado em CL
    MOV DH, " "                ; mover para DH o <espaço>, para na impressao nao imprimir sinal junto ao resultado(positivo)

    PUSH SI
    RET
adicionar ENDP

subtrair PROC
    POP SI

    MOV CL, BH                 ; colocar o valor de BH em CL 
    SUB CL, BL                 ; subtrair entre os dois registradores, resultado em CL
    JS resultado_neg           ; pula para 'resultado_neg', se o flag de sinal for 1 (negativo)

    MOV DH, " "                ; mover para DH o <espaço>, para na impressao nao imprimir sinal junto ao resultado(positivo)
    JMP final                  ; pula para o 'final' do procedimento

    resultado_neg:          
    NEG CL
    MOV DH, "-"                ; mover para DH o <espaço>, para na impressao nao imprimir sinal junto ao resultado(positivo)

    final:
    PUSH SI
    RET
subtrair ENDP

imprimir1 PROC
   POP SI

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

   ;CALL imprimir2              ; chama procedimento 'imprimir2', para imprimir numero com 2 numeros

  MOV AX, CX                  ; mover para AX o conteudo de CL(resultado da conta)
  MOV BL, 10                  ; mover para BL o numero 10
  DIV BL                      ; dividir AX(registrador utilizado pela funcao), por 10(BL). Guarda o resultado em AL e o resto em AH
  MOV BX, AX                  ; mover AX(resultado da conta) para BX, para evitar perda dos valores armazenados

  MOV DL, BL                  ; mover para DL o resultado da divisao (BL: primeiro numero a ser impresso)
  OR DL, 30h                  ; operador OR entre o conteudo de DL e o numero hexadecimal 30h, obtendo o valor decimal em DL
  MOV AH, 02                  ; funcao para impressao de caractere
  INT 21H                     ; executa funcao, imprimindo o conteudo de DL

  MOV DL, BH                  ; mover para DL o resto da divisao (BH: segundo numero a ser impresso) 
  OR DL, 30h                  ; operador OR entre o conteudo de DL e o numero hexadecimal 30h, obtendo o valor decimal em DL
  MOV AH, 02                  ; funcao para impressao de caractere
  INT 21H                     ; executa funcao, imprimindo o conteudo de DL

   PUSH SI
   RET
imprimir1 ENDP

imprimir2 PROC
  POP SI
  POP CX                      ; recupera os dados de CX

  MOV AX, CX                  ; mover para AX o conteudo de CL(resultado da conta)
  MOV BL, 10                  ; mover para BL o numero 10
  DIV BL                      ; dividir AX(registrador utilizado pela funcao), por 10(BL). Guarda o resultado em AL e o resto em AH
  MOV BX, AX                  ; mover AX(resultado da conta) para BX, para evitar perda dos valores armazenados

  MOV DL, BL                  ; mover para DL o resultado da divisao (BL: primeiro numero a ser impresso)
  OR DL, 30h                  ; operador OR entre o conteudo de DL e o numero hexadecimal 30h, obtendo o valor decimal em DL
  MOV AH, 02                  ; funcao para impressao de caractere
  INT 21H                     ; executa funcao, imprimindo o conteudo de DL

  MOV DL, BH                  ; mover para DL o resto da divisao (BH: segundo numero a ser impresso) 
  OR DL, 30h                  ; operador OR entre o conteudo de DL e o numero hexadecimal 30h, obtendo o valor decimal em DL
  MOV AH, 02                  ; funcao para impressao de caractere
  INT 21H                     ; executa funcao, imprimindo o conteudo de DL

  PUSH SI
  RET
imprimir2 ENDP


end main
