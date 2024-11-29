;Elieser David Valdes Correa cdf 2205 tema 5
;Dalay Calzadilla Guerrero


format binary as 'img'
org 7C00h

cli
mov ax, 0 ; Segmento donde se encuentra la IVT
mov es, ax ; Establece ES al segmento de la IVT
mov word[es:9*4],  keyboard_interrupt
mov word[es:9*4+2], cs

xor di, di
xor dl,dl
xor ax, ax
mov es, ax
mov ax,timer

mov [es:4*8], ax
mov [es:4*8+2], cs
sti
mov ax,13h
int 10h
mov ax, 0xa000
mov es, ax
mov bx,0

b1: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
    je espera_activa ; Si es igual, salta a la etiqueta 'next'
    cmp dl, 18
    jne b1
pintar1:
mov al, 08h
mov di,320*132+11
call pintar_bloque
mov dl,0
b2: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
    je espera_activa ; Si es igual, salta a la etiqueta 'next'
    cmp dl, 91
    jne b2
pintar2:
mov al, 08h
mov di,320*132+86
call pintar_bloque
mov dl,0
b3: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
    je espera_activa ; Si es igual, salta a la etiqueta 'next'
    cmp dl, 91
    jne b3
pintar3:
mov al, 08h
mov di,320*132+161
call pintar_bloque
mov dl,0
b4: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
    je espera_activa ; Si es igual, salta a la etiqueta 'next'
    cmp dl, 91
    jne b4
pintar4:
mov al, 08h
mov di,320*132+236
call pintar_bloque
mov dl,0
b5: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
    je espera_activa ; Si es igual, salta a la etiqueta 'next'
    cmp dl, 91
    jne b5
pintar5:
mov al, 08h
mov di,320*102+49
call pintar_bloque
mov dl,0
b6: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
    je espera_activa ; Si es igual, salta a la etiqueta 'next'
    cmp dl, 91
    jne b6
pintar6:
mov al, 08h
mov di,320*102+124
call pintar_bloque
mov dl,0
b7: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
    je espera_activa ; Si es igual, salta a la etiqueta 'next'
    cmp dl, 91
    jne b7
pintar7:
mov al, 08h
mov di,320*102+199
call pintar_bloque
mov dl,0
b8: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
    je espera_activa ; Si es igual, salta a la etiqueta 'next'
    cmp dl, 91
    jne b8
pintar8:
mov al, 08h
mov di,320*72+86
call pintar_bloque
mov dl,0
b9: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
    je espera_activa ; Si es igual, salta a la etiqueta 'next'
    cmp dl, 91
    jne b9
pintar9:
mov al, 08h
mov di,320*72+161
call pintar_bloque
mov dl,0
b10: cmp [obra_en_ejecucion], 0 ; Compara la variable de control con 0
     je espera_activa ; Si es igual, salta a la etiqueta 'next'
     cmp dl, 91
     jne b10
pintar10:mov al, 08h
         mov di,320*42+124
         call pintar_bloque
         mov dl,0
     final:cmp dl,182
         jne final
     fin:
         mov ax,13h
         int 10h
         mov ax,0xa000
         mov es,ax

        jmp $
pintar_bloque:  mov cx,25
                altura:
                push cx
                mov cx,70
                largo:
                mov [es:di],al
                inc di
                loop largo
                pop cx
                add di,320
                sub di,70
                loop altura
                inc bx
                ret
espera_activa:  cmp [obra_en_ejecucion], 1
                jne espera_activa
                cmp bx,0
                je pintar1
                cmp bx,1
                je pintar2
                cmp bx,2
                je pintar3
                cmp bx,3
                je pintar4
                cmp bx,4
                je pintar5
                cmp bx,5
                je pintar6
                cmp bx,6
                je pintar7
                cmp bx,7
                je pintar8
                cmp bx,8
                je pintar9
                cmp bx,9
                je pintar10
                jmp fin
                keyboard_interrupt: in al,64h ; puerto de estado
                    test al,1 ; buffer de salida lleno
                    JZ keyboard_interrupt
                    in al, 60h ; Lee el puerto del teclado
                    cmp al, 19 ; Compara con el código de escaneo de 'R'
                    je start ; Si es igual, salta a la etiquueta start'
                    cmp al, 32 ; Compara con el código de escaneo de 'D'
                    je stop ; Si es igual, salta a la etiqueta 'stop'
                    cmp al,01 ;comprobar si es la tecla escç
                    je fin
                    jmp key
stop:
    mov [obra_en_ejecucion], 0 ; Establece la variable de control a 0
    mov  [contador_bloques], bx
    jmp key ; Retorna de la interrupción
start:
    mov [obra_en_ejecucion], 1 ; Establece la variable de control a 1
    mov bx, [contador_bloques]
   jmp key ; Retorna de la interrupción
key:  mov al,20h
      out 20h,al
      iret ; Retorna de la interrupción
timer:
      cli
      inc dl
      mov al, 20h
      out 20h, al
      sti
iret
obra_en_ejecucion db 1
contador_bloques dw 0

times   510-($-$$) db 0
            dw 0xaa55
