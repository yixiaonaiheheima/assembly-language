assume cs:codesg

datasg segment
    db "Beginner's All-purpose Sumbolic Instruction Code.",0
datasg ends
codesg segment
begin:
    mov dh, 8
	mov dl, 10
	mov cl, 2
    mov ax, datasg
    mov ds, ax
    mov si, 0
    call show_str
    inc dh
    call letterc
    call show_str

    mov ax, 4c00h
    int 21h

;名称：letterc
;功能：将字符串中的小写字母转变成大写字母，以0结尾
;参数：ds:si指向字符串的首地址
letterc:
    pushf
    push si
    traverse:
        cmp byte ptr [si], 0
        je break
        cmp byte ptr [si], 'a'
        jb continue
        cmp  byte ptr [si], 'z'
        ja continue
        and byte ptr [si], 11011111B
    continue:
        inc si
        jmp short traverse
    break:
        pop si
        popf
        ret
;名称：show_str
;功能：在指定的位置，用指定的颜色，显示一个用0结束的字符串
;参数：(dh)=行号(取值范围0~24)，(dl)=列号(取值范围0~79),
; (cl)=颜色, ds:si指向字符串的首地址
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
codesg ends
end begin