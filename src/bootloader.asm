[BITS 16]
[ORG 0x7C00]

start:
    mov si, message   ; Load message address
    call print_string ; Call function to print message

hang:
    jmp hang          ; Infinite loop (stops execution)

print_string:
    mov ah, 0x0E      ; BIOS print character function
.next:
    lodsb             ; Load next character from SI into AL
    cmp al, 0         ; Check if it's NULL terminator
    je done
    int 0x10          ; Call BIOS to print character
    jmp .next
done:
    ret

message db "Hello, World from Bare-Metal Bootloader!", 0

times 510 - ($-$$) db 0  ; Pad boot sector to 512 bytes
dw 0xAA55               ; Boot signature (BIOS requires this)
