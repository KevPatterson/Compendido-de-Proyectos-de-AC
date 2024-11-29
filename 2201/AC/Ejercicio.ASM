;Grupo 2201 Tema 5 Dairon Fajardo Daniel Zamora
format binary as 'img'
org 7c00h
    mov ax,cs
    mov ds,ax
    xor ax,ax

    mov dl, 0
    int 0x3

   mov  ah,0x02      ;usar el BIOS para cargar
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
                 dw 0aa55h

org 8000h
         mov ax, cs
         mov ds, ax
         mov ax, 0x3
         int 10h
         mov ax,0xb800
         mov es,ax

xor di, di
xor dl, dl
xor bl, bl
xor ax, ax
mov es, ax
mov ax,timer
mov [es:4*8], ax
mov [es:4*8+2], cs

mov ax,keyboard
mov [es:4*9], ax
mov [es:4*9+2], cs

sti
RTC:            xor     ax,ax
                mov     es,ax
                mov     ax,leer_RTC
                mov     [es:4*70h],ax           ; Capturar la irq8
                mov     [es:4*70h+2],cs
                mov     al,0bh                  ; Activar las interrupciones del RTC
                out     70h,al
                in      al,71h
                or      al,64                   ; haciendo '1' el bit 6 del registro B
                mov     ah,al
                mov     al,0bh
                out     70h,al
                mov     al,ah                   ; Escribir el valor modificado
                out     71h,al
                in      al,0A1h                 ; Leer la m?scara de interrupciones del PIC esclavo
                and     al,0feh                 ; Activar la irq8 (bit0 = 0)...
                out     0A1h,al                 ; ...sin modificar los otros valores
                sti



  mov ax, 0x3
         int 10h
         mov ax,0xb800
         mov es,ax

hora1:          mov di,0
                mov si,0
                mov cx,33
                call mostrar
minutos1:       mov di,160*2
                mov cx,37
                call mostrar
segundos1:      mov di,160*4
                mov cx,38
                call mostrar
hora2:          mov di,160*6
                mov cx,33
                call mostrar
minutos2:       mov di,160*8
                mov cx,37
                call mostrar
segundos2:      mov di,160*10
                mov cx,38
                call mostrar
hora3:          mov di,160*12
                mov cx,33
                call mostrar
minutos3:       mov di,160*14
                mov cx,37
                call mostrar
segundos3:      mov di,160*16
                mov cx,38
                call mostrar


comparacion:
                cmp [seg],18
                jne comparacion
                mov [seg],0
                call check_alarma
                jmp comparacion

 jmp $

leer_RTC:  mov al,0ch                  ; Leer el registro C
           out 70h,al                  ; del RTC
           in al,71h                  ; Para que siga generando interrupciones

           mov     di,[clockPos]
           mov     ch,71h
           mov     cl,':'

           mov al,4                  ; Leer el registro C
           out 70h,al                  ; del RTC
           in al,71h
           call show_bcd

           mov     [es:di],cx
                add     di,2

           mov al, 2                 ; Leer el registro B
           out 70h,al
           in al,71h
           call show_bcd

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

timer:   cli
         inc [seg]

         mov al, 20h
         out 20h, al
         sti
         iret

keyboard:  in al,60h           ; Leer el buffer del teclado
           cmp al,39h
           je activar_alarmas
           cmp al,01Eh
           je activar_alarma1
           cmp al, 030h
           je activar_alarma2
           cmp al, 02Eh
           je activar_alarma3

     sub al,0x01       ; Convertir el código de escaneo a ASCII
           add al,0x30
           cmp al, 30h
           jb exit
           cmp al, '9'
           ja exit


  print:   mov ah,0x0E         ; AH=0Eh: función de teletipo
           movzx edi,[current_pos]
           mov [0xb8000+edi],al ; Mostrar el ASCII en pantalla

guaradar:  cmp [caracter01],-1
           je guardar1
           cmp [caracter02],-1
           je guardar2


guardar1:
  mov [caracter01], al ; Guardar valor ASCII en caracter01
  sub al, 30h ; Convertir ASCII a valor hexadecimal
  call convertir_hex_bin ; Convertir hexadecimal a binario
  mov [caracter1], al ; Guardar resultado en binario1

  jmp addx


guardar2:
  mov [caracter02], al ; Guardar valor ASCII en caracter02
  sub al, 30h ; Convertir ASCII a valor hexadecimal
  call convertir_hex_bin1 ; Convertir hexadecimal a binario
  mov [caracter2], al ; Guardar resultado en binario1

  jmp addx


     addx:  add [contador],1
            add [c_var],1
            cmp [contador],2
            je newline
            add [current_pos],2 ; Actualizar la siguiente coordenada
            jmp exit
activar_alarmas:  mov ax,3h
                  int 10h
                  mov ax,0xb800
                  mov es,ax
                  mov di,0
                  mov si,0
                  mov cx,29
                  call activacion
                  mov di,160
                  mov cx,26
                  call activacion
                  mov di,160*2
                  mov cx,26
                  call activacion
                  mov di,160*3
                  mov cx,26
                  call activacion
                  jmp exit

activar_alarma1:  mov [activa_alarma1], 1
                  mov di,160*5
                  mov si,0
                  mov cx,23
                  call ready
                  jmp exit
activar_alarma2:  mov [activa_alarma2], 1
                  mov di,160*6
                  mov si,23
                  mov cx,23
                  call ready
                  jmp exit
activar_alarma3:  mov [activa_alarma3], 1
                  mov di,160*7
                  mov si,46
                  mov cx,23
                  call ready
                  jmp exit

       newline: cmp [c_var],2
                je hora_a1
                cmp [c_var],4
                je minutos_a1
                cmp [c_var],6
                je segundos_a1
                cmp [c_var],8
                je hora_a2
                cmp [c_var],10
                je minutos_a2
                cmp [c_var],12
                je segundos_a2
                cmp [c_var],14
                je hora_a3
                cmp [c_var],16
                je minutos_a3
                cmp [c_var],18
                je segundos_a3

       hora_a1: call juntar_caracteres
                mov [hora_alarma1],ax
                jmp reiniciar

    minutos_a1: call juntar_caracteres
                mov [minutos_alarma1],ax
                jmp reiniciar

   segundos_a1: call juntar_caracteres
                mov [segundos_alarma1],ax
                jmp reiniciar

       hora_a2: call juntar_caracteres
                mov [hora_alarma2],ax
                jmp reiniciar

    minutos_a2: call juntar_caracteres
                mov [minutos_alarma2],ax
                jmp reiniciar

    segundos_a2: call juntar_caracteres
                mov [segundos_alarma2],ax
                jmp reiniciar

       hora_a3: call juntar_caracteres
                mov [hora_alarma3],ax
                jmp reiniciar

    minutos_a3: call juntar_caracteres
                mov [minutos_alarma3],ax
                jmp reiniciar

     segundos_a3: call juntar_caracteres
                mov [segundos_alarma3],ax
                jmp reiniciar


     reiniciar: mov byte [contador], 0
                mov ax,[current_pos]
                add ax, 318                     ; Multiplicar por 160 para obtener el inicio de la siguiente línea
                mov [current_pos], ax
                mov [caracter1],-1
                mov [caracter2],-1
                jmp exit

          exit: mov al,20h         ; fin de interrupción hardware
                out 20h,al         ; al pic maestro
                iret


check_alarma:
               cmp [activa_alarma1],1
                je comparar_alarma1

                cmp [activa_alarma2],1
                je comparar_alarma2

                cmp [activa_alarma3],1
                je comparar_alarma3

                jmp fin


comparar_alarma1:  push ax
                   mov ah, 02h; funcion de la interrupcion
                   int 1ah   ; obtener la hora del sistema
                   ; ch = hora, cl = minutos, dh = segundos, dl = cewntesimas de segundos  15:22

                   movsx ax,ch
                   cmp ax,[hora_alarma1]
                   jne fin1
                   movsx ax,cl
                   cmp ax,[minutos_alarma1]
                   jne fin1
                   movsx ax,dh
                   cmp ax,[segundos_alarma1]
                   jne fin1
                   call blink_message
                   mov [activa_alarma1],0

                   fin1: ret

comparar_alarma2:  push ax
                   mov ah, 02h; funcion de la interrupcion
                   int 1ah   ; obtener la hora del sistema
                   ; ch = hora, cl = minutos, dh = segundos, dl = cewntesimas de segundos  15:22

                   movsx ax,ch
                   cmp ax,[hora_alarma2]
                   jne fin2
                   movsx ax,cl
                   cmp ax,[minutos_alarma2]
                   jne fin2
                   movsx ax,dh
                   cmp ax,[segundos_alarma2]
                   jne fin2
                   call blink_message
                   mov [activa_alarma1],0

                   fin2: ret

comparar_alarma3:  push ax
                   mov ah, 02h; funcion de la interrupcion
                   int 1ah   ; obtener la hora del sistema
                   ; ch = hora, cl = minutos, dh = segundos, dl = cewntesimas de segundos  15:22

                   movsx ax,ch
                   cmp ax,[hora_alarma3]
                   jne fin3
                   movsx ax,cl
                   cmp ax,[minutos_alarma3]
                   jne fin3
                   movsx ax,dh
                   cmp ax,[segundos_alarma3]
                   jne fin3
                   call blink_message
                   mov [activa_alarma3],0

                   fin3: ret

                  fin: ret
show_bcd:   mov bl,al
            xor eax,eax
            or al,bl
            shr al,4
            and bl,0fh
            mov ah,ch
            mov bh,ch
            shl ebx,16
            or eax,ebx
            add eax,00300030h
            mov     [es:di],eax
            add     di,4
            ret

activacion: mov al,[activation_msg+si]
          mov ah,[variable]
          mov [es:di],ax
          inc si
          add di,2
          loop activacion
          ret
ready: mov al,[ready_msg+si]
          mov ah,[variable]
          mov [es:di],ax
          inc si
          add di,2
          loop ready
          ret


mostrar:  mov al,[escribir+si]
          mov ah,[variable]
          mov [es:di],ax
          inc si
          add di,2
          loop mostrar
          ret


juntar_caracteres:
  mov bl, [caracter1] ; Obtener valor de caracter1
  mov al, 10 ; Multiplicador
  mul bl ; Multiplicar AX por BL
  add al, [caracter2] ; Sumar valor de caracter2
  ret


blink_message:
                mov cx, 60
         blink: cmp [seg], 9 ; ajustado para parpadear dos veces por segundo
                je clean
                jmp blink
         clean: mov ax,03h
                int 10h
                mov ax,0xb800
                mov es,ax
                mov [seg],0
          show: cmp [seg], 9 ; ajustado para parpadear dos veces por segundo
                je print
                jmp show
     parpadear: mov si,0
                mov di,160*12+2*35
                push cx
                mov cx,10
                mov ah,00001111b
      imprimir: mov al,[mensaje+si]
                mov [es:di],ax
                inc si
                add di,2
                loop imprimir
                pop cx
                mov [seg],0
                loop blink
                ret

  convertir_hex_bin:
  movsx bx, al ; Guardar valor hexadecimal en BX
  xor ax, ax ; Limpiar AX
  mov cx, 4 ; Contador de bits
  
  ciclo_binario:
    shr bx, 1 ; Desplazar un bit a la derecha
    and al, 1 ; Obtener el bit menos significativo
    shl ax, 1 ; Desplazar AX un bit a la izquierda
    or al, bl ; Agregar el bit al resultado
    loop ciclo_binario ; Repetir el ciclo 4 veces

  ret

  convertir_hex_bin1:
  movsx bx, al ; Guardar valor hexadecimal en BX
  xor ax, ax ; Limpiar AX
  mov cx, 4 ; Contador de bits
  
  ciclo_binario1:
    shr bx, 1 ; Desplazar un bit a la derecha
    and al, 1 ; Obtener el bit menos significativo
    shl ax, 1 ; Desplazar AX un bit a la izquierda
    or al, bl ; Agregar el bit al resultado
    loop ciclo_binario1 ; Repetir el ciclo 4 veces

  ret



variable db 00001111b
mensaje db "Ya es Hora"
escribir db "Escriba la hora alarma 1 (00-23):Escriba los minutos alarma 1 (00-59):Escriba los segundos alarma 1 (00-59):Escriba la hora alarma 2 (00-23):Escriba los minutos alarma 2 (00-59):Escriba los segundos alarma 2 (00-59):Escriba la hora alarma 3 (00-23):Escriba los minutos alarma 3 (00-59):Escriba los minutos segundos alarma 3 (00-59):"
activation_msg db "¿Desea Activar alguna alarma?a para activar la alarma 1b para activar la alarma 2c para activar la alarma 3"
cont db 0
ready_msg db "Ha activado la alarma 1Ha activado la alarma 2Ha activado la alarma 3"
current_pos dw 160
color dw 00001111b
caracter01 db -1
caracter02 db -1
caracter1 db 0
caracter2 db 0
contador db 0
c_var db 0
hora_alarma1 dw 0
minutos_alarma1 dw 0
segundos_alarma1 dw 0
hora_alarma2 dw 0
minutos_alarma2 dw 0
segundos_alarma2 dw 0
hora_alarma3 dw 0
minutos_alarma3 dw 0
segundos_alarma3 dw 0
minutos_system dw 0
hora_system dw 0
segundos_system dw 0
activa_alarma1 db 0
activa_alarma2 db 0
activa_alarma3 db 0
seg dw 0
comparacion_activa db 0
clockPos dw 160-8*2
contar_seg db 0
times (4*512)-($-$$) db 0 ; 4*512 porque defini arriba 4 sectores
 times 512 db 0