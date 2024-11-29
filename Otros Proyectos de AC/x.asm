format binary as 'img'
org 7C00h
		mov ax,0x3
		int 10h
		mov ax,0xb800
		mov es,ax
		mov al,'X'
		mov ah,01110100b
		mov [es:160*20+2*50],ax
		jmp	$
		

	  times 510-($-$$) db 0
			   dw 0xaa55
