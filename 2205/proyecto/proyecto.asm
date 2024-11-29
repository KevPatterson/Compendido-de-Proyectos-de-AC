;AWSD

format binary as 'img'
org 7c00h

	mov ax, 0x13
	int 10h

	mov ax, 0xa000
	mov es, ax

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
		cmp [first], 0	; llama a imprimir para que arranque la pantalla con la cruz roja
		jne @f
		call pantalla_blanca
		call cruz_roja
		mov [color_fondo], 1 ; bandera para alternar el color
		mov [first], 1
		@@:
	;salir:
		mov al, 20h
		out 20h, al
		iret

	keyboard:
		in al, 60h 
		cmp al, 30; compara el caracter entrado por la interrupcion con la letra A
		jne @f
		call mov_izq
		jmp salir1
		@@:
		cmp al, 31 ; compara con la B
		jne @f
		call mov_abajo
		jmp salir1
		@@:
		cmp al, 32 ; compara con la D
		jne @f
		call mov_der
		jmp salir1
		@@:
		cmp al, 17 ; compara con la W
		jne salir1
		call mov_arriba

	salir1:
		mov al, 20h
		out 20h, al
		iret

mov_arriba:
	sub [pos_hor], 320*20
	sub [pos_vert], 320*20
	cmp [color_fondo], 0
	jne @f
	call pantalla_blanca
	call cruz_roja
	mov [color_fondo], 1
	jmp dones
	@@:
	call pantalla_roja
	call cruz_blanca
	mov [color_fondo], 0
	dones:
	ret

mov_abajo:
	add [pos_hor], 320*20
	add [pos_vert], 320*20
	cmp [color_fondo], 0
	jne @f
	call pantalla_blanca
	call cruz_roja
	mov [color_fondo], 1
	jmp dones1
	@@:
	call pantalla_roja
	call cruz_blanca
	mov [color_fondo], 0
	dones1:
	ret
mov_izq:
	sub [pos_hor], 20
	sub [pos_vert], 20
	cmp [color_fondo], 0
	jne @f
	call pantalla_blanca
	call cruz_roja
	mov [color_fondo], 1
	jmp dones2
	@@:
	call pantalla_roja
	call cruz_blanca
	mov [color_fondo], 0
	dones2:
	ret
mov_der:
	add [pos_hor], 20
	add [pos_vert], 20
	cmp [color_fondo], 0
	jne @f
	call pantalla_blanca
	call cruz_roja
	mov [color_fondo], 1
	jmp dones3
	@@:
	call pantalla_roja
	call cruz_blanca
	mov [color_fondo], 0
	dones3:
	ret
pantalla_blanca:
		mov di, 0
		mov cx, 200
		@@:
		mov eax, [blanco]
		push cx
		mov cx, 80
		fila:
			mov [es:di], eax
			add di, 4
			loop fila
		pop cx
		loop @b
		ret
cruz_roja:
	mov eax, [rojo]
	mov di, [pos_hor]
	mov cx, 16
	horizontal:
		push cx
		mov cx, 15
		fila1:
			mov [es:di], eax
			add di, 4
			loop fila1
		pop cx
		add di, 320-60
		loop horizontal
	mov di, [pos_vert]
	mov cx, 60
	vertical:
		push cx
		mov cx, 4
		fila2:
			mov [es:di], eax
			add di, 4
			loop fila2
		pop cx
		add di, 320-16
		loop vertical

ret

	pantalla_roja:
		mov di, 0
		mov cx, 200
		@@:
		mov eax, [rojo]
		push cx
		mov cx, 80
		fila3:
			mov [es:di], eax
			add di, 4
			loop fila3
		pop cx
		loop @b
		ret
cruz_blanca:
	mov eax, [blanco]
	mov di, [pos_hor]
	mov cx, 16
	horizontal1:
		push cx
		mov cx, 15
		fila4:
			mov [es:di], eax
			add di, 4
			loop fila4
		pop cx
		add di, 320-60
		loop horizontal1
	mov di, [pos_vert]
	mov cx, 60
	vertical1:
		push cx
		mov cx, 4
		fila6:
			mov [es:di], eax
			add di, 4
			loop fila6
		pop cx
		add di, 320-16
		loop vertical1

ret

jmp $

blanco dd 0f0f0f0fh
rojo dd 04040404h

pos_hor dw 29570 
pos_vert dw 22552

color_fondo db 0; 0-> blanco 1->rojo
first db 0

times 510-($-$$) db 0
dw 0xaa55
