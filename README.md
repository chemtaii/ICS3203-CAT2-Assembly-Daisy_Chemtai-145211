# ICS3203-CAT2-Assembly-Daisy_Chemtai-145211
Question 1:
The program allows a user to input a number and determise whether the number is positive, negative or zero. 

Insights & challenges:
1. Selecting the right jump instructions was essential for ensuring smooth control flow and accurate number classification. To regulate the program's flow according to the conditions, we employed a variety of jump instructions (jne, je, jl, and jmp):

je (Jump if Equal) is used to determine whether the number is zero. If the comparison with zero is equal, it jumps to the is_zero label.
jne (Jump if Not Equal) ensures that if the sign is not negative, the program skips the negation process and proceeds to handle positive numbers or zero.
jl (Jump if Less) checks whether the number is less than zero, indicating it is negative, and jumps to the is_negative label.
jmp (Unconditional Jump) directs the program to the appropriate branch for positive numbers without any condition, jumping to the is_positive label.

2. Managing the number's sign correctly was a major difficulty, especially when the input starts with a minus sign. To ascertain whether the input is negative, the software employs a sign variable. Then, it uses neg eax to modify the result appropriately.
