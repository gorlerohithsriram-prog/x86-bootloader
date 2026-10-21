;
; Read sectors from the boot disk
;

bits 16
org 0x7C00

; Initialize segments and stack
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x8000

; Save the boot drive
mov [BOOT_DRIVE], dl

; Destination offset
mov bx, 0x9000

; Read two sectors
mov dh, 2
mov dl, [BOOT_DRIVE]

call disk_load

; Print the first 16-bit value
mov dx, [0x9000]
call print_hex

; Print the first value from the second sector
mov dx, [0x9000 + 512]
call print_hex

jmp $

; Include the functions
%include "print_string.asm"
%include "print_hex.asm"
%include "disk_load.asm"

BOOT_DRIVE: db 0

; Pad boot sector to 512 bytes
times 510 - ($ - $$) db 0
dw 0xAA55

; Data sector 1
times 256 dw 0xDADA

; Data sector 2
times 256 dw 0xFACE
