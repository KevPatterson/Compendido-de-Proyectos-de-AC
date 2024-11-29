format binary as 'img'
org 7C00h
		mov ax,0x3
		int 10h

		mov ax,0xb800
		mov es,ax

		mov si,0
		mov di,160*12+2*40
		mov cx,20
	      otro:mov al,[lista+si]
	      cmp al,3ah
	      jb num
	      mov ah,[atribl]
	      jmp seguir
	     num: mov ah,[atribc]
	     seguir: mov [es:di],ax
		inc si
		add di,2
		loop otro
		jmp	$
		
		    lista db ' GRUPO 2201  y 2203 '
		    atribl db 00001001b
		    atribc db 00001010b
	  times 510-($-$$) db 0

			   dw 0xaa55
