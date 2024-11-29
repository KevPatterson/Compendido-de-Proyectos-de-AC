tecla:
		in al,60h
		cmp al,48
		jne seguir
		call bolas
		call mostrarb
		jmp salir
		
	seguir:
		cmp al,32
		jne segir1
		call strikes
		call mostrars
		jmp salir
		
	seguir1:
		cmp al,24
		jne salir
		call outss
		call mostrarO
		
	salir: mov al,20h
		   out 20h,al
		   iret