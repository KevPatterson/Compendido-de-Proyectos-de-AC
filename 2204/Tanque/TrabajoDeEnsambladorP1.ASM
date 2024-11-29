Format binary as 'img'
org 7c00h
mov ax,13h
int 10h

mov ax,0a000h
mov es,ax

call Crear

push es
mov ax,0
mov es,ax
mov ax,Teclado
cli
mov [es:9*4],ax
mov [es:9*4+2],cs
sti
pop es
push es
  mov ax,0
  mov es,ax
  mov ax,Time
  cli
  mov [es:8*4],ax
  mov [es:8*4+2],cs
  sti
  pop es

  mov edi,0xa0000
  JMP $

	Crear:
	     Dibuja:
	    mov ax,013h
	    int 10h
	    mov di,320*120+150
	    inicio:
		   mov cx,40
		   tanqueho:
			    mov ah,07h
			    mov al,07h
			    mov [es:di],ax
			    add edi,320
			    loop tanqueho
			    mov cx,30
		   tanqueve:
			    mov ah,07h
			    mov [es:di],ah
			    inc edi
			    loop tanqueve
			    mov cx,41
		   tanqueho2:
			     mov ah,07h
			     mov al,07h
			     mov [es:di],ax
			     sub edi,320
			     loop tanqueho2
			     mov [es:di],ax
			     mov cx,30
		   tanqueve2:
			     mov ah,07h
			     mov [es:di],ah
			     dec edi
			     loop tanqueve2
			     mov [es:di],ax
	    ; add edi,320+29
	     ret

	Teclado:
		in al,60h

		CMP AL,127
		JA salir
			cmp al,017h
			je Llenado

			cmp al,020h
			je Detenido

			cmp al,02Eh
			je  Llenado

			jmp Teclado

	Llenado:
		     mov [boton],1
		     jmp timer
	Detenido:
		 mov [boton],0
		 jmp timer

	Time:
	     timer:
		    cmp [limite1],0
		    je Teclado
		    cmp [boton],1
		    jne Teclado
		    dec [cont]
		    jnz salir

		    mov cx,1
		completo:
		mov edi,[pos1]
			push cx
			 mov cx,26
			tanque1:
				mov ah,1
				mov al,1
				mov bh,1
				mov bl,1
				mov [es:di],ax
				inc edi
				mov [es:di],bx
				loop tanque1
			sub [pos1],320
			pop cx
			loop completo

		dec [limite1]
		mov  [cont],5

		salir:
		cli
		mov	 al,20h
		out	20h,al
		sti
		iret
	  cont dw 5
	  boton dw 0
	  botonApagar dw 0
pos1 dd 320*159+152
limite1 dw 40
  times 510-($-$$) db 0
		 dw 0xaa55