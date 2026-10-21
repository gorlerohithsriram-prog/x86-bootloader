[bits 16]
[org 0x7C00]

%include "print_string.asm"

mov ah,0x02
mov dl, 0	;Drive 0
mov ch, 3	;Cylinder 3
mov dh, 1	;Head 1
mov cl, 4	;Sector 4
mov al, 5	;Read 5 Sector

mov bx, 0xA000
mov es, bx
mov bx, 0x1234

int 0x13

jc disk_error	;Jump if carry flag is set

cmp al, 5	;5 sectors expected 
jne disk_error	;Jump if count differs

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

; Global variables
DISK_ERROR_MSG: db "Disk read error!", 0
