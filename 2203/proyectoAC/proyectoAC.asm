Format binary as 'img'
org 7c00h


Inicio:
     mov ax,0a000h
     mov es,ax

     mov ah,0
     mov al,13h
     int 10h

     mov di,320*96+110
     mov cx,102
     mov ah, 0fh

arriba:
     mov[es:di],ah
     inc di
     loop arriba

     mov di,320*96+110
     mov cx,8

izquierdo:
     mov[es:di],ah
     add di,320
     loop izquierdo

     mov di,320*96+212
     mov cx,8

derecho:
    mov[es:di],ah
    add di,320
    loop derecho

    mov di,320*104+110
    mov CX,103

abajo:
    mov[es:di],ah
    inc di
    loop abajo
               

    cli        ;rutina del timer
    push es 
    xor ax,ax
    mov es,ax
    mov ax,timer
    mov [es:8*4],ax
    mov [es:8*4+2],cs
    sti
    pop es              

    mov bx,0
    mov edi,0xa0000
    
jmp     $

timer:  
    mov al, [rojo] 
    dec [cont]
    jnz salir

    mov cx,5

ciclo:
    mov [edi+320*97+111],al
    mov [edi+320*98+111],al
    mov [edi+320*99+111],al
    mov [edi+320*100+111],al
    mov [edi+320*101+111],al
    mov [edi+320*102+111],al
    mov [edi+320*103+111],al
    inc edi
    add bx,1
    loop ciclo
              
    mov [cont],18
    cmp bx,100
    je Mostrar

salir:
    mov al,20h                 
    out 20h,al
    iret

Mostrar:
    mov ax,0b800h
    mov es,ax
    mov ax,3h
    int 10h
    mov si,0
    mov di,160*12+2*30
    mov ah, [blanco]
    mov cx,24
              
intro:
    mov al,[Transferencia+si]
    mov [es:di],ax
    add di,2
    inc si
    loop intro


    cli
    push es
    xor ax,ax
    mov es,ax
    mov ax,teclado
    mov [es:9*4],ax
    mov [es:9*4+2],cs
    sti
    pop es
    
teclado:
   in al,60h
   cmp al,28
   jnz salir
   jmp Inicio
    
    
    Transferencia db 'Transferencia completada'
    cont db 18
    rojo db 00000100b
    blanco db 00001111b
    
    times 510-($-$$) DB 0
                dw 0xaa55

 
