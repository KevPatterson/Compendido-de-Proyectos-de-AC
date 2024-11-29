	format binary as 'img'
	org 7C00h
    
    mov ax, 0xb800
    mov es, ax

    mov ax, 0x3
    int 10h
   
    mov di, 160*10+10*2
    mov bh, 1b	
    call Escribe

    EsperaPorTeclado:
	in al, 64h
	 test al, 1
	jz EsperaPorTeclado
	
	in al, 60h ; Se guarda en Al el código de rastreo de la tecla oprimida.
	
	cmp al, 72 ; Estos valores están en decimal, aclaro.
	je FlechaArriba; detecta Flecha Arriba
	cmp al, 80
	je FlechaAbajo; detecta el Flecha Abajo
	cmp al, 77
	je FlechaDerecha ; detecta Flecha Derecha
	cmp al, 75
	je FlechaIzquierda; detecta Flecha Izquierda 

	     
	jmp EsperaPorTeclado	

      FlechaArriba:
      sub di, 160
      call Escribe
      jmp EsperaPorTeclado

      FlechaAbajo:
      add di, 160
      call Escribe
      jmp EsperaPorTeclado

      FlechaDerecha:
      add di, 4
      call Escribe
      jmp EsperaPorTeclado

      FlechaIzquierda:
      sub di, 2
      call Escribe
      jmp EsperaPorTeclado

jmp $

    Escribe: 
	
	mov ax, 0x3
	int 10h  ; siempre se limpia la pantalla para volver a imprimir en la nueva posición de DI
	mov cx, 42
	mov bh, 0xF 
	mov si, texto
	@@:
	  mov bl, [si]
	  mov [es:di], bx   
	  add di, 2
	  inc si
	  loop @b 
	sub di, 42*2	; para volver a DI a la posición en que inició la escritura.
     ret
  texto db 'Debo estudiar Arquitectura de Computadoras'
 times 510-($-$$) db 0
		  dw 0xaa55
