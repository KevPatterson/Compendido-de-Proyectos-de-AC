;Juan Pablo Ramirez && Roberto Samir Rosabal Grupo 2201 tema:Carrito1
format binary as 'img'
org 7C00h

; Código de arranque inicial (sector de arranque)

mov ah, 0x02  ; Código de función para leer el sector
mov al, 0x04	 ; Número de sectores para leer
mov ch, 0x00	 ; Número de cilindro
mov cl, 0x02	 ; Número de sector
mov dh, 0x00	 ; Número de cabeza
mov dl, 0x00	 ; Número de unidad (0 para el primer disco duro)
mov bx, 0x8000 ; Dirección del buffer para leer los datos
int 0x13       ; Llamar a la interrupción del BIOS para leer el sector

jmp 0x8000     ; Saltar al código cargado

times 510-($-$$) db 0
dw 0xaa55

org 8000h


		cli
			  mov  ax,13h	; Establecer el modo de video texto VGA
			  int  10h     ;Al establecer el modo de video se limpia la pantalla
	    @@: mov	ax,0x2401		; activar la línea A20
		int	0x15
		jc	@b

		Lgdt	[gdtr]			; Inicializar el registro de descriptores globales
		mov	eax,cr0
		or	al,1			; activar el modo protegido
		mov	cr0,eax
		jmp	8:protectedMode 	; activar los selectores del modo protegido
use32
 protectedMode:
			
		
		mov	ax,10h; el 16 es 10000 primeros dos ceros nivel de privilegios, el otro cero es GDT, y el otro index 3
	
		mov	ds,ax
		mov	ss,ax
	
		mov	ecx,256*2		; "Colonizar" los primeros 2K de la RAM para
		xor	edi,edi 		; que sean la idt
		xor	eax,eax
	    @@: mov	[edi],eax
		add	edi,4
		loop	@b			; Primero hacer que todas las entradas sean cero
		
		;moviendo las subrutinas para la tablas
		
						; Luego ocupar los valores adecuados 
		mov	eax,[irq0]	; mueve a EAX los primeros 4 bytes del descriptor
		mov	[32*8],eax	; ubica esos primeros 4byte en la posicion de la tabla
		mov	eax,[irq0+4]	; mueve para EAX los restantes 4 byte del descriptor
		mov	[32*8+4],eax	;completa los 4 byte que faltaban del descriptor, en la tabla

		mov   eax,[irq1]
		mov   [33*8],eax
		mov   eax,[irq1+4]
		mov   [33*8+4],eax
		
		; mov   eax,[irq8]
		; mov   [40*8],eax
		; mov   eax,[irq8+4]
		; mov   [40*8+4],eax
		
		; mov   eax,[irq12]
		; mov   [44*8],eax
		; mov   eax,[irq12+4]
		; mov   [44*8+4],eax
		
		; mov   eax,[irq14]
		; mov   [46*8],eax
		; mov   eax,[irq14+4]
		; mov   [46*8+4],eax
		
		mov	al,0x11 	; Comando para cambio de irq base
		out	0x20,al 	; al PC maestro
		out	0xA0,al 	; y al esclavo

		mov	al,0x20 	; inicio=int32
		out	0x21,al 	; para el maestro
		mov	al,0x28 	; inicio=int40
		out	0xA1,al 	; para el esclavo
    
		mov	al,0x4
		out	0x21,al 	; ¿Quién es maestro?
		mov	al,0x2
		out	0xA1,al 	; ¿Y quién el esclavo?
    
		mov	al,1		; Mismo modo de trabajo
		out	0x21,al 	; para los dos(modo 8086)
		out	0xA1,al

		xor	al,al		; activar todas las interrupciones
		out	0x21,al 	; en el maestro
		out	0xA1,al 	; y el esclavo
		
		lidt	[idtr]
		sti
		mov edi,100*320+160
		;add edi,0xB8000
		call Pinta
		mov edi,100*320+160
		
		;mov [edi],BX
		jmp	$
		
;aqui voy a poner todas los procedimientos de las interrupciones de hardware
	timer: 
		;18 interrupciones es 1 Segundo
				
		.se:
		mov	al,20h			; fin de interrupción hardware
		out	20h,al			; al pic maestro
	iret
		
    teclado: 
		mov	ah,0
		in	al,60h		   ;leyendo el buffer del teclado
		
		mov bl,al ;para no perder el valor de AL
		
		test	al,10000000b	   ; si el bit mas sgnificativo esta en 1 significa que el buffer está lleno, por tanto se presiono una tecla
		jz     @f
		jmp .se
		;arriba
		@@:
			;xor cx,cx
			mov bh,100b
			mov bl,001b

			
			cmp al,72
			jne .escape

				cmp [x],0
				jne .sii
					jmp .se
				
				.sii:
				push edi
					call borrar
					pop edi
					sub edi,320
					push edi
					
					call Pinta
					
					pop edi
					
					
					dec [x]
					jmp .se

			.escape:
			 cmp al,01
			 jne .no
			  ;xor ax,ax
			 mov ah,4ch
			  int 21h
			  jmp .se

			.no:
			;abajo
			cmp al,80
			jne .no1
			cmp [x],188
				jne .sii1
					;inc ebx
					jmp .se
				
				.sii1:
					push edi
					call borrar
					pop edi
					add edi,320
					push edi
					
					call Pinta
					
					pop edi
					inc [x]
					jmp .se
			
			; izquierda
			.no1:
			 cmp al,75
			 jne .no2
				 cmp [y],0
				 jne .sii2
					 jmp .se
				
				 .sii2:
		    push edi
					call borrar
					pop edi
					sub edi,1
					push edi
					
					call Pinta
					
					pop edi
					
					
					dec [y]
					jmp .se
			
			; derecha
			 .no2:
			 cmp al,77
			 jne .resetea
				 cmp [y],308
				 jne .sii3
				 ;inc ebx
					 jmp .se
				
				 .sii3:
		    push edi
					call borrar
					pop edi
					add edi,1
					push edi
					
					call Pinta
					
					pop edi
					inc [y]
					jmp .se
			 ; reset
			 .resetea:
			 cmp al,19
			 jne .se
			 mov ah,0
			 int 19h
			 jmp .se
     ;salir   
		;.se:
		;cmp ebx,2
		;je cartel
		;jmp .see

	       ; .cartel:
	       ; call cartel
	       ; jmp .see

		.se:

		mov   al,20h		      ; fin de interrupción hardware
		out   20h,al		      ; al pic maestro
	iret
	
	; rtc:
		
		; mov   al,20h                  ; fin de interrupción hardware
		; out   0xA0,al                 ; al pic esclavo
		; out 0x20,al                   ; al pic maestro
	; iret
	
	; mouse:
		; mov   al,20h                  ; fin de interrupción hardware
		; out   0xA0,al                 ; al pic maestro
		; out 0x20,al                   ; al pic maestro
	; iret
		
	; hdd:
		
		; mov   al,20h                  ; fin de interrupción hardware
		; out   0xA0,al                 ; al pic maestro
		; out 0x20,al                   ; al pic maestro
	; iret
		
;hasta aqui, aqui terminan todas las interrupciones de hardware

;aqui voy a poner mis subrutinas
		
		;print lineal para imprimir en pantalla
	Print: ;add     edi, 0x0A0000
			
	    for1:	       
		mov	[0xA0000+edi],ah
		add	edi,1
		
		loop for1
	    ya: ret

       abajo:	mov	[0xA0000+edi],ah
		add	edi,320
		fin: ret
      allado:	mov	[0xA0000+edi],ah
		add	edi,-1
		loop allado
		ya1: ret
		
	borrar:
	
		 mov edi,0xA0000
		 mov ecx,320*200
		
		 .for1:
			mov [edi],dh
			inc edi
		loop .for1
		
	ret

	cartel: mov ax,cs
		mov ds,ax
		mov ax,3
		int 10h
		mov ax,0b800h
		mov es,ax
		mov di,160*12+38*2
		mov ah,111b
		mov al,'W'
;                mov [es:di],ax


	ret

	
	Pinta:
					mov ah,100b
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					mov ecx,10
					call Print
					call abajo
					mov ecx,10
					call allado
					call abajo




	ret
	
;aqui termino todas mis subrutinas
ok db 0
x dw 99
y dw 160
;aqui pongo mis variables

;para teclado este KeyMap esta en ingles
	; keymap        db 0
			; db 27,'123456780-=',8
			; db 9,'qwertyuiop[]',10
			; db 0,'aasdfghjkl;',36,39,0,'\'
			; db 'zxcvbnm,./',0,'*',0,''
			; db 0,'12345678901',0,'3789-456+1230.'
			
		
;aqui termina la declaracion de mis variables
align 4
	   gdt:
		dq 0000000000000000h		; descriptor nulo 
		dq 00cf9a000000ffffh		; código con máximos privilegios
		dq 00cf92000000ffffh		; datos con máximos privilegios
	  .end:

	  gdtr: dw (gdt.end-gdt)
		dd gdt


	  irq0: dw timer and 0ffffh			; int 32 (IRQ0)
		dw 8
		dW 8e00h
		dw timer shr 16
		
	  irq1: dw teclado and 0ffffh		      ; int 33 (IRQ1)
		dw 8
		dW 8e00h
		dw teclado shr 16
		
	 ; irq8: dw rtc and 0ffffh                      ; int 40 (IRQ8)
		; dw 8
		; dW 8e00h
		; dw rtc shr 16
		
	 ; irq12: dw mouse and 0ffffh                   ; int 44 (IRQ12)
		; dw 8
		; dW 8e00h
		; dw mouse shr 16

	 ; irq14: dw hdd and 0ffffh                     ; int 46 (IRQ14)
		; dw 8
		; dW 8e00h
		; dw hdd shr 16
		
	  idtr: dw 256*8
		dd 0

;times 510-($-$$) db 0
;                 dw 0xaa55
times (4*510)-($-$$) db 0