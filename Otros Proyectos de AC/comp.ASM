format binary as 'img'
org 7C00h
		mov ax,0xb800
		mov gs,ax

		mov ax,3
		int 10h

		mov eax,4100
		xor bh,bh
		mov bl,1
		xor ecx,ecx
		mov cl,[uno]
		mov dx, 19

		push bx
		push eax
		push dx
		push ecx

		call cambiar

		cambiar:
		push bp
		mov bp,sp
		mov dx, [bp+14]
		mov [tecla],dh
		mov eax,[bp+4]
		mov ah,al
		mov edx,[bp+10]
		mov di,dx

		sub di,800
		mov si,18
		mov cx,[bp+8]
	      otro:
		mov al,[nombre+si]
		mov [gs:di],al
		inc di
		mov [gs:di],ah
		inc di
		dec si
		loop otro

		tecla db 0
		uno db 0f1h
		nombre db  'Aprobe Arquitectura'
		times 510-($-$$) db 0

			   dw 0xaa55 
