format binary as 'img'
org 7c00h


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

	mov di, 0
	mov cx, 200

	mov bx, 0f0fh
	
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
	cmp [first], 0
	je first1
	mov [color_bombilla], 07h
	mov [par], 1
	cmp [encendida], 1
	jne apagando			
	mov [color_bombilla], 04h
	call bombilla
	@@:
	cmp [parpadeo], 1
	jne salir
	dec [tiempo]
	cmp [tiempo], 0
	jne salir
	mov [tiempo], 9
	cmp [par], 1
	jne @f				 
	mov [color_bombilla], 07h
	mov [par], 0
	call bombilla
	jmp salir
	@@:
	mov [color_bombilla], 04h
	mov [par], 1
	call bombilla
	jmp salir
	first1:
	mov [first], 1
	call dibujar_casa
	jmp salir
	apagando:
	mov [color_bombilla], 07h
	call bombilla
salir:
	mov al, 20h
	out 20h, al
	iret

keyboard:
	in al, 60h
	cmp al, 18
	jne @f
	mov [encendida], 1
	jmp salir2
	@@:
	cmp al, 30
	jne @f
	mov [encendida], 0
	mov [parpadeo], 0
	jmp salir2
	@@:
	cmp al, 25
	jne salir2
	mov [parpadeo], 1
salir2:
	mov al, 20h
	out 20h, al
	iret


dibujar_casa:

	mov di, 320*120+120
	mov cx, 80
	
	mov bx, 0202h
	
		
	casa:
		push cx
		mov cx,40
		interior:
			mov [es:di], bx
			add di, 2
			loop interior
		pop cx
		add di,320-80
		loop casa

	mov di, 320*140+125
	mov cx, 20

	mov bx, 0707h

	
	ventana1:
		push cx
		mov cx,10
		interno1:
			mov [es:di], bx
			add di, 2
			loop interno1
		pop cx
		add di,320-20
		loop ventana1


	mov di, 320*140+175
	mov cx, 20

	mov bx, 0707h

	
	ventana2:
		push cx
		mov cx,10
		interno2:
			mov [es:di], bx
			add di, 2
			loop interno2
		pop cx
		add di,320-20
		loop ventana2


 mov di, 320*165+148
	mov cx, 35

	mov bx, 0707h

	
	puerta:
		push cx
		mov cx,12
		interno3:
			mov [es:di], bx
			add di, 2
			loop interno3
		pop cx
		add di,320-24
		loop puerta


	mov di, 320*75+160
	mov cx, 45
	mov dx, 1
	mov ax, 0

	mov bl, 1eh

	
	techo:	 ;
		push cx ;
		mov cx,dx
		interno4:
			mov [es:di], bl
			add di, 1
			inc ax
			loop interno4
		pop cx
		add di,319
		saltofila:
		sub di,1     ;
		sub ax,1
		cmp ax,0
		jne saltofila
		add dx,2
		loop techo
		call bombilla
ret

bombilla:
	mov di, 320*128+157
	mov cx,4
	mov bl, [color_bombilla]
	
	Lampara:
		push cx ;
		mov cx,7
		interior5:
			mov [es:di], bl
			add di, 1
			loop interior5
		pop cx
		add di,320-7
		loop Lampara

		mov cx, 4
		mov dx, 7
	triangulo2:
		push cx
		mov cx, dx
		@@:

			mov [es:di], bl
			inc di
			loop @b
		pop cx
		add di, 320
		sub di, dx
		add di, 1
		sub dx, 2
		loop triangulo2

			  mov di, 320*124+160
	mov cx, 4
	mov dx, 1
	mov ax, 0


	
      triangulo:   ;
		push cx ;
		mov cx,dx
		interno6:
			mov [es:di], bl
			add di, 1
			inc ax
			loop interno6
		pop cx
		add di,319;
		saltofila1:
		sub di,1     ;
		sub ax,1
		cmp ax,0
		jne saltofila1
		add dx,2
		loop triangulo
ret


encendida db 0
parpadeo db 0
first db 0
color_bombilla db 04h
tiempo db 9
par db 0

times (5*512)-($-$$) db 0
	dw 0xaa55
