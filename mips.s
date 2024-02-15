
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

    # The process_whole_string  identifies and handles substrings

process_whole_string:

    #Get the current character and check if its the end of string

    lb $t3, 0($a0)  
    beq $t3, $zero, check_end  
    
    #Save the pointer to the start of the string on the Stack and make room on stack for string address

    sub $sp, $sp, 4
    
    #Store the address on the stack
    sw $a0, 0($sp)

    find_slashes:
    
        #Increment pointer by 1 and search for a / and replace with a null terminator
        addi $a0, $a0, 1
        li $t3, '/'
        lb $t4, 0($a0)
    
        beq $t3, $t4, null_term
        li $t3, 10 #newline character
        lb $t4, 0($a0)
    
        beq $t3, $t4, null_term
        j find_slashes
    
    null_term:
        # "/" or newline character recognized
        sb $zero, 0($a0)
        
        # When a slash or end of string is found, process the substring
        jal process_substring
    
        #After processing substring, restore the stack, advance the string pointer by 1, and repeat
        addi $sp, $sp, 4
        addi $a0, $a0, 1
        
        #Print the return value of process_substring in $v0
        # Reset $a1 to point to the next character as the start of the next substring
        add $s7, $a0, $zero
        li $t3, '-'

        beq $t3, $v0, dash_print
        add $a0, $v0, $zero
        li $v0, 1
        syscall
        j print_slash

    

