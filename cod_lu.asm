.model small

.data       ; segmento de dados
abertura DB 10, "----------------------------", '$'
introd DB 10, "  CALCULADORA EM ASSEMBLY", '$'
fecha DB 10, "----------------------------", '$'
escolha_op DB 10, "Escolha a operacao que deseja realizar: ", '$'
numero1  DB 10, "Entre com o primeiro numero(1 digito): " ,'$'
numero2  DB 10, "Entre com o segundo numero(1 digito): "  , '$'
resultado DB 10, "Resultado da operacao escolhida: ", '$'
errado DB 10, "Operando nao identificado, aceito apenas +, -, *, //",'$'

.code                          ; segmento que inicia o codigo 
  main PROC                    ; codigo principal

    MOV AX, @DATA
    MOV DS, AX                 ; DS é o registrador que guarda o endereço do segmento de dados 

    MOV AH, 09                 ; imprime a string
    LEA DX, abertura           ; coloca o conteudo da escolha_op no registrador dx 
    INT 21H                    ; chama o SO para realizar a funcao
    
    MOV AH, 09                 ; imprime a string
    LEA DX, introd              ; coloca o conteudo da escolha_op no registrador dx 
    INT 21H                    ; chama o SO para realizar a funcao

    MOV AH, 09                  ; imprime a string
    LEA DX, fecha               ; coloca o conteudo da escolha_op no registrador dx 
    INT 21H                    ; chama o SO para realizar a funcao

    CALL pula

inicializa:
    MOV AH, 09               ; imprime a string escolha_op
    LEA DX, escolha_op     ; coloca o conteudo da escolha_op no registrador dx 
    INT 21H                  ; chama o SO para realizar a funcao

    MOV AH, 01               ; funçao de leitura
    INT 21H                  ; chama o SO para realizar a funcao

   CMP AL, "+"              ;
   JE  verifica             ; jz: salto se igual a zero, se a entrada não for as possíveis operações dará erro 
   CMP AL, "-"
   JE verifica
   CMP AL, "*"
  JE verifica
  CMP AL, "/"
  JE verifica
      
JMP erro
 
verifica:
MOV CH, AL

MOV AH, 09      ; imprime a msg1
LEA DX, numero1 ; coloca o conteudo do numero1 no registrador dx 
INT 21H        ; chama o SO para realizar a funcao

MOV AH, 01   ; funçao de leitura
INT 21H     ; chama o SO para realizar a funcao
MOV BH, AL   ; coloca o conteudo de AL em BH 
SUB BH, 30h  ; subtrai 30h do codigo ascii
     
MOV AH, 09      ; imprime a msg1
LEA DX, numero2 ; coloca o conteudo do numero2 no registrador dx 
INT 21H        ; chama o SO para realizar a funcao

MOV AH, 01   ; funçao de leitura
INT 21H      ; chama o SO para realizar a funcao
MOV BL, AL   ; coloca o conteudo de AL em BH 
SUB BL, 30h  ; subtrai 30h do codigo ascii



CMP CH,"+"    ; compara o sinal '+' com o registardor CH, que contem a operacao a ser realizada 
JNZ nao_adic  ; ele pula para a proxima comparacao caso nao for o sinal de '+'
CALL adiciona ; chamar o procedimento de soma 
nao_adic: 

CMP CH,"-"    ; compara o sinal '-' com o registardor CH, que contem a operacao a ser realizada 
JNZ nao_sub   ; ele pula para a proxima comparacao caso nao for o sinal de '-'
CALL subtrair ; chamar o procedimento de subtracao
nao_sub: 

;CMP CH,"*"      ; compara o sinal '*' com o registardor CH, que contem a operacao a ser realizada 
;JNZ nao_mult    ; ele pula para a proxima comparacao caso nao for o sinal de '*'
;CALL multiplica ; chamar o procedimento de multiplicacao
;nao_mult: 

;CMP CH,"/"   ; compara o sinal '/' com o registardor CH, que contem a operacao a ser realizada 
;JNZ nao_div  ; ele pula para a proxima comparacao caso nao for o sinal de '/'
;CALL divisao ; chamar o procedimento de divisao
;nao_div: 

CALL pula
CALL imprimir



jmp FIM



erro:
MOV AH,09  ; imprime string 
lea DX,errado ; coloca o conteudo da mensagem numero2 no registrador dx 
int 21h
jmp inicializa  ; volta para o inicio 


FIM:
MOV AH,4CH ; exit 
int 21H

main ENDP


pula PROC
  POP SI
  MOV AH, 02      ; funcao para impressao de caractere
  MOV DL, 10      ; move para DL o codigo ascii do <pula linha> -> 10h
  INT 21h
  PUSH SI
  RET
pula ENDP

adiciona PROC
    POP SI
    MOV CL, BH        ;coloca o valor de BH em CL 
    ADD CL, BL        ;soma entre os dois registradores 
    PUSH SI
    RET
adiciona ENDP

subtrair PROC
    POP SI
    MOV CL, BH        ;coloca o valor de BH em CL 
    SUB CL, BL        ;soma entre os dois registradores 
    PUSH SI
    RET
subtrair ENDP



imprimir PROC
   POP SI

   MOV AH, 02        ; funcao para impressao de caractere
   ADD BH, 30h       ; somar 30 no númeo guardado em BH para obter o codigo ascii do numero
   MOV DL, BH        ; move para DL o número a ser impresso, guardado em BH
   INT 21H

   MOV AH, 02        ; funcao para impressao de caractere
   MOV DL, CH        ; move para DL o simbolo (+, -, *, /) a ser impresso 
   INT 21H

   MOV AH, 02        ; funcao para impressao de caractere
   ADD BL, 30h       ; somar 30 no númeo guardado em BL para obter o codigo ascii do numero
   MOV DL, BL        ; move para DL o número a ser impresso, quardado em BL
   INT 21H

   MOV AH, 02

   MOV AH, 02
   MOV DL, '='
   INT 21H   

   MOV AH, 02
   ADD CL, 30h
   MOV DL, CL
   INT 21H
   

   PUSH SI
   
   RET
imprimir ENDP




end main