global _start

section .data
    sensor_value    dd 0        ; Variable to store sensor input
    motor_status    db 0        ; Motor status: 0 = OFF, 1 = ON
    alarm_status    db 0        ; Alarm status: 0 = OFF, 1 = ON

    HIGH_LEVEL      equ 80      ; High sensor level threshold
    MODERATE_LEVEL  equ 50      ; Moderate sensor level threshold

    prompt_msg      db 'Enter sensor value: ', 0
    input_buf       db 10 dup(0) ; Input buffer for user input
    motor_msg       db 'Motor Status: ', 0
    alarm_msg       db 'Alarm Status: ', 0
    on_msg          db 'ON', 10, 0   ; Message indicating ON status
    off_msg         db 'OFF', 10, 0  ; Message indicating OFF status
    value_msg       db 'Sensor Value: ', 0
    newline         db 10, 0         ; Newline character

section .bss
    ; No uninitialized data required

section .text
_start:
    ; Display prompt message for sensor input
    mov     rax, 1                  ; sys_write system call
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, prompt_msg         ; Address of prompt message
    mov     rdx, 20                 ; Length of the message
    syscall

    ; Read user input from stdin
    mov     rax, 0                  ; sys_read system call
    mov     rdi, 0                  ; File descriptor for stdin
    mov     rsi, input_buf          ; Buffer to store input
    mov     rdx, 10                 ; Maximum number of bytes to read
    syscall

    ; Convert ASCII input to an integer
    mov     rsi, input_buf          ; Input buffer for conversion
    call    atoi                    ; Result will be in RAX

    ; Store the sensor value
    mov     [sensor_value], eax

    ; Load the sensor value
    mov     eax, [sensor_value]

    ; Print sensor value for debugging
    mov     rax, 1                  ; sys_write system call
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, value_msg          ; Address of value message
    mov     rdx, 14                 ; Length of the value message
    syscall

    ; Print the actual sensor value
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, input_buf
    mov     rdx, 10
    syscall

    ; Compare sensor value with thresholds
    cmp     eax, HIGH_LEVEL
    jg      high_level              ; If greater, jump to high level

    cmp     eax, MODERATE_LEVEL
    jg      moderate_level          ; If greater, jump to moderate level

low_level:
    ; Low level: Turn motor ON, Turn alarm OFF
    mov     byte [motor_status], 1  ; Motor ON
    mov     byte [alarm_status], 0  ; Alarm OFF
    jmp     display_status          ; Jump to display status

moderate_level:
    ; Moderate level: Turn motor OFF, Turn alarm OFF
    mov     byte [motor_status], 0  ; Motor OFF
    mov     byte [alarm_status], 0  ; Alarm OFF
    jmp     display_status          ; Jump to display status

high_level:
    ; High level: Turn motor ON, Turn alarm ON
    mov     byte [motor_status], 1  ; Motor ON
    mov     byte [alarm_status], 1  ; Alarm ON

display_status:
    ; Display motor status
    mov     eax, 1                  ; sys_write system call
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, motor_msg          ; Motor status message
    mov     rdx, 14                 ; Length of the message
    syscall

    ; Check and display motor status
    mov     al, [motor_status]
    cmp     al, 1                   ; Compare motor status
    je      motor_on                ; If ON, jump to motor_on
    jmp     motor_off               ; Otherwise, jump to motor_off

motor_on:
    ; Output motor ON status
    mov     eax, 1                  ; sys_write system call
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, on_msg             ; ON status message
    mov     rdx, 3                  ; Length of ON message
    syscall
    jmp     display_alarm           ; Jump to display alarm status

motor_off:
    ; Output motor OFF status
    mov     eax, 1                  ; sys_write system call
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, off_msg            ; OFF status message
    mov     rdx, 4                  ; Length of OFF message
    syscall

display_alarm:
    ; Display alarm status
    mov     eax, 1                  ; sys_write system call
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, alarm_msg          ; Alarm status message
    mov     rdx, 13                 ; Length of the message
    syscall

    ; Check and display alarm status
    mov     al, [alarm_status]
    cmp     al, 1                   ; Compare alarm status
    je      alarm_on                ; If ON, jump to alarm_on
    jmp     alarm_off               ; Otherwise, jump to alarm_off

alarm_on:
    ; Output alarm ON status
    mov     eax, 1                  ; sys_write system call
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, on_msg             ; ON status message
    mov     rdx, 3                  ; Length of ON message
    syscall
    jmp     exit_program            ; Jump to exit the program

alarm_off:
    ; Output alarm OFF status
    mov     eax, 1                  ; sys_write system call
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, off_msg            ; OFF status message
    mov     rdx, 4                  ; Length of OFF message
    syscall

exit_program:
    ; Exit the program
    mov     eax, 60                 ; sys_exit system call
    xor     edi, edi                ; Return 0 status code
    syscall

; Subroutine: ASCII to Integer Conversion (atoi)
atoi:
    xor     rax, rax                ; Clear RAX for result
    xor     rcx, rcx                ; Clear RCX (multiplier)
    mov     rcx, 10                 ; Set base to 10

atoi_loop:
    movzx   rdx, byte [rsi]         ; Load next character from buffer
    cmp     rdx, 10                 ; Check for newline
    je      atoi_done               ; End if newline
    sub     rdx, '0'                ; Convert ASCII to digit
    imul    rax, rcx                ; Multiply result by 10
    add     rax, rdx                ; Add digit to result
    inc     rsi                     ; Move to next character
    jmp     atoi_loop               ; Repeat loop

atoi_done:
    ret
