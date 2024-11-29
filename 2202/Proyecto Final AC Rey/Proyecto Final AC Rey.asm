;Adrian Navarro Torres Grupo:2202
;Osvaldo Diaz Marrero  Grupo:2202
format binary as 'img'
org 7c00h

    mov     ah,0x02	 ;usar el BIOS para cargar
    mov     al,0x05	 ;cantidad de sectores
    mov     ch,0x00
    mov     cl,0x02	 ;a partir del segundo sector l�gico
    mov     dh,0x00
    mov     dl,0x00	 ;del primer disco duro
    mov     bx,0x800	 ;y escribir el contenido en 0x800:0
    mov     es,bx
    mov     bx,0x0000
    @@: int	0x13
	jc	@b

	mov	ax,0x13
	int	10h

	jmp	8000h	     ;poner en ejecucion el codigo cargado en HDD

times 510-($-$$) db 0
dw 0xaa55  

org 8000h

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
       cmp [first], 0
       jne @f
       call tablero
       call rey
       mov [first], 1
       @@:
       cmp [cambiar_colores], 1
       je colores

salir:
       mov al, 20h
       out 20h, al
       iret
	

keyboard:
	 in al, 60h
	 cmp al, 30; compara el caracter entrado por la interrupcion con la letra A
	 jne @f
	 call izquierda
	 jmp salir1
	 @@:
	 cmp al, 31 ; compara con la S
	 jne @f
	 call bajar
	 jmp salir1
	 @@:
	 cmp al, 32 ; compara con la D
	 jne @f
	 call derecha
	 jmp salir1
	 @@:
	 cmp al, 17 ; compara con la W
	 jne salir1
	 call subir
salir1:
	mov al, 20h
	out 20h, al
	iret

colores:
	cmp [cont], 9
	jne @f
	call tablero
	mov [color_rey], 08080808h
	mov [color], 0ah
	call rey
	@@:
	dec [cont]
	cmp [cont], 4
	ja salir
	cmp [cont], 0
	je @f
	mov [color_rey], 0c0c0c0ch
	mov [color], 04h
	call tablero
	call rey
	jmp salir
	@@:
	mov [cambiar_colores], 0
	mov [cont], 9
	mov [color_rey], 0d0d0d0dh
	mov [color], 03h
	call tablero
	call rey
	jmp salir
subir:
	mov [cambiar_colores], 1
	call limpiar
	call tablero
	sub [inicio], 320*40
	call rey
	sub [fila], 320*40
	@@:
	ret

bajar:
	mov [cambiar_colores], 1
	cmp [pos_final], 320*40
	call limpiar
	call tablero
	add [inicio], 320*40
	call rey
	add [fila], 320*40
	@@:
	ret

izquierda:
	mov bx, [fila]
	add bx, 40
	mov [cambiar_colores], 1
	call limpiar
	call tablero
	sub [inicio], 40
	call rey
	;call subir
	@@:
	ret

derecha:
	mov bx, [fila]
	add bx, 280
	mov [cambiar_colores], 1
	call limpiar
	call tablero
	add [inicio], 40
	call rey
	;call subir
	@@:
	ret

limpiar:
	mov di, 0
	mov eax, 00000000h
	mov cx, 200
	ciclo0:
		push cx
		mov cx, 80
		@@:
			mov [es:di], eax
			add di, 4
			loop @b
		pop cx
		loop ciclo0
ret

tablero:
	mov di, 0
	mov eax, 0f0f0f0fh
	call cuadrado
	mov di, 80
	call cuadrado
	mov di, 160
	call cuadrado
	mov di, 240
	call cuadrado
	mov di, 320*40+40
	call cuadrado
	mov di, 320*40+120
	call cuadrado
	mov di, 320*40+200
	call cuadrado
	mov di, 320*40+280
	call cuadrado
	mov di, 320*80
	call cuadrado
	mov di, 320*80+80
	call cuadrado
	mov di, 320*80+160
	call cuadrado
	mov di, 320*80+240
	call cuadrado
	mov di, 320*120+40
	call cuadrado
	mov di, 320*120+120
	call cuadrado
	mov di, 320*120+200
	call cuadrado
	mov di, 320*120+280
	call cuadrado
	mov di, 320*160
	call cuadrado
	mov di, 320*160+80
	call cuadrado
	mov di, 320*160+160
	call cuadrado
	mov di, 320*160+240
	call cuadrado
ret


cuadrado:
	mov cx, 40
ciclo:
      push cx
      mov cx, 10
      @@:
      mov [es:di], eax
      add di, 4
      loop @b
      pop cx
      add di, 320-40
      loop ciclo
ret

rey:
      mov ah, [color]
      ;mov di, 320*50+140
      mov di, [inicio]
      mov cx, 25
      @@:
      mov [es:di], ah
      add di, 320
      loop @b
      sub di, 320*16
      @@:
      mov cx, 16
      @@:
      mov [es:di], ah
      add di, 321
      loop @b
      sub di, 320*14+12
      add di, 320*2+2
      mov cx, 4+9
      @@:
      mov [es:di], ah
      sub di, 319
      loop @b


mov [pos_final], di			   
ret

color_rey dd 0d0d0d0dh
color db 03h
inicio dw 320*85+10+120
pos_final dw 0
fila dw 320*8
cambiar_colores db 0
cont db 9
salto db 0

first db 0


times (5*512)-($-$$) db 0
dw 0xaa55

