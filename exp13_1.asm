assume cs:codesg
data segment
    db "welcome to masm!", 0
data ends
codesg segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset strShow
    mov ax, 0
    mov es, ax
    mov di, 200h
    mov cx, offset strShowEnd-offset strShow
    cld
    rep movsb
    mov ax, 0
    mov es, ax
    mov word ptr es:[7ch*4], 200h
    mov word ptr es:[7ch*4+2], 0

    mov dh, 10
    mov dl, 10
    mov cl, 2
    mov ax, data
    mov ds, ax
    mov si, 0
    int 7ch
    mov ax, 4c00h
    int 21h

;名称：strShow
;功能：显示一个用0结束的字符串
;参数：(dh)=行号，(dl)=列号，(cl)=颜色，ds:si指向字符串首地址
strShow:
    push dx
    push di
    push es
    push ax
    push cx
    push si
    mov ax, 0B800h
    mov es, ax
    mov al, 160
    mul dh
    mov dh, 0
    add ax, dx
    mov di, ax
    mov al, cl
    mov ch, 0
    traverse:
        mov cl, [si]
        jcxz strEnd
        mov es:[di], cl
        mov es:[di + 1], al
        inc si
        add di, 2
        jmp short traverse
        strEnd:
            pop si
            pop cx
            pop ax
            pop es
            pop di
            pop dx
            iret
strShowEnd:nop
codesg ends
end start