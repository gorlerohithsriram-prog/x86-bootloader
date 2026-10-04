[bits 16]        ; "NASM, generate 16-bit code" — because old PCs
                 ; always START in a 16-bit mode (a 1980s compatibility thing)

[org 0x7C00]     ; "NASM, assume this code will live at address 0x7C00"
                 ; — because that's where the BIOS always puts it

start:
    cli          ; instruction: "ignore interruptions" (keyboard etc.)
.hang:
    hlt          ; instruction: "CPU, go to sleep"
    jmp .hang    ; instruction: "if you ever wake up, go back to sleep"
    
times 510 - ($ - $$) db 0    ; fill the file with zeros until byte 509
dw 0xAA55                    ; write the 2 magic bytes at positions 510-511
