format binary as 'img'
org 7C00h
      ;Visualizar el código make en decimal
      mov ax,0x3
      int 10h
      xor ax,ax
      mov es,ax
      mov ax,tecla
      mov [es:9*4],ax
      mov [es:9*4+2],cs
      sti
      jmp $


	tecla: in al,60h
	mov dh,4eh
	mov di,160*12+76
	call escribir
	mov al,20h
	out 20h,al
	iret

escribir: mov bx,0b800h
	  mov es,bx
	  and al,01111111b
	  xor ah,ah
	  mov bl
	  add ax,3030h
	  mov dl,ah
	  mov [es:di],dx
	  add di,2
	  mov dl,al
	  mov [es:di],dx
	  ret



		

	  times 510-($-$$) db 0
			   dw 0xaa55
