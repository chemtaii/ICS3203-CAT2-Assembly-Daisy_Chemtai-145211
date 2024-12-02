section .data
    message_prompt db 'Input an integer (0-12): ', 0  ; Ask the user for a number between 0 and 12
    message_result db 'The factorial is: ', 0         ; Message to display the factorial result
    newline_char  db 10, 0                            ; Newline character for formatting output
    buffer_input  db 10 dup(0)                        ; Allocate 10 bytes for input buffer
    buffer_result db 20 dup(0)                        ; Allocate 20 bytes for result buffer

section .bss
    ; No need for uninitialized data in this program

section .text
global _start

_start:
    ; Show the prompt to the user
    mov     rax, 1                 ; sys_write call number
    mov     rdi, 1                 ; File descriptor 1 (stdout)
    mov     rsi, message_prompt    ; Address of the prompt message
    mov     rdx, 23                ; Length of the prompt message
    syscall

    ; Get user input from stdin
    mov     rax, 0                 ; sys_read call number
    mov     rdi, 0                 ; File descriptor 0 (stdin)
    mov     rsi, buffer_input      ; Address of the input buffer
    mov     rdx, 10                ; Maximum number of bytes to read (10)
    syscall

    ; Convert the input string to an integer (atoi)
    mov     rsi, buffer_input      ; Address of the input buffer
    call    atoi                   ; Call atoi to convert the input to an integer

    ; Check if the input is between 0 and 12
    cmp     rax, 12                ; Compare input with 12
    ja      input_invalid          ; Jump if input is greater than 12
    cmp     rax, 0                 ; Compare input with 0
    jl      input_invalid          ; Jump if input is less than 0

    ; Calculate the factorial of the input number
    push    rax                    ; Push the input number onto the stack
    call    factorial              ; Call factorial subroutine, result in RAX
    add     rsp, 8                 ; Clean up the stack (remove the input number)

    ; Convert the factorial result to a string (itoa)
    mov     rsi, buffer_result     ; Address of the result buffer
    call    itoa                   ; Convert the result to a string

    ; Show the result message
    mov     rax, 1                 ; sys_write call number
    mov     rdi, 1                 ; File descriptor 1 (stdout)
    mov     rsi, message_result    ; Address of the result message
    mov     rdx, 16                ; Length of the result message
    syscall

    ; Display the calculated factorial result
    mov     rax, 1                 ; sys_write call number
    mov     rdi, 1                 ; File descriptor 1 (stdout)
    mov     rsi, buffer_result     ; Address of the result buffer
    mov     rdx, 20                ; Maximum number of bytes to write
    syscall

    ; Print a newline character after the result
    mov     rax, 1                 ; sys_write call number
    mov     rdi, 1                 ; File descriptor 1 (stdout)
    mov     rsi, newline_char      ; Address of the newline character
    mov     rdx, 1                 ; Length of the newline character
    syscall

    ; Exit the program successfully
    mov     rax, 60                ; sys_exit call number
    xor     rdi, rdi               ; Exit status 0 (success)
    syscall

input_invalid:
    ; Display an error message for invalid input
    mov     rax, 1                 ; sys_write call number
    mov     rdi, 1                 ; File descriptor 1 (stdout)
    mov     rsi, newline_char      ; Address of the error message
    mov     rdx, 24                ; Length of the error message
    syscall

    ; Exit the program with status 0 (success) after invalid input
    mov     rax, 60                ; sys_exit call number
    xor     rdi, rdi               ; Exit status 0
    syscall

; Subroutine: Calculate Factorial (factorial)
factorial:
    mov     rbx, 1                 ; Initialize result in RBX to 1
    cmp     rax, 0                 ; Check if the input is 0
    je      factorial_done         ; If input is 0, return 1 (factorial of 0)
factorial_loop:
    imul    rbx, rax               ; Multiply RBX by RAX (RBX = RBX * RAX)
    dec     rax                    ; Decrease RAX (next number)
    jnz     factorial_loop         ; Continue loop if RAX is not zero
factorial_done:
    mov     rax, rbx               ; Return the factorial result in RAX
    ret

; Subroutine: Convert ASCII to Integer (atoi)
atoi:
    xor     rax, rax               ; Clear RAX for the result
    xor     rcx, rcx               ; Clear RCX (multiplier for base 10)
    mov     rcx, 10                ; Set base to 10

atoi_loop:
    movzx   rdx, byte [rsi]        ; Load next character from input buffer
    cmp     rdx, 10                ; Check for newline character (ASCII 10)
    je      atoi_done              ; End loop if newline is found
    sub     rdx, '0'               ; Convert ASCII character to digit (e.g., '5' -> 5)
    imul    rax, rcx               ; Multiply current result by 10
    add     rax, rdx               ; Add the digit to the result
    inc     rsi                    ; Move to next character
    jmp     atoi_loop              ; Continue loop

atoi_done:
    ret

; Subroutine: Convert Integer to ASCII (itoa)
itoa:
    xor     rcx, rcx               ; Clear RCX for digit count
itoa_loop:
    xor     rdx, rdx               ; Clear RDX for remainder
    mov     rbx, 10                ; Set divisor to 10
    div     rbx                    ; Divide RAX by 10, quotient in RAX, remainder in RDX
    add     dl, '0'                ; Convert remainder (digit) to ASCII
    push    rdx                    ; Push digit onto stack
    inc     rcx                    ; Increment digit counter
    test    rax, rax               ; Check if RAX is zero (end of number)
    jnz     itoa_loop              ; Repeat loop if RAX is not zero

itoa_pop:
    pop     rdx                    ; Pop digit from stack
    mov     [rsi], dl              ; Store digit in result buffer
    inc     rsi                    ; Move to next position in buffer
    loop    itoa_pop               ; Repeat until all digits are popped

    mov     byte [rsi], 0          ; Null-terminate the string
    ret
