format binary as 'img'
org 7C00h
		mov ax,0xb800
		mov es,ax

		;Escribir el vector
		push es
		mov ax,0
		mov es,ax
		mov ax,cambiacolor
		cli
		mov [es:9*4],ax
		mov [es:9*4+2],cs
		sti
		pop es

		 jmp $

cambiacolor:
	       in al,60h
		cmp al,127
		ja liberada
		cmp al,30
		je continuar
		 error:
		 call cartelerror
		 jmp liberada
		continuar:
		 mov [color],11h
		 call Colorear
		liberada:
		mov al,20h
		out 20h,al
		iret

		Colorear:
		mov al, ' '
		mov ah,[color]
		mov di,0
		mov cx,2000
	      otro:
		mov [es:di],ax
		add di,2
		loop otro
		ret

	cartelerror:
		mov ax,0x3
		int 10h
		mov si,0
		mov ah,00001110b
		mov di,3254
		mov cx,5
	      otroe:mov al,[mensaje+si]
		mov [es:di],ax
		inc si
		add di,2
		loop otroe
		ret

   color rb 1
   mensaje db 'ERROR'
	  
times 510-($-$$) db 0

			       dw 0xaa55 

