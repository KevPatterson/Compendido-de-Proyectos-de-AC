format binary as 'img'
org 7c00h

; Estableciendo el modo modo Video Gráfico

xor ax, ax
mov ax, 13h
int 10h

xor ax, ax
mov ax, 0a000h
mov es, ax

; Escribir Vector Teclado

cli

xor ax, ax
mov gs, ax
mov ax, teclado
mov [gs:9*4], ax
mov [gs:9*4+2], cs

sti



; Escribir Vector Timer

cli

xor ax, ax
mov gs, ax
mov ax, timer
mov [gs:8*4], ax
mov [gs:8*4+2], cs

sti


; Pintar Fondo

mov [ancho], 320
mov [largo], 200
mov di, 0
mov al, 0fh

call rectangulo

; Pintar Parte Exterior Tanque

mov [ancho], 130
mov [largo], 150
mov di, 25*320 + 95
mov al, 00h

call rectangulo

; Pintar Parte Interior Tanque

mov [ancho], 120
mov [largo], 140
mov di, 30*320 + 100
mov al, 0fh

call rectangulo

jmp $

; Pintar Rectangulo

teclado: in al, 60h
	 cmp al, 127
	 ja fin
	 cmp al, 26h
	 jne cmpOtra
	 mov [pos], 163*320 + 100
	 mov [llenar], 1
	 mov [seguir], 1
	 jmp fin
cmpOtra: cmp al, 2fh
	 mov [pos], 30*320 + 100
	 mov [llenar], 0
	 mov [seguir], 1
	 jne fin
fin:	 mov al, 20h
	 out 20h, al
	 iret

; Timer

timer:	      cmp [seguir], 0
	      je finTimer
	      dec [cont]
	      jnz finTimer
	      mov [cont], 18
	      call pintarLL
	      call pintarV
finTimer:     mov al, 20h
	      out 20h, al
	      iret



rectangulo:	
    mov cx, [largo]
for_r1:     
    push cx
    mov cx, [ancho]
for_r2:     
    mov [es:di], al
    inc di
    loop for_r2
    pop cx
    sub di, [ancho]
    add di, 320
    loop for_r1
    ret

pintarLL:	 mov al, 1
		 cmp [llenar], 1
		 jne finPintarLL
		 cmp [pos], 30*320
		 jb finPintarLL
		 mov [ancho], 120
		 mov [largo], 7
		 mov di, [pos]
		 call rectangulo
		 sub [pos], 2240
finPintarLL:	 ret

pintarV:	 mov al, 15
		 cmp [llenar], 0
		 jne finPintarV
		 cmp [pos], 163*320 + 220
		 ja finPintarV
		 mov [ancho], 120
		 mov [largo], 7
		 mov di, [pos]
		 call rectangulo
		 add [pos], 2240
finPintarV:	 ret



; Variables

ancho dw ?
largo dw ?
seguir db 0
cont dw 18
pos dw ?
llenar db 1

times 510-($-$$) db 0
dw 0aa55h