format binary as 'img'
org 7C00h

UP = 11h
RIGHT = 20h
DOWN = 1fh
LEFT = 1eh

mov ax,13h
int 10h
mov ax,Key
xor ax,ax
mov es,ax
mov [es:4*9],ax
mov [es:4*9+2],cs
sti

mov eax,0xA0000
mov gs,ax
mov di,[position]
mov [gs:di],byte 14

 Key: mov di,[position]
in al,60h
cmp al,UP
jne @f
sub di,320
jmp update
@@: cmp al,RIGHT
jne @f
inc di
jmp update
@@: cmp al,DOWN
jne @f
add di,320
jmp update
@@: cmp al,LEFT
jne end_of_int
dec di
jmp update
update: mov [gs:di],byte 14
mov [position],di
end_of_int: mov al,20h
out 20h,al
iret

		
	  position dw 32160
	  times 510-($-$$) db 0
			   dw 0xaa55
