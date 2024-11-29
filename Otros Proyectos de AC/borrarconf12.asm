format binary as 'img'
org 7C00h


		mov ax,0xb800
		mov es,ax

		;Escribir el vector
		push es
		mov ax,0
		mov es,ax
		mov ax,f12borrar
		cli
		mov [es:9*4],ax
		mov [es:9*4+2],cs
		sti
		pop es

		 jmp $

		 f12borrar:
		in al,60h
		cmp al,127
		ja liberada
		cmp al,88;f12
		jne liberada
		call borrar
		liberada:
		mov al,20h
		out 20h,al
		iret



		borrar:
		mov al,20h;espacio
		mov ah,0
		mov di,0
		mov cx,2000
	      otrob:
		mov [es:di],ax
		add di,2
		loop otrob
		ret
		jmp	$
		

	  times 510-($-$$) db 0

			   dw 0xaa55
