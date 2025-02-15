check_command_clear:
    mov si, input_buffer
    mov di, clear_cmd
    call compare_strings
    jnz .not_clear
    call clear_screen
    clc
    ret
.not_clear:
    stc
    ret

clear_cmd db "clear", 0

