
format binary as 'img'
org 7C00h

		mov ax,0x3
		int 10h

		mov ax,0xb800
		mov es,ax

;;;
program:
    mov di, 160*10+2*20
    mov ah, [color_1]
    call solicitar_mensaje_alarma
    call input_alarma_mensaje
    
    frame:
        push di
        call reloj
        pop di
        call comparar
        jmp frame        

    jmp $

;;;	
input_alarma_mensaje: 
    push ax
    mov cx, 50
	mov si, 0
    input_alarma_mensaje_b:
		mov ah, 00h
		int 16h
		mov [mansaje_alarma+si], al 
		inc si
    loop input_alarma_mensaje_b

    pop ax
    ret

sonar_alarma:
    push di
    mov cx, 50
    add di, 160

    parpadear:
        push di    
        mov si, mansaje_alarma
        mov cx, 50
        call print
        call toggle_color
        call esperar_parpadeo
        pop di    
        jmp parpadear
    pop di
    ret
;;;;;;;;;;;;;;;;




solicitar_mensaje_alarma:
    mov si, alarma_solicitar_mensaje
    mov cx, 39
    call print
    ret
toggle_color:
    cmp ah, [color_1]
    je set_color2

    set_color1:
    mov ah, [color_1]
    ret
    set_color2:
    mov ah, [color_2]
    ret
print:
    push cx
    imprimir:
        mov al, [si]
        mov [es:di], ax
        add di, 2
        inc si
    loop imprimir
    pop cx
    imprimir_regresar:
        sub di, 2
    loop imprimir_regresar
    add di, 160
    ret

print_numero:
    push ax
    push bx
    push cx
    push dx

    xor bx, bx
    mov ah, 0
    mov bl, 10
    div bl
    mov bh, ah ; guardamos el resto
    mov ah, [color_1]
    character_1:
        add al, 48
        mov [es:di], ax
        add di, 2
    character_2:
        mov al, bh
        add al, 48
        mov [es:di], ax
        add di, 2
    character_separador:
        mov al, ':'
        mov [es:di], ax
        add di, 2

    pop dx
    pop cx
    pop bx
    pop ax
    ret

esperar_unsegundo:
    push ax
	push cx
    push dx

    mov ah, 86h 		; función que hace esperar
    mov cx, 18	; le asigna el tiempo a esperar
    mov dx, 4240h
    int 15h

    pop dx
    pop cx
    pop ax
    ret
esperar_parpadeo:
    push ax
	push cx
    push dx

    mov ah, 86h 		; función que hace esperar
    mov cx, 6
    mov dx, 4240h
    int 15h

    pop dx
    pop cx
    pop ax
    ret

reloj:
    push ax
    push bx
    push cx
    push dx
    mov ah, 02h; funcion de la interrupcion
    int 1ah  
    ; ch = hora, cl = minutos, dh = segundos, dl = cewntesimas de segundos  15:22
    
    
    ;segundos
    mov al, dh
    call BCDaBinario
    call print_numero
    
    
    ;minutos    
    mov al, cl
    call BCDaBinario
    call print_numero
 
    ;hora
    mov al, ch
    call BCDaBinario
    call print_numero

    pop dx
    pop cx
    pop bx
    pop ax
    ret

comparar:
    push ax
    mov ah, 02h; funcion de la interrupcion
    int 1ah   ; obtener la hora del sistema
    ; ch = hora, cl = minutos, dh = segundos, dl = cewntesimas de segundos  15:22
    mov si, tiempo_alarma_prueba
    
    ;hora
    mov al, ch
	call BCDaBinario
    cmp al, 14
    jl no_sonar
    jg sonar

    ;minutos    
    mov al, cl
	call BCDaBinario
    cmp al, 7
    jl no_sonar
    jg sonar

    ;segundos
    mov al, dh
	call BCDaBinario
    cmp al, 0
    jl no_sonar
    jg sonar
   
    sonar:
        pop ax
        call sonar_alarma
        jmp $
    no_sonar:
    fin_comparar:
	pop ax
    ret


    
;CONVERSIONES;
BCDaBinario:
	push bx
	push cx 
	push dx
    mov bl, 10

    mov ah, 0
	mov cl, al; al = 0010 0010


    shr al, 4   ; al = 0000 0010
    mul bl         ;al = 0010
    mov dl, al ; guardamos el valor de al

    mov al, cl
    
    shl al, 4   ; al = 0010 0000
    shr al, 4   ; al = 0000 0010
    mov cl, al  ; cl valor final

    mov al, dl  
    add al, cl

	pop dx
	pop cx 
	pop bx
	ret

alarma_solicitar_mensaje db 'introsusca el mensaje que desea mostrar en la alarma'
mensaje_solicitar_time db 'introsuca la alarma en ss:mm:hh'
mansaje_alarma db  10 dup(0) ;
tiempo_alarma db  6 dup(?) ; 
tiempo_alarma_prueba db '123456'
tiempo db 50 dup(?), '$'

separador db ':'
color_1 db 00000010b
color_2 db 0100000b

times 510-($-$$) db 0
        dw 0xaa55
