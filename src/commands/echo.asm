global check_command_echo


check_command_echo:
    mov si, input_buffer
    mov di, echo_cmd
    call compare_strings
    jnz .not_echo
    call handle_echo
    clc
    ret
.not_echo:
    stc
    ret

handle_echo:
    mov si, input_buffer + 5  ; Skip "echo "
    call print_string
    call newline
    ret

echo_cmd db "echo ", 0

