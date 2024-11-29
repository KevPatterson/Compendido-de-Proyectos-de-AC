format binary as 'img'
org 7C00h

	mov ax, 13h
	Int 10h

CLI
	xor ax,ax
	mov es,ax
	mov ax,timer
	mov [es:8*4],ax
	mov [es:8*4+2],cs

	mov ax,key
	mov [es:9*4],ax
	mov [es:9*4+2],cs

STI
	call fondo
	call tanq
	jmp $

timer: dec[cont]
       jnz fin_timer


       mov [cont],18

       cmp [estado],1
       jne salt_time
       cmp [nivel],100
       je fin_timer
       add [nivel],5
       call print
       jmp fin_timer

salt_time:
       cmp [estado],0
       jne fin_timer
       cmp [nivel],0
       je limpiar
       call print
       sub [nivel],5
       jmp fin_timer

limpiar: mov ax, 13h
	 Int 10h
	 call fondo
	 call tanq



fin_timer:
       mov al,20h
       out 20h,al
       iret

key:   in al,60h
       cmp al,127
       mov [cont],18
       ja fin_key

       cmp al,38
       jne salt1
       mov [estado],1
salt1:
       cmp al,47
       jne fin_key
       mov [estado],0
fin_key:
       mov al,20h
       out 20h,al
       iret

print:
      mov ax, 13h
      Int 10h

      call fondo
      call tanq
      mov edi,0xA0000+320*150+150
      mov cx,[nivel]
      mov al,1
      print1:
	     push cx
	     mov cx,40

	     print2:
		    mov [edi],al
		    inc edi
		    loop print2

	    sub edi,360
	    pop cx
	    loop print1
ret


      fondo:
		 mov cx,200
      mov edi,0xA0000
      mov al,15
      blanco:
	     push cx
	     mov cx,320
	     blanco1:mov [edi],al
		     inc edi
		     loop blanco1

	     pop cx
	     loop blanco

	ret



      tanq:
      mov edi,0xA0000+320*151+149
      mov al,0
      mov cx,42

      tanq_bajo: mov [edi],al
		 inc edi
		 loop tanq_bajo

      dec edi
      mov cx,102
      tanq_der:  mov [edi],al
		 sub edi,320
		 loop tanq_der

      add edi, 320
      mov cx,41
      tanq_sup:  mov [edi],al
		 dec edi
		 loop tanq_sup
      mov cx,101
      tanq_izq:  mov [edi],al
		 add edi,320
		 loop tanq_izq

      ret
;variables
cont db 18
nivel dw 0
estado db 3
times 510-($-$$) db 0
dw 0xaa55