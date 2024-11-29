;Asteriscos 2
;Desarrollar un programa que rellene la pantalla con asteriscos "*" en espiral, siguiendo el sentido d las manecillas del reloj,
;desde la esquina superior izquierda hasta el centro de la pantalla y que despues borre la pantalla moviendose en sentido contrario
;Los asteriscos aparecen o desaparecen cada un segundo
;Si se preciona R cambie al color rojo y si se preciona V a verde
;Finalice el programa si se preciona ESC
format binary as 'img' ;
org 7c00h


        mov     ah,0x02
        mov     al,0x04
        mov     ch,0x00
        mov     cl,0x02
        mov     dh,0x00
        mov     dl,0x80
        mov     bx,0x800
        mov     es,bx
        mov     bx,0x0000
    @@: int     0x13
        jc      @b
        jmp     8000h

times 510-($-$$) db 0
                 dw 0aa55h

org 8000h

mov ax, 0x3
int 10h
  
CLI
      xor ax,ax
      mov gs,ax
      mov ax, key
      mov [gs:9*4], ax
      mov [gs:9*4+2], cs

      mov ax, timer
      mov [gs:8*4], ax
      mov [gs:8*4+2], cs

STI
      mov ax, 0xb800
      mov es, ax
      mov di, 0
      mov bl, 39
      mov bh, 24
      mov dx, 160*12+108

jmp $
 
timer:
      dec [cont]
      jnz salir

      call PRINT
      mov [cont], 1
      salir:
            mov al, 20h
            out 20h, al
iret

key:
      in al, 60h
      cmp al, 127
      ja fin_key
      cmp al, 19
      jnz opcion1
      mov [aux], 1
      
      opcion1:
            cmp al, 47
            jnz opcion2
            mov [aux], 2
           
      opcion2:
            cmp al, 01
            jnz fin_key
            mov [aux], 3
            

 fin_key:
            mov al, 20h
            out 20h, al
      iret

PRINT:

cmp [aux], 3
je final
cmp [prueba], 1
je reverse

cmp [aux], 1
je rojo
cmp [aux], 2
je verde


comprobacion:
    cmp [flag], 0
    je derecha
    cmp [flag], 1
    je abajo
    cmp [flag], 2
    je izquierda
    cmp [flag], 3
    je arriba




rojo:
    mov [color], 00000100b
    jmp comprobacion
verde:
    mov [color], 00000010b
    jmp comprobacion




derecha:
    cmp [horizontal], bl
    je resta0
    add di, 4
    inc [horizontal]
    jmp asterisco
abajo:
    cmp [vertical], bh
    je resta1
    add di, 160
    inc [vertical]
    jmp asterisco
izquierda:
    cmp [horizontal], bl
    je resta2
    add di, -4
    inc [horizontal]
    jmp asterisco
arriba:
    cmp [vertical], bh
    je resta3
    add di, -160
    inc [vertical]
    jmp asterisco


salto:
    mov [prueba], 1
    mov bh, 1
    mov bl, 15

reverse:
    mov di, dx
    mov [color], 00000000b


    cmp [flag], 1
    je left
    cmp [flag], 2
    je down
    cmp [flag], 3
    je right
    cmp [flag], 0
    je up

    left:
        cmp [horizontal], bl
        je suma0
        add dx, -4
        inc [horizontal]
        jmp asterisco
    down:
        cmp [vertical], bh
        je suma1
        add dx, 160
        inc [vertical]
        jmp asterisco
    right:
        cmp [horizontal], bl
        je suma2
        add dx, 4
        inc [horizontal]
        jmp asterisco
    up:
        cmp [vertical], bh
        je suma3
        add dx, -160
        inc [vertical]
        jmp asterisco





asterisco:
    mov ah, [color]
    mov al, [cadena]
    mov [es:di], ax
ret



resta0:
    sub bl, 1
    mov [flag], 1
    mov [horizontal], 0
jmp abajo

resta1:
    sub bh, 1
    mov [vertical], 0
    cmp bh, -1
    je salto
    mov [flag], 2
    
jmp izquierda

resta2:
    sub bl, 1
    mov [flag], 3
    mov [horizontal], 0
jmp arriba

resta3:
    sub bh, 1
    mov [flag], 0
    mov [vertical], 0
jmp derecha




suma0:
    add bl, 1
    mov [flag], 2
    mov [horizontal], 0
jmp down

suma1:
    add bh, 1
    mov [flag], 3
    mov [vertical], 0
jmp right

suma2:
    add bl, 1
    mov [flag], 0
    mov [horizontal], 0
jmp up

suma3:
    add bh, 1
    mov [flag], 1
    mov [vertical], 0
jmp left

final:
    mov ax, 0x3
    int 10h



cadena db '*'

aux db 0
cont db 1
color db 0000001111b
horizontal db 0
vertical db 0
flag db 0
prueba db 0



times (4*512)-($-$$) db 0 ;)
