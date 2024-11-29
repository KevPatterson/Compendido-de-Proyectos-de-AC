format binary as 'img' 
       org 7c00h

	mov ax,cs
	mov ds,ax
	mov si,sequence16
	mov di,reverse16
	add si,9*2
	mov cx,10
    otro: mov ax,[si]
	mov [di],ax
	sub si,2
	add di,2
	loop otro

	sequence16: rw 10 ;Reservar 10 valores de 16bit
	reverse16: rw 10 ;Reservar 10 valores de 16bit
	times 510-($-$$) db 0 ;Rellenar primer sector
	dw 0xaa55 ;Firma de arranque