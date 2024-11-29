format binary as 'img'
org 7C00h


		mov ax,0xb800
		mov es,ax

		mov al,20h;espacio
		mov ah,0
		mov di,0
		mov cx,2000
	      otro:
		mov [es:di],ax
		add di,2
		loop otro
		jmp	$
		

	  times 510-($-$$) db 0

			   dw 0xaa55
