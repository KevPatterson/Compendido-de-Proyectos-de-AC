format binary as 'img'
org 7C00h
		mov ax,0x3
		int 10h

		mov ax,0xb800
		mov es,ax

		mov al,0
		mov ah,00001001b
		mov di,0
		mov cx,255
	      otro:
		mov [es:di],ax
		inc al
		dec [contador]
		jnz seguir
		mov [contador],40
		add di,164; dejar una fila
		jmp continuar
		seguir:
		add di,4
		continuar:
		loop otro
		jmp	$
		
	     contador db 40
	  times 510-($-$$) db 0

			   dw 0xaa55
