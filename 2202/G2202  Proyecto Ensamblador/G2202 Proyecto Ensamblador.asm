 ;Melisa Hernandez,Melissa Maura Borroto G2202 ,Tema 3

format binary as 'img'
org 7c00h
mov ax, 0x13
int 10h
mov ax,0xa000
mov es, ax
mov di, 0

push es
cli
xor ax,ax
mov es,ax
mov ax, timer
mov [es:8*4], ax
mov [es:8*4+2], cs
sti
pop es
	
push es
cli
xor ax,ax
mov es,ax
mov ax, keyboard
mov [es:9*4], ax
mov [es:9*4+2], cs
sti
pop es

call background

jmp $


timer:
    cmp [flag], 1
    jne quit

    cmp [pausa], 1
    je quit

    inc [count]

    

    cmp [opcion], 1
    je t1

    jmp quit

    t1:
	cmp [count], 18
	jne quit
	

	cmp [pausa], 0
	je dib
	jne quit

	dib:
	    mov cx, 3
	    tt1:
		call untanque
	    loop tt1
	    mov [count], 0

	    inc [count1]
	    cmp [count1], 20
	jne quit

	@@:
	    mov [flag], 0
	    mov [count1], 0

	jmp quit

    

    quit:
	mov al, 20h
	out 20h, al
iret

keyboard:
    in	al,60h

    cmp al, 26h
    je l1
    cmp al, 20h
    je l2
    cmp al, 2eh
    je l3
    cmp al, 1h
    je l4
    jmp salir

    l1:
	call background
	mov [opcion], 1
	mov [flag], 1
	mov [count], 0
	mov [count1], 0
	mov [pausa], 0
	jmp salir
    l2:
	mov [pausa], 1

	jmp salir
    l3:
	mov [pausa], 0
	jmp salir
    
    l4:
	mov [opcion], 0
	mov [flag], 0
	mov [count], 0
	mov [count1], 0
	mov [pausa], 0
	call background

	jmp salir
    
    salir:
	mov	al,20h
	out	20h,al
iret


dibMarco:
	push cx
	call marco
	pop cx
	sub di, 320+39
ret

marco:
    mov cx, 20
    call largo
    sub di, 40

    mov cx, 62
    call ancho

    mov cx, 20
    call largo
    sub di, 320*59-2
    mov cx, 62
    ADD di, -320*2
    call ancho

    
ret

largo:

    mov ah,00h
    mov al, 00h
    DibLargo:
	mov [es:di], ax
	add di, 2
    loop DibLargo
    sub di, 2
ret

ancho:
    mov ah, 00
    mov al, 00h
    DibAncho:
	mov [es:di], ax
	add di, 320
    loop DibAncho
    sub di, 320
    
ret

paso:
    push cx
    mov cx, 39
    mov al, 01h
    mov ah, 01h
    loopt1:
	mov [es:di], ax
	add di, 1
    loop loopt1
    pop cx
ret

untanque:
    call paso
    add di, -359
ret


background:
    mov cx, 320*200
    mov ah, 0fh
    mov al, 0fh
    mov di, 0
    fondo:
	mov [es:di], ax
	add di, 2
    loop fondo

    mov di, 320*80+135
    call dibMarco
ret

count db 0
opcion db 0
flag db 0
count1 db 0
pausa db 0

times  510-($-$$) db 0
dw 0xAA55