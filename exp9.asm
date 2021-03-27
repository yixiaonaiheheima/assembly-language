assume cs:code, ds:data

data segment
	db "welcome to masm!"
data ends

code segment
start:	mov ax, 0B800h
		mov es, ax
		mov ax, data
		mov ds, ax
		mov cx, 16
		mov bx, 0
	s:	mov al, [bx]
		mov di, bx
		add di, bx
		add di, 7D0h
		mov es:[di], al
		mov byte ptr es:[di+1h], 02h
		add di, 0A0h
		mov es:[di], al
		mov byte ptr es:[di+1h], 24h
		add di, 0A0h
		mov es:[di], al
		mov byte ptr es:[di+1h], 71h
		inc bx
		loop s
		
		mov ax, 4c00h
		int 21h
code ends	
end start