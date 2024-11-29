;Equipo 3 , Grupo CDF-2202 , Ernesto Perez Blanco , Abraham Gonzalez Ventura
format binary as 'img'
org 7c00h

mov ax, 0x13   ;Establecer el mode de video en modo VGA 13h
int 10h

mov ax,0xa000  ;Establecer el segmento de memoria de video en la direccion 0xa000
mov es, ax
mov di, 0
;Configurar la interrupcion del temporizador
push es            ;Guardar el valor del registro de segmento 'es' en la pila
     cli           ;Dehsabilita las interrupciones
     xor ax,ax     ;limpia el registro ax
     mov es,ax     ; Establece el segmento de memoria a cero
     mov ax, timer ;Configura las direcciones de rutina de manejo del temporizador
     mov [es:8*4], ax
     mov [es:8*4+2], cs
     sti           ;Habilita las interrupcioes nuevamente
     pop es        ;Restaura el valor guardado en la pila al registro de segmento 'es'
;Cnfigurar la interrupcion del teclado
push es
     cli
     xor ax,ax
     mov es,ax
     mov ax, keyboard
     mov [es:9*4], ax
     mov [es:9*4+2], cs
     sti
     pop es

call Fondo

     jmp $

;incrementar un contador y verifica algunas banderas para determinar qué acciones tomar
timer:
    cmp [flag], 1
    jne quit

    cmp [parar], 1
    je quit

    inc [count]

    

    cmp [opcion], 1
    je t1

    jmp quit

    t1:
        cmp [count], 18
        jne quit
        

        cmp [parar], 0
        je llenar
        jne quit

        llenar:
            mov cx, 3
            tt1:
                call tanque
            loop tt1
            mov [count], 0

            inc [count1]
            cmp [count1], 20
        jne quit

        @@:
            mov [flag], 0
            mov [count1], 0

        jmp quit

    

    quit:
        mov al, 20h
        out 20h, al
iret
;Maneja las interrupciones del teclado y toma diferentes acciones segun las teclas precionadas
keyboard:
    in  al,60h

    cmp al, 26h
    je l1
    cmp al, 20h
    je l2
    cmp al, 2eh
    je l3
    cmp al, 1h
    je l4
    jmp salir

    l1:
        call Fondo
        mov [opcion], 1
        mov [flag], 1
        mov [count], 0
        mov [count1], 0
        mov [parar], 0
        jmp salir
    l2:
        mov [parar], 1

        jmp salir
    l3:
        mov [parar], 0
        jmp salir
    
    l4:
        mov [opcion], 0
        mov [flag], 0
        mov [count], 0
        mov [count1], 0
        mov [parar], 0
        call Fondo

        jmp salir
    
    salir:
        mov     al,20h
        out     20h,al
iret


dibBorde:
        push cx
        call borde
        pop cx
        sub di, 320+39
ret
;Dibujar el tanque
borde:
    mov cx, 20
    call ancho
    sub di, 40

    mov cx, 62
    call alto

    mov cx, 20
    call ancho
    sub di, 320*59-2
    mov cx, 62
    ADD di, -320*2
    call alto

    
ret

ancho:

    mov ah,00h
    mov al, 00h
    DibAncho:
        mov [es:di], ax
        add di, 2
    loop DibAncho
    sub di, 2
ret

alto:
    mov ah, 00
    mov al, 00h
    DibAlto:
        mov [es:di], ax
        add di, 320
    loop DibAlto
    sub di, 320
    
ret
;Llenado del tanque
llenado:
    push cx
    mov cx, 39
    mov al, 01h
    mov ah, 01h
    loopt1:
        mov [es:di], ax
        add di, 1
    loop loopt1
    pop cx
ret

tanque:
    call llenado
    add di, -359
ret


Fondo:
    mov cx, 320*200
    mov ah, 0fh
    mov al, 0fh
    mov di, 0
    fondo1:

        mov [es:di], ax
        add di, 2
    loop fondo1

    mov di, 320*80+135
    call dibBorde
ret

        count db 0
        opcion db 0
        flag db 0
        count1 db 0
        parar db 0

        times  510-($-$$) db 0
        dw 0xAA55