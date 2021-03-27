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

table segment
	db 21 dup ('year summ ne ?? ')
table ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov ax, table
	mov es, ax
	
	mov si, 0
	mov di, 0
	mov bx, 0
	mov bp, 0
	mov cx, 21
yearloop:
	mov dx, ds:[bx].0[si]
	mov es:[bp].0[di], dx
	mov dx, ds:[bx].2[si]
	mov es:[bp].2[di], dx
	add si, 4
	add di, 16
	loop yearloop
	mov si, 0
	mov di, 0
	add bx, 84
	add bp, 5
	mov cx, 21
summloop:
	mov dx, ds:[bx].0[si]
	mov es:[bp].0[di], dx
	mov dx, ds:[bx].2[si]
	mov es:[bp].2[di], dx
	add si, 4
	add di, 16
	loop summloop
	mov si, 0
	mov di, 0
	add bx, 84
	add bp, 5
	mov cx, 21
neloop:
	mov dx, ds:[bx].0[si]
	mov es:[bp].0[di], dx
	add si, 4
	add di, 16
	loop neloop
	mov si, 0
	mov di, 0
	mov bx, 84
	mov bp, 13
	mov cx, 21
aveloop:
	push si
	mov ax, si
	mov ah, 4
	mul ah
	mov si, ax
	mov ax, ds:[bx].0[si]
	mov dx, ds:[bx].2[si]
	pop si
	push ax
	mov ax, si
	mov ah, 2
	mul ah
	mov si, ax
	pop ax
	push cx
	mov cx, ds:[bx].84[si]
	div cx
	mov es:[bp].0[di], ax
	pop cx
	inc si
	add di, 16
	loop aveloop

	mov ax, 4c00h
	int 21h
code ends	
end start