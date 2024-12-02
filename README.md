Question 1: Number Classification Program
This program prompts the user to input a number and determines whether it is positive, negative, or zero.

Insights & Challenges
Control Flow with Jump Instructions:

The program relies on a mix of conditional (je, jne, jl) and unconditional (jmp) jumps to classify numbers.
Key jump instructions include:
je (Jump if Equal): Identifies zero.
jne (Jump if Not Equal): Skips unnecessary checks when the sign is positive.
jl (Jump if Less): Detects negative numbers.
jmp (Unconditional Jump): Redirects flow to the positive classification.
Handling Negative Numbers:

The program uses a sign variable to track negative inputs and adjusts the final result with neg eax for proper classification.
Program Flow
Input Handling:

Prompts the user to input a number.
Converts the input string to an integer, accounting for a potential negative sign.
Classification:

Compares the number to zero.
Jumps to appropriate labels for zero, negative, or positive numbers.
Output:

Displays the classification: "POSITIVE," "NEGATIVE," or "ZERO."
Compilation and Execution
Assemble the program:

nasm -f elf32 question1.asm -o question1.o
Link the object file:

ld -m elf_i386 question1.o -o question1
Run the program:

./question1
Question 2: Array Manipulation with Looping and Reversal (64-bit)
This program prompts the user to input five single-digit integers (0-9), stores them in an array, reverses the array in place, and outputs the reversed array.

Insights & Challenges
Input Validation:

Ensures each input is a valid digit between 0 and 9.
Displays an error message and retries invalid inputs.
Array Reversal:

Uses two pointers (r12 for left and r13 for right) to reverse the array without allocating extra memory.
Output:

Iterates through the reversed array and prints each element.
Program Flow
Input Handling:

Prompts the user to input a single digit.
Validates and stores the input in the array.
Reversal:

Swaps elements at the left and right pointers until they meet.
Output:

Prints the reversed array one digit at a time.
Compilation and Execution
Assemble the program:

nasm -f elf64 question2.asm -o question2.o
Link the object file:

ld question2.o -o question2
Run the program:

./question2
Question 3: Factorial Calculation (64-bit)
This program calculates the factorial of a number input by the user (from 0 to 12) using modular subroutines for validation, calculation, and output formatting.

Insights & Challenges
Input Validation:

Ensures the input is between 0 and 12.
Handles invalid input gracefully with error messages.
Factorial Calculation:

Implements an iterative factorial calculation in a dedicated subroutine.
Output Formatting:

Converts the factorial result into a string for display using an ASCII conversion subroutine.
Program Flow
Input Validation:

Prompts the user for input and checks validity.
Factorial Calculation:

Calls a subroutine to compute the factorial iteratively.
Output:

Displays the factorial result as a formatted string.
Compilation and Execution
Assemble the program:

nasm -f elf64 question3.asm -o question3.o
Link the object file:

ld question3.o -o question3
Run the program:

./question3
Question 4: Sensor Control Simulation (64-bit)
This program simulates a water level sensor system. Based on the input sensor value, it controls motor and alarm states and outputs their statuses.

Features
Low Water Level:

Motor: ON
Alarm: OFF
Moderate Water Level:

Motor: OFF
Alarm: OFF
High Water Level:

Motor: ON
Alarm: ON
Insights & Challenges
Control Logic:

Compares the sensor value against thresholds (MODERATE_LEVEL and HIGH_LEVEL) to determine the state of the motor and alarm.
Output Handling:

Displays the status of the motor and alarm with descriptive messages.
Program Flow
Input Handling:

Prompts the user for a sensor value.
Logic Implementation:

Compares the sensor value against predefined thresholds and updates motor and alarm statuses accordingly.
Output:

Displays the current states of the motor and alarm.
Compilation and Execution
Assemble the program:

nasm -f elf64 question4.asm -o question4.o
Link the object file:

ld question4.o -o question4
Run the program:

./question4
