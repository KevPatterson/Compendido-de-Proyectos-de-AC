format binary as 'img'
ORG 7C00h
 
  MOV AX, 13h
  INT 10h

  MOV AX, 0xA000
  MOV ES, AX

push es
cli
xor ax, ax
xor di, di
mov es, ax
mov ax, timer
mov [es:8*4], ax
mov [es:8*4+2] , cs
mov ax, teclado
mov [es:9*4], ax
mov [es:9*4+2], cs
sti
pop es

CALL bg_draw
mov al, [rojo]
CALL peon
mov al, [azul]
mov [peon_pos], 1775
call peon
mov [peon_pos], 53255
  
JMP $

timer:
dec [counter]
jnz salir_counter

call resaltar_pos

mov [counter], 1

salir_counter:
mov al, 20h
out 20h, al

iret

teclado:
  in al, 60h
  cmp al, 127
  jae salir_teclado

  cmp al, 31 ; C�digo de escaneo de la tecla "s"
  je accion_s
  cmp al, 18 ; C�digo de escaneo de la tecla "e"
  je accion_e
  cmp al, 46 ; C�digo de escaneo de la tecla "c"
  je accion_c 
  jmp salir_teclado

  accion_s:
  mov al, [negro]
  mov [peon_pos], 53255
  call peon
  mov al, [rojo]
  mov [peon_pos], 27335
  call peon
  inc [acciones]
  jmp salir_teclado

  accion_e:
  mov al, [negro]
  mov di, [peon_pos]
  call peon
  mov al, [rojo]
  mov [peon_pos], 14535
  call peon
  inc [acciones]
  jmp salir_teclado

  accion_c:
  mov al, [blanco]
  mov di, [peon_pos]
  call peon
  mov al, [rojo]
  mov [peon_pos], 1775
  call peon
  inc [acciones]
  jmp salir_teclado

  salir_teclado:
    mov dl, [acciones]
    and dl, 1
    jz que_parpadee
    jmp salir_a

    que_parpadee:
      call parpadear
    salir_a:
    mov al, 20h
    out 20h, al
  iret

resaltar_pos:
  cmp [cambiando], 0
  je salir_resaltar_pos
  cmp [color_index], 0
  je dejar_de_resaltar

  mov di, [peon_pos]
  mov dl, [color_index]
  and dl, 1 ;
  jnz color_rojo
  
  color_verde:
    mov al, 00000010b
    jmp cambiar_color
  color_rojo:
    mov al, [rojo]
    jmp cambiar_color

  cambiar_color:
    call peon
    inc al
    sub [color_index], 1
    jmp salir_resaltar_pos
    
  dejar_de_resaltar:
    mov [cambiando], 0
  
  salir_resaltar_pos:
  ret

parpadear:
  mov [cambiando], 1
  mov [color_index], 10
  ret

bg_draw:
  MOV CX, 64000
  MOV DI, 0
  MOV AL, [negro]

  bg_draw_loop:
    MOV [ES:DI], AL
    INC DI
  LOOP bg_draw_loop

  CALL tablero
  RET

tablero:
  MOV CX, 5
  cuadrado_filas_loop:	

    MOV AL, [blanco]
    PUSH CX
    MOV CX, 4
    cuadrado_loop:
PUSH CX
MOV DI, [aux]
CALL cuadrado
POP CX
MOV BX, [offset_x]
ADD [aux], BX
    LOOP cuadrado_loop
    
    ADD [row], 1

    MOV AX, [offset_y]
    MOV BX, [row]
    MUL BX

    MOV BX, 320
    MUL BX
    MOV [aux], AX

    MOV AX, [row]
    AND AX, 00000001b
    JZ par

    impar:
ADD [aux], 40

    par:
    
    POP CX
  LOOP cuadrado_filas_loop
  RET

cuadrado:
  MOV CX, [n]
  
  pintar_filas:
    PUSH CX

    MOV CX, [n]
    pintar_cols:
MOV [ES:DI], AL
INC DI
    LOOP pintar_cols
    ADD DI, 320-40
    POP CX
  LOOP pintar_filas
RET

peon:
mov di, [peon_pos]
call peon_cuerpo
mov di, [peon_pos]
add di, 637
call peon_cabeza
mov di, [peon_pos]
add di, 7675
call peon_base
mov di, [peon_pos]
ret

peon_base:
mov cx, 5
pintar_peon_filas:
push cx
mov cx, 20
pintar_peon_columna:

mov [es:di], al
inc di
loop pintar_peon_columna
add di,320 - 20
pop cx
loop pintar_peon_filas
ret

peon_cuerpo:
mov cx, 25
pintar_peonc_fila:
push cx
mov cx, 10
pintar_peonc_columna:
mov [es:di], al
inc di
loop pintar_peonc_columna
add di, 320-10
pop cx
loop pintar_peonc_fila
ret

peon_cabeza:
mov cx, 12
pintar_peonca_fila:
push cx
mov cx, 16
pintar_peonca_columna:
mov [es:di], al
inc di
loop pintar_peonca_columna
add di, 320-16
pop cx
loop pintar_peonca_fila
ret

 
blanco db 00001111b
negro db 00000000b
rojo db 00001100b
azul db 00000001b
n dw 40
offset_x dw 80
offset_y dw 40
aux dw 0
row dw 0
peon_pos dw 53255
counter db 8
acciones db 0
cambiando db 0
color_index db 0

 
times 510-($-$$) db 0
  dw 0xAA55