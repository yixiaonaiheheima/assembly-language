assume cs:code, ds:data

data segment
	db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
	db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
	db '1993', '1994', '1995'
	;以上为年份
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	;以上为21年总收入数据
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
	;以上为员工个数
data ends

code segment
start:
	call init_screen
	mov ax, data
	mov ds, ax
	mov ax, 0B80ah
	mov es, ax

	mov si, 0
	mov di, 0
	mov bx, 0
	mov bp, 0
	mov cx, 21
yearloop:
	mov dl, ds:[bx].0[si]
	mov es:[bp].0[di], dl
	mov dl, ds:[bx].1[si]
	mov es:[bp].2[di], dl
	mov dl, ds:[bx].2[si]
	mov es:[bp].4[di], dl
	mov dl, ds:[bx].3[si]
	mov es:[bp].6[di], dl
	add si, 4
	add di, 160
	loop yearloop

	mov si, 84
	mov di, 40
	mov cx, 21
summloop:
	mov ax, ds:[si]
	mov dx, ds:[si+2]
	call ddtoc
	add si, 4
	add di, 160
	loop summloop
	
	mov si, 168
	mov di, 80
	mov cx, 21
neloop:
	mov ax, ds:[si]
	mov dx, 0
	call ddtoc
	add si, 2
	add di, 160
	loop neloop

	mov si, 84
	mov di, 120
	mov bx, 0
	mov bp, 0
	mov cx, 21
aveloop:
	push cx
	mov ax, ds:[si+bx]
	mov dx, ds:[si+bx+2]
	mov cx, ds:[si+84+bp]
	call divdw
	call ddtoc
	add bx, 4
	add bp, 2
	add di, 160
	pop cx
	loop aveloop

	call render_screen
	mov ax, 4c00h
	int 21h
	

;功能：进行商不会溢出的除法运算
;参数：(ax)=dword型数据的低16位 (dx)=dword型数据的高16位 (cx)=除数
;返回：(dx)=商的高16位 (ax)=商的低16位 (cx)=余数
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


;功能：将dword型数据间隔打印至内存
;参数：(ax)=dword型数据的低16位 (dx)=dword型数据的高16位 es:di=内存首地址
;返回：无
ddtoc:
	push ax
	push di
	push cx
	push dx
	push bx
	
	mov bx, 0
divloop:
	mov cx, 10
	call divdw
	add cx, 30h ;convert remainder to character
	push cx
	inc bx
	mov cx, dx
	jcxz quotient_high_is_zero
	jmp short divloop
quotient_high_is_zero:
	mov cx, ax
	jcxz end_ddtoc
	jmp short divloop
end_ddtoc:
	mov cx, bx
pushloop:
	pop es:[di]
	add di, 2
	loop pushloop
	
	pop bx
	pop dx
	pop cx
	pop di
	pop ax
	ret


;功能：将屏幕初始化为黑屏
;参数：无
;返回：无
init_screen:
	push es
	push di
	push cx
	mov cx, 0B800h
	mov es, cx
	mov di, 0
	mov cx, 2000
init_loop:
	mov byte ptr es:[di], 20h
	mov byte ptr es:[di+1], 7
	add di, 2
	loop init_loop
	pop cx
	pop di
	pop es
	ret


;功能：将屏幕背景渲染为白色
;参数：无
;返回：无
render_screen:
	push es
	push di
	push cx
	mov cx, 0B800h
	mov es, cx
	mov di, 1
	mov cx, 2000
init_white_bg:
	mov byte ptr es:[di], 7
	add di, 2
	loop init_white_bg
	pop cx
	pop di
	pop es
	ret
	
	
code ends	
end start