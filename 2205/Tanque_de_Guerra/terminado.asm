;GRUPO: 2205
;EQUIPO 1
;TEMA: TANQUE DE GUERRA
;ESTUDIANTES: DAYMAR GUERRERO SANTIAGO
;             RAMON ALEJANDRO MATEO OCHOA
;             CHRISTOPHER FRIAS RAMOS               
format binary as 'img'
org 7c00h

;Código para leer desde HDD:
	mov	ah,0x02      ;usar el BIOS para cargar
	mov	al,0x05      ;cantidad de sectores
	mov	ch,0x00
	mov	cl,0x02      ;a partir del segundo sector lógico
	mov	dh,0x00
	mov	dl,0x00      ;del primer disco duro
	mov	bx,0x800     ;y escribir el contenido en 0x800:0
	mov	es,bx
	mov	bx,0x0000
    @@: int	0x13
	jc	@b

	mov	ax,0x13
	int	10h

	jmp	8000h	     ;poner en ejecucion el codigo cargado en HDD

times 510-($-$$) db 0
dw 0xaa55  

org 8000h

mov ax, 0x13
int 10h

mov ax, 0xa000 
mov es, ax

mov di, 320*150+30 
mov [where], di

cli
push es
xor ax, ax ;
mov es, ax
mov ax, rutina_timer
mov [es:8*4], ax
mov [es:8*4+2], cs
sti
pop es


cli
push es
xor ax, ax
mov es, ax
mov ax, rutina_keyboard
mov [es:9*4], ax
mov [es:9*4+2], cs
sti
pop es


jmp $

rutina_timer:
        cmp [first], 0 
        je first1
        
        cmp [explosion_flag], 0;
        je dddd;
        
        dec [exp_cont]
        call explosion;
        
        cmp [exp_cont], 0;
        jne @f;
        mov [exp_cont],6;
        call limpiar
        call print_tanque
        mov [explosion_flag], 0;
        jmp dddd
        
        @@:
        cmp [exp_cont], 3
        jne dddd
        call explosion1;

        dddd:;
        cmp [shoot], 0 ; si shoot esta en cero el proyectil esta en el aire
        je @f ; salto a la siguiente etiqueta anonima
        dec [contador_proyectil] 
        cmp [contador_proyectil], 0
        jne @f
        mov [contador_proyectil], 6
        call shooting
        @@:
        cmp [flag], 1 ; flag es una bandera de movimiento, si esta en uno se mueve a la izquierda, si esta en 2, se mueve a la derecha
        je mover_a_izq
        cmp [flag], 2
        jne salir
        @@:
        mov [flag], 10
        call mov_rigth
        jmp salir
        
        mover_a_izq:
        mov [flag], 10
        call mov_left
        jmp salir
        first1:
        mov [first], 1
        call print_tanque

salir:
        mov al, 20h
        out 20h, al
        iret

rutina_keyboard:
        in al, 60h 
        cmp al, 30
        jne comp_d
        mov [flag], 1 ; mover a la izq
        jmp salir2
        comp_d:
        cmp al, 32
        je @f
        cmp al, 31
        je disparar
        jmp salir2
        @@:
        mov [flag], 2 ; mover a la der
        jmp salir2
        disparar:
        mov [shoot], 1 ; 

salir2:
        mov al, 20h
        out 20h, al
        iret

mov_rigth:
        add [where], 6 
        call limpiar
        call print_tanque
        @@:
        cmp [shoot], 0
        je @f
        sub [pos_proyectil], 33
        call shooting
        @@:
        ret

mov_left:
        sub [where], 6
        call limpiar
        call print_tanque
        @@:
        cmp [shoot], 0
        je @f
        sub [pos_proyectil], 33
        call shooting
        @@:
        ret

limpiar:
        mov di, 0
        mov edx, 00000000h
        mov cx, 200
        fila:
        push cx
        mov cx, 80
        columna:
                mov [es:di], edx
                add di, 4
                loop columna
        pop cx
        loop fila
        ret

print_tanque:

        mov di, [where]
        mov al, [color_tanque]
        call tanqueta
        mov di, [pos]
        sub di, [amplitud]
        sub di, 5
        call cuerpo
        add di, 320
        sub di, [amplitud]
        add di, 3
        call ruedas
        ret

tanqueta:
        mov cx, 20
        @@:
        mov [es:di], al
        inc di
        loop @b
        mov [amplitud], 21
        mov cx, 5
        @@:
        add di, 320
        sub di, [amplitud]
        mov [es:di], al
        add [amplitud], 1
        add di, [amplitud]
        mov [es:di], al
        inc [amplitud]
        cmp cx, 3
        je ppp
        loop @b
        jmp @f
        ppp:
        push cx
        mov cx, 15
           ttt:
            mov [es:di], al
            inc di
            loop ttt
        pop cx
        mov [pos_canon], di
        sub di, 15
        loop @b
        @@:
        mov [pos], di
        ret
cuerpo:
        mov cx, 40
        @@: ;linea_alta:
        mov [es:di], al
        inc di
        loop @b

        add di, 320-40
        mov [amplitud], 40
        mov cx, 8
        @@: ;laterales:
        mov [es:di], al
        add di, [amplitud]
        mov [es:di], al
        add di, 320
        sub di, [amplitud]
        loop @b
        mov cx, 40
        @@: ;linea_baja
        mov [es:di], al
        inc di
        loop @b
        mov [pos], di
        ret

ruedas: 
        mov cx, 12
        @@:
        mov [es:di], al
        add di, 3
        loop @b
        ret

shooting:
        cmp [shoot], 1
        jne @f
        mov [shoot], 2
        mov bx, [pos_canon]
        mov [pos_proyectil], bx
        mov [pos_disparo], bx
        mov di, [pos_proyectil]
        sub di, 320
        mov al, 04h
        mov [es:di], al
        inc di
        mov [es:di], al
        inc di
        mov [es:di], al
        add di, 320-2
        mov [es:di], al
        inc di
        mov [es:di], al
        inc di
        mov [es:di], al
        sub [contador_proyectil], 3
        add [pos_proyectil], 3
        jmp finall
        
        @@:
        cmp [pos_proyectil], 320*154-16
        jae end_shoot
        call limpiar
        call print_tanque
        mov al, [color_proyectil]
        mov di, [pos_proyectil]
        mov [es:di], al
        finall:
        add [pos_proyectil],33
        ret
        end_shoot:
        mov [explosion_flag], 1
        call limpiar
        call print_tanque
        mov [shoot], 0
        ret

explosion:
        mov di, 320*154-3
        mov al, 0eh
        mov [es:di], al
        inc di
        mov [es:di], al
        inc di
        mov [es:di], al
        add di, 320-2

        mov [es:di], al
        inc di
        mov [es:di], al
        inc di
        mov [es:di], al
        ret
explosion1:
        mov di, 320*154-3
        mov al, 04h
        mov [es:di], al
        inc di
        mov [es:di], al
        inc di
        mov [es:di], al
        add di, 320-2

        mov [es:di], al
        inc di
        mov [es:di], al
        inc di
        ret
        
flag db 0 ;1-> izq 2-> der
color_tanque db 02h
color_proyectil db 0fh
amplitud dw 0
pos dw 0
where dw 0
first db 0
contador_tanque dw 8
contador_proyectil dw 6
pos_canon dw 0
pos_proyectil dw 0
pos_disparo dw 0
shoot db 0
resto db 0
caja db 0
limite db 9
exp_cont db 3
explosion_flag db 0

times (5*512)-($-$$) db 0
dw 0xaa55
