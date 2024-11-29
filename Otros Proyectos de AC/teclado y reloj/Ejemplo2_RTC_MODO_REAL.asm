format binary as 'img'
use16
org 7c00h
		mov	ax, 3
		int	10h

		xor	ax,ax
		mov	es,ax
		mov	ax,show_time
		mov	[es:4*70h],ax		; Capturar la irq8
		mov	[es:4*70h+2],cs

		mov	ax,0b800h
		mov	es,ax

		mov	al,0bh			; Activar las interrupciones del RTC
		out	70h,al
		in	al,71h
		or	al,64			; haciendo '1' el bit 6 del registro B
		mov	ah,al
		mov	al,0bh
		out	70h,al
		mov	al,ah			; Escribir el valor modificado
		out	71h,al
						; Por defecto, la irq8 est? deshabilitada :-(
		in	al,0A1h 		; Leer la m?scara de interrupciones del PIC esclavo
		and	al,0feh 		; Activar la irq8 (bit0 = 0)...
		out	0A1h,al 		; ...sin modificar los otros valores

		sti

		jmp	$

       clockPos dw 160-8*2
	datePos dw 160*2-15*2
	   days db 'DomLunMarMieJueVieSab'
	 months db 'EneFebMarAbrMayJunJulAgoSepOctNovDic'

;_______________________________________________________;
;                                                       ;
;                      Subrutinas                       ;
;_______________________________________________________;

     show_time: mov	al,0ch			; Leer el registro C
		out	70h,al			; del RTC
		in	al,71h			; Para que siga generando interrupciones

		mov	di,[clockPos]		; Posici?n designada para el "reloj"
		
		mov	ch,71h
		mov	cl,':'

		mov	al,4			; Solicitar valor de las horas
		out	70h,al
		in	al,71h
		call	show_bcd

		mov	[es:di],cx
		add	di,2

		mov	al,2			; Solicitar valor de los minutos
		out	70h,al
		in	al,71h
		call	show_bcd

		mov	[es:di],cx
		add	di,2

		mov	al,0			; Solicitar valor de los segundos
		out	70h,al
		in	al,71h
		call	show_bcd

		mov	di,[datePos]

		mov	al,6			; Solicitar valor del d?a de la semana
		out	70h,al
		in	al,71h
		call	show_week_day

		mov	cl,','
		mov	[es:di],cx
		add	di,2

		mov	al,8			; Solicitar valor del mes
		out	70h,al
		in	al,71h
		call	show_month

		mov	cl,' '
		mov	[es:di],cx
		add	di,2

		mov	al,7			; Solicitar valor del d?a del mes
		out	70h,al
		in	al,71h
		call	show_bcd

		mov	[es:di],cx
		add	di,2

		mov	al,50			; Solicitar valor de la centuria
		out	70h,al
		in	al,71h
		call	show_bcd

		mov	al,9			; Solicitar valor del a?o
		out	70h,al
		in	al,71h
		call	show_bcd

		mov	al,20h			; Enviar el fin de interrupci?n
		out	0a0h,al 		; al PIC esclavo
		out	20h,al			; y al maestro
		iret

      show_bcd: mov	bl,al
		xor	eax,eax
		or	al,bl
		shr	al,4
		and	bl,0fh
		mov	ah,ch
		mov	bh,ch
		shl	ebx,16
		or	eax,ebx
		add	eax,00300030h
		mov	[es:di],eax
		add	di,4
		ret

 show_week_day: dec	al
		xor	ah,ah			; Hacer una multiplicaci?n por tres
		mov	si,ax			; Pero de manera incremental
		shl	si,1			; solo sumando
		add	si,ax
		mov	bx,days 		; Utilizar bx como apuntador al texto
		add	bx,si			; Apuntar al nombre de d?a correcto
		mov	cl,[bx]
		mov	[es:di],cx
		mov	cl,[bx+1]
		mov	[es:di+2],cx
		mov	cl,[bx+2]
		mov	[es:di+4],cx
		add	di,6
		ret

    show_month: dec	al
		test	al,10h			; Si el d?gito m?s significativo es 0
		jz	@f			; Se procede como para el d?a de la semana
		and	al,0fh			; En caso contrario, solo debe sumarse diez
		add	al,10			; ;-)
	    @@: xor	ah,ah			; Hacer una multiplicaci?n por tres
		mov	si,ax			; Pero de manera incremental
		shl	si,1			; solo sumando
		add	si,ax
		mov	bx,months		; Utilizar bx como apuntador al texto
		add	bx,si			; Apuntar al nombre de d?a correcto
		mov	cl,[bx]
		mov	[es:di],cx
		mov	cl,[bx+1]
		mov	[es:di+2],cx
		mov	cl,[bx+2]
		mov	[es:di+4],cx
		add	di,6
		ret

times 510-($-$$) db 0
		 dw 0aa55h
