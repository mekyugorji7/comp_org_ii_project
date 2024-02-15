
.data
    str: .space 1024  # Space for input string
    prompt: .asciiz "Input: "
   

# Determine base_n, beta, and delta values based on your Howard ID
# Howard ID : 03057357
# N = 26 + (3057357 % 11) = 26 + 6 = 32
# M = 22
# Beta: 'v'
# Delta: 'V'

.text
.globl main

main:
    # Display prompt
    li $v0, 4
    la $a0, prompt
    syscall

     # Read input string
    li $v0, 8
    la $a0, str
    li $a1, 1001
    syscall

    # Process the input string
    jal process_whole_string
