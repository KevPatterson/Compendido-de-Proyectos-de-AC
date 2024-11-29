;Tablero de Ajedrez  la reina se tiene que mover ahcia ariba,abajo,derecha y izquierda y ir cambiando de color
;Juan Manuel Rodriguez Pupo  grupo 2202
;Cristian Alejandro Buque Matos  grupo 2202
format binary as 'img'
org 7c00h    ;Estanlece la direccion de origen del programa en la direccion de memoria fisica.Indica al ensamblador donde cargar el codigo en la memoria

mov ax,cs    ;Carga el segmento de codigo cs en el registro ax
mov ds,ax    ;Luego transfieren ese valor a ds, esto es importante para asegurar que los segmentos de codigo y datos esten bien configurados antes de ejecutar el programa

mov ax,3     ;Inicializa el modo video con el servicio 3 para ver en modo tecto, se usa la interrupcion 10h
int 10h





mov ax,0b800h  ;Espacio en memoria para el modo texto se transfiere a ax
mov es,ax      ;Transfiere al registro de segmento es el valor de ax,se utiliza para cargar el valor del espacio en memoria antes tranferido a ax

	CLI	;Deshabilita las interrupciones del procesador, esto evita que se produzcan interrupciones mientras se ejecuta el codigo critico
	XOR AX,AX   ;establece a ax en 0
	MOV GS,AX   ;copia el contenido de ax al registro de segmento gs, se utiliza para acceder a la memoria en el segmento gs
	MOV AX,EsperaPorTeclado   ;Carga el valor de la etiqueta EperaPorTeclado en el registro ax.Esta es una forma de cargar una direccion espesifica en ax
	MOV [GS:9*4],AX 	   ;Estas 2 lineas de codigo se utilizan para almacenar el valor de ax en la direccion de memoria calculada
	MOV [GS:9*4+2],CS	    ;Estas direcciones pueden estar guardando la direccion especifica de 36 y 38 del segmento gs
	STI			       ;Habilita las intrucciones  del procesador   deshabilitadas por CLI



 Call Pintar		    ;Hace un llamado a la etiqueta Pintar  Pra pintar el tablero
  mov di,160*11+40*2	     ;Inicializa un valor en el registro di que va a ser la pocicion inicial de la reina
   mov bx,0		       ;Inicializa un contador en 0 en el registro bx
Call Reina		    ;Hace un llamado a la etiqueta Reina para pintar a la reina

jmp $			  ;Fin del programa



EsperaPorTeclado:	;Rutina del teclado
	in al, 64h	 ;lee losbyte del puerto 64h y lo almacena en el registro al,este byte de datos contiene informacion con el estado y la configuracion del teclado,(si hay una tecla presionada)
	 test al, 1	 ;realiza una operacion and logica y el valor 1, esto establece las banderas de estado del procesador segun el resultado de la operacion, en este caso se esta probando que si el bi menos significativo(bit 0) del registro al es 1
	jz EsperaPorTeclado    ;Salta a la etiqueta Espera por teclado  si la bandera de cero esta establecida, lo que significa que el resultado de la operacion test es 0
	
	in al, 60h ; Se guarda en Al el código de rastreo de la tecla oprimida.

;Estas lineas de codigos anteriores crea un bucle que espera a que se presione una tecla leyendo rapidamente el controlador del teclado hasta que detecta una pulsacion
;Una vez que se presione una tecla el bucle se rompe y sigue con las intrucciones posteriores


	cmp al, 72 ;cmpara el registro al con el codigo scan del teclado(en decimal) el valor 72 que corresponde a la tecla de flecha hacia arriba
	je FlechaArriba; detecta Flecha Arriba
	cmp al, 80   ;cmpara el registro al con el codigo scan del teclado(en decimal) el valor 80 que corresponde  la tecla de flecha hacia abajo
	je FlechaAbajo; detecta el Flecha Abajo
	cmp al, 77   ;cmpara el registro al con el codigo scan del teclado(en decimal) el valor 77 que corresponde  la tecla de flecha hacia la derecha
	je FlechaDerecha ; detecta Flecha Derecha
	cmp al, 75   ;cmpara el registro al con el codigo scan del teclado(en decimal) el valor 75 que corresponde  la tecla de flecha hacia la izquierda
	je FlechaIzquierda; detecta Flecha Izquierda

FlechaArriba:  ;Etiqueta para mover una pocicion hacia arriba
;sub di,160

cmp al, 72   ;cmpara al con el codigo scan de la tecla presionada para asegurar que es la tecla correcta
jne nomover  ; si no es salta a nomover
mov ax,0
int 10h       ;hace un limpiado de pantalla con el servicio 0 de la interrupcion 10h
mov ax,3
int 10h        ;vuevel activer el modo video en el sevicio de texto
sub di,160     ;modifica di para obtener la pocicios deseada
push di        ;guarda en pila al registro di con la pocicion modificada
Call Pintar	 ;LLama a la etiqueta pintar
cmp bx,3       ; cmpara al contador bx con 3
je CambioColor	  ;si bx=3 salta a CambioColor
pop di	      ;saca de la pila a di

Call PintarReina    ;llama a la etiqueta PintarReina
jmp Salir	    ;Salta a Salir
       ; Todo lo demas es lo ismo pero cambiando la pocision y la tecla presionada
FlechaAbajo:
cmp al, 80
jne nomover
mov ax,0
int 10h
mov ax,3
int 10h
add di,160
push di
Call Pintar
cmp bx,3
je CambioColor
pop di
Call PintarReina
jmp Salir

FlechaDerecha:
cmp al,77
jne nomover
mov ax,0
int 10h
mov ax,3
int 10h
add di,2
push di
Call Pintar
cmp bx,3
je CambioColor
pop di
Call PintarReina
jmp Salir


FlechaIzquierda:
 cmp al,75
 jne nomover
mov ax,0
int 10h
mov ax,3
int 10h
sub di,2
push di
Call Pintar
cmp bx,3
je CambioColor
pop di
Call PintarReina
jmp Salir


nomover:
jmp Salir ;Salt a Salir

CambioColor:
mov bx,0     ;transfiere al registro bx que se utiliza como contador el 0 para iniciar de nuevo el conteo
cmp ah,00001111b     ;cmpara ah con el color que tendro lo que vayas a pintar
je CambioColor2;si es igual salta a CambioColor2
Cmp ah,11110000b
je CambioColor3
jmp Salir


CambioColor2:
mov ah,11110000b     ;asignas a ah el color fondo blanco,caracter negro
pop di		    ;sacas a di de la pila
Call PintarReina       ;LLamas PintarReina
jmp Salir	       ; Saltas a Salir

CambioColor3:
mov ah,00001111b      ; asigna ah, el color fondo negro,caracter blanco
pop di		      ; Sacas a di de la pila
Call PintarReina	; Llamas a PintarReina
Salir:
	MOV AL,20h  ;transfiere a al 20h la cual se utiliza para mandar comonados al pic
	OUT 20h,AL  ;Envia el valor del registro AL al puerto E/S 20H que es el puerto de datos del pic , eviandolo un comando al pic para desahabilitar intrcciones.
	IRET	    ;Esta intruccion se utiliza al final de un manejador de intrucciones para retprnar a la rutina de intruccion al codigo qu estaba ejecutandose antes que ocurriera IRET
		    ;Tambien restaura el estado del procesador(como las banderas y los registros) a su estado anterior a la interrupcion
		    ; Resumiendo que vuelve a la rutina del teclado EsperaPorTecla deshabilitando todas las interrupciones y restaurando las banderas y registros del procesador pra antes de la rutina


   ;Aqui se va a pintar el tablero de ajedrez alternando el balnco y el negro(aclaro el negro no se va a dibujar sino que va a ser altado por eso se suma 4 en ves de 2 a di y se sebujan la mitad de columnas)
Pintar:
 mov di,160
mov si,11    ;Cantidad de filas que van a ser dibujadas
mov al,' '
Tablero:
mov cx,40  ;Cantidas de veces que va a dibujar por fila teniendo en cuenta las columnas
Dibujar:
mov ah,11110000b  ;Color blanco
mov [es:di],ax
add di,4
loop Dibujar
mov cx,40
add di, 160-158
Dibujar2:
mov [es:di],ax
add di,4
loop Dibujar2
add di,160-162
dec si
cmp si,0
jnz  Tablero


ret    ; vuelve al comando call el cual llamo a la rutina
 ;Pinta la reina
PintarReina:
inc bx	 ;incrementa en 1 el contador del registro bx
 Reina:
mov al,'Q'
mov [es:di],ax

ret    ; vuelve al comando call el cual llamo a la rutina







times 510-($-$$) db 0
dw 0aa55h