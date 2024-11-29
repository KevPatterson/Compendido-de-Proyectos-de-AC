format binary as 'img'
org 7C00h
;punto centro de la pantalla
mov ax,0x13
int 10h
mov ax,0xA000
mov es,ax
mov di,100
mov eax,01010101h
mov cx,255
otro: mov [es:di],eax
add di,320*2
add eax,01010101h
loop otro


		jmp	$
		

	  times 510-($-$$) db 0
			   dw 0xaa55
