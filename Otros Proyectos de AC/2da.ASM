format binary as 'img'
org 7C00h
		mov ax,0xb800
		mov gs,ax

		mov ax,3
		int 10h
		mov di,2000

		;Escribir el vector
		push es
		mov ax,0
		mov es,ax
		mov ax,cartel
		cli
		mov [es:9*4],ax
		mov [es:9*4+2],cs
		sti
		pop es


		 jmp $

		 cartel:
		in al,60h
		cmp al,127
		ja liberada
		cmp al,19;scan de la R
		jne seguir
		mov [tecla],1
		mov ah,[atrib]
		call escribir
		jmp liberada
		seguir:
		mov [tecla],2
		mov ah,[color]
		call escribir
		liberada:
		mov al,20h
		out 20h,al
		iret

	     escribir:
		sub di,800
		mov si,11
		mov cx,12
	      otro:
		mov al,[nombre+si]
		mov [gs:di],ax
		dec si
		cmp [tecla],1
		jne cambiar
		dec di
		dec di
		jmp fin
		cambiar:
		add di,2
		fin:
		loop otro
		jmp	$

		tecla db 0
		atrib db 21h
		color db 0e4h
		nombre db  'ARQUITECTURA'
		times 510-($-$$) db 0

			   dw 0xaa55 
