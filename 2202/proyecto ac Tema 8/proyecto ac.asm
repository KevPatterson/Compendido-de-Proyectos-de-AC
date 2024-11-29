format binary as 'img'
org 7c00h
	mov ax, 0x13
	int 10h       
	mov ax,0xa000
	mov es, ax
	mov di, 0
	
	push es        ; cascaron de timer
	cli
	xor ax,ax
	mov es,ax
	mov ax, timer
	mov [es:8*4], ax
	mov [es:8*4+2], cs
	sti
	pop es
	
	push es 			  ;cascaron de teclado
	cli
	xor ax,ax
	mov es,ax
	mov ax, keyboard
	mov [es:9*4], ax
	mov [es:9*4+2], cs
	sti
	pop es

	jmp $				   ;fin de programa

	timer:	cmp [bandera], 0
		jne decc
		mov [color_relleno], 0eh
		mov [bandera], 1
		call reloj
		jmp salir
		decc:
		cmp [bandera], 2
		je reiniciar
		dec [un_segundo]
		jnz salir
		mov [un_segundo], 50
		cmp [flag], 1
		je @f
		jmp salir
		@@:
		call bajar
		jmp salir
		reiniciar:
		dec [un_segundo]
		jnz salir
		mov [un_segundo], 50
		cmp [flag], 1
		je @f
		jmp salir	   ; compara la bandera con 1 si es igual comineza a decrementar
		@@:
		mov [bandera], 1
		call reloj
		call bajar
	
	salir:	mov al, 20h			; fin de la interrupcion
		out 20h, al
		iret
		
		keyboard:			  ; rutina del teclado
			in al, 60h   ; buffer
			cmp al, 2eh
			je letra_c
			cmp al, 13h
			je letra_r
			jmp salir
			letra_c:
				mov [flag], 1	      ; si la bander esta en 1 es decir que el reloj esta bajando
				jmp salir
			letra_r:			; si la bandera esta en 2 reinica (esta entre corchete esta guardando el contenido , sino esta vuardando la direciion de memora)
				mov [bandera], 2
				mov [num_linea], 46
				mov [un_segundo], 46
				mov [bandera], 0
				mov [flag], 1
				mov [cont], 0
				jmp salir


	reloj:	
		mov di, 320*40+160-25	      ;   ( dibujo del reloj)
		mov ah, [color_borde]
		mov cx, 50
		borde:
			mov [es:di], ah
			inc di
			loop borde
		mov di, 320*41+160-24
		mov dx, 48
		mov cx, 24
		arriba:
			mov bx, 320
			dec dx
			mov [es:di], ah
			add di, dx
			mov [es:di], ah
			dec dx
			sub bx, dx
			add di, bx
			loop arriba
		mov cx, 25
		dec di
		abajo:
			mov bx, 320
			inc dx
			mov [es:di], ah
			add di, dx
			mov [es:di], ah
			inc dx
			sub bx, dx
			add di, bx
			loop abajo
	    parte_baja:
			mov cx, 50
			mov di, 320*90+160-25
			borde2:
				mov [es:di], ah
				inc di
				loop borde2
				sub di, 49
				sub di, 320
				mov [di_abajo], di
				
	relleno:	mov ah, [color_relleno]       ;dibuja lo de adentro del reloj
			mov di, 320*41+160-23
			mov cx, 23
			mov dx, 46
		arena_arriba:		   ; (dibuja la part arriba en amarillo
			mov bx, 320
			push cx
			mov cx, dx
			ciclo1:
				mov [es:di], ah
				inc di
				loop ciclo1
			sub dx, 2
			sub bx, dx
			dec bx
			pop cx
			add di, bx
			loop arena_arriba

		add di, 320*2-1
		mov cx, 24
		mov dx, 1

		arena_abajo:			   ;(en negroo)
			mov ah, 00h
			mov bx, 320
			push cx
			inc dx
			mov cx, dx
		ciclo2:
			mov [es:di], ah
			inc di
			loop ciclo2
		inc dx
		sub bx, dx
		pop cx
		add di, bx
		loop arena_abajo
		mov [di_arriba], 320*41+160-23
		ret

		
		bajar:	cmp [num_linea], 46
			jne @f
			mov di, 320*41+160-23
			@@:
			mov al, 00h 
			
		dec_reloj:
			mov di, [di_arriba]
			inc [cont]
			cmp [cont], 26
			jae salir2
			cmp [num_linea], 0
			je salir2
			mov bx, 320
			mov dx, [num_linea]
			mov cx, dx
			dec_arriba:
				mov [es:di], al
				inc di
				loop dec_arriba
			mov cx, dx
			add cx, 2
			mov al, 0eh    ; clor del relleno abajo
			add [di_arriba], 320+1
			sub bx, [num_linea]
			dec bx
			add di, bx
			mov di, [di_abajo]
			aum_abajo:
				mov [es:di], al
				inc di
				loop aum_abajo
			sub [di_abajo], 319
			sub [num_linea], 2
			salir2:
			ret

limpiar:
	mov eax, 00000000h
	mov di, 0
	mov cx, 200
	push cx
	@@:
		mov cx, 80
		ciclo:
			mov [es:di], eax
			add di, 4
			loop ciclo
		pop cx
		loop @b
		ret

		salir1:
			mov al, 20h
			out 20h, al
			iret



;******************************************************        
	color_relleno db 0eh			     ;*amarillo
	color_borde db 04h			     ;*rojo
	un_segundo db 50			     ;*
	bandera db 0				     ;*
	terminado db 0				     ;*
	num_linea dw 46 			     ;*
	cont dd 0				     ;*
	flag db 0				     ;*
	di_arriba dw 320*41+160-23		     ;*
	di_abajo dw 0				     ;*
;******************************************************

times 510-($-$$) db 0
dw 0xaa55	  