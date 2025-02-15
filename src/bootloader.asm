[BITS 16]
[ORG 0x7C00]

start:
    cli                 ; Disable interrupts
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Stack at 0x7C00
    sti                 ; Enable interrupts

    call clear_screen
    call print_prompt

command_loop:
    call read_input      ; Read user input into buffer
    call process_command ; Process user command
    call print_prompt    ; Show the terminal prompt again
    jmp command_loop     ; Loop forever

; ========================
; PRINT TERMINAL PROMPT
; ========================
print_prompt:
    mov si, prompt
    call print_string
    ret

prompt db "baremetal> ", 0

; ========================
; CLEAR SCREEN FUNCTION
; ========================
clear_screen:
    mov ah, 0x06
    mov al, 0           ; Scroll full screen up
    mov bh, 0x07        ; Text attribute (white on black)
    mov cx, 0           ; Top-left corner
    mov dh, 24          ; Bottom row
    mov dl, 79          ; Rightmost column
    int 0x10            ; BIOS video interrupt
    ret

; ========================
; PRINT STRING FUNCTION
; ========================
print_string:
    mov ah, 0x0E        ; BIOS teletype mode
.next:
    lodsb               ; Load next char from SI
    cmp al, 0           ; End of string?
    je done
    int 0x10            ; Print character
    jmp .next
done:
    ret

; ========================
; READ INPUT FUNCTION
; ========================
read_input:
    mov di, input_buffer
    mov cx, 0           ; Track buffer length

.read_loop:
    mov ah, 0x00        ; BIOS read key
    int 0x16            ; Wait for keypress

    cmp al, 0x0D        ; Check if Enter was pressed
    je .enter_pressed

    cmp al, 0x08        ; Check if Backspace was pressed
    je .backspace

    stosb               ; Store character in buffer
    inc cx              ; Increment buffer length
    call print_char     ; Echo character to screen
    jmp .read_loop

.backspace:
    cmp cx, 0           ; Ensure buffer is not empty
    je .read_loop
    dec di              ; Move buffer pointer back
    dec cx              ; Reduce buffer length
    mov ah, 0x0E
    mov al, 0x08        ; Backspace character
    int 0x10
    mov al, ' '         ; Overwrite with space
    int 0x10
    mov al, 0x08        ; Move cursor back again
    int 0x10
    jmp .read_loop

.enter_pressed:
    mov byte [di], 0    ; Null-terminate the string
    call newline
    ret

; ========================
; PRINT SINGLE CHARACTER FUNCTION
; ========================
print_char:
    mov ah, 0x0E
    int 0x10
    ret

; ========================
; PROCESS COMMAND FUNCTION
; ========================
process_command:
    mov si, input_buffer
    mov di, echo_cmd
    call compare_strings
    jnz .unknown_cmd
    call handle_echo
    ret

.unknown_cmd:
    mov si, unknown_message
    call print_string
    ret

; ========================
; HANDLE ECHO COMMAND
; ========================
handle_echo:
    mov si, input_buffer + 5  ; Skip "echo " part
    call print_string
    call newline
    ret

; ========================
; COMPARE TWO STRINGS
; ========================
compare_strings:
    mov cx, 5
.compare:
    lodsb                   ; Load char from SI
    scasb                   ; Compare with DI
    jne .not_equal
    loop .compare
    clc                     ; Clear carry flag if equal
    ret
.not_equal:
    stc                     ; Set carry flag if not equal
    ret

; ========================
; NEWLINE FUNCTION
; ========================
newline:
    mov ah, 0x0E
    mov al, 0x0D  ; Carriage return
    int 0x10
    mov al, 0x0A  ; Line feed
    int 0x10
    ret

; ========================
; DATA SECTION
; ========================
input_buffer times 64 db 0
echo_cmd db "echo ", 0
unknown_message db "Unknown command!", 0

times 510 - ($-$$) db 0  ; Pad boot sector to 512 bytes
dw 0xAA55               ; Boot signature
