global check_command_help


check_command_help:
    mov si, input_buffer
    mov di, help_cmd
    call compare_strings
    jnz .not_help
    call show_help
    clc
    ret
.not_help:
    stc
    ret

show_help:
    mov si, help_text
    call print_string
    call newline
    ret

help_cmd db "help", 0
help_text db "Available commands: echo, clear, help", 0

