;
; Print Two strings using a function
;

[bits 16]
[org 0x7C00]

mov bx,HELLO_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string

jmp $
%include "print_string.asm"

;Data
HELLO_MSG:
	db "HELLO,WORLD!" ,0

GOODBYE_MSG:
	db "GOODBYE!" ,0

times 510-($-$$) db 0
dw 0xAA55
