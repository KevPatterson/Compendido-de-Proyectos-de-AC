format binary as 'img'
       org 7c00h

       mov ah,2h
       mov al,4h
       mov ch,0h
       mov cl,2h
       mov dh,0h
       mov dl,80h
       mov bx,800h
       mov es,bx
       mov bx,0h

	@@: int 13h
	jc @b

	jmp 8000h

times 510-($-$$) db 0
      dw 0aa55h
;----------------------------------------------------------------------------------------------
	org 8000h

	mov ax, 13h
	int 10h


	CLI
	xor ax,ax
	mov gs,ax
	mov ax, teclado
	mov [gs:9*4], ax
	mov [gs:9*4+2], cs

	mov ax, timer
	mov [gs:8*4], ax
	mov [gs:8*4+2], cs

	STI
	mov dx, 320*60 + 120 ;Casilla del Rey
	mov edi, 0A0000h

	jmp   $
;----------------------------------------------------------------------------------------------
	timer:
		dec [cont]
		jnz salir

		call PRINCIPAL
		mov [cont], 9

       salir:
		mov al, 20h
		out 20h, al
		iret
;----------------------------------------------------------------------------------------------
       teclado:
	      in al, 60h
	      cmp al, 127
	      ja fin_teclado

	      cmp al, 32 ;D
	      jnz opc1

	      mov [aux], 1

       opc1:
	      cmp al, 30 ;A
	      jnz opc2

	      mov [aux], 2

       opc2:
	      cmp al, 31 ;S
	      jnz opc3

	      mov [aux], 3
       opc3:
	      cmp al, 17 ;w
	      jnz fin_teclado

	      mov [aux], 4
     
      
       fin_teclado:
	     mov al, 20h
	     out 20h, al
	     iret
;----------------------------------------------------------------------------------------------
	PRINCIPAL:
	    cmp [aux], 0
	    je REY

	    cmp[aux], 1
	    je arriba_derecha

	    cmp [aux], 2
	    je arriba_izquierda

	    cmp [aux], 3
	    je abajo_derecha

	    cmp [aux], 4
	    je abajo_izquierda


	arriba_derecha:
		cmp [vertical], 0
		je REY
		cmp [horizontal], 3
		je REY
		add dx, 320*-40+40
		mov [aux], 0
		dec [vertical]
		inc [horizontal]
		mov [varc],3
		jmp REY

	arriba_izquierda:
		cmp [horizontal], 0
		je REY
		cmp [vertical], 0
		je REY
		add dx, 320*-40-40
		mov [aux], 0
		dec [horizontal]
		dec [vertical]
		mov [varc],3
		jmp REY

	abajo_derecha:
		cmp [horizontal], 3
		je REY
		cmp [vertical], 3
		je REY
		add dx, 320*40+40
		mov [aux], 0
		inc [vertical]
		inc [horizontal]
		mov [varc],3
		jmp REY

	abajo_izquierda:
		cmp [horizontal], 0
		je REY
		cmp [vertical], 3
		je REY
		add dx, 320*40-40
		mov [aux], 0
		dec [horizontal]
		inc [vertical]
		mov [varc], 3
		jmp REY
;---------------------------------------------------------------------------------------------
	 REY:
	     mov ax, 13h
	     int 10h

	     ;Mesa
	     mov di, 35
	     mov [alto], 200
	     mov [ancho], 250
	     mov al, 0110b
	     mov [color], al
	     call cuadrado
	     call tablero



	     ;Borde del Tablero
	     mov di, 320*18+78
	     mov [alto], 164
	     mov [ancho], 164
	     mov al, 0111b
	     mov [color], al
	     call cuadrado
	     call tablero

	     ;Fondo del tablero
	     mov di, 320*20+80
	     mov [alto], 160
	     mov [ancho], 160
	     mov al, 1111b
	     mov [color], al
	     call cuadrado
	     call tablero

	     ;Casilla dinamica
	     mov al, [color1]
	     mov [color], al
	     mov di, dx
	     mov [alto], 40
	     mov [ancho], 40
	     call cuadrado

	     ;Torre Aliada
	     mov di, 320*176+90
	     mov [alto],3
	     mov [ancho], 18
	     mov al, 1000b
	     mov [color], al
	     call cuadrado

	     add di, 320*-6+2
	     mov [alto],2
	     mov [ancho], 14
	     mov [color], al
	     call cuadrado

	     add di, 320*-20+3
	     mov [alto],20
	     mov [ancho], 8
	     mov [color], al
	     call cuadrado

	     add di, 320*-23-3
	     mov [alto],2
	     mov [ancho], 14
	     mov [color], al
	     call cuadrado

	     add di, 320*-6-2
	     mov [alto],3
	     mov [ancho], 18
	     mov [color], al
	     call cuadrado

	     add di, 320*-6-2
	     mov [alto],3
	     mov [ancho], 6
	     mov [color], al
	     call cuadrado

	     add di, 320*-3+8
	     mov [alto],3
	     mov [ancho], 6
	     mov [color], al
	     call cuadrado

	     add di, 320*-3+8
	     mov [alto],3
	     mov [ancho], 6
	     mov [color], al
	     call cuadrado

	     ;Torre Enemiga der
	     mov di, 320*56+210 ;176
	     mov [alto],3
	     mov [ancho], 18
	     mov al, 110b
	     mov [color], al
	     call cuadrado

	     add di, 320*-6+2
	     mov [alto],2
	     mov [ancho], 14
	     mov [color], al
	     call cuadrado

	     add di, 320*-20+3
	     mov [alto],20
	     mov [ancho], 8
	     mov [color], al
	     call cuadrado

	     add di, 320*-23-3
	     mov [alto],2
	     mov [ancho], 14
	     mov [color], al
	     call cuadrado

	     add di, 320*-6-2
	     mov [alto],3
	     mov [ancho], 18
	     mov [color], al
	     call cuadrado

	     add di, 320*-6-2
	     mov [alto],3
	     mov [ancho], 6
	     mov [color], al
	     call cuadrado

	     add di, 320*-3+8
	     mov [alto],3
	     mov [ancho], 6
	     mov [color], al
	     call cuadrado

	     add di, 320*-3+8
	     mov [alto],3
	     mov [ancho], 6
	     mov [color], al
	     call cuadrado
 ;---------------------------------------------------------------------------------------------
	     ;Base
	     mov [color], 1000b
	     add dx, 320*37+10 ;11 850
	     mov di, dx
	     mov [alto], 2
	     mov [ancho], 20
	     call cuadrado

	     ;2da Base
	     add dx, 320*-3+2 ;-958 ;10892
	     mov di, dx
	     mov [alto], 2
	     mov [ancho], 16
	     call cuadrado

	     ;3ra Base
	     add dx, 320*-2+2 ;-638 10254
	     mov di, dx
	     mov [alto], 1
	     mov [ancho], 12
	     call cuadrado

	     ;Cuerpo
	     add dx, 320*-14+2 ;-4778 ;5776
	     mov di, dx
	     mov [alto], 13
	     mov [ancho], 8
	     call cuadrado

	     ;Arriba Base 1
	     add dx, 320*-2-1 ;-641 ;5135
	     mov di, dx
	     mov [alto], 1
	     mov [ancho], 10
	     call cuadrado

	     ;Arriba Base 2
	     add dx, 320*-2-2 ;-642 ;4493
	     mov di, dx
	     mov [alto], 1
	     mov [ancho], 14
	     call cuadrado

	     ;Arriba Base 3
	     add dx, 320*-2+2 ;-638 ;3855
	     mov di, dx
	     mov [alto], 1
	     mov [ancho], 10
	     call cuadrado

	     ;Corona Horizontal
	     add dx, 320*-6+1 ;-1919 1936
	     mov di, dx
	     mov [alto], 2
	     mov [ancho], 8
	     call cuadrado

	     ;Corona Vertical
	     add dx, 320*-4+3 ;-1277 659
	     mov di, dx
	     mov [alto], 9
	     mov [ancho], 2
	     call cuadrado

	     cmp [varc], 0
	     ja cambioColor

	     cmp [varc], 0
	     je devolver

	     fin:
	     add dx, -659
	     ret
;---------------------------------------------------------------------------------------------
	cuadrado:
		 mov bl, [alto]
		 mov al, [color]
		 mov cx, bx

		     externo:
			     push cx
			     mov bl, [ancho]
			     mov cx, bx
		     interno:
			     mov [edi], al
			     inc di
			     loop interno
			     add di, 320
			     sub di, bx
		    pop cx
		    loop externo
	ret

       tablero:
		mov di,320*20+20
		mov al, 02h ;color de casillas que sobreescriben
		mov cx, 40 ;L

	blanco: push cx
		mov cx, 40 ;A

		       B:
			mov [edi+100], al
			mov [edi+180], al

			mov [edi+320*40+60], al
			mov [edi+320*40+140], al

			mov [edi+320*80+100], al
			mov [edi+320*80+180], al

			mov [edi+320*120+60], al
			mov [edi+320*120+140], al


			  inc di
			  loop B
			  pop cx
			  add di, 280
			  loop blanco
			  ret



		cambioColor:
		sub [color1], 2
		dec [varc]

		jmp fin

	     devolver:
		 mov [color1], 1111b
		 jmp fin
;----------------------------------------------------------------------------------------------
			 cont db 9
			 horizontal db 1
			 vertical db 1
			 flag db 0
			 aux db 0
			 alto db 0
			 ancho db 0
			 color db 00000001b
			 color1 db 1111b
			 varc db 0



times (4*512)-($-$$) db 0