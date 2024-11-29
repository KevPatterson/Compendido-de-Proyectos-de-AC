format binary as 'img'
org 7c00h


	mov	ah,0x02      
	mov	al,0x05      
	mov	ch,0x00
	mov	cl,0x02      
	mov	dh,0x00
	mov	dl,0x00      
	mov	bx,0x800     
	mov	es,bx
	mov	bx,0x0000
    @@: int	0x13
	jc	@b

	mov	ax,0x13
	int	10h

	jmp	8000h	     

times 510-($-$$) db 0
dw 0xaa55  

org 8000h                    
        mov ax, 0x13         
        int 10h

        mov ax, 0xa000
        mov es, ax

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
        
        jmp $

        timer:
                cmp [iniciando], 0 
                jne @f
                call tablero
                call torre
                mov [iniciando], 1
                @@:
                cmp [parpadeo_flag], 1
                je parpadeo

        salir:                  
                mov al, 20h
                out 20h, al
                iret
        
        parpadeo:
                cmp [cont], 9
                jne @f
                call tablero
                mov [color_torre], 03030303h
                mov [color_t], 03h
                call torre
                @@:
                dec [cont]
                cmp [cont], 4
                ja salir
                cmp [cont], 0
                je @f
                mov [color_torre], 01010101h
                mov [color_t], 01h
                call tablero
                call torre
                jmp salir
                @@:
                mov [parpadeo_flag], 0
                mov [cont], 9
                mov [color_torre], 04040404h
                mov [color_t], 04h
                call tablero
                call torre
                jmp salir

        keyboard:
                in al, 60h 
                cmp al, 30
                jne @f
                call mov_izq
                jmp salir1
                @@:
                cmp al, 31
                jne @f
                call mov_abajo
                jmp salir1
                @@:
                cmp al, 32
                jne @f
                call mov_der
                jmp salir1
                @@:
                cmp al, 17
                jne salir1
                call mov_arriba
        salir1:
                mov al, 20h
                out 20h, al
                iret

mov_arriba:
        cmp [pos_final], 320*40
        jbe @f
        mov [parpadeo_flag], 1
	call limpiar
        call tablero
        sub [inicio], 320*40
        call torre
        sub [fila], 320*40
        @@:
        ret

mov_abajo:
        cmp [pos_final], 320*170
        jae @f
        mov [parpadeo_flag], 1
        cmp [pos_final], 320*40
       	call limpiar
        call tablero
        add [inicio], 320*40
        call torre
        add [fila], 320*40
        @@:
        ret

mov_izq:
        mov bx, [fila]
        add bx, 40
        cmp [inicio], bx
        jb @f
        mov [parpadeo_flag], 1
        call limpiar
        call tablero
        sub [inicio], 40
        call torre
        @@:
        ret

mov_der:
        mov bx, [fila]
        add bx, 280
        cmp [inicio], bx
        jae @f
        mov [parpadeo_flag], 1
        call limpiar
        call tablero
        add [inicio], 40
        call torre
        @@:
        ret

limpiar:
	mov di, 0
	mov eax, 00000000h
	mov cx, 200
	ciclo0:
		push cx
		mov cx, 80
		@@:
			mov [es:di], eax
			add di, 4
			loop @b
		pop cx
		loop ciclo0
ret

tablero:
        mov di, 0
        mov eax, 04040404h
        call cuadrado
        mov di, 80
        call cuadrado
        mov di, 160
        call cuadrado
        mov di, 240
        call cuadrado
        mov di, 320*40+40
        call cuadrado
        mov di, 320*40+120
        call cuadrado
        mov di, 320*40+200
        call cuadrado
        mov di, 320*40+280
        call cuadrado
        mov di, 320*80
        call cuadrado
        mov di, 320*80+80
        call cuadrado
        mov di, 320*80+160
        call cuadrado
        mov di, 320*80+240
        call cuadrado
        mov di, 320*120+40
        call cuadrado
        mov di, 320*120+120
        call cuadrado
        mov di, 320*120+200
        call cuadrado
        mov di, 320*120+280
        call cuadrado
        mov di, 320*160
        call cuadrado
        mov di, 320*160+80
        call cuadrado
        mov di, 320*160+160
        call cuadrado
        mov di, 320*160+240
        call cuadrado
ret


cuadrado:
        mov cx, 40
        ciclo:
                push cx
                mov cx, 10
                @@:
                        mov [es:di], eax
                        add di, 4
                        loop @b
                pop cx
                add di, 320-40
                loop ciclo
ret

torre:
	mov eax, [color_torre]
	mov cx, 2
        ciclo1:
        push cx
        mov di, [inicio]
        mov cx, 6
        @@:                
                mov [es:di], ah
                add di, 4
                loop @b
        pop cx
        add di, 320-4*6
        loop ciclo1
        mov cx, 3
        @@:                
                mov [es:di], ah
                add di, 20
                mov [es:di], ah
                add di, 320-20
                loop @b
        sub di, 320
        mov cx, 5
        @@:                
                mov [es:di], eax
                add di, 4
                loop @b
        
        add di, 320-20
        add di, 4
        mov ah, [color_t]
        mov cx, 15
        @@:                
                mov [es:di], ah
                add di, 12
                mov [es:di], ah
                add di, 320-12
                loop @b

        sub di, 4
        mov cx, 5
        @@:                
                mov [es:di], eax
                add di, 4
                loop @b
                sub di, 20
        mov cx, 4
        @@:                
                mov [es:di], ah
                add di, 20
                mov [es:di], ah
                add di, 320-20
                loop @b
        sub di, 320
        mov cx, 5
        @@:                
                mov [es:di], eax
                add di, 4
                loop @b
                
                mov [pos_final], di
ret

color_torre dd 04040404h
color_t db 04h
inicio dw 320*164+290
pos_final dw 0
fila dw 320*164
parpadeo_flag db 0
cont db 9

iniciando db 0


times (512*5)-($-$$) db 0
dw 0xaa55
