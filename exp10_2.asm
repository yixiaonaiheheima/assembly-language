assume cs:code
code segment
start:
	mov ax, 4240H
	mov dx, 00FH
	mov cx, 0AH
	call divdw
	
	mov ax, 4c00h
	int 21h
;名称：divdw
;功能：进行不会产生移除的除法运算，被除数为dword型，除数为word型，结果为dword性
;参数：(ax)=dword型数据的低16位 (dx)=dword型数据的高16位 (cx)=除数
;返回：(dx)=除数的高16位, (ax)=结果的低16位 (cx)=余数
divdw:
	push bx
	
	push ax
	mov ax, dx
	mov dx, 0
	div cx
	mov bx, ax ;int(H/N)
	pop ax
	div cx
	mov cx, dx ;rem((rem(H/N)*65536+L)/N)
	mov dx, bx
	
	pop bx
	ret

code ends
end start