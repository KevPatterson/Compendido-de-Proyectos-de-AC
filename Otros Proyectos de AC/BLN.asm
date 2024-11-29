format binary as 'img'
org 7C00h
		mov ax,0x3
		int 10h
		mov ax,0xb800
		mov es,ax
		mov eax,'BALA'
		mov bx,'NA'
		mov [es:160*12+2*40],eax
		mov [es:160*12+2*42],bx
		jmp	$
		

	  times 510-($-$$) db 0
			   dw 0xaa55
