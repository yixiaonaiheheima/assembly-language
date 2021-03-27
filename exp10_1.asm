assume cs:code
data segment
	db 'Welcome to masm!',0
data ends

code segment
start:
    mov dh, 8
    mov dl, 10
    mov cl, 2
    mov ax, data
    mov ds, ax
    mov si, 0
    call show_str
    
    mov ax, 4c00h
    int 21h
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