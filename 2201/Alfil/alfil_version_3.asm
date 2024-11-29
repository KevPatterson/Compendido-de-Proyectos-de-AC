format binary as 'img'
org 7C00h

		mov ax,13h
		int 10h

		mov ax,0a000h
		mov es,ax
		
		
		
	mov di,320*0+0
	mov al, [background]
	mov ah, [background]

rellenar_pantalla:
	mov cx, 32000
	loop_p:

		mov [es:di], ax
		add di, 2
	loop loop_p

mov di,320*36+96

call game
jmp $


game:
    xor bx, bx
    mov bh, 7
    call toggle_color
	call tablero
    call alfil_
	frame:

	call input
	call alfil_
	jmp frame
	jmp $
ret 
alfil_:
	push ax
	xor ax, ax 
	mov al, [color_alfil]
	mov ah, [color_alfil]
	call alfil
	pop ax
ret 

tablero:
	push di
	mov cx, 8
	tablero_b:
		call fila
	loop tablero_b
	pop di
ret
input:
	push ax
	push di
    push bx

	xor ax, ax
	mov ah, 00h
	int 16h
	cmp al, 'a'
	je mov_up_left
	cmp al, 'd'
	je mov_up_right
	cmp al, 'w'
	je mov_down_left
	cmp al, 's'
	je mov_down_right

	jmp no_mover
	mov_up_left:
		add bl, -1
		add bh, -1
		jmp fin_input_con_mov

	mov_up_right:
		add bl, 1
		add bh, -1
		jmp fin_input_con_mov

	mov_down_left:
		add bl, -1
		add bh, 1
		jmp fin_input_con_mov

	mov_down_right:
		add bl, 1
		add bh, 1


    fin_input_con_mov:
     

        cmp bl, 7
        jg no_mover
        cmp bl, 0
        jl no_mover
        cmp bh, 7
        jg no_mover
        cmp bh, 0
        jl no_mover
        jmp mover;

        no_mover:
            pop bx
            pop di
            pop ax
            jmp frame
        mover:
            pop ax
        analizar:

        pop di
        pop ax

        call await
        ret
	fin_input_sin_mov:
	pop di
	pop ax
    ret

fila:
	push cx
	push di
	mov cx, 8
	row:
		call cuadrado
	loop row
	call toggle_color
	pop di
	mov cx, [height]
	mover_abajo:
		add di, 320
	loop mover_abajo

	pop cx
ret
cuadrado:
	push cx
	mov cx, [height]
	cuadrado_b:
		push cx 
		mov cx, [widht]
		linea:  			
			mov [es:di], ax
			add di, 1
		loop linea
		
		mov cx, [widht]
		linea_subir:		
			add di, -1
		loop linea_subir
		add di, 160*2		
		pop cx
	loop cuadrado_b
	mov cx, [widht]
	re:
		add di, 1
	loop re
	mov cx, [height]
	re2:
		add di, -320
	loop re2
	call toggle_color
	pop cx
	ret

toggle_color:
	cmp al, [color_1]
	je c2

	c1:
	mov al, [color_1]
	mov ah, [color_1]
	ret
	c2:
	mov al, [color_2]
	mov ah, [color_2]
ret 



await:
	push ax
	push cx
	push dx
    call tablero
    call  alfil_

	call esperar
	mov ah, [color_3]
	mov al, [color_3]
	call alfil

	call esperar
	call  alfil_

	call esperar
	mov ah, [color_3]
	mov al, [color_3]
	call alfil

	call esperar
	call  alfil_

    pop dx
	pop cx
	pop ax  
ret
esperar:
    mov ah, 86h 		
    mov cx, [tiempo]	
    mov dx, 4240h
    int 15h
ret

alfil:
    push di
    push bx
	mov cl, bl
	posisionar_x:
		push cx
		mov cx, [widht]
		posisionar_x1:
			add di, 1
		loop posisionar_x1
		pop cx
	loop posisionar_x
	mov cl, bh
	posisionar_y:
		push cx
		mov cx, [height]
		posisionar_y1:
			add di, 320
		loop posisionar_y1
		pop cx
	loop posisionar_y

    mov bx, 2
    call draw_line
    mov bx, 3
    call draw_line
    call draw_line
    mov bx, 2
    call draw_line
    call draw_line
    mov bx, 1
    call draw_line
    call draw_line
    call draw_line
    call draw_line
    mov bx, 2
    call draw_line
    call draw_line
    mov bx, 3
    call draw_line
    mov bx, 4
    call draw_line
    pop bx
    pop di
ret
    
    
draw_line:
    mov cx, 7
    sub cx, bx
    mov_linea_1: 
        add di,1
    loop mov_linea_1
    
    mov cx, bx
    add cx, 1
    dib_linea_1: 
        mov [es:di],eax
        add di,2
    loop dib_linea_1
    
    mov cx, 7
    sub cx, bx

    reg1_linea_1:
        add di,-1
    loop reg1_linea_1
    mov cx, bx
    add cx, 1
    reg2_linea_1: 
        add di, -2
    loop reg2_linea_1


        add di,320
ret


	color_1 db 00001111b
	color_2 db 00000100b

	color_3 db 00000110b
	color_alfil db 00000011b
	background db 00000011b

	widht dw 16 
	height dw 16
	tiempo dw 3
	

	  times 510-($-$$) db 0
			   dw 0xaa55
