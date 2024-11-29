format binary as 'img'
org 7c00h

;Código para leer desde HDD:
 mov ah,0x02      ;usar el BIOS para cargar
 mov al,0x05      ;cantidad de sectores
 mov ch,0x00
 mov cl,0x02      ;a partir del segundo sector lógico
 mov dh,0x00
 mov dl,0x00      ;del primer disco duro
 mov bx,0x800     ;y escribir el contenido en 0x800:0
 mov es,bx
 mov bx,0x0000
    @@: int 0x13
 jc @b

 mov ax,13h ; 0x3 para modo texto
 int 10h


 jmp 8000h      ;poner en ejecución el código cargado en HDD

times 510-($-$$) db 0
   dw 0xaa55
org 8000h

EMPEZAR:

MOV AH, 0      ;iniciar modo de video
MOV AL, 13H    ;establecer el modo grafico
INT 10H        ;comenzar con la instruc

MOV BL, 50 
NEXT: 

MOV AH, 0CH    
MOV AL, 1111b 
MOV CX, 61     ;

  
MOV DI, 50         
FIRSTLINE:
INT 10H
INC CX
DEC DI
JNZ FIRSTLINE

INC DX
DEC BL
JNZ NEXT

MOV DX, 0 

MOV BL, 50 
NEXT1: 

MOV AH, 0CH    ;
MOV AL, 1111b 
MOV CX, 163

  
MOV DI, 50         
FIRSTLINE1:
INT 10H
INC CX
DEC DI
JNZ FIRSTLINE1

INC DX
DEC BL
JNZ NEXT1

MOV DX, 51

MOV BL, 50 
NEXT2: 

MOV AH, 0CH    ;
MOV AL, 1111b 
MOV CX, 112

  
MOV DI, 50         
FIRSTLINE2:
INT 10H
INC CX
DEC DI
JNZ FIRSTLINE2

INC DX
DEC BL
JNZ NEXT2 

MOV DX, 51   

MOV BL, 50 
NEXT3: 

MOV AH, 0CH    ;
MOV AL, 1111b 
MOV CX, 214

  
MOV DI, 50         
FIRSTLINE3:
INT 10H
INC CX
DEC DI
JNZ FIRSTLINE3

INC DX
DEC BL
JNZ NEXT3

MOV DX, 102


;REPETICION PRIMERA LINEA 



MOV BL, 50 
NEXT4: 

MOV AH, 0CH    ;
MOV AL, 1111b 
MOV CX, 61


  
MOV DI, 50         
FIRSTLINE4:
INT 10H
INC CX
DEC DI
JNZ FIRSTLINE4

INC DX
DEC BL
JNZ NEXT4

MOV DX, 102 

MOV BL, 50 
NEXT5: 

MOV AH, 0CH    ;
MOV AL, 1111b 
MOV CX, 163

  
MOV DI, 50         
FIRSTLINE5:
INT 10H
INC CX
DEC DI
JNZ FIRSTLINE5

INC DX
DEC BL
JNZ NEXT5 

;REPETICION SEGUNDA LINEA

MOV DX, 153

MOV BL, 50 
NEXT6: 

MOV AH, 0CH    ;
MOV AL, 1111b 
MOV CX, 112

  
MOV DI, 50         
FIRSTLINE6:
INT 10H
INC CX
DEC DI
JNZ FIRSTLINE6

INC DX
DEC BL
JNZ NEXT6 

MOV DX, 153   

MOV BL, 50 
NEXT7: 

MOV AH, 0CH    ;
MOV AL, 1111b 
MOV CX, 214

  
MOV DI, 50         
FIRSTLINE7:
INT 10H
INC CX
DEC DI
JNZ FIRSTLINE7

INC DX
DEC BL
JNZ NEXT7

;-------------------------------------------------------------------Marco----------------------------------------------------------------------------

MOV AX , CS
MOV DS , AX

MOV AX , 0A000H
MOV ES , AX

MOV DI , 320+57
SUB DI , 320*2
MOV EAX , 00000100000001000000010000000100B


MOV CX , 202
MARCO:

MOV [ES:DI], EAX
ADD DI , 320
MOV [ES:DI], EAX

DEC CX

JNZ MARCO

MOV DI , 320+264
MOV CX ,202

MARCO2:

MOV [ES:DI], EAX
ADD DI , 320
MOV [ES:DI],EAX

DEC CX

JNZ MARCO2

MOV DI, 320+57
SUB DI, 320

MOV CX , 207
MARCO3:

MOV [ES:DI], EAX
ADD DI, 1
MOV [ES:DI], EAX

DEC CX

JNZ MARCO3

MOV DI, 320*199+57

MOV CX, 207
MARCO4:

MOV [ES:DI] , EAX
ADD DI, 1
MOV [ES:DI] , EAX

DEC CX
JNZ MARCO4

;------------------------------------------------------------PIEZA---------------------------------------------------------------------

MOV DI , 320*58+125
MOV EAX , 00000000H
MOV [ES:DI], EAX

MOV CX, 30
P:
ADD DI , 320
MOV [ES:DI], EAX

DEC CX
JNZ P

MOV DI , 320*58+125

MOV CH,3
A:
MOV CL, 5
D:
MOV [ES:DI], EAX
ADD DI, 4
DEC CL
JNZ D
ADD DI, 320
SUB DI, 20
DEC CH
JNZ A

SUB DI, 300
MOV CL, 13
P1:
ADD DI , 320
MOV [ES:DI], EAX

DEC CX
JNZ P1
SUB DI, 4

MOV CH,3
A1:
MOV CL, 5
D1:
MOV [ES:DI], EAX
SUB DI, 4
DEC CL
JNZ D1
ADD DI, 320
ADD DI, 20
DEC CH
JNZ A1

SUB DI , 320
MOV CX, 3
P3:
ADD DI , 321
MOV [ES:DI], EAX

DEC CX
JNZ P3

MOV CX, 10
P4:
ADD DI , 320
MOV [ES:DI], EAX

DEC CX
JNZ P4
;------------------------------------------------------------------TECLAO-------------------------------------------------------------------------------------------
XOR AX, AX

KEY_PRESS:
MOV AH, 01H
INT 16H

JZ KEY_PRESS
MOV AH, 00H
INT 16H



CMP AL,'a'

JE IA

CMP AL,'w'

JE IAB

CMP AL,'s'

JE DAB

CMP AL,'S'

JE DAZ

CMP AL,'d'

JE DA

JNE KEY_PRESS

;-------------------------------------------------------Izquierda_Arriba-----------------------------------------------------------------------------------------
IA:
;A partir de aqui funciona el teclado
XOR DI, DI


MOV DI , 320+60
MOV AX , 01H

MOV BL, 49
COLUMNA:
MOV BH, 49
FILA:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA
ADD DI, 271
DEC BL
JNZ COLUMNA
;-------------------------------------------------------------Timer-----------------------------------------------------------------------

 mov cx, 300h
 mov dx, 07d0h
 mov ah, 86h
 int 15h

MOV DI , 320+60
MOV AX , 05H

MOV BL, 49
COLUMNA1:
MOV BH, 49
FILA1:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA1
ADD DI, 271
DEC BL
JNZ COLUMNA1

 mov cx, 300h
 mov dx, 07d0h
 mov ah, 86h
 int 15h

MOV DI , 320+60
MOV AX , 06H

MOV BL, 49
COLUMNA2:
MOV BH, 49
FILA2:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA2
ADD DI, 271
DEC BL
JNZ COLUMNA2
;------------------------------------------------------------------------------------Pieza_Isquierda-----------------------------------------------------------
XOR EAX, EAX
XOR BX, BX
XOR CX, CX
XOR DX, DX


MOV DI , 320*8+75
MOV [ES:DI], EAX

MOV CX, 30
LOOP1:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP1

MOV DI , 320*8+75

MOV CH,3
LOOP2:
MOV CL, 5
INNER_LOOP2:
MOV [ES:DI], EAX
ADD DI, 4
DEC CL
JNZ INNER_LOOP2
ADD DI, 320
SUB DI, 20
DEC CH
JNZ LOOP2

SUB DI, 300
MOV CL, 13
LOOP3:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP3
SUB DI, 4

MOV CH,3
LOOP4:
MOV CL, 5
INNER_LOOP4:
MOV [ES:DI], EAX
SUB DI, 4
DEC CL
JNZ INNER_LOOP4
ADD DI, 320
ADD DI, 20
DEC CH
JNZ LOOP4

SUB DI , 320
MOV CX, 3
LOOP5:
ADD DI , 321
MOV [ES:DI], EAX
DEC CX
JNZ LOOP5

MOV CX, 10
LOOP6:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP6
;----------------------------------------------------------------------CUADRADO BLANCO------------------------------------------------------------------------------

MOV DI , 320*51+112
MOV AX , 0FH

MOV BL, 49
COLUMNA3:
MOV BH, 49
FILA3:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA3
ADD DI, 271
DEC BL
JNZ COLUMNA3

;---------------------------------------------------------------------IZQUIERDA_ABAJO-----------------------------------------------------------------------
JMP KEY2
IAB:

XOR DI, DI

MOV DI , 320*102+60
MOV AX , 01H

MOV BL, 50
COLUMNA_100:
MOV BH, 49
FILA_100:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_100
ADD DI, 271
DEC BL
JNZ COLUMNA_100

;-------------------------------------------------------------Timer-----------------------------------------------------------------------

mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320*102+60
MOV AX , 05H

MOV BL, 50
COLUMNA_101:
MOV BH, 49
FILA_101:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_101
ADD DI, 271
DEC BL
JNZ COLUMNA_101

mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320*102+60
MOV AX , 06H

MOV BL, 50
COLUMNA_102:
MOV BH, 49
FILA_102:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_102
ADD DI, 271
DEC BL
JNZ COLUMNA_102

;------------------------------------------------------------------------------------Left_Piece-----------------------------------------------------------
XOR EAX, EAX
XOR BX, BX
XOR CX, CX
XOR DX, DX

MOV DI , 320*110+75
MOV [ES:DI], EAX

MOV CX, 30
LOOP_200:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_200

MOV DI , 320*110+75

MOV CH,3
LOOP_201:
MOV CL, 5
INNER_LOOP_201:
MOV [ES:DI], EAX
ADD DI, 4
DEC CL
JNZ INNER_LOOP_201
ADD DI, 320
SUB DI, 20
DEC CH
JNZ LOOP_201

SUB DI, 300
MOV CL, 13
LOOP_202:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_202
SUB DI, 4

MOV CH,3
LOOP_203:
MOV CL, 5
INNER_LOOP_203:
MOV [ES:DI], EAX
SUB DI, 4
DEC CL
JNZ INNER_LOOP_203
ADD DI, 320
ADD DI, 20
DEC CH
JNZ LOOP_203

SUB DI , 320
MOV CX, 3
LOOP_204:
ADD DI , 321
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_204

MOV CX, 10
LOOP_205:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_205

;----------------------------------------------------------------------WHITE_SQUARE------------------------------------------------------------------------------

MOV DI , 320*51+112
MOV AX , 0FH

MOV BL, 49
COLUMNA_300:
MOV BH, 49
FILA_300:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_300
ADD DI, 271
DEC BL
JNZ COLUMNA_300
;-----------------------------------------------------------------------DERECHA_ARRIBA---------------------------------------------------------------------------
JMP KEY2

DA:

XOR DI, DI

MOV DI , 320+162
MOV AX , 01H

MOV BL, 49
COLUMNA_103:
MOV BH, 49
FILA_103:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_103
ADD DI, 271
DEC BL
JNZ COLUMNA_103

;-------------------------------------------------------------Timer-----------------------------------------------------------------------

mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320+162
MOV AX , 05H

MOV BL, 49
COLUMNA_104:
MOV BH, 49
FILA_104:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_104
ADD DI, 271
DEC BL
JNZ COLUMNA_104

mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320+162
MOV AX , 06H

MOV BL, 49
COLUMNA_105:
MOV BH, 49
FILA_105:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_105
ADD DI, 271
DEC BL
JNZ COLUMNA_105

;------------------------------------------------------------------------------------Left_Piece-----------------------------------------------------------
XOR EAX, EAX
XOR BX, BX
XOR CX, CX
XOR DX, DX

MOV DI , 320*8+177
MOV [ES:DI], EAX

MOV CX, 30
LOOP_206:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_206

MOV DI , 320*8+177

MOV CH,3
LOOP_207:
MOV CL, 5
INNER_LOOP_207:
MOV [ES:DI], EAX
ADD DI, 4
DEC CL
JNZ INNER_LOOP_207
ADD DI, 320
SUB DI, 20
DEC CH
JNZ LOOP_207

SUB DI, 300
MOV CL, 13
LOOP_208:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_208
SUB DI, 4

MOV CH,3
LOOP_209:
MOV CL, 5
INNER_LOOP_209:
MOV [ES:DI], EAX
SUB DI, 4
DEC CL
JNZ INNER_LOOP_209
ADD DI, 320
ADD DI, 20
DEC CH
JNZ LOOP_209

SUB DI , 320
MOV CX, 3
LOOP_210:
ADD DI , 321
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_210

MOV CX, 10
LOOP_211:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_211

;----------------------------------------------------------------------WHITE_SQUARE------------------------------------------------------------------------------

MOV DI , 320*51+112
MOV AX , 0FH

MOV BL, 49
COLUMNA_306:
MOV BH, 49
FILA_306:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_306
ADD DI, 271
DEC BL
JNZ COLUMNA_306
;--------------------------------------------------------------------------DERECHA_ABAJO---------------------------------------------------------------------------
JMP KEY2

DAB:

XOR DI, DI

MOV DI , 320*102+162
MOV AX , 01H

MOV BL, 50
COLUMNA_1:
MOV BH, 49
FILA_1:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_1
ADD DI, 271
DEC BL
JNZ COLUMNA_1

;-------------------------------------------------------------Timer-----------------------------------------------------------------------

mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320*102+162
MOV AX , 05H

MOV BL, 50
COLUMNA_2:
MOV BH, 49
FILA_2:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_2
ADD DI, 271
DEC BL
JNZ COLUMNA_2

mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320*102+162
MOV AX , 06H

MOV BL, 50
COLUMNA_3:
MOV BH, 49
FILA_3:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_3
ADD DI, 271
DEC BL
JNZ COLUMNA_3

;------------------------------------------------------------------------------------Left_Piece-----------------------------------------------------------
XOR EAX, EAX
XOR BX, BX
XOR CX, CX
XOR DX, DX

MOV DI , 320*110+177
MOV [ES:DI], EAX

MOV CX, 30
LOOP_4:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_4

MOV DI , 320*110+177

MOV CH,3
LOOP_5:
MOV CL, 5
INNER_LOOP_5:
MOV [ES:DI], EAX
ADD DI, 4
DEC CL
JNZ INNER_LOOP_5
ADD DI, 320
SUB DI, 20
DEC CH
JNZ LOOP_5

SUB DI, 300
MOV CL, 13
LOOP_6:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_6
SUB DI, 4

MOV CH,3
LOOP_7:
MOV CL, 5
INNER_LOOP_7:
MOV [ES:DI], EAX
SUB DI, 4
DEC CL
JNZ INNER_LOOP_7
ADD DI, 320
ADD DI, 20
DEC CH
JNZ LOOP_7

SUB DI , 320
MOV CX, 3
LOOP_8:
ADD DI , 321
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_8

MOV CX, 10
LOOP_9:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_9

;----------------------------------------------------------------------WHITE_SQUARE------------------------------------------------------------------------------

MOV DI , 320*51+112
MOV AX , 0FH

MOV BL, 49
COLUMNA_9:
MOV BH, 49
FILA_9:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_9
ADD DI, 271
DEC BL
JNZ COLUMNA_9


;------------------------------------------------------------------------ABAJO_IZQUEIRDA_EZQUINA-------------------------------------------------------------------
JMP KEY2

DAZ:

XOR DI, DI

MOV DI , 320*152+213
MOV AX , 01H

MOV BL, 48
COLUMNA_4:
MOV BH, 49
FILA_4:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_4
ADD DI, 271
DEC BL
JNZ COLUMNA_4

;-------------------------------------------------------------Timer-----------------------------------------------------------------------

mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320*152+213
MOV AX , 05H

MOV BL, 48
COLUMNA_5:
MOV BH, 49
FILA_5:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_5
ADD DI, 271
DEC BL
JNZ COLUMNA_5

mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320*152+213
MOV AX , 06H

MOV BL, 48
COLUMNA_6:
MOV BH, 49
FILA_6:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_6
ADD DI, 271
DEC BL
JNZ COLUMNA_6

;------------------------------------------------------------------------------------Left_Piece-----------------------------------------------------------
XOR EAX, EAX
XOR BX, BX
XOR CX, CX
XOR DX, DX

MOV DI , 320*163+227
MOV [ES:DI], EAX

MOV CX, 30
LOOP_71:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_71

MOV DI , 320*163+227

MOV CH,3
LOOP_81:
MOV CL, 5
INNER_LOOP_8:
MOV [ES:DI], EAX
ADD DI, 4
DEC CL
JNZ INNER_LOOP_8
ADD DI, 320
SUB DI, 20
DEC CH
JNZ LOOP_81

SUB DI, 300
MOV CL, 13
LOOP_91:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_91
SUB DI, 4

MOV CH,3
LOOP_10:
MOV CL, 5
INNER_LOOP_10:
MOV [ES:DI], EAX
SUB DI, 4
DEC CL
JNZ INNER_LOOP_10
ADD DI, 320
ADD DI, 20
DEC CH
JNZ LOOP_10

SUB DI , 320
MOV CX, 3
LOOP_11:
ADD DI , 321
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_11

MOV CX, 10
LOOP_12:
ADD DI , 320
MOV [ES:DI], EAX
DEC CX
JNZ LOOP_12

;----------------------------------------------------------------------WHITE_SQUARE------------------------------------------------------------------------------

MOV DI , 320*51+112
MOV AX , 0FH

MOV BL, 49
COLUMNA_7:
MOV BH, 49
FILA_7:

ADD DI, 1
MOV [ES:DI], AX
DEC BH
JNZ FILA_7
ADD DI, 271
DEC BL
JNZ COLUMNA_7





;---------------------------------------------------------------------------REPETIR---------------------------------------------------------------------------------
KEY2:

KEY_PRESS2:
MOV AH, 01H
INT 16H

JZ KEY_PRESS2
MOV AH, 00H
INT 16H


CMP AL,'r'

JE EMPEZAR


times (5*512)-($-$$) db 0
        dw 0xaa55



    


 