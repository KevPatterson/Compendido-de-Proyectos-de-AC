format binary as 'img'
org 7C00h

xor di, di

xor ax, ax
mov es, ax

mov ax,timer
mov [es:4*8], ax
mov [es:4*8+2], cs
sti

@@:
    cmp dl, 9
    je pintar
    jmp @b

pintar:
    mov ax, 3
    int 10h

mov ax, 0b800h
mov es, ax
mov ah, 00000100b
mov al, 'R'
mov [es:di], ax
add di, 2
mov dl,0
jmp @b

jmp $


timer:
    cli










    mov al, 20h
    out 20h, al
    sti
iret

times   510-($-$$) db 0
            dw 0xaa55