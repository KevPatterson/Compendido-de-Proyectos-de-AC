format binary as 'img'
org 7c00h


 mov ah,0x02     
 mov al,0x05     
 mov ch,0x00
 mov cl,0x02      
 mov dh,0x00
 mov dl,0x00      
 mov bx,0x800     
 mov es,bx
 mov bx,0x0000
    @@: int 0x13
 jc @b

 mov ax,13h 
 int 10h


 jmp 8000h      

times 510-($-$$) db 0
   dw 0xaa55
org 8000h

EMPEZAR:

MOV AH, 0      
MOV AL, 13H    
INT 10H        
MOV BL, 50 
NEXT: 

MOV AH, 0CH    
MOV AL, 1111b 
MOV CX, 61     

  
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

MOV AH, 0CH    
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

MOV AH, 0CH    
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

MOV AH, 0CH    
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

MOV AH, 0CH    
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

MOV AH, 0CH    
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

MOV AH, 0CH    
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

MOV AH, 0CH    
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

MOV AX , CS
MOV DS , AX

MOV AX , 0A000H
MOV ES , AX

MOV DI , 320
SUB DI , 320*2
MOV EAX , 00000010000000100000001000000010B

mov bl,201
ancho:
MOV CX , 58
MARCO:

MOV [ES:DI], EAX
ADD DI , 1
DEC CX

JNZ MARCO
sub di, 58
add di, 320
dec bl
jnz ancho

MOV DI , 264
mov bl,201
ancho2:
MOV CX , 58
MARCO2:

MOV [ES:DI], EAX
ADD DI , 1
DEC CX

JNZ MARCO2
sub di, 58
add di, 320
dec bl
jnz ancho2

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

;PIEZA

MOV DI , 320*75+135
MOV EAX , 00000000H
MOV [ES:DI], EAX

MOV CX, 10
P:
ADD DI , 320
MOV [ES:DI], EAX

DEC CX
JNZ P

ADD DI, 320
SUB DI, 1
MOV [ES:DI] , EAX
ADD DI, 2
MOV [ES:DI] , EAX

ADD DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

ADD DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

MOV DI , 320*75+135
MOV [ES:DI] , EAX
SUB DI , 320
SUB DI , 1
MOV [ES:DI] , EAX
ADD DI , 2
MOV [ES:DI] , EAX

SUB DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

SUB DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX
                 
;INTERRUPCCION DEL TECLADO 
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

CMP AL,'d'

JE DA

JNE KEY_PRESS


IA:

XOR DI, DI


MOV DI , 320+60
MOV AX , 09H

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
;Timer

 mov cx, 300h
 mov dx, 07d0h
 mov ah, 86h
 int 15h

MOV DI , 320+60
MOV AX , 04H

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
MOV AX , 03H

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

;Pieza_Isquierda
XOR EAX, EAX
XOR BX, BX
XOR CX, CX
XOR DX, DX
MOV DI , 320*20+85
MOV EAX , 00000000H
MOV [ES:DI], EAX

MOV CX, 10
P30:
ADD DI , 320
MOV [ES:DI], EAX

DEC CX
JNZ P30

ADD DI, 320
SUB DI, 1
MOV [ES:DI] , EAX
ADD DI, 2
MOV [ES:DI] , EAX

ADD DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

ADD DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

MOV DI , 320*20+85
MOV [ES:DI] , EAX
SUB DI , 320
SUB DI , 1
MOV [ES:DI] , EAX
ADD DI , 2
MOV [ES:DI] , EAX

SUB DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

SUB DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX




;CUADRADO BLANCO
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

;IZQUIERDA_ABAJO
JMP KEY2
IAB:

XOR DI, DI

MOV DI , 320*102+60
MOV AX , 09H

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


mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320*102+60
MOV AX , 04H

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
MOV AX , 03H

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

;Left_Piece
XOR EAX, EAX
XOR BX, BX
XOR CX, CX
XOR DX, DX

MOV DI , 320*122+85
MOV EAX , 00000000H
MOV [ES:DI], EAX

MOV CX, 10
P31:
ADD DI , 320
MOV [ES:DI], EAX

DEC CX
JNZ P31

ADD DI, 320
SUB DI, 1
MOV [ES:DI] , EAX
ADD DI, 2
MOV [ES:DI] , EAX

ADD DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

ADD DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

MOV DI , 320*122+85
MOV [ES:DI] , EAX
SUB DI , 320
SUB DI , 1
MOV [ES:DI] , EAX
ADD DI , 2
MOV [ES:DI] , EAX

SUB DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

SUB DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

;WHITE_SQUARE

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
;DERECHA_ARRIBA
JMP KEY2

DA:

XOR DI, DI

MOV DI , 320+162
MOV AX , 09H

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

;Timer
mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320+162
MOV AX , 04H

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
MOV AX , 03H

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

;Left_Piece
XOR EAX, EAX
XOR BX, BX
XOR CX, CX
XOR DX, DX

MOV DI , 320*20+185
MOV EAX , 00000000H
MOV [ES:DI], EAX

MOV CX, 10
P32:
ADD DI , 320
MOV [ES:DI], EAX

DEC CX
JNZ P32

ADD DI, 320
SUB DI, 1
MOV [ES:DI] , EAX
ADD DI, 2
MOV [ES:DI] , EAX

ADD DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

ADD DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

MOV DI , 320*20+185
MOV [ES:DI] , EAX
SUB DI , 320
SUB DI , 1
MOV [ES:DI] , EAX
ADD DI , 2
MOV [ES:DI] , EAX

SUB DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

SUB DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

;WHITE_SQUARE
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


;DERECHA_ABAJO

JMP KEY2

DAB:

XOR DI, DI

MOV DI , 320*102+162
MOV AX , 09H

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


; Timer 
mov cx, 300h
mov dx, 07d0h
mov ah, 86h
int 15h

MOV DI , 320*102+162
MOV AX , 04H

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
MOV AX , 03H

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

; Left_Piece 
XOR EAX, EAX
XOR BX, BX
XOR CX, CX
XOR DX, DX

MOV DI , 320*122+185
MOV EAX , 00000000H
MOV [ES:DI], EAX

MOV CX, 10
P33:
ADD DI , 320
MOV [ES:DI], EAX

DEC CX
JNZ P33

ADD DI, 320
SUB DI, 1
MOV [ES:DI] , EAX
ADD DI, 2
MOV [ES:DI] , EAX

ADD DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

ADD DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

MOV DI , 320*122+185
MOV [ES:DI] , EAX
SUB DI , 320
SUB DI , 1
MOV [ES:DI] , EAX
ADD DI , 2
MOV [ES:DI] , EAX

SUB DI, 320
SUB DI, 3
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

SUB DI, 320
SUB DI, 4
MOV [ES:DI] , EAX
ADD DI, 4
MOV [ES:DI], EAX

; WHITE_SQUARE 

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






; REPETIR 
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



    


 