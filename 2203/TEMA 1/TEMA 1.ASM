format binary as 'img'
       org 7c00h

	mov	ah,2h
	mov	al,4h
	mov	ch,0h
	mov	cl,2h
	mov	dh,0h
	mov	dl,80h
	mov	bx,800h
	mov	es,bx
	mov	bx,0h

	@@: int     13h
	jc	@b

	jmp	8000h

times 510-($-$$) db 0
	dw 0aa55h
;---------------------------------------------------------------------------------------------
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

	     mov dx, 320*100 + 160 ;ubicacion inicial de la Reina
	     mov edi, 0A0000h


	 jmp   $
;---------------------------------------------------------------------------------------------
	timer:
	      dec [cont]
	      jnz salir

	      call dibujar
	      mov [cont], 18

       salir:
	      mov al, 20h
	      out 20h, al
	      iret
 
       teclado:
	      in al, 60h
	      cmp al, 127
	      ja fin_teclado

	      cmp al, 32 ;D
	      jnz opcion1
	      mov [aux], 1

       opcion1:
	      cmp al, 30 ;A
	      jnz opcion2
	      mov [aux], 2

       opcion2:
	      cmp al, 31 ;S
	      jnz opcion3
	      mov [aux], 3
       opcion3:
	      cmp al, 17 ;W
	      jnz fin_teclado
	      mov [aux], 4

       fin_teclado:
	     mov al, 20h
	     out 20h, al
	     iret
;----------------------------------------------------------------------------------------------
       dibujar:
	    cmp [aux], 0
	    je Reina

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
		je Reina
		cmp [horizontal], 3
		je Reina
		add dx, -320*50+50
		mov [aux], 0
		dec [vertical]
		inc [horizontal]
		mov [varc],3
		jmp Reina

	arriba_izquierda:
		cmp [horizontal], 0
		je Reina
		cmp [vertical], 0
		je Reina
		add dx, -320*50-50
		mov [aux], 0
		dec [horizontal]
		dec [vertical]
		mov [varc],3
		jmp Reina

	abajo_derecha:
		cmp [horizontal], 3
		je Reina
		cmp [vertical], 3
		je Reina
		add dx, 320*50+50
		mov [aux], 0
		inc [vertical]
		inc [horizontal]
		mov [varc],3
		jmp Reina

	abajo_izquierda:
		cmp [horizontal], 0
		je Reina
		cmp [vertical], 3
		je Reina
		add dx, 320*50-50
		mov [aux], 0
		dec [horizontal]
		inc [vertical]
		mov [varc], 3
		jmp Reina
;----------------------------------------------------------------------------------------------
	Reina:
	      mov ax, 13h
	      int 10h

	     ;Fondo
	     mov di,320*0+60
	     mov [alto], 200
	     mov [ancho], 200
	     mov al, 1111b
	     mov [color], al
	     call cuadrado
	     call tablero

	     ;Casilla de la Reina
	     mov al, [color_casilla]
	     mov [color], al
	     mov di, dx
	     mov [alto], 50
	     mov [ancho], 50
	     call cuadrado

	     ;Pieza base
	     mov [color], 0000b
	     add dx, 320*33+15
	     mov di, dx
	     mov [alto], 3
	     mov [ancho], 20
	     call cuadrado

	     ;Segunda Pieza
	     add dx, 320*-2+2
	     mov di, dx
	     mov [alto], 2
	     mov [ancho], 16
	     call cuadrado

	     ;Cuerpo
	     add dx, 320*-18+3
	     mov di, dx
	     mov [alto], 18
	     mov [ancho], 10
	     call cuadrado

	     ;Arriba
	     add dx, 320*-2-3
	     mov di, dx
	     mov [alto], 2
	     mov [ancho], 16
	     call cuadrado

	     cmp [varc], 0
	     ja cambioColor
	     cmp [varc], 0
	     je devolver
	     fin:

	     add dx, -3537

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
		mov di,0
		mov al, 0100b ;color de casillas
		mov cx, 50 ;largo

	blanco: push cx
		mov cx, 50 ;ancho

		B:
		mov [edi+110], al
		mov [edi+210], al
		mov [edi+320*50+60], al
		mov [edi+320*50+160], al
		mov [edi+320*100+110], al
		mov [edi+320*100+210], al
		mov [edi+320*150+60], al
		mov [edi+320*150+160], al

		inc di
		loop B
		pop cx
		add di, 270

	loop blanco
	ret

	cambioColor:
	 sub [color_casilla], 3
	 dec [varc]
	 jmp fin

	devolver:
	mov [color_casilla], 1111b

	jmp fin
;---------------------------------------------------------------------------------------------
	cont db 18
	horizontal db 2
	vertical db 2
	flag db 0
	aux db 0
	alto db 0
	ancho db 0
	color db 00000001b
	color_casilla db 1111b
	varc db 0

times (4*512)-($-$$) db 0