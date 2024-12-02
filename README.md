# ICS3203-CAT2-Assembly-Daisy_Chemtai-145211
Question 1: Number Classification Program
This program allows the user to input a number and determines whether the number is positive, negative, or zero.

Insights & Challenges
Control Flow with Jump Instructions:

A combination of conditional (je, jne, jl) and unconditional (jmp) jumps ensures efficient number classification.
Specific jump instructions include:
je (Jump if Equal): Determines if the number is zero and directs the flow to the is_zero label.
jne (Jump if Not Equal): Skips unnecessary processes if the number is not negative.
jl (Jump if Less): Identifies negative numbers and jumps to the is_negative label.
jmp (Unconditional Jump): Redirects the program to handle positive numbers without additional checks.
Handling Negative Numbers:

Managing the sign of the input was a critical challenge, particularly for numbers preceded by a minus sign.
The program uses a sign variable to track whether the input is negative and employs neg eax to adjust the result when necessary.
Question 2: Array Manipulation with Looping and Reversal (64-bit)
Overview
This program accepts an array of integers (five single digits, 0-9) from the user, reverses the array in place, and outputs the reversed array. It uses 64-bit architecture for efficient memory access and operations.

Insights & Challenges
Input Validation:

Ensures the input consists of valid digits (0-9).
Redirects the user back to the input loop on invalid input.
Memory Management:

Reverses the array in place without allocating additional memory.
Uses two registers (r12 for the left pointer and r13 for the right pointer) to manage indices during reversal.
Error Handling:

Invalid inputs are handled gracefully with a prompt, ensuring the program continues to operate correctly.
Program Flow
Input Handling:

Prompts the user to input a single digit.
Validates the digit and stores it in the array.
Array Reversal:

Initializes two indices: r12 (left) and r13 (right).
Swaps elements at these indices, incrementing the left index and decrementing the right index until the pointers meet.
Output:

Iterates through the array and prints each digit after the reversal.
Compilation and Execution
Assemble the program:

nasm -f elf64 array_reverse_64.asm -o array_reverse_64.o
Link the object file:

ld array_reverse_64.o -o array_reverse_64
Run the program:

./array_reverse_64
Question 3: Factorial Calculation (64-bit)
Overview
This program calculates the factorial of a user-input number (0-12) using a modular approach with subroutines. It leverages 64-bit registers and efficient looping for performance.

Program Flow
Input Validation:

Prompts the user for a number.
Validates that the input is between 0 and 12.
Factorial Calculation:

Uses a subroutine to iteratively calculate the factorial by decrementing the input and multiplying until reaching 1.
Output:

Converts the factorial result into a string and displays it.
Insights
Modular Design:

Separates logic into subroutines for factorial calculation and input validation, enhancing clarity and reusability.
Stack Management:

Uses the stack to preserve register values and intermediate results during subroutine execution.
Input Conversion:

Handles ASCII-to-integer conversion for user input.
Compilation and Execution
Assemble the program:

nasm -f elf64 factorial_64.asm -o factorial_64.o
Link the object file:

ld factorial_64.o -o factorial_64
Run the program:

./factorial_64
Question 4: Sensor Control Simulation (64-bit)
Overview
This program simulates a sensor control system. It reads a water level sensor value, determines motor and alarm states based on the value, and outputs the current statuses. The program uses 64-bit instructions for calculations and comparisons.

Features
Low Level: Motor ON, Alarm OFF.
Moderate Level: Motor OFF, Alarm OFF.
High Level: Motor ON, Alarm ON.
Program Flow
Prompts the user to input a sensor value.
Processes the value to determine:
Motor state.
Alarm state.
Displays the resulting states to the user.
Compilation and Execution
Assemble the program:

nasm -f elf64 sensor_control_64.asm -o sensor_control_64.o
Link the object file:

ld sensor_control_64.o -o sensor_control_64
Run the program:

./sensor_control_64
Example
Input:
Enter sensor value: 90
Output:
Motor Status: ON
Alarm Status: ON
