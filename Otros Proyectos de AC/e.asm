format binary as 'img'
org 7c00h
 
mov ax,0x3
int 10h
mov ax,0xb800
mov es,ax
push es
mov ax,0
mov es,ax
mov ax,escribir
cli
mov [es:9*4],ax
mov [es:9*4+2],cs
sti
pop es ;agregar


jmp $

escribir:
in al ,60h
cmp al,127
jnb salir
mov ah,01000010b
mov di,160*10+2*40
mov si,0
mov cx,7
otro:
mov al,[nombre+si]
mov [es:di],ax
inc si
add di,2
loop otro



 
 salir:
 mov al ,20h
 out 20h,al
 iret
 
 
 color rb 1
 nombre db 'Armando'
 times 510 -($-$$) db 0
 dw 0xaa55