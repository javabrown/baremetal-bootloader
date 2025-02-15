[BITS 16]
[ORG 0x7C00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    call clear_screen   ; ✅ Ensures the screen is clean before prompt
    call print_prompt   ; ✅ Show "baremetal> " before looping

command_loop:
    call read_input      ; ✅ Read user input into buffer
    call process_command ; ✅ Process user command
    call print_prompt    ; ✅ Show the terminal prompt again
    jmp command_loop     ; ✅ Loop forever

times 510 - ($-$$) db 0
dw 0xAA55

%include "core.asm"
%include "commands/echo.asm"
%include "commands/clear.asm"
%include "commands/help.asm"
