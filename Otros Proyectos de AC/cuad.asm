format binary as 'img'
org 7C00h
		mov ax,0x13
int 10h
mov ax,0xA000
mov es,ax
mov di,320*100+160
mov [es:di],dword 01010101b
mov [es:di+320],dword 01010101b
mov [es:di+320*2],dword 01010101b
mov [es:di+320*3],dword 01010101b
		jmp	$
		

	  times 510-($-$$) db 0
			   dw 0xaa55
