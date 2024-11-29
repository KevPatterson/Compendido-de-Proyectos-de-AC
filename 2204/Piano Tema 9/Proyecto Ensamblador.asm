Format binary as 'img'
org 7C00h
    mov ax, 0x13
    int 10h

    mov ax, 0xA000
    mov es, ax

    mov di, 0
    mov AL, 0x0f ;
    mov cx, 320
pantalla:
dibuja_pantalla_blanca:
    mov [es:di],ax
    inc di
    loop dibuja_pantalla_blanca
    inc di
    dec dl
    mov cx,319
    cmp dl,0
    ja pantalla

;________________________________________
    xor di,di                            ;
    mov di,320*0+50                      ;
    mov cx,14                            ;
    mov al, 0x00                         ;
    mov dl,100                           ;
repetir:                                 ;
dibuja_tecla_negra_pequena:              ;
    mov [es:di],ax                       ;     1
    inc di                               ;
    loop dibuja_tecla_negra_pequena      ;
    add di,306                           ;
    dec dl                               ;
    mov cx,14                            ;
    cmp dl,0                             ;
    ja repetir                           ;
;________________________________________
    mov di,320*0+114                     ;
    mov cx,14                            ;
    mov al, 0x00                         ;
    mov dl,100                           ;
repetir2:                                ;
dibuja_tecla_negra_pequena2:             ;
    mov [es:di],ax                       ;     2
    inc di                               ;
    loop dibuja_tecla_negra_pequena2     ;
    add di,306                           ;
    dec dl                               ;
    mov cx,14                            ;
    cmp dl,0                             ;
    ja repetir2                          ;
;________________________________________
   mov di,320*0+178                      ;
    mov cx,14                            ;
    mov al, 0x00                         ;
    mov dl,100                           ;
repetir3:                                ;
dibuja_tecla_negra_pequena3:             ;
    mov [es:di],ax                       ;
    inc di                               ;     3
    loop dibuja_tecla_negra_pequena3     ;
    add di,306                           ;
    dec dl                               ;
    mov cx,14                            ;
    cmp dl,0                             ;
    ja repetir3                          ;
;________________________________________
    mov di,320*0+242                     ;
    mov cx,14                            ;
    mov al, 0x00                         ;
    mov dl,100                           ;
repetir4:                                ;
dibuja_tecla_negra_pequena4:             ;     4
    mov [es:di],ax                       ;
    inc di                               ;
    loop dibuja_tecla_negra_pequena4     ;
    add di,306                           ;
    dec dl                               ;
    mov cx,14                            ;
    cmp dl,0                             ;
    ja repetir4                          ;
;________________________________________
    mov di,320*0+305                     ;
    mov cx,14                            ;
    mov al, 0x00                         ;
    mov dl,100                           ;
repetir5:                                ;
dibuja_tecla_negra_pequena5:             ;
    mov [es:di],ax                       ;
    inc di                               ;
    loop dibuja_tecla_negra_pequena5     ;
    add di,306                           ;
    dec dl                               ;
    mov cx,14                            ;
    cmp dl,0                             ;    5
    ja repetir5
;________________________________________

    xor di, di                           ;
    mov di, 320*100+63                   ;
    call ralla                           ;
    mov di, 320*100+127                  ;
    call ralla                           ;
    mov di, 320*100+191                  ;
    call ralla                           ;
    mov di, 320*100+255                  ;
    call ralla                           ;



espera_tecla:
    mov ah, 0
    int 16h
    cmp al, 'a'
    je tecla_a

    cmp al, 's'
    je tecla_s

    cmp al, 'd'
    je tecla_d

    cmp al, 'f'
    je tecla_f

    cmp al, 'b'
    je tecla_g

tecla_a:
       mov [pos], 320*0+0
       call tecla
       jmp espera_tecla

tecla_s:
       mov [pos], 320*0+64
       call tecla
       jmp espera_tecla


tecla_d:
       mov [pos], 320*0+128
       call tecla
       jmp espera_tecla

tecla_f:
       mov [pos], 320*0+192
       call tecla
       jmp espera_tecla

tecla_g:
       mov [pos], 320*0+256
       call tecla
       jmp espera_tecla
ret


tecla:
        mov di, [pos]
        mov bl, 03h
        mov bh, 03h
        push dx
        push cx
        call tecla_presionada
        pop dx
        pop cx
        call esperar

        mov di, [pos]
        mov bl, 02h
        mov bh, 02h
        push cx
        call tecla_presionada
        pop cx
        call esperar

        mov di, [pos]
        mov bl, 04h
        mov bh, 04h
        push cx
        call tecla_presionada
        pop cx
        call esperar

        mov di, [pos]
        mov bl, 05h
        mov bh, 05h
        push cx
        call tecla_presionada
        pop cx
        call esperar

        mov di, [pos]
        mov bl, 0fh
        mov bh, 0fh
        push cx
        call tecla_presionada
        pop cx
        call esperar

ret

tecla_presionada:
        mov cx, 50
        mov dl, 200

repetir7:
    repetir7.1:
        mov [es:di],bx
        inc di
    loop repetir7.1
        add di, 270
        dec dl
        mov cx, 50
        cmp dl,0
        ja repetir7

        sub di,320*99+270
        mov cx, 12
        mov dl, 100


repetir8:
    repetir8.2:
        mov [es:di],bx
        inc di
        loop repetir8.2
        add di, 308
        dec dl
        mov cx, 12
        cmp dl,0
        ja repetir8
ret

ralla:
        mov al, 0x00
        mov dl, 100
    show:
        mov[es:di],bx
        dec dl
        add di,320
        cmp dl,0
        ja show
ret

esperar:
    mov ah, 86h
    mov cx, 280
    mov dx, 4240h
    int 15h
ret

pos dw 0

times 510-($-$$) db 0
dw 0aa55h