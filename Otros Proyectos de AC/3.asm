
format binary as 'img'
org 7C00h

MOV AX,0x30
MOV ES,AX
MOV SI,3
MOV BX,0xFF
MOV EAX,0
MOV AL,[Pal+SI]
PUSH EAX
PUSH ES
PUSH BX
CALL CALCULAR

CALCULAR:
PUSH BP
MOV BP,SP
MOV DX,[BP+6]
MOV EBX,[BP+8]
MOV AX,BX
DIV DL
ADD [resto],ah
CALL mostrar
RET 

 mostrar:
		mov ax,0x3
		int 10h
		mov ax,0xb800
		mov es,ax
		mov al,[resto]
		mov ah,00000100b
		mov [es:160*12+2*39],ax
		ret
		jmp	$


Pal   db 14,2,150,55,84,25,16
resto db 48

times 510-($-$$) db 0
			   dw 0xaa55
