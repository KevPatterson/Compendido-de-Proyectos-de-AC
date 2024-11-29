format binary as 'img'
org 7C00h
      ;Visualizar el código scan en binario
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
	  mov cx,8
otro: mov dl,30h; ascii del 0
      shl al,1; para saber si es 0 o 1
      jnc cero
      mov dl,31h;ascii del 1
cero: mov [es:di],dx
      add di,2
      loop otro
      ret


		

	  times 510-($-$$) db 0
			   dw 0xaa55
