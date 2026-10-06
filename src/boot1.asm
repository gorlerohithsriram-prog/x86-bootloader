[bits 16]

[org 0x7C00]

mov ah,0x0E

mov bp,0x8000
mov sp,bp

push 'A'
push 'B'
push 'C'

pop bx
mov al,bl
int 0x10

pop bx
mov al,bl
int 0x10

mov al,[0x7FFE]
int 0x10

jmp $

times 510-($-$$) db 0
dw 0xAA55

