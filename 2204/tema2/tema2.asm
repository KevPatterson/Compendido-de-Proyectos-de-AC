format binary as 'img'
org 7C00h

xor ax, ax
mov es, ax

mov ax,0x3
int 10h
mov ax,0xb800
mov es,ax

mov dh, 3
mov di, 160 * 11 + 2 * 36

falsafila:
	mov cx, 6
	CALL seleccionar

	falsacol:
	    mov al, [si]
	    inc si
	    mov ah, [color]
	    mov [es:di], ax
	add di, 2

	loop falsacol

	add di, 148

	dec dh
	cmp dh,0
	ja falsafila

xor ax, ax
mov es, ax


jmp escuchar

empezar:
mov di, 160 * 11 + 2 * 36

mov ax,timer
mov [es:4*8], ax
mov [es:4*8+2], cs
sti

mov bl, 1


@@:
	IN AL,60h
	CMP AL, 0x21	
	je termina

    cmp dl, 9
    je pintar

    jmp @b

pintar:
	

	    mov ax,0x3
		int 10h
		mov ax,0xb800
		mov es,ax
	    mov dh, 3

	fila:
	mov cx, 6
	CALL seleccionar

	col:
	    mov al, [si]
	    inc si
	    mov ah, [color]
	    mov [es:di], ax
	add di, 2

	loop col

	add di, 148
    

	dec dh
	cmp dh,0
	ja fila
    
    cmp di, 4072
    je arriba
    
    cmp di, 552
    je abajo

    cmp bl, 1
    je moverAbajo
    cmp bl, 2
    je moverArriba
    

    seguir:
    
    
	

mov dl,0
jmp @b
termina:
jmp $


timer:
    cli
    inc dl
    mov al, 20h
    out 20h, al
    sti
iret

seleccionar:
	cmp dh, 3
	je up
	cmp dh, 2
	je mid
	cmp dh, 1
	je down
	fin:
  ret

    up:
    mov si, ar
    jmp fin

    mid:
    mov si, ce
    jmp fin

    down:
    mov si, ab
    jmp fin
    

    arriba:
    mov bl, 2
    add [color], 16
    xor [color], 11000010b
    or	[color], 64
    jmp moverArriba

    moverAbajo:
    sub di, 320
    jmp seguir

    moverArriba:
    sub di, 640
    jmp seguir

    abajo:
    mov bl, 1
    add [color], 16
    xor [color], 10100100b
    or	[color], 64
    jmp moverAbajo

    escuchar: 
	IN AL,60h

	CMP AL, 0x1f	
	je empezar	
    jmp escuchar
    
	

    color db 01110010b

    ar db '      '
    ce db '  AC  '
    ab db '      '

times	510-($-$$) db 0
	    dw 0xaa55