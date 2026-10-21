; Load DH sectors from drive DL into ES:BX

disk_load:
    pusha
    mov [SECTOR_COUNT], dh

    mov ah, 0x02
    mov al, dh          ; Number of sectors
    mov ch, 0x00        ; Cylinder 0
    mov dh, 0x00        ; Head 0
    mov cl, 0x02        ; Start at sector 2

    int 0x13
    jc disk_error

    cmp al, [SECTOR_COUNT]
    jne disk_error

    popa
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

SECTOR_COUNT: db 0
DISK_ERROR_MSG: db "Disk read error!", 0
