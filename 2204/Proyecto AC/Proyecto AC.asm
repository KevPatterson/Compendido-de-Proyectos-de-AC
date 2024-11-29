format binary as 'img'
org 7C00H

;Código para leer desde HDD:
	mov	ah,0x02
	mov	al,0x05
	mov	ch,0x00
	mov	cl,0x02
	mov	dh,0x00
	mov	dl,0x00
	mov	bx,0x800
	mov	es,bx
	mov	bx,0x0000
    @@: int	0x13
	jc	@b

	mov	ax,0x13
	int	10h

	jmp	8000h

times 510-($-$$) db 0
dw 0xaa55

org 8000h

	mov ax, 0x13
	int 10h

	mov ax, 0xa000
	mov es, ax
	MOV EDI, [pos]

	push es
	cli
	xor ax,ax
	mov es,ax
	mov ax, timer
	mov [es:8*4], ax
	mov [es:8*4+2], cs
	sti

	pop es
	push es
	cli
	xor ax,ax
	mov es,ax
	mov ax, keyboard
	mov [es:9*4], ax
	mov [es:9*4+2], cs
	sti
	pop es
	
	jmp $

       timer:
		cmp [first], 0	; llama a imprimir para que aparezca el cuadrado
		jne @f
		call cuadrado
		mov [first], 1
		@@:
		cmp [flag_game_over], 1
		je game_over
		cmp [pos], 320*180+300
		jne @f
		mov [flag_game_over], 1
		call borrar
		@@:
		cmp [pos], 0
		jne @f
		mov [flag_game_over], 1
		call borrar
		@@:
		cmp [pos], 300
		jne @f
		mov [flag_game_over], 1
		call borrar
		@@:
		cmp [pos], 320*180
		jne @f
		mov [flag_game_over], 1
		call borrar
		@@:
	salir:
		mov al, 20h
		out 20h, al
		iret	    
	game_over:
		dec [contador]
		cmp [contador], 0
		jne salir
		mov [contador], 9
		cmp [flag_cartel], 1
		jne @f
		mov ah, [color1] ;ah -> letras
		mov al, [color2] ;al -> fondo
		mov [flag_cartel], 2
		call cartel
		jmp salir
		@@:
		mov ah, [color2]
		mov al, [color1]
		mov [flag_cartel], 1
		call cartel
		jmp salir

	keyboard:
		cmp [flag_game_over], 1
		je salir1
		in al, 60h 

		cmp al, 1 ; codigo scan de Escape
		jne @f
		call borrar
		jmp $
		@@:
		cmp al, 19  ;  codigo scan de R
		jne @f
		call borrar
		mov [pos], 320*80+150+10
		call cuadrado
		@@:
		cmp al, 75
		jne @f
		call mov_izq
		jmp salir1
		@@:
		cmp al, 80
		jne @f
		call mov_abajo
		jmp salir1
		@@:
		cmp al, 77
		jne @f
		call mov_der
		jmp salir1
		@@:
		cmp al, 72
		jne salir1
		call mov_arriba

	salir1:
		mov al, 20h
		out 20h, al
		iret

mov_arriba:
	call borrar
	cmp [pos], 320*19
	ja seguir
	jmp @f
	seguir:
	sub [pos], 320*20
	sub [pos_fila], 320*20
	@@:
	call cuadrado
	salida:
	ret

mov_abajo:
	call borrar
	cmp [pos], 320*180
	jb seguir1
	jmp @f
	seguir1:
	add [pos], 320*20
	add [pos_fila], 320*20
	@@:
	call cuadrado
	salida1:
	ret
mov_izq:
	mov edx, [pos_fila]
	;add edx, 20
	cmp edx, [pos]
	je salir2
	call borrar
	sub [pos], 20
	call cuadrado
	salir2:
	ret
mov_der:
	mov edx, [pos_fila]
	add edx, 300
	cmp edx, [pos]
	je salir3
	call borrar
	add [pos], 20
	call cuadrado
	salir3:
	ret
borrar:
	mov di, 0
	mov edx, 00000000h
	mov cx, 200
	fila:
	push cx
	mov cx, 80
	columna:
		mov [es:di], edx
		add di, 4
		loop columna
	pop cx
	loop fila
	ret

cuadrado:
	mov edi, [pos]
	mov ah, [color]
carro:
mov cx,20
CICLO2:
push cx
mov cx,20
CICLO1:
MOV [ES:eDI],Ah
INC eDI
LOOP CICLO1
ADD eDI,320-20
POP CX
LOOP CICLO2
ret



cartel: 
	mov edi, [pos_cartel]
	call fondo
	mov edi, [pos_cartel]
	add di, 320*5+4
	call letras
	ret

fondo:
	mov edi, [pos_cartel]
rect:
MOV CX,20
CICLO2a:
PUSH CX
MOV CX,80
CICLO1a:
MOV [ES:EDI],AL
INC EDI
LOOP CICLO1a
ADD EDI,320-80
POP CX
LOOP CICLO2a
	ret
letras:
letra_g:
	
	mov cx, 7
	@@:
		mov [es:di], ah
		inc di
		loop @b
		sub di, 7
	mov cx, 6
	@@:
		mov [es:di], ah
		add di, 320
		loop @b
	mov cx, 6
	@@:
		mov [es:di], ah
		inc di
		loop @b
		sub di, 320*3+3
	mov cx, 3
	@@:
		mov [es:di], ah
		inc di
		loop @b
	mov cx, 4
	@@:
		mov [es:di], ah
		add di, 320
		loop @b
letra_a:
	sub di, 320*7-3
	mov cx, 7
	@@:
		mov [es:di], ah
		add di, 6
		mov [es:di], ah
		add di, 320-6
		loop @b
	sub di, 320*7
	mov cx, 7
	@@:
		mov [es:di], ah
		add di, 320*3
		mov [es:di], ah
		sub di, 320*3
		inc di
		loop @b
letra_m:
	sub di, -2
	mov cx, 7
	@@:
		mov [es:di], ah
		add di, 7
		mov [es:di], ah
		add di, 320-7
		loop @b
	sub di, 320*7
	mov cx, 4
	mov dx, 7
	@@:
		mov [es:di], ah
		add di, dx
		mov [es:di], ah
		dec dx
		sub di, dx
		add di, 320
		dec dx
		loop @b

letra_e:
	sub di, 320*4-4-2
	mov cx, 7
	@@:
		mov [es:di], ah
		add di, 320
		loop @b
	sub di, 320*7
	mov cx, 6
	@@:
		mov [es:di], ah
		add di, 320*3
		mov [es:di], ah
		add di, 320*3
		mov [es:di], ah
		sub di, 320*6-1
		loop @b

letra_o:
	add di, 5
	mov cx, 7
	@@:
		mov [es:di], ah
		add di, 6
		mov [es:di], ah
		add di, 320-6
		loop @b
	 sub di, 320*7
	 mov cx, 7
	 @@:
		mov [es:di], ah
		add di, 320*6
		mov [es:di], ah
		sub di, 320*6
		inc di
		loop @b

letra_v:
	add di, 2
	mov cx, 3
	@@:
		mov [es:di], ah
		add di, 7
		mov [es:di], ah
		add di, 320-7
		loop @b

	mov cx, 4
	mov dx, 7
	@@:
		mov [es:di], ah
		add di, dx
		mov [es:di], ah
		dec dx
		sub di, dx
		add di, 320
		dec dx
		loop @b
letra_e2:
	sub di, 320*7-4-2
	mov cx, 7
	@@:
		mov [es:di], ah
		add di, 320
		loop @b
	sub di, 320*7
	mov cx, 6
	@@:
		mov [es:di], ah
		add di, 320*3
		mov [es:di], ah
		add di, 320*3
		mov [es:di], ah
		sub di, 320*6-1
		loop @b

letra_r:
	sub di,-2
	mov cx, 7
	@@:
		mov [es:di], ah
		add di, 320
		loop @b
	sub di, 320*7
	mov cx, 6
	@@:
		mov [es:di], ah
		add di, 320*3
		mov [es:di], ah
		sub di, 320*3
		inc di
		loop @b
	mov cx, 4
	@@:
		mov [es:di], ah
		add di, 320
		loop @b
	sub di, 2
	mov cx, 3
	@@:
		mov [es:di], ah
		add di, 321
		loop @b
	ret

mov_derecha dd 0
pos dd 320*80+150+10
pos_fila dd 320*80
first db 0
color db 04h
flag_cartel db 0 ; 1-> letras rojas fondo azul. 2 -> Alterno
flag_game_over db 0
contador db 9
pos_cartel dd 320*100+120
color1 db 04h
color2 db 01h

times (5*512)-($-$$) db 0
;times 510-($-$$) db 0
dw 0xAA55
