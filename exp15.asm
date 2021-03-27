assume cs:csode

sstack segment
    db 128 dup (0)
sstack ends

csode segment
start:
    mov ax, sstack
    mov ss, ax
    mov sp, 128

    push cs
    pop ds

    mov ax, 0
    mov es, ax

    mov si, offset int9
    mov di, 204h
    mov cx, offset int9end-offset int9
    cld
    rep movsb

    push  es:[9*4]
    pop es:[200h]
    push es:[9*4+2]
    pop es:[202h]

    cli
    mov word ptr es:[9*4], 204h
    mov word ptr es:[9*4+2], 0
    sti

    mov ax, 4c00h
    int 21h

int9:
    push ax
    push bx
    push cs
    push es

    in al, 60h

    pushf
    call dword ptr cs:[200h] ;当此中断执行时(cs)=0

    cmp al, 9eh ;'A'的断码为1eh+80h=9eh
    jne int9ret

    mov ax, 0B800h
    mov es, ax
    mov bx, 0
    mov cx, 2000
s:
    mov byte ptr es:[bx], 'A'
    add bx, 2
    loop s

int9ret:
    pop es
    pop cx
    pop bx
    pop ax
    iret

int9end:
    nop

csode ends
end start