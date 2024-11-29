format binary as 'img'
org 7C00h

	 xor ax,ax
	 mov es,ax
	 mov ax,tecla
	 mov [es:9*4],ax
	 mov [es:9*4+2],cs
	 sti
	 jmp $

   escribir:
	mov ax,0x3
	int 10h
	mov bx,0b800h
	mov es,bx
	mov di,160*12+72
	mov ah,01001110b
  otro: mov al,[si]
	cmp al,0
	je salir
	mov [es:di],ax
	add di,2
	inc si
	jmp otro
  salir: ret

   tecla:
	 in al,60h
	 test al,10000000b
	 jz presionada
	 mov si,cliberada
	 jmp seguir
 presionada: mov si,cpresionada
  seguir: call escribir
	 mov al,20h
	 out 20h,al
	 iret

cpresionada db 'Tecla presionada',0
cliberada   db 'Tecla liberada  ',0
		

	  times 510-($-$$) db 0
			   dw 0xaa55
