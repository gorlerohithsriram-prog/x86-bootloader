;
; Prints the value in DX as a 4-digit hexadecimal number
; Example: DX = 0x1234 -> prints 1234
;

print_hex:
    pusha
    mov cx, 4             ; Four hexadecimal digits

hex_loop:
    rol dx, 4             ; Rotate DX left by 4 bits
    mov ax, dx
    and ax, 0x000F        ; Extract the lowest 4 bits

    cmp al, 0x09
    jbe hex_digit         ; If 0-9, skip letter conversion

    add al, 0x07          ; Convert 10-15 to A-F range

hex_digit:
    add al, 0x30          ; Convert to ASCII

    mov ah, 0x0E          ; BIOS character-printing service
    int 0x10

    loop hex_loop

    popa
    ret
