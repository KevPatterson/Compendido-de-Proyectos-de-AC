 
 ;Proyecto AC 
 
						 ;tema 7
; Trébol giratorio
;En ensamblador construya un programa que simule un trébol de 4 hojas que gira, apóyese en la figura siguiente:
;El estado inicial debe ser el de la figura a.
;Cuando el usuario oprima la tecla “g” se debe alternar entre la imagen b y la c cada 1 segundo.
;Cuando el usuario oprima la tecla “d” debe volver al estado a.
 
;Anthony Santiesteban  Jerez
;Eliani Martinez Estevez

;Grupo 2202
 
format binary as 'img'

org 7c00h

mov ax,cs
mov ds,ax

call estadoa
principal:


    in al,60h
    cmp al,32	 
    je estadoa

    cmp al,34	
    je estado1


    jmp principal



  estado1:
    call estadob

  call timer

    call estadoc

   call timer


    in al, 60h
    cmp al,32
    je principal

    jmp estado1


   timer:

    mov cx,18
    mov dx,07d0h
    mov ah,86h
    int 15h

ret







estadoa:



mov ax,13h
int 10h
mov ax,0a000h
mov es,ax

mov cx, 40
mov di, 320*1+140

call hoja1
call hoja2
call hoja3
call hoja4
call tallo
jmp principal



;--------------------------------------------------------------------------------------------------------------------------------------------------------

hoja1:


mov di,320*1+150
mov cx,40
vertical:
mov al, 00000111b 
mov [es:di], al 
add di, 320 
loop vertical 


ret


;-------------------------------------------------------------------------------------------------------------------------------------------------------------

hoja2:
mov di,320*80+150
mov cx,40
vertical3:
mov al, 00000111b 
mov [es:di], al 
add di, 320 
loop vertical3 


ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------

hoja3:

mov di,320*60+80
mov cx,40
horizontal5:
mov al, 00000111b 
mov [es:di], al 
inc di 
loop horizontal5 



ret




;----------------------------------------------------------------------------------------------------------------------------------------------------------------

hoja4:

mov di,320*60+180
mov cx,40
horizontal7:
mov al, 00000111b
mov [es:di], al 
inc di 
loop horizontal7 



ret


;----------------------------------------------------------------------------------------------------------------------------------------------------------------

tallo:

mov cx,20
mov di,320*140+150
vertical10:
mov al, 00000110b 
mov [es:di], al
add di, 320 
loop vertical10 


ret








 estadob:
  mov ax,13h
int 10h
mov ax,0a000h
mov es,ax

mov cx, 40
mov di, 320*1+140

call hoja12
call hoja22
call hoja32
call hoja42
call tallo2
ret


;--------------------------------------------------------------------------------------------------------------------------------------------------------

hoja12:


mov di,320*1+150
mov cx,40
vertical2:
mov al, 00000100b 
mov [es:di], al 
add di, 320 
loop vertical2


ret


;-------------------------------------------------------------------------------------------------------------------------------------------------------------

hoja22:
mov di,320*80+150
mov cx,40
vertical32:
mov al, 00000100b 
mov [es:di], al 
add di, 320 
loop vertical32


ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------

hoja32:

call hoja3


ret




;----------------------------------------------------------------------------------------------------------------------------------------------------------------

hoja42:

call hoja4

ret


;----------------------------------------------------------------------------------------------------------------------------------------------------------------

tallo2:

call tallo


ret




estadoc:

mov ax,13h
int 10h
mov ax,0a000h
mov es,ax


mov cx, 40
mov di, 320*1+140

call hoja13
call hoja23
call hoja33
call hoja43
call tallo3
ret


;--------------------------------------------------------------------------------------------------------------------------------------------------------

hoja13:


call hoja1


ret


;-------------------------------------------------------------------------------------------------------------------------------------------------------------

hoja23:

call hoja2


ret

;----------------------------------------------------------------------------------------------------------------------------------------------------------------

hoja33:

mov di,320*60+80
mov cx,40
horizontal53:
mov al, 00000100b 
mov [es:di], al 
inc di 
loop horizontal53 



ret




;----------------------------------------------------------------------------------------------------------------------------------------------------------------

hoja43:

mov di,320*60+180
mov cx,40
horizontal73:
mov al, 00000100b
mov [es:di], al 
inc di 
loop horizontal73 



ret


;----------------------------------------------------------------------------------------------------------------------------------------------------------------

tallo3:

call tallo

ret





jmp $


 contador db 18

times 510-($-$$) db 0
dw 0aa55h
