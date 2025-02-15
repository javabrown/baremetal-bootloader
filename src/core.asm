global core_init
global print_prompt
global clear_screen
global print_string
global read_input
global process_command
global newline
global print_char
global compare_strings

section .bss
input_buffer resb 64    ; ✅ Reserve space for user input

section .data
prompt db "baremetal> ", 0
unknown_cmd db "Unknown command!", 0

section .text

; ================================
; PRINT PROMPT FUNCTION (Fixed)
; ================================
print_prompt:
    mov si, prompt      ; ✅ Point SI to "baremetal> "
    call print_string   ; ✅ Print it to the screen
    ret

; ================================
; CLEAR SCREEN FUNCTION
; ================================
clear_screen:
    mov ah, 0x06
    mov al, 0
    mov bh, 0x07        ; ✅ White text on black background
    mov cx, 0
    mov dh, 24
    mov dl, 79
    int 0x10
    ret

; ================================
; PRINT STRING FUNCTION
; ================================
print_string:
    mov ah, 0x0E
.next:
    lodsb               ; ✅ Load character from SI
    test al, al         ; ✅ Check if AL == 0 (end of string)
    jz done             ; ✅ If NULL, stop printing
    int 0x10            ; ✅ Print character
    jmp .next           ; ✅ Print next character
done:
    ret

; ================================
; READ USER INPUT FUNCTION (Fixed)
; ================================
read_input:
    mov di, input_buffer
    mov cx, 0

.read_loop:
    mov ah, 0x00        ; ✅ BIOS read key
    int 0x16            ; ✅ Wait for keypress

    cmp al, 0x0D        ; ✅ If Enter is pressed
    je .enter_pressed

    cmp al, 0x08        ; ✅ If Backspace is pressed
    je .backspace

    stosb               ; ✅ Store character in buffer
    inc cx              ; ✅ Increase buffer length
    call print_char     ; ✅ Echo character to screen
    jmp .read_loop

.backspace:
    cmp cx, 0           ; ✅ Ensure buffer is not empty
    je .read_loop
    dec di              ; ✅ Move buffer pointer back
    dec cx              ; ✅ Reduce buffer length
    mov ah, 0x0E
    mov al, 0x08        ; ✅ Backspace character
    int 0x10
    mov al, ' '         ; ✅ Overwrite with space
    int 0x10
    mov al, 0x08        ; ✅ Move cursor back again
    int 0x10
    jmp .read_loop

.enter_pressed:
    mov byte [di], 0    ; ✅ Null-terminate the string
    call newline
    ret

; ================================
; PRINT SINGLE CHARACTER FUNCTION
; ================================
print_char:
    mov ah, 0x0E
    mov bh, 0x00        ; ✅ Ensure proper BIOS execution
    int 0x10
    ret

; ================================
; NEWLINE FUNCTION
; ================================
newline:
    mov ah, 0x0E
    mov al, 0x0D        ; ✅ Carriage return
    int 0x10
    mov al, 0x0A        ; ✅ Line feed
    int 0x10
    ret

; ================================
; PROCESS COMMAND FUNCTION (Fixed)
; ================================
process_command:
    mov si, input_buffer
    call check_command_echo
    jnc .not_found
    call check_command_clear
    jnc .not_found
    call check_command_help
    jnc .not_found
    mov si, unknown_cmd
    call print_string
.not_found:
    ret

; ================================
; COMPARE STRINGS FUNCTION (Restored Old Working Version)
; ================================
compare_strings:
    mov cx, 5
.compare:
    lodsb                   ; ✅ Load char from SI
    scasb                   ; ✅ Compare with DI
    jne .not_equal
    loop .compare
    clc                     ; ✅ Clear carry flag if equal
    ret
.not_equal:
    stc                     ; ✅ Set carry flag if not equal
    ret
