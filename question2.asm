section .data
    prompt_msg db "Please enter a digit (0-9): ", 0  ; Prompting the user for a single digit
    prompt_len equ $ - prompt_msg                    ; Length of the prompt message
    newline db 10                                    ; Newline character for formatting output
    error_msg db "Invalid input! Enter a digit between 0-9.", 0  ; Error message for invalid input
    error_len equ $ - error_msg                      ; Length of the error message

section .bss
    digits resb 5    ; Reserve 5 bytes for storing digits
    user_input resb 2  ; Reserve 2 bytes for user input (1 digit + newline)

section .text
    global _start

_start:
    ; Initialize an index to store digits in the array (r12 will be the counter)
    xor r12, r12    ; Clear r12 (initialize to 0) for use as the array index (0 to 4)

input_loop:
    ; Display the prompt message to the user
    mov rax, 1      ; System call to write (1 = write to stdout)
    mov rdi, 1      ; File descriptor for stdout (1 = standard output)
    mov rsi, prompt_msg ; Address of the prompt message
    mov rdx, prompt_len  ; Length of the prompt message
    syscall         ; Invoke the system call to print the prompt

    ; Read the user's input
    mov rax, 0      ; System call to read (0 = read from stdin)
    mov rdi, 0      ; File descriptor for stdin (0 = standard input)
    mov rsi, user_input  ; Address of the input buffer
    mov rdx, 2      ; Read 2 bytes (1 for the character and 1 for the newline)
    syscall         ; Invoke the system call to read input

    ; Validate if the input is a digit (0-9)
    mov al, [user_input]  ; Load the input character into the al register
    cmp al, '0'           ; Compare the input with ASCII value of '0'
    jl invalid_input      ; Jump to error handling if input < '0'
    cmp al, '9'           ; Compare the input with ASCII value of '9'
    jg invalid_input      ; Jump to error handling if input > '9'

    ; Store the valid input character in the array at the current index
    mov [digits + r12], al  ; Store the digit at the position r12 in the array
    inc r12                 ; Increment the index (r12) for the next position

    ; Check if 5 digits have been collected
    cmp r12, 5
    jl input_loop          ; Continue input loop if less than 5 digits collected

    ; Reverse the array in place using two pointers (left and right)
    mov r12, 0      ; Initialize left index (r12) to 0
    mov r13, 4      ; Initialize right index (r13) to 4 (last element of the array)

reverse_loop:
    ; Exit if left index (r12) >= right index (r13)
    cmp r12, r13
    jge display_array  ; Proceed to display array if indices have crossed

    ; Swap elements at r12 (left) and r13 (right)
    mov al, [digits + r12]  ; Load the left element into al register
    mov bl, [digits + r13]  ; Load the right element into bl register

    ; Store swapped elements back into the array
    mov [digits + r12], bl  ; Store the right element (bl) at the left index (r12)
    mov [digits + r13], al  ; Store the left element (al) at the right index (r13)

    ; Move indices towards each other (increment left index, decrement right index)
    inc r12                 ; Move the left index (r12) to the right
    dec r13                 ; Move the right index (r13) to the left

    ; Repeat the loop until indices meet or cross
    jmp reverse_loop        ; Continue reversing process

display_array:
    ; Display the reversed array of digits
    mov r12, 0              ; Reset the index to 0 for printing

print_loop:
    ; Load the character from the array at the current index (r12)
    mov al, [digits + r12]
    mov [user_input], al    ; Store it in the input buffer for printing

    ; Print the character (1 byte at a time)
    mov rax, 1              ; System call to write (1 = write to stdout)
    mov rdi, 1              ; File descriptor for stdout
    mov rsi, user_input     ; Address of the input buffer
    mov rdx, 1              ; Print 1 byte (1 character)
    syscall                 ; Invoke the system call to print the character

    ; Print a newline after each character
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Increment the index and check if all 5 characters have been printed
    inc r12
    cmp r12, 5
    jl print_loop           ; Continue printing if more characters remain

exit_program:
    ; Exit the program successfully
    mov rax, 60             ; System call to exit (60 = exit)
    xor rdi, rdi            ; Exit status 0 (successful)
    syscall                 ; Invoke the system call to exit the program

invalid_input:
    ; Display error message for invalid input
    mov rax, 1              ; System call to write (1 = write to stdout)
    mov rdi, 1              ; File descriptor for stdout
    mov rsi, error_msg      ; Address of the error message
    mov rdx, error_len      ; Length of the error message
    syscall

    ; Restart the input loop after displaying the error message
    jmp input_loop
