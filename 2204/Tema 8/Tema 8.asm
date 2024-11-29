format binary as 'img'
org 7C00h

     mov ax, cs
     mov ds,ax

     mov ax, 13h
     int 10h

     mov ax, 0xA000
     mov es,ax

     ; Escribiendo en el vector teclado

     cli

     xor ax, ax
     mov gs, ax
     mov ax, teclado
     mov [gs:9*4], ax
     mov [gs:9*4+2], cs

     sti

    ; Escribir Vector Timer

    cli

    xor ax, ax
    mov gs, ax
    mov ax, timer
    mov [gs:8*4], ax
    mov [gs:8*4+2], cs

    sti

     ;Pintando Fondo

     mov al, 15
     mov di, 0
     mov cx, 200

     pintar_fondo:   push cx
		     mov cx, 320
	   for_pf:   mov [es:di], al
		     inc di
		     loop for_pf
		     pop cx
		     loop pintar_fondo


     call parar




jmp $

trianguloUp:	mov [medida], 50
		mov di, 44*320 + 110
		mov cx, [medida]
		add [medida],50
   pintarUp:	push cx
		mov cx, [medida]
      forUp:	mov [es:di], al
		inc di
		loop forUp
		sub di, [medida]
		sub [medida], 2
		add di, 321
		pop cx
		loop pintarUp
		ret


trianguloDown:	mov [medida], 50
		mov di, 155*320 +110
		mov cx, [medida]
		add [medida],50
   pintarDown:	push cx
		mov cx, [medida]
      forDown:	mov [es:di], al
		inc di
		loop forDown
		sub di, [medida]
		sub [medida], 2
		sub di, 319
		pop cx
		loop pintarDown
		ret

trianguloLeft:	mov [medida], 50
		mov di, 51*320 + 100
		mov cx, [medida]
		add [medida],50
   pintarLeft:	push cx
		mov cx, [medida]
      forLeft:	mov [es:di], al
		add di, 320
		loop forLeft
		mov cx, [medida]
	 decL:	sub di, 320
		loop decL
		sub [medida], 2
		add di, 321
		pop cx
		loop pintarLeft
		ret


trianguloRigth: mov [medida], 50
		mov di, 51*320 + 220
		mov cx, [medida]
		add [medida],50
   pintarRigth: push cx
		mov cx, [medida]
      forRigth: mov [es:di], al
		add di, 320
		loop forRigth
		mov cx, [medida]
	 decR:	sub di, 320
		loop decR
		sub [medida], 2
		add di, 319
		pop cx
		loop pintarRigth
		ret

; Teclado

teclado:  in al, 60h
	  cmp al, 127
	  ja finTec
	  cmp al, 22h
	  jne compOtra
	  cmp [seguir], 1
	  je finTec
	  mov [cont], 18
	  mov [seguir], 1
	  call animar
	  jmp finTec

compOtra: cmp al, 20h
	  jnz finTec
	  mov [seguir], 0
	  call parar

finTec:   mov al, 20h
	  out 20h, al
	  iret


; Timer

timer:	    cmp [seguir], 0
	    je finTim
	    dec [cont]
	    jnz finTim
	    mov [cont], 18
	    call animar
   finTim:  mov al, 20h
	    out 20h, al
	    iret




animar:     cmp [pos], 1
	    je cambiar
	    mov [pos], 1

	    mov al, 3
	    call trianguloUp
	    call trianguloDown

	    mov al, 15h
	    call trianguloLeft
	    call trianguloRigth
	    jmp finAnimar

cambiar:    mov [pos], 2

	    mov al, 15h
	    call trianguloUp
	    call trianguloDown

	    mov al, 3
	    call trianguloLeft
	    call trianguloRigth

finAnimar:  ret

parar:	    mov al, 15h
	    call trianguloUp

	    call trianguloDown

	    call trianguloLeft

	    call trianguloRigth
	    ret



;Variables

medida dw ?
pos db 1
seguir db 0
cont dw 18

times 510-($-$$) db 0
      dw 0xaa55
				 