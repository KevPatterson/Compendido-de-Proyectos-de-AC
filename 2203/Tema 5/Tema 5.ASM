format binary as 'img'
   org 7c00h
                                                                                                      ;devolver el estado del shift para resolver el problema de la mayuscula al presionar
    mov ax, 3                                                                                         ;esc
    int 10h



xor di, di
xor dl, dl
xor bl, bl
xor ax, ax

mov ax,keyboard        ;inicia el teclado
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


          repet:

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
                xor cx,cx
                xor dx,dx
                xor ah,ah

                mov cx, 400h      ;  dx=2000
                mov dx, 07d0h
                mov ah, 86h
                int 15h

                mov di, 160*20+2*40
                mov si,0
                mov cx,7

          otro2:   mov ah,[color2]
                   mov al,[message+si]

                mov [es:di],ax
                inc si
                add di,2
                loop otro2




                mov di,160*12+2*40
                mov si,0
                mov cx,7
                xor ax,ax
          otro3:   mov ah,[color3]
                   mov al,[clear_msj+si]

                mov [es:di],ax
                inc si
                add di,2
                loop otro3


                mov cx, 400h
                mov dx, 05d0h
                mov ah, 86h
                int 15h


                mov di, 160*20+2*40
                mov si,0
                mov cx,7

          otro4:
                    mov ah,[color3]
                    mov al,[clear_msj+si]

                mov [es:di],ax
                inc si
                add di,2
                loop otro4




                jmp repet


   keyboard:  ;preparacion del teclado!!!!!!!!!!
     in al,60h    ;  buffer del teclado
     cmp al, 2ah ;verificar el uso de la tecla shift izquierda
     jne @f
     mov [shift_status],0xff
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
       cmp al,0x1
         je error
   @@:
     mov esi,normal_keymap
        cmp al,0x1c         ;CODIGO para cerrar app
     je Fin
      cmp al,0x1
         je error
      cmp al,0x1
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
        color db 11100100b
        color2 db 00100100b
        color3 db 00000000b
        clear_msj db   '      '

 times 510-($-$$) db 0
                           dw 0xaa55