format binary as 'img'
       org 7c00h

       mov ax, 0a000h
       mov es,ax
       mov ax, 0x13
       int 10h
       Call Crear
	Teclado:
		in al, 64h
		test al, 1
		jz Teclado

		in al,60h

		cmp al,12H
		je Encender

		cmp al,1EH
		je Apagar

		cmp al,19H
		je Parpadeo

		jmp Teclado


 jmp $





	Crear:

	;configuracion inicial:
		mov ax, 0x13
	int 10h

	mov di, 0 ;dibujar el fondo
	mov cx, 200

	mov bx, 0f0fh;color del fondo
	
       pantalla:
	       push cx ;guardar a cx para no modificar el anterior
		mov cx,160
	     interno:
	    mov [es:di], bx
		   add di, 2
		       loop interno
	 pop cx

	       loop pantalla

	      mov di, 320*120+120 ; posicion donde empiezo
	mov cx, 80	;altura de la figura

	mov bx, 0808h	; color

	
	casa:	;
		push cx ;
		mov cx,40 ;mitad del ancho
		interior:
			mov [es:di], bx 	;dibujar una fila
			add di, 2
			loop interior
		pop cx			;sacar a cx
		add di,320-80		;pasar a la siguiente fila
		loop casa

	mov di, 320*140+125 ; posicion donde empiezo
	mov cx, 20	;altura de la figura

	mov bx, 0101h	; color

	
	ventana1:   ;
		push cx ;
		mov cx,10 ;mitad del ancho
		interno1:
			mov [es:di], bx 	;dibujar una fila
			add di, 2
			loop interno1
		pop cx			;sacar a cx
		add di,320-20	       ;pasar a la siguiente fila
		loop ventana1


	mov di, 320*140+175 ; posicion donde empiezo
	mov cx, 20	;altura de la figura

	mov bx, 0101h	; color

	
	ventana2:   ;
		push cx ;
		mov cx,10 ;mitad del ancho
		interno2:
			mov [es:di], bx 	;dibujar una fila
			add di, 2
			loop interno2
		pop cx			;sacar a cx
		add di,320-20	       ;pasar a la siguiente fila
		loop ventana2


 mov di, 320*165+148 ; posicion donde empiezo
	mov cx, 35    ;altura de la figura

	mov bx, 0606h	; color

	
	puerta:   ;
		push cx ;
		mov cx,12 ;mitad del ancho
		interno3:
			mov [es:di], bx 	;dibujar una fila
			add di, 2
			loop interno3
		pop cx			;sacar a cx
		add di,320-24	       ;pasar a la siguiente fila
		loop puerta


	mov di, 320*75+160 ; posicion donde empiezo
	mov cx, 45    ;altura de la figura
	mov dx, 1      ; cantidad de veces que se va a repetir los pixel al dibujar una fila
	mov ax, 0

	mov bl, 06h   ; color

	
	techo:	 ;
		push cx ;
		mov cx,dx	 ;cantida de veces q se va a dibujar el pixel para forma el tringulo
		interno4:
			mov [es:di], bl 	;dibujar una fila
			add di, 1
			inc ax	   ;contador para salto fila
			loop interno4
		pop cx			;sacar a cx
		add di,319;  pasar a la siguiente fila
		saltofila :
		sub di,1     ;
		sub ax,1
		cmp ax,0
		jne saltofila
		add dx,2
		loop techo
	   call Dibuja

     ret
      Dibuja:

	    mov di,320*128+155

		   mov cx,10
		   tanqueho:
			    mov ah,07h
			    mov al,07h
			    mov [es:di],ax
			    add edi,320
			    loop tanqueho
			    mov cx,10
		   tanqueve:
			    mov ah,07h
			    mov [es:di],ah
			    inc edi
			    loop tanqueve
			    mov cx,11
		   tanqueho2:
			     mov ah,07h
			     mov al,07h
			     mov [es:di],ax
			     sub edi,320
			     loop tanqueho2
			     mov [es:di],ax
			     mov cx,10
		   tanqueve2:
			     mov ah,07h
			     mov [es:di],ah
			     dec edi
			     loop tanqueve2
			     mov [es:di],ax
	     add edi,320+29

	     ret
      Encender:
		mov ax,013h
	    int 10h
	    call Crear
	    mov di,320*128+155
	    add di,320*9+2

		    mov cx,10
		    completo:
			     push cx
			     mov cx,6
		    tanque1:
			    mov ah,04h
			    mov al,04h
			    mov bh,04h
			    mov bl,04h
			    mov [es:di],ax
			    inc edi
			    mov [es:di],bx
			    loop tanque1
	      sub edi,326
	      pop cx
	      loop completo

       jmp Teclado

      Apagar:
	     mov ax,013h
	    int 10h
	    call Crear

	    jmp Teclado

      Parpadeo:
	     mov cx,20
	lop:
      call encender
      call timer
      call apagar
      call timer
      call encender
      call timer
      call apagar
      call timer
      call encender
      call timer
      call apagar
      call timer
      call encender
      call timer
      call apagar


       dec cx
       cmp cx, 0
       jz lop
       jmp Teclado



	      timer:
	      mov cx,125h
	      mov dx,07d0h
	      mov ah,86h
	      int 15h
	      ret

		encender:
  mov ax,013h
	    int 10h
	    call Crear
	    mov di,320*128+155
	    add di,320*9+2

		    mov cx,10
		   lol:
			     push cx
			     mov cx,6
		    tanque21:
			    mov ah,04h
			    mov al,04h
			    mov bh,04h
			    mov bl,04h
			    mov [es:di],ax
			    inc edi
			    mov [es:di],bx
			    loop tanque21
	      sub edi,326
	      pop cx
	      loop lol
	      ret

apagar:
	     mov ax,013h
	    int 10h
	    call Crear

	    ret


times 510-($-$$) db 0
		  dw 0xaa55