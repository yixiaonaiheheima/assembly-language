assume cs:code
data segment
	db 10 dup (0)
data ends

code segment
start:	
	mov ax, 12666
	mov bx, data
	mov ds, bx
	mov si, 0
	call dtoc
	
	mov dh, 18
	mov dl, 50
	mov cl, 2
	call show_str
	
	mov ax, 4c00h
	int 21h
show_str:
	push dx
	push cx
	push ds
	push si
	push bx

	mov ax, 0B800h
	mov es, ax
	mov al, 0A0h
	mul dh
	mov dh, 0
	add ax, dx
	mov di, ax
	mov bl, cl
show_char:		
	mov cl, [si]
	jcxz strEnd
	mov es:[di], cl
	inc di
	mov es:[di], bl
	inc di
	inc si
	jmp short show_char
		
strEnd:	
	pop bx
	pop si
	pop ds
	pop cx
	pop dx
	ret
	
;名称：dtoc
;功能：将word型数据转变为表示十进制数的字符串，字符串以0位结束符
;参数：(ax)=word型数据 ds:si指向字符串的首地址
;返回：无
dtoc:
	push ax
	push si
	push cx
	push dx
	push bx
	push bp
	
	mov bp, 10
	mov bx, 0
divloop:
	mov dx, 0
	div bp
	add dx, 30h
	push dx
	inc bx
	mov cx, ax
	jcxz end_dtoc
	jmp short divloop
end_dtoc:
	mov cx, bx
pushloop:
	pop ds:[si]
	inc si
	loop pushloop
	
	pop bp
	pop bx
	pop dx
	pop cx
	pop si
	pop ax
	ret
code ends
end start