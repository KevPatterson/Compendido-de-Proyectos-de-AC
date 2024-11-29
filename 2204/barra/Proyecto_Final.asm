format binary as 'img'
org 7c00h

    ;Código para leer desde HDD:
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

	mov	ax,13h 
	int	10h


	jmp	8000h	     ;poner en ejecución el código cargado en HDD

times 510-($-$$) db 0
		 dw 0xaa55
        org 8000h

mov ax, 0x13
int 10h

mov ax, 0xa000
mov es, ax

mov bx, 0
mov di, 320*93+160-70

cli   
push es
xor ax, ax
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
        cmp bx, 0
        jne @f
        call barra
        mov bx, 1
        jmp fin_timer
       
        @@:
        cmp [flag], 2
        je fin_timer
        dec [cont_time]
        cmp [cont_time], 0
       
        jne fin_timer
        mov [cont_time], 18*2

llamar_bloque:
        inc [cont_prog]
        cmp [cont_prog], 1
        jne @f
        call bloque1
        jmp fin_timer

        @@:
        cmp [cont_prog], 2
        jne @f
        call bloque2
        jmp fin_timer

        @@:
        cmp [cont_prog], 3
        jne @f
        call bloque3
        jmp fin_timer

        @@:
        cmp [cont_prog], 4
        jne @f
        call bloque4
        jmp fin_timer

        @@:
        cmp [cont_prog], 5
        jne @f
        call bloque5
        jmp fin_timer

        @@:
        cmp [cont_prog], 6
        jne @f
        call bloque6
        jmp fin_timer

        @@:
        cmp [cont_prog], 7
        jne @f
        call bloque7
        jmp fin_timer

        @@:
        cmp [cont_prog], 8
        jne @f
        call bloque8
        jmp fin_timer

        @@:
        cmp [cont_prog], 9
        jne @f
        call bloque9
        jmp fin_timer

        @@:
        cmp [cont_prog], 10
        jne @f
        call bloque10

fin_timer:
        mov al, 20h
        out 20h, al
        iret

rutina_keyboard:
        in al, 60h 
        cmp al, 32 
        jne @f
        mov [flag], 2 
        @@:
        cmp al, 46
        jne fin_key
        mov [flag], 1
        
fin_key:
        mov al, 20h
        out 20h, al
        iret

barra:
        sub di, 1
        mov cx, 141
        mov ah, 0fh
        @@:
        mov [es:di], ah
        add di, 320*14
        mov [es:di], ah
        sub di, 320*14-1
        loop @b

        sub di, 141
        mov cx, 15
        @@:
        mov [es:di], ah
        add di, 141
        mov [es:di], ah
        add di, 320-141
        loop @b
ret


barra1:
       sub di,1
       mov cx, 36*4-5
       mov ah, 0fh
up:           
       mov [es:di], ah
       add di, 1
       loop up


       add di, 320-139
       mov cx, 15
       mov ah, 0fh
extremos:            
        mov [es:di], ah
        add di, 141
        mov [es:di], ah
        add di, 320-141
        loop extremos

        mov di, 320*107+160-70

        mov ah, 0fh
        mov cx, 36*4-3

down:               
        mov [es:di], ah
        add di, 1
        loop down
ret


bloque1:
        mov di, 320*95-160-69
        mov cx, 13
        pint_negro:
                push cx
                mov cx, 7
                mov ax, [negro]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-14
                loop pint_negro
                ret

bloque2:
        mov di, 320*95-160-69+14
        mov cx, 13
        pint_negro1:
                push cx
                mov cx, 3
                mov ax, [negro]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-6
                loop pint_negro1

        mov di, 320*95-160-69+14+6
        mov cx, 13
        pint_azul:
                push cx
                mov cx, 4
                mov ax, [azul]    
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-8
                loop pint_azul
                ret
bloque3:
        mov di, 320*95-160-69+14+6+8
        mov cx, 13
        pint_azul1:
                push cx
                mov cx, 6
                mov ax, [azul]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-12
                loop pint_azul1

        mov di, 320*95-160-69+14+6+8+12
        mov cx, 13
        pint_magenta:
                push cx
                mov cx, 1
                mov ax, [magenta]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-2
                loop pint_magenta
                ret

bloque4:
        mov di, 320*95-160-69+14+6+8+12+2
        mov cx, 13
        pint_magenta1:
                push cx
                mov cx, 7
                mov ax, [magenta]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-14
                loop pint_magenta1
                ret

bloque5:
        mov di, 320*95-160-69+14+6+8+12+2+14
        mov cx, 13
        pint_morado2:
                push cx
                mov cx,2
                mov ax, [magenta]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-4
                loop pint_morado2

        mov di, 320*95-160-69+14+6+8+12+2+14+4
        mov cx, 13
        pint_verde:
                push cx
                mov cx, 5
                mov ax, [verde] 
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-10
                loop pint_verde
                ret

bloque6:
        mov di, 320*95-160-69+14+6+8+12+2+14+4+10
        mov cx, 13
        pint_verde1:
                push cx
                mov cx, 5
                mov ax, [verde]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-10
                loop pint_verde1

        mov di, 320*95-160-69+14+6+8+12+2+14+4+10+10
        mov cx, 13
        pint_rojo:
                push cx
                mov cx, 2
                mov ax, [rojo] 
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-4
                loop pint_rojo
                ret

bloque7:
        mov di, 320*95-160-69+14+6+8+12+2+14+4+10+10+4
        mov cx, 13
        pint_rojo1:
                push cx
                mov cx, 7
                mov ax, [rojo]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-14
                loop pint_rojo1
                ret

bloque8:
        mov di, 320*95-160-69+14+6+8+12+2+14+4+10+10+4+14
        mov cx, 13
        pint_rojo2:
                push cx
                mov cx, 1
                mov ax, [rojo]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-2
                loop pint_rojo2


        mov di, 320*95-160-69+14+6+8+12+2+14+4+10+10+4+14+2
        mov cx, 13
        pint_amarillo:
                push cx
                mov cx, 6
                mov ax, [amarillo] 
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-12
                loop pint_amarillo
                ret

bloque9:
        mov di, 320*95-160-69+14+6+8+12+2+14+4+10+10+4+14+2+12
        mov cx, 13
        pint_amarillo1:
                push cx
                mov cx, 4
                mov ax, [amarillo]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-8
                loop pint_amarillo1

        mov di, 320*95-160-69+14+6+8+12+2+14+4+10+10+4+14+2+12+8
        mov cx, 13
        pint_blanco:
                push cx
                mov cx, 3
                mov ax, [blanco]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-6
                loop pint_blanco
                ret

bloque10:
        mov di, 320*95-160-69+14+6+8+12+2+14+4+10+10+4+14+2+12+8+6
        mov cx, 13
        pint_blanco1:
                push cx
                mov cx, 7
                mov ax, [blanco]
                @@:
                        mov [es:di], ax
                        add di, 2
                        loop @b
                pop cx
                add di, 320-14
                loop pint_blanco1
                ret

negro dw 0000h
azul dw 0101h 
magenta dw 0505h
verde dw 0202h
rojo dw 0404h
amarillo dw 0e0eh
blanco dw 0f0fh

color dd 0f0f0f0fh

flag db 0

cont_time db 18*2 
cont_prog db 0 

times (5*512)-($-$$) db 0
        dw 0xaa55
