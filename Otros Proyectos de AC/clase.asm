   format binary as 'img'
org 7c00h

mov ax,0x13
int 10h

mov ax,0xa000
mov es,ax

push es
xor ax,ax
mov es,ax
mov ax, rutina
cli
mov [es:9*4],ax
mov [es:9*4+2],cs
sti

pop es

jmp $

rutina:mov  ax,0x13
       int 10h
       mov ax,0xa000
       mov es,ax


        in al ,60h
        cmp al,127
        ja liberada
        call color 
        call pintar
 salir:mov al,20h
        out 20h,al
        iret
        
color : mov [color1],00111100b
         ret

pintar: 
        mov al,[color1]
        mov di,320*(100-60)+160
        mov cx,60
  dib:mov [es:di],al
         add di,320
         loop dib
         
         mov cx,60
 dib1:mov [es :di],al
         add di,-1
         loop dib1       
         ret
         
 liberada:mov  ax,0x13
          int 10h
          mov ax,0xa000
          mov es,ax
 
 
          mov al,00001010b  
          mov di,320*100+160+60
          mov cx,60
 dib2: mov [es:di],al
          add di,-1
          loop dib2
          
          mov cx,60
 dib3: mov [es:di],al
          add di,320
          loop dib3
          jmp salir
          
                         
 color1 rb 1
 times 510 -($-$$) db 0
 dw 0xaa55   
