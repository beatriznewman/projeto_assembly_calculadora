TITLE Beatriz Newman, RA: 22002150 / Luana Baptista, RA: 22006563
.model small

.data       ; segmento de dados
abertura DB 10, "----------------------------", '$'
introd DB 10, "  CALCULADORA EM ASSEMBLY", '$'
fecha DB 10, "----------------------------", '$'
escolha_op  DB 10, "Escolha a operacao que deseja realizar: ", '$'
numero1  DB 10, "Entre com o primeiro numero(1 digito): " ,'$'
numero2  DB 10, "Entre com o segundo numero(1 digito): "  , '$'
resultado DB 10, "Resultado da operacao escolhida: ", '$'
errado DB 10, "Operando nao identificado, aceito apenas +, -, *, //",'$'

.code       ; segmento que inicia o codigo 
main proc   ; codigo principal

mov AX, @data
mov DS,AX   ; DS é o registrador que guarda o endereço do segmento de dados 


mov AH,09   ; imprime a string
lea DX,abertura ; coloca o conteudo da escolha_op no registrador dx 
int 21H     ; chama o SO para realizar a funcao

mov AH,09   ; imprime a string
lea DX,introd ; coloca o conteudo da escolha_op no registrador dx 
int 21H     ; chama o SO para realizar a funcao

mov AH,09   ; imprime a string
lea DX,fecha ; coloca o conteudo da escolha_op no registrador dx 
int 21H     ; chama o SO para realizar a funcao

call pula

inicializa:

mov AH,09   ; imprime a string escolha_op
lea DX,escolha_op ; coloca o conteudo da escolha_op no registrador dx 
int 21H     ; chama o SO para realizar a funcao


mov AH,01   ; funçao de leitura
int 21H     ; chama o SO para realizar a funcao

 cmp al,"+" 
 JE  verifica  ; jz: salto se igual a zero, se a entrada não for as possíveis operações dará erro 
 cmp al, "-"
 JE verifica
 cmp al,"*"
 JE verifica
 cmp al, "/"
 JE verifica

JMP ERRO
 



verifica:
mov AH,09      ; imprime a msg1
lea DX,numero1 ; coloca o conteudo do numero1 no registrador dx 
int 21H        ; chama o SO para realizar a funcao

mov AH,01   ; funçao de leitura
int 21H     ; chama o SO para realizar a funcao
mov BH,AL   ; coloca o conteudo de AL em BH 
sub BH,30h  ; subtrai 30h do codigo ascii


mov AH,09      ; imprime a msg1
lea DX,numero2 ; coloca o conteudo do numero2 no registrador dx 
int 21H        ; chama o SO para realizar a funcao

mov AH,01   ; funçao de leitura
int 21H     ; chama o SO para realizar a funcao
mov BL,AL   ; coloca o conteudo de AL em BH 
sub BL,30h  ; subtrai 30h do codigo ascii
jmp FIM



erro:
mov AH,09
lea dx,errado 
int 21h
jmp inicializa  ; volta para o inicio 


FIM:
mov AH,4CH ; exit 
int 21H
main endp


pula PROC
  pop SI
  mov AH, 02
  mov AL, 10h
  int 21h
  push SI
  ret
pula ENDP


end main
 



verifica:
mov AH,09      ; imprime a msg1
lea DX,numero1 ; coloca o conteudo do numero1 no registrador dx 
int 21H        ; chama o SO para realizar a funcao

mov AH,01   ; funçao de leitura
int 21H     ; chama o SO para realizar a funcao
mov BH,AL   ; coloca o conteudo de AL em BH 
sub BH,30h  ; subtrai 30h do codigo ascii


mov AH,09      ; imprime a msg1
lea DX,numero2 ; coloca o conteudo do numero2 no registrador dx 
int 21H        ; chama o SO para realizar a funcao

mov AH,01   ; funçao de leitura
int 21H     ; chama o SO para realizar a funcao
mov BL,AL   ; coloca o conteudo de AL em BH 
sub BL,30h  ; subtrai 30h do codigo ascii
jmp FIM



erro:
mov AH,09
lea dx,errado 
int 21h
jmp inicializa  ; volta para o inicio 


FIM:
mov Ah,4CH ; exit 
int 21H
main endp
end main
