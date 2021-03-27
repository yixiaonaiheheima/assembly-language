assume cs:codesg
codesg segment
start:
    mov ax, cs
    mov ds, ax
    mov si, offset lp
    mov ax, 0
    mov es, ax
    mov di, 200h
    mov cx, offset lpEnd-offset lp
    cld
    rep movsb
    mov ax, 0
    mov es, ax
    mov word ptr es:[7ch*4], 200h
    mov word ptr es:[7ch*4+2], 0

    mov ax, 0B800h
    mov es, ax
    mov di, 160*12
    mov bx, offset s - offset se ;设置从标号se到标号s的转移位移
    mov cx, 80
s:
    mov byte ptr es:[di], '!'
    add di, 2
    int 7ch
se:
    nop
    mov ax, 4c00h
    int 21h

;名称lp
;功能：模拟loop指令
;参数：(cx)=循环次数 (bx)=位移
lp:
    push bp
    mov bp, sp
    dec cx
    jcxz lpret
    add [bp+2], bx
    lpret:
        pop bp
        iret
lpEnd:nop
codesg ends
end start