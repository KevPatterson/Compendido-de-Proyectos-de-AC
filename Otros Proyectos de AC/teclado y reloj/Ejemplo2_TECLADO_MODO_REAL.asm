format binary as 'img'
org 7C00h

mov ax, 3
int 10h

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

jmp $

; _________ISR_______
timer:
  cli
   inc [cont]
   cmp [cont], 18
   jne @f
   mov [cont],0
   inc bl
   mov al, bl
   xor ah, ah
   aam
   add ax, 3030h

    mov [0xb8000+ 160*24+156], ah
    mov [0xb8000+ 160*24+158], al
 @@:
  mov al, 20h
  out 20h, al
  sti
iret

 keyboard:
  in	al,60h			; Leer el buffer del teclado
  cmp	  al,2ah		  ; Verificar el uso de la tecla Shift izquierda
  jne	  @f
  mov	  [shift_status],0xff	  ; En caso que sea esta, "recordarlo" con el valor 0xff en una variable
  jmp	  .exit
 @@:
  cmp	  al,2ah+128		  ; Verificar que la tecla Shift ha dejado de usarse
  jne	  @f
  mov	  [shift_status],0	  ; Para reestablecer el valor de la variable bandera
  jmp	  .exit
 @@:
  cmp	  al,127
  ja	  .exit
  cmp	  [shift_status],0	  ; Seleccionar el mapa de caracteres adecuado seg?n el valor de la bandera
  je	  @f
  mov	  esi,shift_keymap
  jmp	  .print
 @@:
  mov	  esi,normal_keymap
 .print:
  xor	  ah,ah
  add	  si,ax
  mov	  al,[esi]
  mov	  edi,[current_pos]
  mov	  [0xb8000+edi],al	  ; Mostrar el ASCII en pantalla
  add	  [current_pos],2	  ; Actualizar la siguiente coordenada
.exit:
   mov	al,20h			; fin de interrupci?n hardware
   out	20h,al			; al pic maestro
iret
; ________ Declaraci?n de variables________
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

times	510-($-$$) db 0
	    dw 0xaa55
