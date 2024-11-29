format binary as 'img'
org 7c00h

;Código para leer desde HDD:
        mov     ah,0x02      ;usar el BIOS para cargar
        mov     al,0x05      ;cantidad de sectores
        mov     ch,0x00
        mov     cl,0x02      ;a partir del segundo sector lógico
        mov     dh,0x00
        mov     dl,0x00      ;del primer disco duro
        mov     bx,0x800     ;y escribir el contenido en 0x800:0
        mov     es,bx
        mov     bx,0x0000
    @@: int     0x13
        jc      @b

        mov     ax,13h ; 0x3 para modo texto
        int     10h


        jmp     8000h        ;poner en ejecución el código cargado en HDD

times 510-($-$$) db 0
                 dw 0xaa55
org 8000h

    mov ax, cs
    mov ds, ax

    mov ax,0x3
    int 10h

    mov ax, 0xb800
    mov es, ax




              ;Mensaje de solicitud de introduzca la hora a la que sonara la alarma

    mov di, [direMen1]
    mov si, 0
    mov cx,70
    mov ah,[atributo]
        ;este es el ciclo que se utilizara para escribir
  ciclo: mov al,[cadena+si]


 escribir:mov[es:di],ax
          inc si
         add di ,2
 loop ciclo



 ;------------------------------------------------------------------------------------
       jmp inicio_horas
       suma_16h:
      sub  [horaA],0x0009
      add [horaA], 0x0010
  ;----------------------------------------------------------------------------------
      inicio_horas:
        mov si, 0
        bucle_horas:
         mov ah , 0x0
         int 16h

cmp al,0x2B      ; comparamos con + si no se cumple saltamos a nada
   jne fuera
      inc si   ; si se cumple no se salta y se incrementa si
   cmp si , 10
   je suma_16h
   add [horaA], 0x0001


 loop  bucle_horas
   fuera:

 ;----------------------------------------------------------------------------------
       jmp inicio_min
       suma_16m:
       sub  [minA],0x0009
      add [minA], 0x0010
  ;----------------------------------------------------------------------------------
      inicio_min:
        mov si, 0
        bucle_min:
         mov  ah , 0x0
         int 16h

cmp al,0x2B      ; comparamos con + si no se cumple saltamos a nada
   jne fueram

     inc si   ; si se cumple no se salta y se incrementa si
   cmp si , 10
   je suma_16m
   add [minA],0x0001


 loop  bucle_min
   fueram:



         ;-------------------------------------------------------
;                   ; entrar los dos carecteres a la horaA
;                      mov ah, 0x00        ; Función 00h de la interrupción 16h (BIOS) para leer un carácter sin eco
;         int 0x16            ; Llamar a la interrupción para leer un carácter del teclado
;          mov [buffer], al    ; Almacenar el primer carácter en el buffer
;
;           ; Leer el segundo carácter
;       mov ah, 0x00        ; Función 00h de la interrupción 16h (BIOS) para leer un carácter sin eco
;        int 0x16            ; Llamar a la interrupción para leer un carácter del teclado
;        mov [buffer+1], al  ; Almacenar el segundo carácter en el buffer
;
;            ; Convertir los caracteres ASCII a números y combinarlos en horaA
;       mov al, [buffer]   ; Primer dígito
;        sub al,30h       ; Convertir ASCII a número
;        mov bl, 16         ; Multiplicador para convertir a decimal
;        mul bl             ; Multiplicar por 10
;         mov [horaA], al    ; Almacenar el dígito en horaA
;
;         mov al, [buffer+1] ; Segundo dígito
;     sub al, 30h       ; Convertir ASCII a número
;        add [horaA], al    ; Sumar al valor anterior en horaA
;
;
;     ;---------------------------------------------------------------
;;     mov  [buffer] ,0
;     mov [buffer+1] ,0
    ; ----------------------------------------------------------------

;------------------------------------------------------------------------------
                  ; entrar los dos carecteres a la horaA
;         mov ah, 0x00        ; Función 00h de la interrupción 16h (BIOS) para leer un carácter sin eco
;         int 0x16            ; Llamar a la interrupción para leer un carácter del teclado
;         mov [buffer], al    ; Almacenar el primer carácter en el buffer

    ; Leer el segundo carácter
;         mov ah, 0x00        ; Función 00h de la interrupción 16h (BIOS) para leer un carácter sin eco
;         int 0x16            ; Llamar a la interrupción para leer un carácter del teclado
;         mov [buffer+1], al  ; Almacenar el segundo carácter en el buffer

    ; Convertir los caracteres ASCII a números y combinarlos en horaA
;         mov al, [buffer]   ; Primer dígito
;         sub al, 0x30       ; Convertir ASCII a número
;         mov bl, 16         ; Multiplicador para convertir a decimal
;         mul bl             ; Multiplicar por 10
;         mov [horaA], al    ; Almacenar el dígito en horaA

;         mov al, [buffer+1] ; Segundo dígito
;         sub al, 0x30       ; Convertir ASCII a número
;         add [minA], al    ; Sumar al valor anterior en horaA

;-------------------------------------------------------------------------------
                xor     ax,ax
                mov     es,ax
                mov     ax,show_time

                mov     [es:4*70h],ax           ; Capturar la irq8
                mov     [es:4*70h+2],cs

                mov     ax,0b800h
                mov     es,ax

                mov     al,0bh                  ; Activar las interrupciones del RTC
                out     70h,al
                in      al,71h

                or      al,64                   ; haciendo '1' el bit 6 del registro B
                mov     ah,al
                mov     al,0bh
                out     70h,al
                mov     al,ah                   ; Escribir el valor modificado
                out     71h,al
                                                ; Por defecto, la irq8 est? deshabilitada :-(
                in      al,0A1h                 ; Leer la m?scara de interrupciones del PIC esclavo
                and     al,0feh                 ; Activar la irq8 (bit0 = 0)...
                out     0A1h,al                 ; ...sin modificar los otros valores

                sti


   ;----------------------------------------------------------------------------------
             no_es_hora:

              mov al, 4             ; Leer la hora
              out 70h, al
              in  al, 71h          ; Llama a la interrupción de BIOS y guardar en al hora



              mov    bl ,[horaA]



              cmp     al , bl  ; Compara con la hora deseada (en este caso, las 12:00)
              jne no_es_hora   ; Si no es la hora, salta a no_es_hora

 ;--------------------------------------------------------------------------
                  ;aqui es donde comprobamos si es la hora correcta
                  ; falta que el usuario sea el que de la hora por teclado
                  ;no puedo comparar correctamente parece que estoy solicitando mal la hora de la computadora
                  ;no puedo comparar directamente una variable con un registro
               no_es_min :
    mov al, 2
    out 70h, al
    in al, 71h


              mov    bl ,[minA]

              cmp     al , bl
              jne     no_es_min             ; Si no, volver a comprobar


  ;---------------------------------------------------------------------------------
          ;este es el mensaje de alarma que se va a mostrar
          ;le falta que parpadee y le falta ser escrito por el usuario
           alarma:
            mov di, 160*12+2*40
            mov si, 0
            mov cx,6
            mov ah,[atributo]
             ;este es el ciclo que se utilizara para escribir
           ciclo1:
           mov al,[cadenaAlarma+si]

          escribir1:
         mov[es:di],ax
          inc si
         add di ,2

  loop ciclo1

 ;---------------------------------------------------------------------------------------
    ;ciclo que dura  1/3 seg
    ;  Esperar un segundo
    mov cx, 10h
    mov dx, 07d0h
    mov ah, 86h
    int 15h

;---------------------------------------------------------------------------------------

   ;cartel en negro para borrar

                       alarma2:
            mov di, 160*12+2*40
            mov si, 0
            mov cx,6
            mov ah,[atributoN]
             ;este es el ciclo que se utilizara para escribir
           ciclo2:
           mov al,[cadenaAlarma+si]
         mov[es:di],ax
          inc si
         add di ,2

  loop ciclo2
                    mov cx,10h
    mov dx, 07d0h
    mov ah, 86h
    int 15h
          jmp alarma  ; salto a primer cartel para repetir


      ;---------------------------------------------------------------------------------

               jmp     $
         cadena db 'rellene el formulario para la alarma [hora(00):min(00),rep(si=1/no=0)]'
         cadenaAlarma db 'Alarma'
      ;-----------------------------------------------------------------------------------

         buffer db 2 dup(0) ; Buffer para almacenar las dos últimas interacciones del teclado
    index dw 0          ; Índice para rastrear la posición actual en el buffer



      ;-----------------------------------------------------------------------------
        hora db 0
        min db 0x0000
        minutos1   db 0x0000

       ;---------------------------------------------------------------------------
         horaA db 0x0000
         minA  db 0x0000
         repA  db 1
          atributoN db  00000000b
     atributo db 00000010b
       direMen1 dw  320
       posReloj dw 160-8*2






     jmp $

     show_time: mov     al,0ch                  ; Leer el registro C
                out     70h,al                  ; del RTC
                in      al,71h                  ; Para que siga generando interrupciones

                mov     di,[posReloj]           ; Posici?n designada para el "reloj"
                
                mov     ch,71h
                mov     cl,':'

                mov     al,4                    ; Solicitar valor de las horas
                out     70h,al
                in      al,71h
                call    show_bcd

                mov     [es:di],cx

                add     di,2

                mov     al,2                    ; Solicitar valor de los minutos
                out     70h,al
                in      al,71h

               call    show_bcd

                mov     [es:di],cx
                add     di,2

                mov     al,0                    ; Solicitar valor de los segundos
                out     70h,al
                in      al,71h
                call    show_bcd



                mov     al,20h                  ; Enviar el fin de interrupci?n
                out     0a0h,al                 ; al PIC esclavo
                out     20h,al                  ; y al maestro
                iret

      show_bcd: mov     bl,al
                xor     eax,eax
                or      al,bl
                shr     al,4
                and     bl,0fh
                mov     ah,ch
                mov     bh,ch
                shl     ebx,16
                or      eax,ebx
                add     eax,00300030h
                mov     [es:di],eax
                add     di,4
                ret




times (5*512)-($-$$) db 0
        dw 0xaa55
