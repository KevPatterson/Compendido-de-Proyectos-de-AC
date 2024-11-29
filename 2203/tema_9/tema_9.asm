;Tema 9 cintillo promocional giratorio 
;Alejandro Vázquez Marrero
;Patricia Rojas Gácita
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

	mov	ax, 13h
	int	10h

	jmp	8000h	    

times 510-($-$$) db 0
dw 0xaa55

org 8000h


mov ax, 0x3
int 10h

mov ax, 0xb800
mov es, ax

cli
push es
xor ax, ax
mov es, ax
mov ax, rutina_de_tiempo
mov [es:8*4], ax
mov [es:8*4+2], cs
sti
pop es


cli
push es
xor ax, ax
mov es, ax
mov ax, rutina_de_teclado
mov [es:9*4], ax
mov [es:9*4+2], cs
sti
pop es

jmp $

rutina_de_tiempo:
        cmp [do_it], 1
        jne final_tiempo
        dec [tiempo]
        cmp [tiempo], 0
        jnz final_tiempo
        mov [tiempo], 3
        call borrar1
        call print_cadena1
final_tiempo:
        mov al, 20h
        out 20h, al
        iret

rutina_de_teclado:
        inc [contador]
        cmp [contador], 255
        je matrix
        cmp [cintillo_flag], 1
        je cintillo
        in al, 60h
        cmp al, 1
        jne @f
        mov ax, 0x3
        int 10h
        jmp $
        
        @@:
        cmp al, 14   
        je borrar
        cmp al, 28    
        je matrix
        cmp al, 128   
        jae fina_teclado
        mov esi, normal_keymap
        call print_num
        jmp fina_teclado
        
        matrix:
        mov [cintillo_flag], 1
        jmp fina_teclado
        borrar:
        mov al, 00000000b
        xor ah, ah
        mov [es:edi], al
        ;dec si
        ;sub di, 2
        sub edi, 2
        sub dx, 1
        sub [current_pos], 2
        jmp fina_teclado
        
        cintillo:
        in al, 60h
        cmp al, 1
        jne @f
        mov ax, 0x3
        int 10h
        jmp $
        
        @@:
        cmp al, 50
        jne @f
        mov [do_it], 0
        mov [cintillo_flag], 0
        
        @@:
        mov di, 160*24+2*79
        ;push di
        mov [do_it], 1
fina_teclado:
        mov al, 20h
        out 20h, al
        iret

print_num:
        cmp [cintillo_flag], 1
        je @f
        xor ah, ah
        add si, ax
        mov al, [esi]
        mov edi, [current_pos]
        mov [0xb8000+edi], al
        push si
        mov si, cadena
        add si, dx
        mov [si], al
        inc [tamano]
        inc dx
        xor si, si
        pop si
        add [current_pos], 2
        @@:
        ret

borrar1:
        mov di, 0
        mov cx, 160
        @@:
                push cx
                mov cx, 30
                erase:
                mov ah, 00000000h
                mov al, ' '
                mov [es:di], ax
                add di, 2
                loop erase
                pop cx
                loop @b
                ret

        
print_cadena1:
        mov si, cadena
        mov di, [pos_num]
        sub di, [cant_act]
        mov cx, [cant_act]
        mov al, 00001111b
        @@:
        mov ah, [si]
        mov [es:edi], ax
        add di, 2
        inc si
        loop @b
        inc [cant_act]
        sub [pos_num], 2
        ret


pos_num dw 3840
color db 00001111b
contador db 0x
current_pos dd 0
cadena db 255 dup(?)
tamano dw 0
tiempo db 1
do_it db 0
cant_act dw 1

normal_keymap: db 0
                db 27,'1234567890-=',8
                db 9,'qwertyuiop[]',10
                db 0,'asdfghjkl;',39,96,0,'\'
                db 'zxcvbnm,./',0,'*',0,' '
                db 0,'2345678901',0,'3789-456+1230.'
                ret

cintillo_flag db 0

times (5*512)-($-$$) db 0
dw 0xaa55
