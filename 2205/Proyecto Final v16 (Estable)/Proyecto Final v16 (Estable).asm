format binary as 'img'
org 7c00h

 mov ax, 13h
 int 10h

 cli
 push es
  xor ax, ax
   mov es, ax
  mov ax, timer
  mov [es:8*4],ax
  mov [es:8*4+2], cs
  sti
 pop es

  cli
 push es
   mov ax,keyboard
   mov [es:4*9], ax
   mov [es:4*9+2], cs
   sti
  pop es



; Estaticos:  
  ;Fondo
  mov ah,01011110b
  mov edi,0
  mov ecx,320*200
  call Print
  
; Tanque 1:
  ;Borde Tanque 1
  mov ah,0000b
  mov edi,320*139+57
  mov ecx,76   ; Vertical
  mov edx,56   ; Horizontal
  call Dibujar
  
  ;Tanque 1
  mov ah,1111b
  mov edi,320*136+60
  mov ecx,70   ; Vertical
  mov edx,50   ; Horizontal
  call Dibujar

; Tanque 2: 
  ;Borde Tanque 2
  mov ah,0000b
  mov edi,320*139+137
  mov ecx,76   ; Vertical
  mov edx,56   ; Horizontal
  call Dibujar
  
  ;Tanque 2
  mov ah,1111b
  mov edi,320*136+140
  mov ecx,70
  mov edx,50
  call Dibujar
  
;Tanque 3:  
  ;Borde Tanque 3
  mov ah,0000b
  mov edi,320*139+217
  mov ecx,76   ; Vertical
  mov edx,56   ; Horizontal
  call Dibujar
  
  ;Tanque 3
  mov ah,1111b
  mov edi,320*136+220
  mov ecx,70
  mov edx,50
  call Dibujar
  
; NO TOCAR CODIGO de arriba

 Principal:
 jmp Principal
 
  jmp $

; AQUI COMIENZAS LAS INSTRUCCIONES DE HARDWARE
 
 timer: 
  dec [cont]
  cmp [cont], 0
  jne salirTimer
  mov [cont], 1   ; cont=3  // 10s
  call Llenar
  
  salirTimer:
  mov al,20h   
  out 20h,al   
  iret



 keyboard:
  in al,60h   
  
  
  
 Tecla1:
  cmp al, 2  ; COMPRUEBA LA TECLA 1
  jne Tecla2 
  
  T1:
   mov [lineas],0
   add [necesarios],1
   mov edi, 0xa0000 
   add edi,320*136+60
   call Llenar
   ;jmp salirKey
  
  
  
  
 Tecla2:
  cmp al, 3  ; COMPRUEBA LA TECLA 2
  jne Tecla3
  
  
  ;T1:
   ;mov [lineas],0
   ;add [necesarios],1
   ;mov edi, 0xa0000 
   ;add edi,320*136+60
   ;call Llenar
   ;jmp salirKey
  
  
  T2:
  mov [lineas],0
   add [necesarios],1   ; Necesarios debe ser 2 pero esta bug
   mov ah,1001b
   mov edi,0xa0000
   add edi,320*136+140
   call Llenar 
  jmp salirKey
  
  
  
  
  
 Tecla3:
  cmp al, 4  ; COMPRUEBA LA TECLA 3
  jne salirKey
  
  ;mov [lineas],0
  ;add [necesarios], 3    ; Necesario debe ser 3 pero sigue bug
  
  
  T13:
   mov edi,0xa0000
   add edi,320*136+60
   call Llenar
  T23:
   mov edi,0xa0000
   add edi,320*136+140
   call Llenar
  T3:
   mov edi,0xa0000
   add edi,320*136+220
   call Llenar
  jmp salirKey
  
  
  ;Reset:
  ;cmp al, 30        ; Comprueba la teclca A
  ;jne salirKey
  ;int 10h
  ;jmp salirKey
  
  salirKey:
  mov   al,20h        
  out   20h,al        
  iret
  
;aqui terminan todas las interrupciones de hardware



; Subrutinas
 
 Llenar:
  mov cx, 50                   ; Ancho del agua
  ciclo_horizontal:
       mov al, 1100b            ; color del agua                    
       mov [edi], al                 
       add edi, 1
      loop ciclo_horizontal        
      sub edi, 320 + 50
      inc [lineas]			; Rutina para detener
      cmp [lineas],61
     ; cmp edi, 320*75
      je salirLlenar
  @@:
  ret
  
  
  
  salirLlenar:
   push dx            ; apilar dx
   mov edi,0
   mov [lineas],0     ; Reiniciar el llenado
   inc [tanques]        ; Incrementar los vasos llenos
   mov dh,[tanques] 
   cmp dh,[necesarios]  ; Ver si ya es suficiente
   je salirLlenar
   pop dx
   jmp @b 
   
   ;salirLlenar2:
   ;push dx           
   ;mov edi,0
   ;mov [lineas],0     ; Reiniciar el llenado
   ;inc [tanques]        ; Incrementar los vasos llenos
   ;mov dh,[tanques] 
   ;cmp dh,[necesarios]  ; Ver si ya es suficiente
   ;je salirLlenar2
   ;pop dx
   ;jmp T2 



; NO TOCAR CODIGO

 Dibujar:
  .for3:
   push edi
   push ecx
   mov ecx, edx
   call Print
   pop ecx
   pop edi
   sub edi, 320
   loop .for3
   ret
  Print: 
   add edi, 0x0A0000   
  for1:        
   mov [edi],ah
   add edi,1
   loop for1
   ret
  
  


; Variables
 cont db 18
 lineas db 0   ; cantidad de lineas para llenar un tanque
 tanques db 0  ; cantidad de tanques llenos
 necesarios db 0  ; cantidad de tanques necesarios por tecla presionada

 times 510- ($-$$) db 0
 dw 0xaa55
