assume cs:code
code segment
start:
    mov ax, 0B800h
    mov es, ax
    mov di, 160*12+80
    mov al, 9
    call display_date
    add di, 4
    mov byte ptr es:[di], '/'
    add di, 2
    mov al, 8
    call display_date
    add di, 4
    mov byte ptr es:[di], '/'
    add di, 2
    mov al, 7
    call display_date
    add di, 6
    mov al, 4
    call display_date
    add di, 4
    mov byte ptr es:[di], ':'
    add di, 2
    mov al, 2
    call display_date
    add di, 4
    mov byte ptr es:[di], ':'
    add di, 2
    mov al, 0
    call display_date

    mov ax, 4c00h
    int 21h

;名称：display_date
;功能：将CMOS RAM中的日期、时间信息显示到屏幕
;参数：(al)=CMOS RAM中的数据的单元格标号 es:di指向用于显示的屏幕的起始地址
名称：display_date:
    push cx
    push ax
    out 70h, al
    in al, 71h
    mov ah, al
    mov cl, 4
    shr ah, cl
    and al, 00001111b
    add ah, 30h
    add al, 30h
    mov byte ptr es:[di], ah
    mov byte ptr es:[di+2], al
    pop ax
    pop cx
    ret
code ends
end start
