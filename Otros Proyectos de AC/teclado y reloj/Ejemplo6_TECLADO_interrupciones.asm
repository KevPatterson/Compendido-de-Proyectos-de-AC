; Escriba y pruebe una subrutina para utilizar las
; teclas del 1 al 9 de modo que al oprimirlas, se
; imprima un mensaje en pantalla de color
; equivalente a la tecla oprimida.

format binary as 'img'
org 7C00h
	
	MOV AX,CS
	MOV DS,AX
	MOV AX,0B800h
	MOV ES,AX
	
	XOR AH,AH	
	MOV AL,3		; modo 3, texto 80x25
	INT 10h 
	
	CLI
	XOR AX,AX
	MOV GS,AX
	MOV AX,rutina_teclado
	MOV [GS:9*4],AX
	MOV [GS:9*4+2],CS
	STI
	
	jmp $	
	
rutina_teclado: 
	IN AL,60h
	CMP AL,127		; no hacer nada si se libera una tecla
	JA salir
	CMP AL,2		; no hacer nada si es menor que el scan del 1
	JB salir
	CMP AL,10		; no hacer nada si es mayor que el scan del 9
	JA salir
		
	MOV AH,AL		; carga el atributo
	DEC AH			; lo convierte al atributo seg?n el n?mero
	
	XOR DI,DI		; se escribirá al inicio de la pantalla
	MOV SI,mensaje		; mensaje a escibir
ciclo:
	MOV AL,[SI]
	CMP AL,0
	JE salir
	MOV [ES:DI],AX
	INC SI
	ADD DI,2
	JMP ciclo
salir:
	MOV AL,20h
	OUT 20h,AL
	IRET
	
	mensaje db "Esto es una prueba",0	
	
times 510-($-$$) db 0
	dw 0xAA55
