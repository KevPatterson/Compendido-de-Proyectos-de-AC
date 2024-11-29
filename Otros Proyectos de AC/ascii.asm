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
		add di,4
		loop otro
		jmp	$
		

	  times 510-($-$$) db 0

			   dw 0xaa55
