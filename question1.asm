section .data
    prompt db "Enter a number: ", 0
    pos_msg db "POSITIVE", 0xA, 0  ; Added newline
    neg_msg db "NEGATIVE", 0xA, 0  ; Added newline
    zero_msg db "ZERO", 0xA, 0     ; Added newline

section .bss
    number resb 10     ; Reserve space for up to a 10-character number
    num resd 1         ; Reserve space for the parsed integer
    sign resb 1        ; To store the sign of the number

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4         ; syscall: sys_write
    mov ebx, 1         ; file descriptor: stdout
    mov ecx, prompt    ; message to print
    mov edx, 15        ; message length
    int 0x80           ; make syscall

    ; Get user input
    mov eax, 3         ; syscall: sys_read
    mov ebx, 0         ; file descriptor: stdin
    mov ecx, number    ; buffer to store input
    mov edx, 10        ; number of bytes to read (up to 10 digits)
    int 0x80           ; make syscall

    ; Initialize
    mov byte [sign], 1  ; Assume the number is positive by default
    mov esi, number     ; Point to the start of the input

    ; Check for minus sign
    cmp byte [esi], '-'
    jne parse_number    ; If not '-', continue parsing number
    mov byte [sign], -1 ; If it's '-', set sign to negative
    inc esi             ; Move pointer to next character

parse_number:
    ; Convert string to integer
    xor eax, eax        ; Clear eax to hold the result
    xor ebx, ebx        ; Clear ebx for digit extraction

convert_loop:
    mov bl, [esi]       ; Load the next character
    cmp bl, 0xA         ; Check for newline character (end of input)
    je classify         ; If newline, we've reached the end
    sub bl, '0'         ; Convert ASCII to integer
    imul eax, eax, 10   ; Multiply result so far by 10
    add eax, ebx        ; Add current digit to result
    inc esi             ; Move to next character
    jmp convert_loop    ; Repeat

classify:
    ; Apply the sign
    cmp byte [sign], -1
    jne check_zero      ; If not negative, skip negation
    neg eax             ; Negate the value if negative

check_zero:
    mov [num], eax      ; Store the final result in num
    cmp eax, 0
    je is_zero          ; If it's zero, jump to is_zero
    jl is_negative      ; If less than zero, jump to is_negative
    jmp is_positive     ; Otherwise, it's positive

is_zero:
    ; Print "ZERO"
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, zero_msg   ; message to print
    mov edx, 5          ; message length (including newline)
    int 0x80            ; make syscall
    jmp done            ; exit program

is_negative:
    ; Print "NEGATIVE"
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, neg_msg    ; message to print
    mov edx, 9          ; message length (including newline)
    int 0x80            ; make syscall
    jmp done            ; exit program

is_positive:
    ; Print "POSITIVE"
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, pos_msg    ; message to print
    mov edx, 9          ; message length (including newline)
    int 0x80            ; make syscall

done:
    ; Exit the program
    mov eax, 1          ; syscall: sys_exit
    xor ebx, ebx        ; return code 0
    int 0x80            ; make syscall
