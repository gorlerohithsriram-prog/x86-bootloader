;
;A simple boot sector that prints "Hello" using interrupt 0x10 (Invoke ISR)
;

 [bits 16]

 [org 0x7C00]

 mov ah, 0x0E	;BIOS print-character Service
 
 mov al, 'H'
 int 0x10
 
 mov al, 'e'
 int 0x10
 
 mov al, 'l'
 int 0x10
 
 mov al, 'l'
 int 0x10
 
 mov al, 'o'
 int 0x10
 
 jmp $
 
 times 510-($-$$) db 0
 
 dw 0xAA55
 

