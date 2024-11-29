format binary as 'img'
org 7c00h



mov ax, 0x3
int 10h

mov ax, 0xb800
mov es, ax

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
xor ax, ax
mov es, ax
mov ax,keyboard
mov [es:4*9], ax
mov [es:4*9+2], cs
 
sti
pop es

jmp $

timer:
	cmp [ban], 0
	jne @f
	mov [ban], 1
	call imprimir
	@@:
	dec [contador]
	cmp [contador], 0
	jne salir
	xor bl, bl
	mov [contador], 18*15
	call imprimir

salir:	mov al, 20h
	out 20h, al
	iret


keyboard:
	xor ax, ax
	in al, 60h
	cmp al, 128
	jae fin_keyboard
	mov di, keymap
	add di, ax
	mov bl, [di]
	mov [charac], bl
	call imprimir

fin_keyboard:
	mov al, 20h
	out 20h, al
	iret

imprimir:
mov di, 160*10+30
	mov si, cad1
	mov cx, 28
	call print

	mov si, cad2
	mov cx, 28
	call print

	mov si, cad3
	mov cx, 28
	call print

	mov si, cad4
	mov cx, 28
	call print

	mov si, cad5
	mov cx, 28
	call print

		jmp final
	print:
		mfc:
		mov ah, [color]
		mov al, [si]
		cmp al, bl
		jne @f
		mov ah, 00010100b
		mov [contador], 18*15
		@@:
		mov [es:di], ax
		inc si
		add di, 2
		loop mfc
		add di, 160-28*2
		ret
final:	     
	mov di, 160*10+30
	xor bl, bl
	ret


;*******************[VARIABLES]**************************
cad1 db ' Q | W | E | R | T | Y | U |'
cad2 db '----------------------------'
cad3 db ' A | S | D | F | G | H | J |'
cad4 db '----------------------------'
cad5 db ' Z | X | C | V | B | N | M |'

color db 00010010b

keymap db '012345678900¡00QWERTYUIOP0+00ASDFGHJKLÑ00<ZXCVBNM,.-'

ban db 0
contador dw 18*15
charac db 0


times 510-($-$$) db 0
dw 0xaa55
