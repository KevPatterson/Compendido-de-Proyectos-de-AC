
format binary as 'img'              ;HAROLD RICARDO WALWYN CDF 2203        EDITOR DE TEXTO
   org 7c00h                       ;JUAN MIGUEL QUINTANA FUEGO 2203

  mov ax, 3
int 10h



xor di, di
xor dl, dl
xor bl, bl
xor ax, ax

mov ax,keyboard
mov [es:4*9], ax
mov [es:4*9+2], cs
in al, 60h




   sti
   jmp $
    Fin:
       mov ax,03h
       int 10h
       jmp $
           error:

   mov al,3
   int 10h


                bucle:                 ;bucle para dibujar error en el centro y abajo

                mov ax,0xb800
                mov es,ax

                mov di,160*12+2*40
                mov si,0
                mov cx,7
           otro:
           mov ah,[color]
                   mov al,[message+si]

                mov [es:di],ax
                inc si
                add di,2

                loop otro

                xor cx,cx         ;temporizador para el movimiento.begin()
                xor dx,dx
                xor ah,ah

                mov cx, 100h
                mov dx, 17f0h
                mov ah, 86h
                int 15h

                mov di, 160*20+2*40
                mov si,0
                mov cx,7

           other:
           mov ah,[color2]
                   mov al,[message+si]

                mov [es:di],ax
                inc si
                add di,2
                loop other




                mov di,160*12+2*40
                mov si,0
                mov cx,7
                xor ax,ax

          another:
          mov ah,[color3]
                   mov al,[clear_msj+si]

                mov [es:di],ax
                inc si
                add di,2
                loop another
                mov cx, 100h
                mov dx, 17f0h
                mov ah, 86h
                int 15h


                 mov di, 160*20+2*40
                mov si,0
                mov cx,7

         another_one:
         mov ah,[color3]
                   mov al,[clear_msj+si]

                mov [es:di],ax
                inc si
                add di,2
                loop another_one




                jmp bucle


     keyboard:  ;preparacion del teclado!!!!!!!!!!
     in al,60h ; leer el buffer del teclado
     cmp al, 2ah ;verificar el uso de la tecla shift izquierda
     jne @f
     mov [shift_status],0xff ;en caso de q sea esta recordarlo
     jmp .exit
     @@:
     cmp al,2ah
     jne @f
     mov [shift_status],0
     jmp .exit



     @@:
     cmp al,127
     ja .exit
     cmp [shift_status],0
     je @f
     mov esi,shift_keymap
     jmp .print
       cmp al,0x1         ;Codigo para saltar al mensaje de error
         je error
     @@:
     mov esi,normal_keymap
        cmp al,0x1c         ;CODIGO PARA CERRAR LA APP CON EL PRESIONAR DE UNA TECLA
     je Fin
       cmp al,0x1         ;Codigo para saltar al mensaje de error
         je error
     cmp al,0x1         ;Codigo para saltar al mensaje de error
         je error
  .print:
     xor ah,ah
     add si,ax
     mov al,[esi]
     mov edi,[current_pos]
     mov [0xb8000+edi], al   ;mostrar el ascii en pantalla
     add [current_pos],2     ;actualizar la sig cordenada
     .exit:
     mov al,20h  ;fin de interrupcion hardware
     out 20h,al  ;al pic maestro


iret
;variables
cont db 0
    current_pos dd 0
   shift_status db 0
 normal_keymap: db 0
                db 27,'1234567890-=',8
                db 9,'qwertyuiop[]',10
                db 0,'asdfghjkl;',39,96,0,'\'
                db 'zxcvbnm,./',0,'*',0,' '
                db 0,'2345678901',0,'3789-456+1230.'

  shift_keymap: db 0
                db 27,'!@#$%^&*()_+',8
                db 9,'QWERTYUIOP{}',10
                db 0,'ASDFGHJKL:',39,'~',0,'|'
                db 'ZXCVBNM<>?',0,'*',0,' '
                db 0,'2345678901',0,'3789-456+1230.'
        message db ' ERROR '
        color db 01000010b
        color2 db 01000010b
        color3 db 00000000b
        clear_msj db   '      '

 times 510-($-$$) db 0
                           dw 0xaa55