	   ;           INICIO
;  _______________________

format binary as 'img'	; Guardar como imagen
org 7C00h	    ; Direccion de arranque
;Código para leer desde HDD:
	mov	ah,0x02      ;usar el BIOS para cargar
	mov	al,0x05      ;cantidad de sectores
	mov	ch,0x00
	mov	cl,0x02      ;a partir del segundo sector lógico
	mov	dh,0x00
	mov	dl,0x00      ;del primer disco duro
	mov	bx,0x800     ;y escribir el contenido en 0x800:0
	mov	es,bx
	mov	bx,0x0000
    @@: int	0x13
	jc	@b

mov ax, 3h	 ; Establecer modo de video, limpia la pantalla dhXdl
int 10h 	

jmp	8000h	     ;poner en ejecución el código cargado en HDD

times 510-($-$$) db 0
		 dw 0aa55h
org 8000h

mov ax, 3h	 ; Establecer modo de video, limpia la pantalla dhXdl
int 10h    

; AQUI COMIENZA
xor di, di	    ; Establecer el Destination Index a 0
xor ax, ax	    ; Establecer el valor de ax a 0
mov es, ax	    ; Establece Extra Segment a 0


;  _______________________
;
;           TIMER
;  _______________________

mov ax,timer	    ; Copia la direccion de memoria de la rutina timer
mov [es:4*8], ax    ; NO ENTIENDO 
mov [es:4*8+2], cs  ; NO ENTIENDO
sti		    ; Habilita las interrupciones]
;  _______________________
;
;           KEYBOARD
;  _______________________

mov ax,keyboard
mov [es:4*9], ax
mov [es:4*9+2], cs
sti





;  _______________________

;   IMPRESION EN PANTALLA 
;  _______________________


mov ax, 3h	 ; Establecer modo de video, limpia la pantalla dhXdl
int 10h 	 ; Interrupcion del BIOS
mov dh,33	 ; Caracter inicial
mov cl,0
mov dl,0
mov di,0


@@:		    ; Etiqueta anonima
    cmp dl,2	   ; Comparar dl con 3
    je pintar	    ; Si es igual saltar a la etiqueta pintar
    jmp @b	    ; Salta a la etiqueta anonima anterior

pintar:

mov ax, 0b800h	    ; VGA Text Framebuffer
mov es, ax	    ; Establecer ExtraSegment para Text Framebuffer


mov ah, 00001010b   ; Color verde brillante
mov si,cadena

test [pausado],1
je ciclo

     


jmp frente

sig:


;------------------


  add cl,1
cmp cl,64
je salto1
cmp cl, 128
je salto2
cmp cl,255
je empezar
 add di,160
mov dl,0


;__________________________
ciclo:
mov dl,0
jmp @b
;_____________________________

salto1:
mov di,6
jmp pintar

salto2:
mov di,12
jmp pintar

empezar:
mov cl,0
mov di,0
jmp pintar



; .....................................................................

   ; imprimir la matrix

; .....................................................................


frente:

;-----------------------

 mov [contfila],0

  columna:
  mov si,cadena1
  mov al,[si]
  mov [es:di], ax
  push di
  mov bl,0

  jmp cola

  columna2:
  mov si,cadena2
  mov al,[si]
  mov [es:di], ax
  push di

  add di,12
  mov bl,0

  jmp cola


  columna3:
  mov si,cadena3
  mov al,[si]
  mov [es:di], ax
  push di

  add di,26
  mov bl,0

  jmp cola

  columna4:
  mov si,cadena4
  mov al,[si]
  mov [es:di], ax
  push di

  add di,44
  mov bl,0

  jmp cola

   colum5:
  mov si,cadena5
  mov al,[si]
  mov [es:di], ax
  push di

  add di,64
  mov bl,0



  jmp cola

   columna6:
  mov si,cadena6
  mov al,[si]
  mov [es:di], ax
  push di

  add di,84
  mov bl,0



  jmp cola

   columna7:
  mov si,cadena7
  mov al,[si]
  mov [es:di], ax
  push di

  add di,104
  mov bl,0

 jmp cola

  columna8:
  mov si,cadena8
  mov al,[si]
  mov [es:di], ax
  push di

  add di,124
  mov bl,0

 jmp cola

   columna9:
  mov si,cadena9
  mov al,[si]
  mov [es:di], ax
  push di

  add di,144
  mov bl,0

 jmp cola



 ;-----------------------------------------------------
    ;
    ;   FUNCION DE LA COLA
    ;
;--------------------------------------------------------
   cola:

  mov [es:di], ax
  inc si
  sub di,160
  mov ah, 00001010b
  mov al,[si]
  inc bl
  cmp bl,45
  jb cola
  xor si,si
 mov bl,0
;-----------------------------------------------------------
   pop di
   inc [contfila]
   cmp [contfila] ,1
   je columna2
   cmp [contfila] ,2
   je columna3
   cmp [contfila] ,3
   je columna4
   cmp [contfila] ,4
   je colum5
   cmp [contfila] ,5
   je columna6
   cmp [contfila],6
   je columna7
   cmp [contfila],7
   je columna8
   cmp [contfila],8
   je columna9
   cmp [contfila],9
   jmp sig







; .....................................................................
; Subrutina para limpiar la pantalla

Limpiar:
      ; Establecer modo de video, limpia la pantalla dhXdl


mov di,0
  mov cx,4000
limpieza:
mov ah,00000000b
mov al,''

mov [es:di],ax
inc di
loop limpieza

; .....................................................................




;  _____________________________________________

;   FINAL , VARIABLES , RUTINA DEL TEMPORIZADOR y Teclasdo
;  _____________________________________________
jmp $		     ; salto infinito
col_counter db 0
columns db 5
cadena db '001 1001 1110 00 001111 000                       '	;35
cadena1 db '     1 01110 0010101 0001 001 1101                ' ; 35
cadena2 db ' 1 0101 11010 001 11000 111 0001                  '
cadena3 db '      01011 00 11100 1100 100 1110                '
cadena4 db ' 1 01  110 001     0101 00 01 001 1101        '
cadena5 db '     1 01110 0010101 0001 001 1101                '
cadena6 db '001 1001 1110 00 001111 000                       '
cadena7 db ' 1 0101 110  10 001 110 00 111 0 001              '
cadena8 db '     1 01  110 001    0101 0001 001 110          '
cadena9 db '  101 10101 111 01010   1010001  10               '
incremento dw 0
pausado dw 0
contfila db 0

 ;-----------------------------------------------------

;--------------------------------------------

; subrutina del temporizador
timer:
    cli 	    ; Deshabilita las interrupciones
    inc dl	    ; Incrementa el contador de ticks
    mov al, 20h     ; Se ha atendido la interrupcion del temporizador 
    out 20h, al     ; Envia el valor almacenado en al al puerto 20h
    sti 	    ; Habilita las interrupciones
iret		    ; Fin de rutina de temporizador 


; subrutina del teclado
keyboard:
 @@:
 in al,60h 
 cmp al,185 
 je Limpiar  ; Liberacion de (Espacio) borra la pantalla
 cmp al,156
 je Pausar   ; Liberacion de (Enter) pausa la iteracion

 ;mov [es:160*13+2*(30-27/2)],ax  ;TEST

finTeclado:
 mov al,20h
 out 20h,al
 iret

Pausar:
inc [pausado]
jmp finTeclado
 

times (5*512)-($-$$) db 0 ; para usar mas de un sector y saltar la limitante de 512 bytes
dw 0aa55h