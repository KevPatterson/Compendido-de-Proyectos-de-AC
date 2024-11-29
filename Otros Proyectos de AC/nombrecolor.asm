format binary as 'img'
org 7C00h
		mov ax,0x3
		int 10h

		mov ax,0xb800
		mov es,ax

		mov si,0
		mov ah,[atrib]
		mov di,160*12+2*40
		mov cx,7
	      otro:mov al,[nombre+si]
		mov [es:di],ax
		inc si
		inc ah
		add di,2
		loop otro
		jmp	$
		
		    nombre db 'BARBARA'
		    atrib  db 00000001b
	  times 510-($-$$) db 0

			   dw 0xaa55
