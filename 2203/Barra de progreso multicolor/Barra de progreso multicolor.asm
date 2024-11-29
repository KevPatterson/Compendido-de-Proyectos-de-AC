						format binary as 'img'
org 7c00h; punto de entrada del programa

mov	ah,0x02
mov	al,0x05
mov	ch,0x00
mov	cl,0x02
mov	dh,0x00
mov	dl,0x00
mov	bx,0x800
mov	es,bx
mov	bx,0x0000
@@: int     0x13
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
mov di, 29850

cli   
push es
xor ax, ax
mov es, ax
mov ax, rutina_timer
mov [es:32], ax
mov [es:34], cs
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
mov [cont_time], 30

llamar_segmento:
inc [cont_prog]
cmp [cont_prog], 1
jne @f
call segmento1
jmp fin_timer

@@:
cmp [cont_prog], 2
jne @f
call segmento1.2
jmp fin_timer

@@:
cmp [cont_prog], 3
jne @f
call segmento2
jmp fin_timer

 @@:
cmp [cont_prog], 4
jne @f
call segmento3
jmp fin_timer

@@:
cmp [cont_prog], 5
jne @f
call segmento3.1
jmp fin_timer

@@:
cmp [cont_prog], 6
jne @f
call segmento4
jmp fin_timer

@@:
cmp [cont_prog], 7
jne @f
call segmento5
jmp fin_timer

@@:
cmp [cont_prog], 8
jne @f
call segmento6
jmp fin_timer

@@:
cmp [cont_prog], 9
jne @f
call segmento6.1
jmp fin_timer

@@:
cmp [cont_prog], 10
jne @f
call segmento7

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
add di, 4480
mov [es:di], ah
sub di, 4479
loop @b

sub di, 141
mov cx, 15
@@:
mov [es:di], ah
add di, 141
mov [es:di], ah
add di,179
loop @b
ret


barra1:
sub di,1
mov cx, 139
mov ah, 0fh
up:	      
mov [es:di], ah
add di, 1
loop up


add di, 181
mov cx, 15
mov ah, 0fh
extremos:	     
mov [es:di], ah
add di, 141
mov [es:di], ah
add di, 179
loop extremos

mov di, 34330

mov ah, 0fh
mov cx, 141

down:		    
mov [es:di], ah
add di, 1
loop down
ret


segmento1:
mov di, 30171
mov cx, 13
pint_color1:
push cx
mov cx, 7
mov ax, [color1]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 306
loop pint_color1
ret

segmento1.2:
mov di, 30157
mov cx, 13
pint_color11:
push cx
mov cx, 3
mov ax, [color1]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 314
loop pint_color11

mov di,30191
mov cx, 13
pint_color2:
push cx
mov cx, 4
mov ax, [color2]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 312
loop pint_color2
ret
segmento2:
mov di,30199
mov cx, 13
pint_color21:
push cx
mov cx, 6
mov ax, [color2]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 308
loop pint_color21

mov di,30211
mov cx, 13
pint_color31:
push cx
mov cx, 1
mov ax, [color3]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di,318
loop pint_color31
ret

segmento3:
mov di,30213
mov cx, 13
pint_color32:
push cx
mov cx, 7
mov ax, [color3]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 320-14
loop pint_color32
ret

segmento3.1:
mov di, 30227
mov cx, 13
pint_morado2:
push cx
mov cx,2
mov ax, [color3]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 316
loop pint_morado2

mov di, 30231
mov cx, 13
pint_color4:
push cx
mov cx, 5
mov ax, [color4]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 310
loop pint_color4
ret

segmento4:
mov di,30241
mov cx, 13
pint_color41:
push cx
mov cx, 5
mov ax, [color4]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 310
loop pint_color41

mov di,30251
mov cx, 13
pint_color5:
push cx
mov cx, 2
mov ax, [color5]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 316
loop pint_color5
ret

segmento5:
mov di, 30255
mov cx, 13
pint_color52:
push cx
mov cx, 7
mov ax, [color5]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 306
loop pint_color52
ret

segmento6:
mov di, 30269
mov cx, 13
pint_color51:
push cx
mov cx, 1
mov ax, [color5]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 318
loop pint_color51

mov di,30271
mov cx, 13
pint_color6:
push cx
mov cx, 6
mov ax, [color6]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 308
loop pint_color6
ret

segmento6.1:
mov di, 30283
mov cx, 13
pint_color62:
push cx
mov cx, 4
mov ax, [color6]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 312
loop pint_color62

mov di, 30291
mov cx, 13
pint_color7:
push cx
mov cx, 3
mov ax, [color7]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 314
loop pint_color7
ret

segmento7:
mov di, 30297
mov cx, 13
pint_color71:
push cx
mov cx, 7
mov ax, [color7]
@@:
mov [es:di], ax
add di, 2
loop @b
pop cx
add di, 306
loop pint_color71
ret

color1 dw 0000h
color2 dw 0101h
color3 dw 0202h
color4 dw 0303h
color5 dw 0404h
color6 dw 0505h
color7 dw 0606h

color dd 0f0f0f0fh

flag db 0

cont_time db 18*2 
cont_prog db 0 

times (5*512)-($-$$) db 0
	dw 0xaa55
