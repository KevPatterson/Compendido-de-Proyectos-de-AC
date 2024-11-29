				     ;Tema 10:Tic Tac Toe(Cero y Cruz)   2205
; Jeniffer Frometa Tamayo
;Elizabeth Laura Oliva Gómez
;Idaleydis Castellano Jimenez





format binary as 'img'
    org 7C00h

   mov ax,cs
   mov ds,ax

	mov	ah,0x02
	mov	al,0x05
	mov	ch,0x00
	mov	cl,0x02
	mov	dh,0x00
	mov	dl,0x00
	mov	bx,0x800
	mov	es,bx
	mov	bx,0x0000
    @@: int	0x13
	jc	@b

    mov ax,03h
    int 10h

	jmp	8000h

       times 510-($-$$) db 0
	     dw 0aa55h
   org 800h

   mov ax,03h
   int 10h
   mov ax, 0B800h
   mov es,ax			   ; se establece la direccion de memoria

  call Pintar

EsperaPorTeclado:
	   in al,64h			    ;lee el estado del controlador del teclado desde el puerto 64h y lo copia al registro al
	   test al,1	       
	   jz EsperaPorTeclado		    ;vuelve a espera por teclado si no se ha presionado la tecla
	   
	    in al, 60h			     ; se copia en el registro AL el codigo de rastreo de la tecla oprimida.
	    cmp al,16			     
	    je LetraQ			    ; detecta si se pulsa la letra Q
	    
	    cmp al,17
	    je LetraW			    ; detecta si se pulsa la letra W
	    
	    cmp al, 18
	    je LetraE			    ; detecta si se pulsa la letra E
	    
	    cmp al,30
	    je LetraA			    ; detecta si se pulsa la letra A 
	    
	    cmp al,31
	    je LetraS			    ; detecta si se pulsa la letra S
	    
	    cmp al,32
	    je LetraD			    ; detecta si se pulsa la letra D
	    
	    cmp al,44
	    je LetraZ			    ; detecta si se pulsa la letra Z
	    
	    cmp al,45
	    je LetraX			    ; detecta si se pulsa la letra X
	   
	    cmp al,46
	    je LetraC			    ; detecta si se pulsa la letra C
	
	jmp EsperaPorTeclado
 LetraQ:
      cmp[Q],1			      ;si la letra Q ya fue presionada espera que se presione otra
      je EsperaPorTeclado
      mov di,160*10+2*36	      ; se le asigna la posicion en el tablero
      mov[Q],1			      ; al presionarse la tecla pone a Q en 1
      cmp[T],0			      ; compara T con cero y si es igual juega el jugador 1
      je Jugador1
      jmp Jugador2
LetraW:
      cmp[W],1
      je EsperaPorTeclado
      mov di,160*10+2*38
      mov[W],1
      cmp[T],0
      je Jugador1
      jmp Jugador2
LetraE:
      cmp[E],1
      je EsperaPorTeclado
      mov di,160*10+2*40
      mov[E],1
      cmp[T],0
      je Jugador1
      jmp Jugador2
LetraA:
      cmp[A],1
      je EsperaPorTeclado
      mov di,160*12+2*36
      mov[A],1
      cmp[T],0
      je Jugador1
      jmp Jugador2
LetraS:
      cmp[S],1
      je EsperaPorTeclado
      mov di,160*12+2*38
      mov[S],1
      cmp [T],0
      je Jugador1
      jmp Jugador2
LetraD:
      cmp[D],1
      je EsperaPorTeclado
      mov di,160*12+2*40
      mov[D],1
      cmp [T],0
      je Jugador1
      jmp Jugador2
LetraZ:
      cmp[Z],1
      je EsperaPorTeclado
      mov di,160*14+2*36
      mov[Z],1
      cmp [T],0
      je Jugador1
      jmp Jugador2
LetraX:
      cmp[X],1
      je EsperaPorTeclado
      mov di,160*14+2*38
      mov[X],1
      cmp[T],0
      je Jugador1
      jmp Jugador2
LetraC:
      cmp[C],1
      je EsperaPorTeclado
      mov di ,160*14+2*40
      mov[C],1
      cmp[T],0
      je Jugador1
      jmp Jugador2

Jugador1:
      mov al,'O'
      mov ah,01000000b
      mov[es:di],ax
      mov[T],1
C_Q:
      cmp di,1672
      jne C_W
      inc[contador]
      inc[contador3]
       add[h1],12
       add[v1],14
       add[d1],16
      jmp Comprobar
C_W:
      cmp di,1676
      jne C_E
      inc[contador]
      inc[contador3]
       add[h1],5
       add[v2],9
      jmp Comprobar
C_E:
      cmp di,1680
      jne C_A
      inc[contador]
      inc[contador3]
       add[h1],15
       add[v3],13
       add[d2],11
     jmp Comprobar
C_A:
      cmp di,1992
      jne C_S
      inc[contador]
      inc[contador3]
      add[h2],8
      add[v1],6
     jmp Comprobar
C_S:
      cmp di,1996
      jne C_D
      inc[contador]
      inc[contador3]
       add[h2],10
       add[v2],20
       add[d1],30
       add[d2],40
     jmp Comprobar
C_D:
      cmp di,2000
      jne C_Z
      inc[contador]
      inc[contador3]
      add[h2],9
      add[v3],5
      jmp Comprobar
C_Z:
      cmp di,2312
      jne C_X
      inc[contador]
      inc[contador3]
       add[h3],13
       add[v1],15
       add[d2],13
      jmp Comprobar
C_X:
      cmp di,2316
      jne C_C
      inc[contador]
      inc[contador3]
      add[h3],7
      add[v2],1
      jmp Comprobar
C_C:
      cmp di,2320
      jne Comprobar
      inc[contador]
      inc[contador3]
       add[h3],30
       add[v3],40
       add[d1],50
       jmp Comprobar

Comprobar:
  cmp[contador],3
  jb EsperaPorTeclado
  cmp[contador],3
   ja Resultado
  cmp[contador],3
   je Resultado
 jmp EsperaPorTeclado

 Resultado:
 H1:
  cmp[h1],32
  jne H2
  jmp Ganador1

 H2:
  cmp[h2],27
  jne H3
  jmp Ganador1

 H3:
  cmp[h3],50
  jne V1
  jmp Ganador1

  V1:
  cmp[v1],35
  jne V2
  jmp Ganador1

  V2:
  cmp[v2],30
  jne V3
  jmp Ganador1

  V3:
  cmp[v3],58
  jne D1
  jmp Ganador1

  D1:
  cmp[d1],96
  jne D2
  jmp Ganador1

  D2:
  cmp[d2],64
  jne CompruebaT
  jmp Ganador1

Jugador2:
      mov al,'X'
      mov ah,00100000b
      mov[es:di],ax
      mov [T],0
  C_Q2:
      cmp di,1672
      jne C_W2
      inc[contador2]
      inc[contador3]
       add[h_1],12
       add[v_1],14
       add[d_1],16
     jmp Comprobar2
C_W2:
      cmp di,1676
      jne C_E2
      inc[contador2]
      inc[contador3]
       add[h_1],5
       add[v_2],9
      jmp Comprobar2
C_E2:
      cmp di,1680
      jne C_A2
      inc[contador2]
      inc[contador3]
       add[h_1],15
       add[v_3],13
       add[d_2],11
     jmp Comprobar2
C_A2:
      cmp di,1992
      jne C_S2
      inc[contador2]
      inc[contador3]
      add[h_2],8
      add[v_1],6
     jmp Comprobar2
C_S2:
      cmp di,1996
      jne C_D2
      inc[contador2]
      inc[contador3]
       add[h_2],10
       add[v_2],20
       add[d_1],30
       add[d_2],40
     jmp Comprobar2
C_D2:
      cmp di,2000
      jne C_Z2
      inc[contador2]
      inc[contador3]
      add[h_2],9
      add[v_3],5
      jmp Comprobar2
C_Z2:
      cmp di,2312
      jne C_X2
      inc[contador2]
      inc[contador3]
       add[h_3],13
       add[v_1],15
       add[d_2],13
      jmp Comprobar2
C_X2:
      cmp di,2316
      jne C_C2
      inc[contador2]
      inc[contador3]
      add[h_3],7
      add[v_2],1
      jmp Comprobar2
C_C2:
      cmp di,2320
      jne Comprobar2
      inc[contador2]
       inc[contador3]
       add[h_3],30
       add[v_3],40
       add[d_1],50
       jmp Comprobar2

   Comprobar2:
  cmp[contador2],3
  jb EsperaPorTeclado
  cmp[contador2],3
   ja Resultado2
  cmp[contador2],3
   je Resultado2
 jmp EsperaPorTeclado

Resultado2:
 H_1:
  cmp[h_1],32
  jne H_2
  jmp Ganador2
 H_2:
  cmp[h_2],27
  jne H_3
  jmp Ganador2
 H_3:
  cmp[h_3],50
  jne V_1
  jmp Ganador2
  V_1:
  cmp[v_1],35
  jne V_2
  jmp Ganador2
  V_2:
  cmp[v_2],30
  jne V_3
  call Ganador2
  V_3:
  cmp[v_3],58
  jne D_1
  jmp Ganador2
  D_1:
  cmp[d_1],96
  jne D_2
  jmp Ganador2
  D_2:
  cmp[d_2],64
  jne CompruebaT
  jmp Ganador2

 CompruebaT:
  cmp[contador3],9
  je Tabla
  jmp EsperaPorTeclado

Ganador1:
      mov ax,03h
      int 10h
      mov ax,0B800h
      mov es,ax
      mov di,160*10+2*31
      mov ah,00000100b
 escribe:
      mov al,'J'
      mov [es:di],ax
      add di,2
      mov al,'U'
      mov [es:di],ax
      add di,2
      mov al,'G'
      mov [es:di],ax
      add di,2
      mov al,'A'
      mov [es:di],ax
      add di,2
      mov al,'D'
      mov [es:di],ax
      add di,2
      mov al,'O'
      mov [es:di],ax
      add di,2
      mov al,'R'
      mov [es:di],ax
      add di,4
      mov al,'1'
      mov [es:di],ax
      add di,4
      mov al,'G'
      mov [es:di],ax
      add di,2
      mov al,'A'
      mov [es:di],ax
      add di,2
      mov al,'N'
      mov [es:di],ax
      add di,2
      mov al,'A'
      mov [es:di],ax
    jmp EsperaPorTeclado

Ganador2:
     mov ax,03h
      int 10h
      mov ax,0B800h
      mov es,ax
      mov di,160*10+2*31
      mov ah,00000010b
 escribe2:
      mov al,'J'
      mov [es:di],ax
      add di,2
      mov al,'U'
      mov [es:di],ax
      add di,2
      mov al,'G'
      mov [es:di],ax
      add di,2
      mov al,'A'
      mov [es:di],ax
      add di,2
      mov al,'D'
      mov [es:di],ax
      add di,2
      mov al,'O'
      mov [es:di],ax
      add di,2
      mov al,'R'
      mov [es:di],ax
      add di,4
      mov al,'2'
      mov [es:di],ax
      add di,4
      mov al,'G'
      mov [es:di],ax
      add di,2
      mov al,'A'
      mov [es:di],ax
      add di,2
      mov al,'N'
      mov [es:di],ax
      add di,2
      mov al,'A'
      mov [es:di],ax
    jmp EsperaPorTeclado

  Tabla:
      mov ax,03h
      int 10h
      mov ax,0B800h
      mov es,ax
      mov di,160*10+2*38
      mov ah,00000011b
   escribe3:
    mov al,'T'
    mov [es:di],ax
    add di,2
    mov al,'A'
    mov [es:di],ax
    add di,2
    mov al,'B'
    mov [es:di],ax
    add di,2
    mov al,'L'
    mov [es:di],ax
    add di,2
    mov al,'A'
    mov [es:di],ax


	  jmp $

  Pintar:
	mov ax,03h
	int 10h
	mov ax,0B800h
	mov es,ax
	mov di,160+2*30
	mov ah,00001111b
  esc:
	mov al,'J'
	mov[es:di],ax
	add di,2
	mov al,'U'
	mov[es:di],ax
	add di,2
	mov al,'E'
	mov[es:di],ax
	add di,2
	mov al,'G'
	mov[es:di],ax
	add di,2
	mov al,'O'
	mov[es:di],ax
	add di,4
	mov al,'C'
	mov[es:di],ax
	add di,2
	mov al,'E'
	mov[es:di],ax
	add di,2
	mov al,'R'
	mov[es:di],ax
	add di,2
	mov al,'O'
	mov[es:di],ax
	add di,4
	mov al,'Y'
	mov[es:di],ax
	add di,4
	mov al,'C'
	mov[es:di],ax
	add di,2
	mov al,'R'
	mov[es:di],ax
	add di,2
	mov al,'U'
	mov[es:di],ax
	add di,2
	mov al,'Z'
	mov[es:di],ax

     mov di,160*10+2*36
     mov al,''
     mov ah,00010001b
     mov cx,9
   
 Tablero_v:
	     mov[es:di],ax
	      add di,4
	      inc [cont]
	      cmp [cont],3
	      je Fila_s
	      cmp [cont],6
	      je Fila_s
	      cmp [cont],9
	      je EsperaPorTeclado
	      loop Tablero_v
  Fila_s: 
	    add di,308
	    inc bx
	    jmp Tablero_v
      RET

  Q db 0
  W db 0
  E db 0
  A db 0
  S db 0
  D db 0
  Z db 0
  X db 0
  C db 0
  T db 0	    ;turno para jugar
  ; posibles resultados
  h1  db 0
  h2  db 0
  h3  db 0
  v1  db 0
  v2  db 0
  v3  db 0
  d1  db 0
  d2  db 0
  h_1 db 0
  h_2 db 0
  h_3 db 0
  v_1 db 0
  v_2 db 0
  v_3 db 0
  d_1 db 0
  d_2 db 0
  cont db 0
  contador   db 0
  contador2  db 0
  contador3  db 0

 times (5*512)-($-$$) db 0 ; para usar mas de un sector y saltar la limitante de 512 bytes
			       