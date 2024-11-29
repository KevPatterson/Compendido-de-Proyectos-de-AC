
format binary as 'img'
org 7C00h

MOV AX,16
MOV ES,AX
MOV SI,4
MOV BX,0xFF
MOV EAX,0
MOV AL,[Palabra+SI]
PUSH ES
PUSH EAX
PUSH BX
CALL EJEMPLO


EJEMPLO:
PUSH BP
MOV BP,SP
MOV BX,[BP+10]
MOV ECX,[BP+6]
MOV AX,CX
DIV BL
ADD [resto],ah
call mostrar
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


Palabra db 16,25,84,150,36,2,14
resto db 48

times 510-($-$$) db 0
			   dw 0xaa55
