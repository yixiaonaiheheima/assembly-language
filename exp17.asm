assume cs:code
sdata segment
    db 'hello world!!'
sdata ends
sstack segment
    db 128 dup (0)
sstack ends
code segment
start:
    mov ax, sstack
    mov ss, ax
    mov sp, 128

    ;安装7ch
    push cs
    pop ds

    mov ax, 0
    mov es, ax

    mov si, offset int7c
    mov di, 200h
    mov cx, offset int7cEnd-offset int7c
    cld
    rep movsb

    cli
    mov word ptr es:[7ch*4], 200h
    mov word ptr es:[7ch*4+2], 0
    sti

    ;测试
    mov ah,0
    mov dx, sdata
    mov es, dx
    mov bx, 0
    mov dx, 1234
    int 7ch
    ;显示到屏幕上
    mov dh, 12
    mov dl, 10
    mov cl, 2
    mov ax, sdata
    mov ds, ax
    mov si, 0
    ;最多显示30个字符
    mov byte ptr ds:[si+30], 0
    call show_str
    mov ax, 4c00h
    int 21h
org 200h;设置此处的offset为200h
int7c:
    push cx
    push dx
    cmp ah, 1
    ja sret
    je write
    cmp ah, 0
    je read
sret:
    pop dx
    pop cx
    iret ;用于中断例程的返回

read:
    push bx
    push ax
    call logical2phisical
    mov ah, 2 
    mov al, 1 ;默认只读取一个扇区
    int 13h

    pop ax
    pop bx
    jmp sret

write:
    push bx
    push ax
    call logical2phisical
    mov ah, 3
    mov al, 1 ;默认只写入一个扇区
    int 13h

    pop ax
    pop bx
    jmp sret

;名称：logical2phisical
;功能：将逻辑扇区号转化为物理扇区号
;参数：(dx)=逻辑扇区号
;返回：(ch)=磁道号 (cl)=扇区号 (dh)=面号 (dl)=驱动器号
logical2phisical:
    push ax

    mov ax, dx
    mov dx, 0
    mov cx, 1440
    div cx
    push ax
    mov ax, dx
    mov ch, 18
    div ch
    mov ch, al
    mov cl, ah
    inc cl
    pop ax
    mov dh, al
    mov dl, 0

    pop ax
    ret

int7cEnd:
    nop
;名称：show_str
;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
;参数：(dh)=行号(取值范围0~24)，(dl)=列号(取值范围0~79),
; (cl)=颜色, ds:si指向字符串的首地址
show_str:
    push dx
    push cx
    push si
    push ax

    mov ch, 0
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
    pop ax
    pop si
    pop cx
    pop dx
    ret

code ends
end start